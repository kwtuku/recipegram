export default () => {
  document.addEventListener('turbolinks:load', () => {
    let searchHistories = JSON.parse(localStorage.getItem('search-histories')) || [];
    const suggestContainer = document.getElementById('suggest-container');
    const input = document.getElementById('q');

    let suggests = '';
    searchHistories.slice(0, 5).forEach((value) => {
      suggests += `
        <a class="panel-block is-flex is-justify-content-space-between is-align-items-center"
          href="/search?q=${encodeURI(value)}" data-search-history="suggest" data-search-history-value="${value}"
        >
          <span>${value}</span>
          <button class="delete is-small js-delete-suggest"></button>
        </a>
      `;
    });
    suggestContainer.insertAdjacentHTML('beforeend', suggests);

    input.addEventListener('focus', () => {
      if (JSON.parse(localStorage.getItem('search-histories'))?.length) {
        suggestContainer.classList.remove('is-hidden');
      }
    });

    document.addEventListener('click', (e) => {
      if (
        !e.target.closest('#search-form') &&
        !e.target.closest('#suggest-container') &&
        !e.target.closest('.js-delete-suggest') &&
        !e.target.closest('#expand-search-input')
      ) {
        suggestContainer.classList.add('is-hidden');
      }
    });

    input.addEventListener('keydown', (e) => {
      if (input.value.trim() && e.key === 'Enter') {
        if (input.value.trim() !== '' && searchHistories.indexOf(input.value) === -1) {
          searchHistories.unshift(input.value);
          searchHistories.splice(20);
        }
        localStorage.setItem('search-histories', JSON.stringify(searchHistories));
      }
    });

    const allSuggestDeleteTrigger = document.getElementById('delete-all-suggests');
    allSuggestDeleteTrigger.addEventListener('click', () => {
      suggestContainer.classList.add('is-hidden');
      document.querySelectorAll('[data-search-history]').forEach((suggestEl) => {
        suggestEl.remove();
      });
      searchHistories = [];
      localStorage.removeItem('search-histories');
    });

    const deleteSuggestButtons = document.querySelectorAll('.js-delete-suggest');
    deleteSuggestButtons.forEach((button) => {
      const suggestEl = button.parentNode;
      const suggestValue = suggestEl.dataset.searchHistoryValue;

      button.addEventListener('click', (e) => {
        e.preventDefault();
        suggestEl.remove();
        searchHistories.splice(searchHistories.indexOf(suggestValue), 1);
        localStorage.setItem('search-histories', JSON.stringify(searchHistories));

        if (JSON.parse(localStorage.getItem('search-histories')).length === 0) {
          suggestContainer.classList.add('is-hidden');
        }
      });
    });
  });
};
