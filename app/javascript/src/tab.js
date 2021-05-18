export default () => {
  document.addEventListener('turbolinks:load', function() {
    const tabs = Array.prototype.slice.call(document.querySelectorAll('.tabs li'), 0);

    if (tabs.length > 0) {
      tabs.forEach( tab => {
        tab.addEventListener('click', () => {
          tabs.forEach( tab => {
            tab.classList.remove('is-active');
          });

          const target = document.getElementById(tab.dataset.target);
          const tabContents = Array.prototype.slice.call(document.querySelectorAll('#tab-contents > div'), 0);
          tabContents.forEach( tabContent => {
            tabContent.classList.add('is-hidden');
          });

          tab.classList.add('is-active');
          target.classList.remove('is-hidden');
        });
      });
    }
  });
}