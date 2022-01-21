export default () => {
  document.addEventListener('turbolinks:load', () => {
    const imageModal = document.getElementById('image-modal');
    const signInModal = document.getElementById('sign-in-modal');

    if (imageModal === null && signInModal === null) return false;

    const html = document.querySelector('html');
    const body = document.querySelector('body');
    const navbar = document.querySelector('.navbar');

    const scrollbarMeasure = document.createElement('div');
    scrollbarMeasure.setAttribute('style', 'visibility: hidden; position: absolute; top: 0; left: 0; width: 100vw;');
    document.body.appendChild(scrollbarMeasure);
    const viewportWidth = parseInt(window.getComputedStyle(scrollbarMeasure).width);
    scrollbarMeasure.style.width = '100%';
    const percentWidth = parseInt(window.getComputedStyle(scrollbarMeasure).width);
    document.body.removeChild(scrollbarMeasure);
    const scrollbarWidth = viewportWidth - percentWidth;

    function showModal(modal) {
      modal.classList.add('is-active');
      html.classList.add('is-clipped');
      body.style.paddingRight = `${scrollbarWidth}px`;
      navbar.style.paddingRight = `${scrollbarWidth}px`;
    }

    function hideModal(modal) {
      modal.classList.remove('is-active');
      html.classList.remove('is-clipped');
      body.style.paddingRight = 'unset';
      navbar.style.paddingRight = 'unset';
    }

    if (imageModal) {
      const imageModalTrigger = document.getElementById('show-image-modal');
      imageModalTrigger.addEventListener('click', () => {
        showModal(imageModal);
      });

      const imageModalCloseButton = imageModal.querySelector('.modal-close');
      imageModalCloseButton.addEventListener('click', () => {
        hideModal(imageModal);
      });

      const imageModalBg = imageModal.querySelector('.modal-background');
      imageModalBg.addEventListener('click', () => {
        hideModal(imageModal);
      });
    }

    if (signInModal) {
      const signInModalTriggers = Array.prototype.slice.call(document.querySelectorAll('.js-show-sign-in-modal'), 0);
      signInModalTriggers.forEach((signInModalTrigger) => {
        signInModalTrigger.addEventListener('click', () => {
          showModal(signInModal);
          signInModalTrigger.blur();
        });
      });

      const signInModalCloseButton = signInModal.querySelector('.modal-close');
      signInModalCloseButton.addEventListener('click', () => {
        hideModal(signInModal);
      });

      const signInModalBg = signInModal.querySelector('.modal-background');
      signInModalBg.addEventListener('click', () => {
        hideModal(signInModal);
      });
    }
  });
};
