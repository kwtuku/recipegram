import Tagify from '@yaireo/tagify'

export default () => {
  document.addEventListener('turbolinks:load', () => {
    const tagInput = document.getElementById('recipe_tag_list')

    if (tagInput === null) return false;

    new Tagify(tagInput, {
      originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(','),
    })
  });
}
