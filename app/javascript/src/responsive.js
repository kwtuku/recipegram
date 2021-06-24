export default () => {
  document.addEventListener('turbolinks:load', () => {
    const addClassTargets = Array.prototype.slice.call(document.querySelectorAll('[data-add-class-mobile]'), 0);
    const removeClassTargets = Array.prototype.slice.call(document.querySelectorAll('[data-remove-class-mobile]'), 0);
    if (addClassTargets === null && removeClassTargets === null) {
      return false;
    }

    const addClass = () => {
      addClassTargets.forEach( target => {
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
    };

    const removeClass = () => {
      removeClassTargets.forEach( target => {
        const className = target.dataset.removeClassMobile

        window.addEventListener('resize', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.remove(className);
          } else {
            target.classList.add(className);
          }
        });

        window.addEventListener('pageshow', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.remove(className);
          } else {
            target.classList.add(className);
          }
        });
      });
    };

    if (addClassTargets !== null && removeClassTargets === null) {
      addClass();
    }
    if (addClassTargets === null && removeClassTargets !== null) {
      removeClass();
    }
    if (addClassTargets !== null && removeClassTargets !== null) {
      addClass();
      removeClass();
    }
  });
}
