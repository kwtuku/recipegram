import Tagify from '@yaireo/tagify'

export default () => {
  document.addEventListener('turbolinks:load', () => {
    const tagInput = document.getElementById('recipe_tag_list')

    if (tagInput === null) return false;

    const tagify = new Tagify(tagInput, {
      originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(','),
      whitelist: [],
      delimiters: ',| ',
      dropdown: {
        classname: 'custom-tagify-look card',
        maxItems: 5,
      },
      maxTags: 5,
    })
    let controller;

    tagify.on('input', onInput)

    function onInput(e) {
      const value = e.detail.value

      if (!value) return false;

      tagify.whitelist = null

      controller && controller.abort()
      controller = new AbortController()

      tagify.loading(true).dropdown.hide()

      fetch(`/tags?name=${value}`, { signal: controller.signal })
        .then(RES => RES.json())
        .then(function (newWhitelist) {
          tagify.whitelist = newWhitelist.data
          tagify.loading(false).dropdown.show(value)
        })
    }
  });
}
