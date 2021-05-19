export default () => {
  document.addEventListener('turbolinks:load', function() {
    const readmore = document.querySelector('#readmore');
    const readless = document.querySelector('#readless');
    const oldestComment = document.querySelector('.oldest-comment');
    const allComments = document.querySelector('.all-comments');

    if (readmore) {
      readmore.addEventListener('click', () => {
        oldestComment.classList.add('is-hidden');
        allComments.classList.remove('is-hidden');
      });

      readless.addEventListener('click', () => {
        oldestComment.classList.remove('is-hidden');
        allComments.classList.add('is-hidden');
      });
    }
  });
}
