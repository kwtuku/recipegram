export default () => {
  document.addEventListener('DOMContentLoaded', function() {
    const modals = Array.prototype.slice.call(document.querySelectorAll('.modal'), 0);

    if (modals.length > 0) {
      modals.forEach( modal => {
        const recipeImage = document.querySelector('#recipe-image');
        const html = document.querySelector('html');
        recipeImage.addEventListener('click', () => {
          modal.classList.add('is-active');
          html.classList.add('is-clipped');
        });

        const button = document.querySelector('.modal button');
        button.addEventListener('click', () => {
          modal.classList.remove('is-active');
          html.classList.remove('is-clipped');
        });

        const modalBg = document.querySelector('.modal-background');
        modalBg.addEventListener('click', () => {
          modal.classList.remove('is-active');
          html.classList.remove('is-clipped');
        });
      });
    }
  });
}
