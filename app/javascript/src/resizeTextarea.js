export default () => {
  document.addEventListener('turbolinks:load', function() {
    const textarea = document.querySelector("textarea");

    if (textarea) {
      window.addEventListener('turbolinks:load', () => {
        const PADDING_Y = 20;
        let lineHeight = getComputedStyle(textarea).lineHeight;
        lineHeight = lineHeight.replace(/[^-\d\.]/g, '');
        const lines = (textarea.value + '\n').match(/\n/g).length;
        textarea.style.height = lineHeight * lines + PADDING_Y + 'px';
      });
      textarea.addEventListener('input', () => {
        const PADDING_Y = 20;
        let lineHeight = getComputedStyle(textarea).lineHeight;
        lineHeight = lineHeight.replace(/[^-\d\.]/g, '');
        const lines = (textarea.value + '\n').match(/\n/g).length;
        textarea.style.height = lineHeight * lines + PADDING_Y + 'px';
      });
    }
  });
}
