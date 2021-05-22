export default () => {
  document.addEventListener('turbolinks:load', () => {
    const passwordMasks = Array.prototype.slice.call(document.querySelectorAll('.password-mask'), 0);

    if (passwordMasks) {
      passwordMasks.forEach( passwordMask => {
        passwordMask.addEventListener('click', () => {
          const input = passwordMask.previousElementSibling.firstElementChild;
          const icon = passwordMask.querySelector('i');

          if (input.getAttribute('type') === 'password') {
            input.setAttribute('type', 'text');
            icon.setAttribute('class','far fa-eye');
          } else {
            input.setAttribute('type', 'password');
            icon.setAttribute('class','far fa-eye-slash');
          }
        });
      });
    }
  });
}
