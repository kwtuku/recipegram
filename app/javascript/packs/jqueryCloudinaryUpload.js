$(() => {
  const previewContainer = $('#image-preview-container');
  const statusContainer = $('#status-container');
  const progressBar = $('#progress-bar');
  const statusMessage = $('#status-message');

  let imgClass;
  let figureClass;
  let imgWidth;
  let imgHeight;

  if (document.getElementById('recipe_image_field') === null) {
    figureClass = 'image is-200x200 mx-auto';
    imgClass = 'is-rounded';
    imgWidth = 400;
    imgHeight = 400;
  } else {
    figureClass = 'image is-400x400 mx-auto';
    imgWidth = 800;
    imgHeight = 800;
  }

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
          width: imgWidth,
          height: imgHeight,
          crop: 'fill',
        })
        .addClass(imgClass)
        .appendTo($('<figure>', { class: figureClass }).appendTo(previewContainer));

      $('.cloudinary-fileupload').prop('required', false);
    });
});
