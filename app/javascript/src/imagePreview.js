export default () => {
  document.addEventListener('turbolinks:load', () => {
    const imageForm =
      document.getElementById('recipe_recipe_image') ||
      document.getElementById('user_user_image');
    if (imageForm === null) {
      return false;
    }

    imageForm.addEventListener('change', (e) => {
      const file = e.target.files[0];
      const blobUrl = window.URL.createObjectURL(file);
      const previewImage = document.getElementById('file-preview');
      const cta = document.getElementById('file-cta');

      previewImage.classList.remove('is-hidden');
      previewImage.src = blobUrl;
      if (cta) {
        cta.remove();
      }
    });
  });
};
