$(() => {
  const previewContainer = $('#image-preview-container');
  const statusContainer = $('#status-container');
  const progressBar = $('#progress-bar');
  const statusMessage = $('#status-message');

  const maxNumberOfFiles = 10;
  let displayedValidationErrorMessages = [];
  let processedFilesCounter = 0;
  let uploadedFilesCounter = 0;

  $('.cloudinary-fileupload')
    .cloudinary_fileupload({
      acceptFileTypes: /(\.|\/)(jpe?g|png|webp)$/i,
      maxFileSize: 2000000,
      getNumberOfFiles() {
        return uploadedFilesCounter;
      },
      maxNumberOfFiles,
      messages: {
        acceptFileTypes: 'jpg, jpeg, png, webpファイルのみがアップロードできます',
        maxFileSize: '2MB以下のファイルがアップロードできます',
        maxNumberOfFiles: `画像は最大で${maxNumberOfFiles}枚までアップロードできます`,
      },
      dropZone: '#drop-zone',
      change(e, data) {
        if (data.files.length > maxNumberOfFiles) {
          alert(`画像は最大で${maxNumberOfFiles}枚までアップロードできます`);
          return false;
        }
      },
      processalways(e, data) {
        const errorMessage = data.files[0].error;

        if (data.files.error && displayedValidationErrorMessages.indexOf(errorMessage) === -1) {
          alert(errorMessage);
          displayedValidationErrorMessages.push(errorMessage);
        }

        if (!data.files.error) {
          uploadedFilesCounter += 1;
        }

        processedFilesCounter += 1;

        if (processedFilesCounter === data.originalFiles.length) {
          displayedValidationErrorMessages = [];
          processedFilesCounter = 0;
        }
      },
      start() {
        statusContainer.removeClass('is-hidden');
        statusMessage.text('アップロードを開始...');
      },
      progressall(e, data) {
        const progressAllValue = Math.round((data.loaded * 100.0) / data.total);

        progressBar.val(progressAllValue);
        statusMessage.text(`アップロード中... ${progressAllValue}%`);
        if (progressAllValue === 100) {
          statusContainer.addClass('is-hidden');
          progressBar.val('0');
        }
      },
      fail() {
        alert('アップロードに失敗しました');
      },
    })
    .off('cloudinarydone')
    .on('cloudinarydone', (e, data) => {
      const key = new Date().valueOf();
      const preview = $('<div>', { class: 'column is-one-fifth is-flex', 'data-sortable-key': key }).appendTo(
        previewContainer,
      );
      const publicId = data.result.public_id;

      $.cloudinary
        .image(publicId, {
          format: data.result.format,
          width: 256,
          height: 256,
          crop: 'fill',
        })
        .appendTo($('<figure>', { class: 'image is-128x128' }).appendTo(preview));

      $(`input[value*="${publicId}"]`).attr('name', `recipe[image_attributes][${key}][resource]`);

      $('<button>', { class: 'delete_by_token delete is-medium' })
        .data({ delete_token: data.result.delete_token })
        .appendTo(preview)
        .on('click', function deleteImage(event) {
          event.preventDefault();
          $.cloudinary
            .delete_by_token($(this).data('delete_token'))
            .done(() => {
              preview.remove();
              $(`input[value*="${publicId}"]`).remove();

              uploadedFilesCounter -= 1;
            })
            .fail(() => {
              alert('画像が削除できません');
            });
        });

      $('.cloudinary-fileupload').prop('required', false);
    });
});
