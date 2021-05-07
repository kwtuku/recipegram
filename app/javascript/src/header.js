export default () => {
  document.addEventListener('DOMContentLoaded', function() {
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

    if ($navbarBurgers.length > 0) {
      $navbarBurgers.forEach( el => {
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        el.addEventListener('click', () => {
          el.classList.toggle('is-active');
          $target.classList.toggle('is-active');
        });

        document.addEventListener('click', (e) => {
          if (!e.target.closest('.navbar')) {
            el.classList.remove('is-active');
            $target.classList.remove('is-active');
          }
        });
      });
    }
  });
}
