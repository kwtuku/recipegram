export default () => {
  const textarea = document.querySelector('.js-resize-textarea');

  if (textarea === null) return false;

  const textareaClientHeight = textarea.clientHeight;

  textarea.addEventListener('input', () => {
    textarea.style.height = `${textareaClientHeight + 2}px`;

    const textareaScrollHeight = textarea.scrollHeight;
    textarea.style.height = `${textareaScrollHeight + 2}px`;
  });
};
