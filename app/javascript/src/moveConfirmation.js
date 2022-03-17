export default () => {
  function openDialog(event) {
    event.preventDefault();
    event.returnValue = '';
  }

  function moveConfirmation(currentInputTrimmedValues, inputs) {
    let isSubmitting = false;

    window.addEventListener('beforeunload', (event) => {
      const newInputTrimmedValues = inputs.map((input) => input.value.trim());

      if (!isSubmitting && JSON.stringify(currentInputTrimmedValues) !== JSON.stringify(newInputTrimmedValues)) {
        openDialog(event);
      }
    });

    window.addEventListener('submit', () => {
      isSubmitting = true;
    });
  }

  const updateAccountButton = document.getElementById('update_account');
  const updateUserButton = document.getElementById('update_user');
  const createRecipeButton = document.getElementById('create_recipe');
  const updateRecipeButton = document.getElementById('update_recipe');

  if (updateAccountButton) {
    const username = document.getElementById('user_username');
    const email = document.getElementById('user_email');
    const password = document.getElementById('user_password');
    const passwordConfirmation = document.getElementById('user_password_confirmation');

    const inputs = [username, email, password, passwordConfirmation];
    const currentInputTrimmedValues = inputs.map((input) => input.value.trim());

    moveConfirmation(currentInputTrimmedValues, inputs);
  }

  if (updateUserButton) {
    const nickname = document.getElementById('user_nickname');
    const profile = document.getElementById('user_profile');

    const inputs = [nickname, profile];
    const currentInputTrimmedValues = inputs.map((input) => input.value.trim());

    moveConfirmation(currentInputTrimmedValues, inputs);
  }

  if (createRecipeButton || updateRecipeButton) {
    const title = document.getElementById('recipe_title');
    const body = document.getElementById('recipe_body');
    const tagList = document.getElementById('recipe_tag_list');

    const inputs = [title, body, tagList];
    const currentInputTrimmedValues = inputs.map((input) => input.value.trim());

    moveConfirmation(currentInputTrimmedValues, inputs);
  }
};
