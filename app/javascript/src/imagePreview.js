export default () => {
  const imageForm = document.getElementById('recipe_recipe_image') || document.getElementById('user_user_image');

  if (imageForm === null) return false;

  imageForm.addEventListener('change', (e) => {
    const file = e.target.files[0];
    const blobUrl = window.URL.createObjectURL(file);
    const previewImageContainer = document.getElementById('file-preview-container');
    const imageStyle = previewImageContainer.classList.contains('is-256x256') ? 'is-256x256 round' : 'is-400x400';

    previewImageContainer.classList.remove('is-hidden');
    previewImageContainer.innerHTML = `<img src="${blobUrl}" class="${imageStyle}">`;
  });
};
