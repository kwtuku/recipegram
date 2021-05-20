export default () => {
  document.addEventListener('turbolinks:load', function() {
    // 一番下までスクロールしたか判断
    const scrollHeight = Math.max(
      document.body.scrollHeight, document.documentElement.scrollHeight,
      document.body.offsetHeight, document.documentElement.offsetHeight,
      document.body.clientHeight, document.documentElement.clientHeight
      );
    const pageMostBottom = scrollHeight - window.innerHeight;


    window.recipeContainer = document.getElementById('recipe-container')
    let oldestRecipeId
    // レシピの追加読み込みの可否を決定する変数
    window.showAdditionally = true


    window.addEventListener('scroll', () => {
    // 一番下までスクロールしたか判断
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

      if (scrollTop >= pageMostBottom && showAdditionally) {
        showAdditionally = false
        // 表示済みのレシピの内，最も古いidを取得
        oldestRecipeId = document.getElementsByClassName('recipe')[0].id.replace(/[^0-9]/g, '')


        // Ajax を利用してレシピの追加読み込みリクエストを送る。最も古いレシピidも送信しておく。
        $.ajax({
          type: 'GET',
          url: '/show_additionally',
          cache: false,
          data: {oldest_recipe_id: oldestRecipeId, remote: true}
        })
      }
    }, {passive: true});
  });
}
