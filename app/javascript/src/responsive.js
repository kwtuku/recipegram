export default () => {
  document.addEventListener('turbolinks:load', () => {
    const targets = Array.prototype.slice.call(document.querySelectorAll('[data-add-class-mobile]'), 0);
    if (targets === null) {
      return false;
    }

    targets.forEach( target => {
      const className = target.dataset.addClassMobile

      window.addEventListener('resize', () => {
        const windowWidth = window.innerWidth;

        if (windowWidth <= 768) {
          target.classList.add(className);
        } else {
          target.classList.remove(className);
        }
      });

      window.addEventListener('pageshow', () => {
        const windowWidth = window.innerWidth;

        if (windowWidth <= 768) {
          target.classList.add(className);
        } else {
          target.classList.remove(className);
        }
      });
    });
  });
}
