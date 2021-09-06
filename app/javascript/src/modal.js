export default () => {
  document.addEventListener('turbolinks:load', () => {
    const imageModalTrigger = document.getElementById('show-image-modal')
    const signInModalTriggers = Array.prototype.slice.call(document.querySelectorAll('.js-show-sign-in-modal'), 0);

    if (imageModalTrigger === null && signInModalTriggers.length === 0) {
      return false;
    }

    const html = document.querySelector('html');
    const body = document.querySelector('body');

    if (imageModalTrigger) {
      const imageModal = document.getElementById('image-modal')

      imageModalTrigger.addEventListener('click', () => {
        imageModal.classList.add('is-active');
        html.classList.add('is-clipped');
        body.classList.add('mr-4');
      });

      const imageModalCloseButton = imageModal.querySelector('button');
      imageModalCloseButton.addEventListener('click', () => {
        imageModal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });

      const imageModalBg = imageModal.querySelector('.modal-background');
      imageModalBg.addEventListener('click', () => {
        imageModal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });
    }

    if (signInModalTriggers.length) {
      const signInModal = document.getElementById('sign-in-modal')

      signInModalTriggers.forEach(signInModalTrigger => {
        signInModalTrigger.addEventListener('click', () => {
          signInModal.classList.add('is-active');
          html.classList.add('is-clipped');
          body.classList.add('mr-4');
        });
      });

      const signInModalCloseButton = signInModal.querySelector('button');
      signInModalCloseButton.addEventListener('click', () => {
        signInModal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });

      const signInModalBg = signInModal.querySelector('.modal-background');
      signInModalBg.addEventListener('click', () => {
        signInModal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });
    }
  });
}
