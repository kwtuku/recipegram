export default () => {
  document.addEventListener('turbolinks:load', () => {
    const expandTrigger = document.getElementById('expand-search-input');
    const shrinkTrigger = document.getElementById('shrink-search-input');
    const input = document.getElementById('q');
    const navbarBrand = document.getElementById('navbar-brand');
    const navbarMenu = document.getElementById('navbar-menu');
    const navbarEnd = document.getElementById('navbar-end');

    expandTrigger?.addEventListener('click', () => {
      navbarBrand.classList.add('is-hidden-mobile');
      navbarMenu.classList.add('is-block-mobile');
      navbarMenu.style.overflow = 'visible';
      navbarEnd.classList.add('is-hidden-mobile');
      input.focus();
      const valueEnd = input.value.length;
      input.setSelectionRange(valueEnd, valueEnd);
    });

    shrinkTrigger.addEventListener('click', () => {
      navbarBrand.classList.remove('is-hidden-mobile');
      navbarMenu.classList.remove('is-block-mobile');
      navbarMenu.style.overflow = 'unset';
      navbarEnd.classList.remove('is-hidden-mobile');
    });

    document.addEventListener('click', (e) => {
      if (
        !e.target.closest('#navbar-menu') &&
        !e.target.closest('#expand-search-input') &&
        !e.target.closest('.js-delete-suggest')
      ) {
        navbarBrand.classList.remove('is-hidden-mobile');
        navbarMenu.classList.remove('is-block-mobile');
        navbarMenu.style.overflow = 'unset';
        navbarEnd.classList.remove('is-hidden-mobile');
      }
    });
  });
};
