export default () => {
  document.addEventListener('turbolinks:load', () => {
    window.infiniteScrollContainer = document.getElementById('infinite-scroll-container');

    window.addEventListener(
      'scroll',
      () => {
        if (infiniteScrollContainer === null) return false;

        if (infiniteScrollContainer.dataset.infiniteScroll !== 'true') return false;

        const scrollHeight = Math.max(
          document.body.scrollHeight,
          document.documentElement.scrollHeight,
          document.body.offsetHeight,
          document.documentElement.offsetHeight,
          document.body.clientHeight,
          document.documentElement.clientHeight,
        );
        const pageMostBottom = scrollHeight - window.innerHeight;
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        if (scrollTop >= pageMostBottom * 0.8) {
          infiniteScrollContainer.dataset.infiniteScroll = 'false';

          const items = Array.prototype.slice.call(document.querySelectorAll('[data-infinite-scroll-item]'), 0);
          const displayedItemCount = items.length;
          const path = location.pathname.slice(1);

          $.ajax({
            type: 'GET',
            url: '/infinite_scroll',
            cache: false,
            data: {
              displayed_item_count: displayedItemCount,
              path: path,
              remote: true,
            },
          });
        }
      },
      { passive: true },
    );
  });
};
