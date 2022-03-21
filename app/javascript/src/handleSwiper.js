import Swiper from 'swiper/swiper-bundle.min';

export default () => {
  if (document.querySelector('.swiper') === null) return;

  /* eslint-disable no-new */
  new Swiper('.swiper', {
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });
  /* eslint-able no-new */
};
