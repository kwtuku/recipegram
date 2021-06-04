export default () => {
  document.addEventListener('turbolinks:load', () => {
    window.infiniteScrollContainer = document.getElementById('infinite-scroll-container')
    if (!infiniteScrollContainer) {
      return
    }

    window.addEventListener('scroll', () => {
      const scrollHeight = Math.max(
        document.body.scrollHeight, document.documentElement.scrollHeight,
        document.body.offsetHeight, document.documentElement.offsetHeight,
        document.body.clientHeight, document.documentElement.clientHeight
        );
      const pageMostBottom = scrollHeight - window.innerHeight;
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

      if (scrollTop >= pageMostBottom * 0.9 && infiniteScrollContainer.dataset.infiniteScroll === 'true') {
        infiniteScrollContainer.dataset.infiniteScroll = 'false';

        const items = Array.prototype.slice.call(document.querySelectorAll('[data-infinite-scroll-item]'), 0);
        const itemsSize = items.length;

        let type;

        if (location.pathname === '/') {
          type = 'home_home';
        } else if (location.pathname === '/recipes') {
          type = 'recipes_index';
        }

        $.ajax({
          type: 'GET',
          url: '/show_additionally',
          cache: false,
          data: {itemsSize: itemsSize, type: type, remote: true}
        });
      }
    }, {passive: true});
  });
}
