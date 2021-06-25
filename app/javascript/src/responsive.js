export default () => {
  document.addEventListener('turbolinks:load', () => {
    const addClassTargets = Array.prototype.slice.call(document.querySelectorAll('[data-add-class-mobile]'), 0);
    const removeClassTargets = Array.prototype.slice.call(document.querySelectorAll('[data-remove-class-mobile]'), 0);
    if (addClassTargets === null && removeClassTargets === null) {
      return false;
    }

    const addClass = () => {
      addClassTargets.forEach( target => {
        const classNames = target.dataset.addClassMobile.split(' ');

        window.addEventListener('resize', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.add(...classNames);
          } else {
            target.classList.remove(...classNames);
          }
        });

        window.addEventListener('pageshow', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.add(...classNames);
          } else {
            target.classList.remove(...classNames);
          }
        });
      });
    };

    const removeClass = () => {
      removeClassTargets.forEach( target => {
        const classNames = target.dataset.removeClassMobile.split(' ');

        window.addEventListener('resize', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.remove(...classNames);
          } else {
            target.classList.add(...classNames);
          }
        });

        window.addEventListener('pageshow', () => {
          const windowWidth = window.innerWidth;

          if (windowWidth <= 768) {
            target.classList.remove(...classNames);
          } else {
            target.classList.add(...classNames);
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