const deleteButtons = document.querySelectorAll('.js-delete-image-button');

deleteButtons.forEach((deleteButton) => {
  const image = deleteButton.parentNode;

  deleteButton.addEventListener('click', () => {
    image.remove();
    const { key, cache } = deleteButton.dataset;

    if (cache) {
      const resourceInput = document.getElementById(`recipe_image_attributes_${key}_resource`);
      resourceInput.remove();
    } else {
      const destroyInput = document.getElementById(`recipe_image_attributes_${key}__destroy`);
      destroyInput.value = 'true';
    }
  });
});
