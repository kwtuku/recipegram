export default () => {
  const readmore = document.getElementById('readmore');

  if (readmore === null) return false;

  const oldestComment = document.querySelector('.oldest-comment');
  const allComments = document.querySelector('.all-comments');

  readmore.addEventListener('click', () => {
    oldestComment.classList.add('is-hidden');
    allComments.classList.remove('is-hidden');
  });

  const readless = document.getElementById('readless');

  readless.addEventListener('click', () => {
    oldestComment.classList.remove('is-hidden');
    allComments.classList.add('is-hidden');
  });
};
