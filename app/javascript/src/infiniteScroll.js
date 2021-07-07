export default () => {
  document.addEventListener('turbolinks:load', () => {
    window.infiniteScrollContainer = document.getElementById('infinite-scroll-container')

    window.addEventListener('scroll', () => {
      if (infiniteScrollContainer === null) {
        return false;
      }

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
        let paramsId;
        const regexp = /users\/\d/;

        if (location.pathname === '/') {
          type = 'home_home';
        } else if (location.pathname === '/recipes') {
          type = 'recipes_index';
        } else if (location.pathname === '/users') {
          type = 'users_index';
        } else if (location.pathname.indexOf('followings') !== -1) {
          type = 'followings';
          paramsId = location.pathname.replace(/\D/g, '');
        } else if (location.pathname.indexOf('followers') !== -1) {
          type = 'followers';
          paramsId = location.pathname.replace(/\D/g, '');
        } else if (location.pathname.indexOf('favorites') !== -1) {
          type = 'favorites';
          paramsId = location.pathname.replace(/\D/g, '');
        } else if (regexp.test(location.pathname)) {
          type = 'users_show';
          paramsId = location.pathname.replace(/\D/g, '');
        }

        $.ajax({
          type: 'GET',
          url: '/infinite_scroll',
          cache: false,
          data: {itemsSize: itemsSize, type: type, remote: true, paramsId: paramsId}
        });
      }
    }, {passive: true});
  });
}
