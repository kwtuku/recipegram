import Sortable from 'sortablejs/modular/sortable.core.esm';

const images = document.querySelector('[data-sortable="images"]');

Sortable.create(images, {
  animation: 150,
  ghostClass: 'is-invisible',
});

window.addEventListener('submit', () => {
  const keys = Array.from(images.children).map((item) => item.dataset.sortableKey);
  let positionInputs = '';

  keys.forEach((key, index) => {
    positionInputs += `<input type="hidden" value="${index + 1}" name="recipe[image_attributes][${key}][position]">`;
  });

  images.insertAdjacentHTML('beforeend', positionInputs);
});
