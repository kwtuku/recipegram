export default () => {
  if (document.getElementById('loading-animation') === null) return false;

  window.addEventListener(
    'scroll',
    () => {
      if (document.getElementById('loading-animation') === null) return false;
      if (document.getElementById('next-page-link').dataset.loading) return false;

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
        document.getElementById('loading-animation');
        const link = document.getElementById('next-page-link');
        link.click();
        link.dataset.loading = 'true';
      }
    },
    { passive: true },
  );
};
