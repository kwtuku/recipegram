export default () => {
  document.addEventListener('turbolinks:load', () => {
    const imageModal = document.getElementById('image-modal')
    const signInModal = document.getElementById('sign-in-modal')

    if (imageModal === null && signInModal === null) {
      return false;
    }

    const html = document.querySelector('html');
    const body = document.querySelector('body');

    if (imageModal) {
      const imageModalTrigger = document.getElementById('show-image-modal')

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

    if (signInModal) {
      const signInModalTriggers = Array.prototype.slice.call(document.querySelectorAll('.js-show-sign-in-modal'), 0);

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
