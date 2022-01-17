export default () => {
  document.addEventListener('turbolinks:load', () => {
    const updateUser = document.getElementById('update_user');
    const createRecipe = document.getElementById('create_recipe');
    const updateRecipe = document.getElementById('update_recipe');
    const createComment = document.getElementById('create_comment');

    if (updateUser) {
      const nickname = document.getElementById('user_nickname');
      const countNicknameCharacters = document.getElementById(
        'count-nickname-characters',
      );

      nickname.addEventListener('input', () => {
        countNicknameCharacters.textContent = nickname.value.length;
        if (nickname.value.length > 30) {
          nickname.classList.add('is-danger');
          countNicknameCharacters.classList.add('has-text-danger');
        } else {
          nickname.classList.remove('is-danger');
          countNicknameCharacters.classList.remove('has-text-danger');
        }
      });

      const profile = document.getElementById('user_profile');
      const countProfileCharacters = document.getElementById(
        'count-profile-characters',
      );

      profile.addEventListener('input', () => {
        countProfileCharacters.textContent = profile.value.length;
        if (profile.value.length > 500) {
          profile.classList.add('is-danger');
          countProfileCharacters.classList.add('has-text-danger');
        } else {
          profile.classList.remove('is-danger');
          countProfileCharacters.classList.remove('has-text-danger');
        }
      });
    }

    if (createRecipe || updateRecipe) {
      const recipeTitle = document.getElementById('recipe_title');
      const countRecipeTitleCharacters = document.getElementById(
        'count-recipe-title-characters',
      );

      recipeTitle.addEventListener('input', () => {
        countRecipeTitleCharacters.textContent = recipeTitle.value.length;
        if (recipeTitle.value.length > 30) {
          recipeTitle.classList.add('is-danger');
          countRecipeTitleCharacters.classList.add('has-text-danger');
        } else {
          recipeTitle.classList.remove('is-danger');
          countRecipeTitleCharacters.classList.remove('has-text-danger');
        }
      });

      const recipeBody = document.getElementById('recipe_body');
      const countRecipeBodyCharacters = document.getElementById(
        'count-recipe-body-characters',
      );

      recipeBody.addEventListener('input', () => {
        countRecipeBodyCharacters.textContent = recipeBody.value.length;
        if (recipeBody.value.length > 2000) {
          recipeBody.classList.add('is-danger');
          countRecipeBodyCharacters.classList.add('has-text-danger');
        } else {
          recipeBody.classList.remove('is-danger');
          countRecipeBodyCharacters.classList.remove('has-text-danger');
        }
      });
    }

    if (createComment) {
      const commentBody = document.getElementById('comment_body');
      const countCommentBodyCharacters = document.getElementById(
        'count-comment-body-characters',
      );

      commentBody.addEventListener('input', () => {
        countCommentBodyCharacters.textContent = commentBody.value.length;
        if (commentBody.value.length > 500) {
          commentBody.classList.add('is-danger');
          countCommentBodyCharacters.classList.add('has-text-danger');
        } else {
          commentBody.classList.remove('is-danger');
          countCommentBodyCharacters.classList.remove('has-text-danger');
        }
      });
    }
  });
};
