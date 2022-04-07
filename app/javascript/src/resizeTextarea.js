export default () => {
  const textarea = document.querySelector('.js-resize-textarea');

  if (textarea === null) return false;

  const textareaClientHeight = textarea.clientHeight;
  textarea.style.height = `${textareaClientHeight + 2}px`;

  let textareaScrollHeight = textarea.scrollHeight;
  textarea.style.height = `${textareaScrollHeight + 2}px`;

  textarea.addEventListener('input', () => {
    textarea.style.height = `${textareaClientHeight + 2}px`;

    textareaScrollHeight = textarea.scrollHeight;
    textarea.style.height = `${textareaScrollHeight + 2}px`;
  });
};
