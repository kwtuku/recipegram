export default () => {
  document.addEventListener('turbolinks:load', () => {
    const deleteButtons = [].slice.call(document.querySelectorAll('.notification .delete'), 0);

    if (deleteButtons === null) return false;

    deleteButtons.forEach((deleteButton) => {
      const notification = deleteButton.parentNode;

      deleteButton.addEventListener('click', () => {
        notification.remove();
      });
    });
  });
};
