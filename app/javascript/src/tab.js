export default () => {
  document.addEventListener('DOMContentLoaded', function() {
    const $tabs = Array.prototype.slice.call(document.querySelectorAll('.tab'), 0);

    if ($tabs.length > 0) {
      $tabs.forEach( el => {
        el.addEventListener('click', () => {
          $tabs.forEach( el => {
            el.classList.remove('is-active');
          });
          const $tabContents = Array.prototype.slice.call(document.querySelectorAll('.tab-content'), 0);
          $tabContents.forEach( el => {
            const $tabContentsChirdlen = Array.prototype.slice.call(el.children, 0);
            $tabContentsChirdlen.forEach( el => {
              el.classList.add('display_none');
            });
          });

          el.classList.add('is-active');
          const $targetTabContentsChirdlen = Array.prototype.slice.call($tabContents[$tabs.indexOf(el)].children, 0);
          $targetTabContentsChirdlen.forEach( el => {
            el.classList.remove('display_none');
          });

        });
      });
    }
  });
}
