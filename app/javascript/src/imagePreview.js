export default () => {
  document.addEventListener('turbolinks:load', () => {
    const image = document.getElementById('recipe_recipe_image') || document.getElementById('user_user_image');
    const cta = document.getElementById('file-cta');

    if (image) {
      image.addEventListener('change', (e) => {
        const file = e.target.files[0];
        const blobUrl = window.URL.createObjectURL(file);
        const img = document.getElementById('file-preview');
        img.classList.remove('is-hidden');
        img.src = blobUrl;
        cta.remove();
      });
    }
  });
}
