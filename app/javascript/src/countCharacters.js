export default () => {
  document.addEventListener('turbolinks:load', () => {
    const inputs = Array.prototype.slice.call(document.querySelectorAll('input'), 0);
    const textarea = document.querySelector('textarea');

    const recipeTitle = document.getElementById('recipe_title');
    const recipeBody = document.getElementById('recipe_body');
    const commentBody = document.getElementById('comment_body');

    const createRecipe = document.getElementById('create_recipe');
    const updateRecipe = document.getElementById('update_recipe');
    const createComment = document.getElementById('create_comment');

    if (createRecipe || updateRecipe) {
      const countRecipeTitleCharacters = document.getElementById('count-recipe-title-characters');
      const countRecipeBodyCharacters = document.getElementById('count-recipe-body-characters');
      inputs.forEach(input => {
        input.addEventListener('input', () => {
          countRecipeTitleCharacters.textContent = recipeTitle.value.length;
          if (recipeTitle.value.length > 30) {
            recipeTitle.classList.add('is-danger')
            countRecipeTitleCharacters.classList.add('has-text-danger')
          } else {
            recipeTitle.classList.remove('is-danger')
            countRecipeTitleCharacters.classList.remove('has-text-danger')
          }
        });
      });
      textarea.addEventListener('input', () => {
        countRecipeBodyCharacters.textContent = recipeBody.value.length;
        if (recipeBody.value.length > 2000) {
          recipeBody.classList.add('is-danger')
          countRecipeBodyCharacters.classList.add('has-text-danger')
        } else {
          recipeBody.classList.remove('is-danger')
          countRecipeBodyCharacters.classList.remove('has-text-danger')
        }
      });
    }

    if (createComment) {
      const countCommentBodyCharacters = document.getElementById('count-comment-body-characters');
      textarea.addEventListener('input', () => {
        countCommentBodyCharacters.textContent = commentBody.value.length;
        if (commentBody.value.length > 500) {
          commentBody.classList.add('is-danger')
          countCommentBodyCharacters.classList.add('has-text-danger')
        } else {
          commentBody.classList.remove('is-danger')
          countCommentBodyCharacters.classList.remove('has-text-danger')
        }
      });
    }
  });
}
