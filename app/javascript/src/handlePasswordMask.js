export default () => {
  const passwordFormControls = [].slice.call(document.querySelectorAll('.js-handle-password-mask'), 0);

  if (passwordFormControls === null) return false;

  passwordFormControls.forEach((formControl) => {
    const input = formControl.querySelector('input');
    const icon = formControl.querySelector('i');
    const iconContainer = icon.parentNode;

    iconContainer.addEventListener('click', () => {
      if (input.getAttribute('type') === 'password') {
        input.setAttribute('type', 'text');
        icon.setAttribute('class', 'far fa-eye');
        iconContainer.setAttribute('title', 'パスワードを非表示にする');
      } else {
        input.setAttribute('type', 'password');
        icon.setAttribute('class', 'far fa-eye-slash');
        iconContainer.setAttribute('title', 'パスワードを表示する');
      }
    });

    document.addEventListener('click', (e) => {
      if (!e.target.closest('.js-handle-password-mask')) {
        input.setAttribute('type', 'password');
        icon.setAttribute('class', 'far fa-eye-slash');
        iconContainer.setAttribute('title', 'パスワードを表示にする');
      }
    });
  });
};
