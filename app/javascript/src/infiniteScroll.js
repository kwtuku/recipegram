export default () => {
  document.addEventListener('turbolinks:load', () => {
    window.infiniteScrollContainer = document.getElementById('infinite-scroll-container')
    if (!infiniteScrollContainer) {
      return
    }

    infiniteScrollContainer.dataset.infiniteScroll = 'true';

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

        const recipes = Array.prototype.slice.call(document.querySelectorAll('[data-infinite-scroll-item]'), 0);
        const recipesSize = recipes.length;

        $.ajax({
          type: 'GET',
          url: '/show_additionally',
          cache: false,
          data: {recipesSize: recipesSize, remote: true}
        });
      }
    }, {passive: true});
  });
}
