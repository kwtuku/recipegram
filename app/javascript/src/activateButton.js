export default () => {
  document.addEventListener('turbolinks:load', () => {
    const inputs = Array.prototype.slice.call(document.querySelectorAll('input'), 0);
    const textarea = document.querySelector('textarea');

    const username = document.getElementById('user_username');
    const nickname = document.getElementById('user_nickname');
    const email = document.getElementById('user_email');
    const password = document.getElementById('user_password');
    const passwordConfirmation = document.getElementById('user_password_confirmation');
    const currentPassword = document.getElementById('user_current_password');
    const recipeTitle = document.getElementById('recipe_title');
    const recipeBody = document.getElementById('recipe_body');
    const recipeImage = document.getElementById('recipe_recipe_image');
    const commentBody = document.getElementById('comment_body');
    const searchQueries = Array.prototype.slice.call(document.querySelectorAll('#search_query'), 0);

    const signup = document.getElementById('signup');
    const signin = document.getElementById('signin');
    const updateAccount = document.getElementById('update_account');
    const destroyAccount = document.getElementById('destroy_account');
    const resetPassword = document.getElementById('reset_password');
    const updateUser = document.getElementById('update_user');
    const createRecipe = document.getElementById('create_recipe');
    const updateRecipe = document.getElementById('update_recipe');
    const createComment =document.getElementById('create_comment');
    const searchButtons = Array.prototype.slice.call(document.querySelectorAll('#search'), 0);

    if (signup) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (username.value.trim() && nickname.value.trim() && email.value.trim() && password.value.trim().length >= 6 && passwordConfirmation.value.trim().length >= 6) {
            signup.disabled = false;
          } else {
            signup.disabled = true;
          }
        });
      });
    }

    if (signin) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (email.value.trim() && password.value.trim().length >= 6) {
            signin.disabled = false;
          } else {
            signin.disabled = true;
          }
        });
      });
    }

    if (updateAccount) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (username.value.trim() && email.value.trim() && currentPassword.value.trim().length >= 6) {
            updateAccount.disabled = false;
          } else {
            updateAccount.disabled = true;
          }
        });
      });
    }

    if (destroyAccount) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (currentPassword.value.trim().length >= 6) {
            destroyAccount.disabled = false;
          } else {
            destroyAccount.disabled = true;
          }
        });
      });
    }

    if (resetPassword) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (email.value.trim()) {
            resetPassword.disabled = false;
          } else {
            resetPassword.disabled = true;
          }
        });
      });
    }

    if (updateUser) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (nickname.value.trim()) {
            updateUser.disabled = false;
          } else {
            updateUser.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (nickname.value.trim()) {
          updateUser.disabled = false;
        }
      });
    }

    if (createRecipe) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (recipeTitle.value.trim() && recipeBody.value.trim() && recipeImage.value) {
            createRecipe.disabled = false;
          } else {
            createRecipe.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (recipeTitle.value.trim() && recipeBody.value.trim() && recipeImage.value) {
          createRecipe.disabled = false;
        } else {
          createRecipe.disabled = true;
        }
      });
    }

    if (updateRecipe) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (recipeTitle.value.trim() && recipeBody.value.trim()) {
            updateRecipe.disabled = false;
            recipeImage.required = false;
          } else {
            updateRecipe.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (recipeTitle.value.trim() && recipeBody.value.trim()) {
          updateRecipe.disabled = false;
          recipeImage.required = false;
        } else {
          updateRecipe.disabled = true;
        }
      });
    }

    if (createComment) {
      textarea.addEventListener('input', () => {
        if (commentBody.value.trim()) {
          createComment.disabled = false;
        } else {
          createComment.disabled = true;
        }
      });
    }

    if (searchButtons) {
      for (let i = 0; i < searchButtons.length; i++) {
        searchQueries[i].addEventListener('input', () => {
          if (searchQueries[i].value.trim()) {
            searchButtons[i].disabled = false;
          } else {
            searchButtons[i].disabled = true;
          }
        });
      }
    }
  });
}
