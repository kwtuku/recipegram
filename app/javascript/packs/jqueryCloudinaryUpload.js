$(() => {
  const previewContainer = $('#image-preview-container');
  const statusContainer = $('#status-container');
  const progressBar = $('#progress-bar');
  const statusMessage = $('#status-message');

  $('.cloudinary-fileupload')
    .cloudinary_fileupload({
      acceptFileTypes: /(\.|\/)(jpe?g|png|webp)$/i,
      maxFileSize: 2000000,
      messages: {
        acceptFileTypes: 'jpg, jpeg, png, webpファイルのみがアップロードできます',
        maxFileSize: '2MB以下のファイルがアップロードできます',
      },
      dropZone: '#drop-zone',
      processalways(e, data) {
        if (data.files.error) alert(data.files[0].error);
      },
      start() {
        statusContainer.removeClass('is-hidden');
        statusMessage.text('アップロードを開始...');
        previewContainer.html('');
      },
      progress(e, data) {
        progressBar.val(Math.round((data.loaded * 100.0) / data.total));
        statusMessage.text(`アップロード中... ${Math.round((data.loaded * 100.0) / data.total)}%`);
      },
      fail() {
        alert('アップロードに失敗しました');
      },
    })
    .off('cloudinarydone')
    .on('cloudinarydone', (e, data) => {
      statusContainer.addClass('is-hidden');
      progressBar.val('0');

      $.cloudinary
        .image(data.result.public_id, {
          format: data.result.format,
          width: 400,
          height: 400,
          crop: 'fill',
        })
        .addClass('is-rounded')
        .appendTo($('<figure>', { class: 'image is-200x200 mx-auto' }).appendTo(previewContainer));

      $('.cloudinary-fileupload').prop('required', false);
    });
});
