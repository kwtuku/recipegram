export default () => {
  document.addEventListener('turbolinks:load', () => {
    const recipeImage = document.getElementById('recipe_recipe_image');
    const cta = document.getElementById('file-cta');

    if (recipeImage) {
      recipeImage.addEventListener('change', (e) => {
        const file = e.target.files[0];
        const blobUrl = window.URL.createObjectURL(file);
        const img = document.getElementById('file-preview');
        img.src = blobUrl;
        cta.remove();
      });
    }
  });
}
