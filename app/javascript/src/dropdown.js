export default () => {
  document.addEventListener('DOMContentLoaded', function() {
    const $dropdownTriggers = Array.prototype.slice.call(document.querySelectorAll('.dropdown-trigger'), 0);

    if ($dropdownTriggers.length > 0) {
      $dropdownTriggers.forEach( el => {
        const $button = el.querySelector('button');
        const $dropdown = el.parentNode;

        $button.addEventListener('click', () => {
          $dropdown.classList.toggle('is-active');
        });

        document.addEventListener('click', (e) => {
          if(!e.target.closest('.dropdown')) {
            $dropdown.classList.remove('is-active');
          }
        })
      });
    }
  });
}
