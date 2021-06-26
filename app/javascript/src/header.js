export default () => {
  document.addEventListener('turbolinks:load', () => {
    const navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
    if (navbarBurgers === null) {
      return false;
    }

    navbarBurgers.forEach( navbarBurger => {
      const target = document.getElementById(navbarBurger.dataset.target);

      navbarBurger.addEventListener('click', () => {
        navbarBurger.classList.toggle('is-active');
        target.classList.toggle('is-active');
      });

      document.addEventListener('click', (e) => {
        if (!e.target.closest('.navbar')) {
          navbarBurger.classList.remove('is-active');
          target.classList.remove('is-active');
        }
      });

      window.addEventListener('scroll', () => {
        navbarBurger.classList.remove('is-active');
        target.classList.remove('is-active');
      });
    });
  });
}
