export default () => {
  document.addEventListener('turbolinks:load', () => {
    const inputs = Array.prototype.slice.call(document.querySelectorAll('input'), 0);
    const textarea = document.querySelector('textarea');

    const username = document.getElementById("user_username");
    const email = document.getElementById("user_email");
    const password = document.getElementById("user_password");
    const passwordConfirmation = document.getElementById("user_password_confirmation");
    const currentPassword = document.getElementById("user_current_password");
    const recipeTitle = document.getElementById("recipe_title");
    const recipeBody = document.getElementById("recipe_body");
    const recipeImage = document.getElementById("recipe_recipe_image");
    const commentBody = document.getElementById("comment_body");

    const signup = document.getElementById("signup");
    const signin = document.getElementById("signin");
    const updateAccount = document.getElementById("update_account");
    const resetPassword = document.getElementById("reset_password");
    const updateUser = document.getElementById("update_user");
    const createRecipe = document.getElementById("create_recipe");
    const updateRecipe = document.getElementById("update_recipe");
    const createComment =document.getElementById("create_comment");

    if (signup) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (username.value && email.value && password.value.length >= 6 && passwordConfirmation.value.length >= 6) {
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
          if (email.value && password.value.length >= 6) {
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
          if (username.value && email.value && currentPassword.value.length >= 6) {
            updateAccount.disabled = false;
          } else {
            updateAccount.disabled = true;
          }
        });
      });
    }

    if (resetPassword) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (email.value) {
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
          if (username.value) {
            updateUser.disabled = false;
          } else {
            updateUser.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (username.value && textarea.value) {
          updateUser.disabled = false;
        }
      });
    }

    if (createRecipe) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (recipeTitle.value && recipeBody.value) {
            createRecipe.disabled = false;
          } else {
            createRecipe.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (recipeTitle.value && recipeBody.value) {
          createRecipe.disabled = false;
        } else {
          createRecipe.disabled = true;
        }
      });
    }

    if (updateRecipe) {
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          if (recipeTitle.value && recipeBody.value) {
            updateRecipe.disabled = false;
            recipeImage.required = false;
          } else {
            updateRecipe.disabled = true;
          }
        });
      });
      textarea.addEventListener('input', () => {
        if (recipeTitle.value && recipeBody.value) {
          updateRecipe.disabled = false;
          recipeImage.required = false;
        } else {
          updateRecipe.disabled = true;
        }
      });
    }

    if (createComment) {
      textarea.addEventListener('input', () => {
        if (commentBody.value) {
          createComment.disabled = false;
        } else {
          createComment.disabled = true;
        }
      });
    }
  });
}
