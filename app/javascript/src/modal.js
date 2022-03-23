export default () => {
  const signInModal = document.getElementById('sign-in-modal');

  if (signInModal === null) return false;

  const html = document.querySelector('html');
  const body = document.querySelector('body');
  const navbar = document.querySelector('.navbar');

  const scrollbarMeasure = document.createElement('div');
  scrollbarMeasure.setAttribute('style', 'visibility: hidden; position: absolute; top: 0; left: 0; width: 100vw;');
  document.body.appendChild(scrollbarMeasure);
  const viewportWidth = parseInt(window.getComputedStyle(scrollbarMeasure).width, 10);
  scrollbarMeasure.style.width = '100%';
  const percentWidth = parseInt(window.getComputedStyle(scrollbarMeasure).width, 10);
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

  const signInModalTriggers = [].slice.call(document.querySelectorAll('.js-show-sign-in-modal'), 0);
  signInModalTriggers.forEach((signInModalTrigger) => {
    signInModalTrigger.addEventListener('click', (e) => {
      e.preventDefault();
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
};
