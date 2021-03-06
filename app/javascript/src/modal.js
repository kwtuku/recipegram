export default () => {
  document.addEventListener('turbolinks:load', () => {
    const modals = Array.prototype.slice.call(document.querySelectorAll('.modal'), 0);
    if (modals === null) {
      return false;
    }

    modals.forEach( modal => {
      const modalTriggerImage = document.querySelector('#open-modal > img');
      const html = document.querySelector('html');
      const body = document.querySelector('body');
      modalTriggerImage.addEventListener('click', () => {
        modal.classList.add('is-active');
        html.classList.add('is-clipped');
        body.classList.add('mr-4');
      });

      const button = document.querySelector('.modal button');
      button.addEventListener('click', () => {
        modal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });

      const modalBg = document.querySelector('.modal-background');
      modalBg.addEventListener('click', () => {
        modal.classList.remove('is-active');
        html.classList.remove('is-clipped');
        body.classList.remove('mr-4');
      });
    });
  });
}
