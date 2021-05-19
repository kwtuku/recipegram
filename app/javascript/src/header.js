export default () => {
  document.addEventListener('turbolinks:load', function() {
    const navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

    if (navbarBurgers.length > 0) {
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

        window.addEventListener('scroll', (e) => {
          navbarBurger.classList.remove('is-active');
          target.classList.remove('is-active');
        });
      });
    }
  });
}
