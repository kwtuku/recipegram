export default () => {
  document.addEventListener('turbolinks:load', () => {
    const deleteButtons = document.querySelectorAll('.notification .delete');
    if (deleteButtons === null) {
      return false;
    }

    (deleteButtons || []).forEach((deleteButton) => {
      const notification = deleteButton.parentNode;

      deleteButton.addEventListener('click', () => {
        notification.remove();
      });
    });
  });
};
