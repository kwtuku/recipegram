export default () => {
  document.addEventListener('turbolinks:load', () => {
    const passwordMasks = Array.prototype.slice.call(document.querySelectorAll('.password-mask'), 0);
    if (passwordMasks === null) {
      return false;
    }

    passwordMasks.forEach( passwordMask => {
      const input = passwordMask.previousElementSibling.firstElementChild;
      const icon = passwordMask.querySelector('i');
      const button = passwordMask.querySelector('button');

      passwordMask.addEventListener('click', () => {
        if (input.getAttribute('type') === 'password') {
          input.setAttribute('type', 'text');
          icon.setAttribute('class','far fa-eye');
          button.setAttribute('title','パスワードを非表示にする');
        } else {
          input.setAttribute('type', 'password');
          icon.setAttribute('class','far fa-eye-slash');
          button.setAttribute('title','パスワードを表示する');
        }
      });

      document.addEventListener('click', (e) => {
        if(!e.target.closest('.password-area')) {
          input.setAttribute('type', 'password');
          icon.setAttribute('class','far fa-eye-slash');
          button.setAttribute('title','パスワードを非表示にする');
        }
      });

      window.addEventListener('scroll', () => {
        input.setAttribute('type', 'password');
        icon.setAttribute('class','far fa-eye-slash');
        button.setAttribute('title','パスワードを表示する');
      });
    });
  });
}
