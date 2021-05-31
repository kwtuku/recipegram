export default () => {
  document.addEventListener('turbolinks:load', () => {
    window.recipeContainer = document.getElementById('recipe-container');
    if (!recipeContainer) {
      return
    }

    let lastRecipeId;

    window.showAdditionally = true;

    window.addEventListener('scroll', () => {
      const scrollHeight = Math.max(
        document.body.scrollHeight, document.documentElement.scrollHeight,
        document.body.offsetHeight, document.documentElement.offsetHeight,
        document.body.clientHeight, document.documentElement.clientHeight
        );
      const pageMostBottom = scrollHeight - window.innerHeight;
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

      if (scrollTop >= pageMostBottom * 0.9 && showAdditionally) {
        showAdditionally = false;

        const recipes = Array.prototype.slice.call(document.getElementsByClassName('recipe'), 0);
        lastRecipeId = recipes.slice(-1)[0].id.replace(/[^0-9]/g, '');

        $.ajax({
          type: 'GET',
          url: '/show_additionally',
          cache: false,
          data: {last_recipe_id: lastRecipeId, remote: true}
        });
      }
    }, {passive: true});
  });
}
