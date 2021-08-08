export default () => {
  document.addEventListener('turbolinks:load', () => {
    const inputs = Array.prototype.slice.call(document.querySelectorAll('input'), 0);
    const textarea = document.querySelector('textarea');

    const recipeTitle = document.getElementById('recipe_title');
    const recipeBody = document.getElementById('recipe_body');

    const createRecipe = document.getElementById('create_recipe');

    if (createRecipe) {
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
  });
}
