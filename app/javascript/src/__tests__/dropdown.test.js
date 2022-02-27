/**
 * @jest-environment jsdom
 */

import dropdown from '../dropdown';

function fixture(isActive = false) {
  return `
    <div data-test="outside-element"></div>
    <div class="dropdown ${isActive ? 'is-active' : ''}" data-test="dropdown-1">
      <div class="dropdown-trigger">
        <button class="button" data-test="button-1">
          <span class="icon">
            <i class="fa fa-ellipsis-h"></i>
          </span>
        </button>
      </div>
      <div class="dropdown-menu">
        <div class="dropdown-content">
          <a class="dropdown-item" data-test="inside-element">
            <span class="icon">
              <i class="fas fa-edit"></i>
            </span>
            <span>編集する</span>
          </a>
        </div>
      </div>
    </div>
    <div class="dropdown" data-test="dropdown-2">
      <div class="dropdown-trigger">
        <button class="button" data-test="button-2">
          <span class="icon">
            <i class="fa fa-ellipsis-h"></i>
          </span>
        </button>
      </div>
      <div class="dropdown-menu">
        <div class="dropdown-content">
          <a class="dropdown-item">
            <span class="icon">
              <i class="fas fa-edit"></i>
            </span>
            <span>編集する</span>
          </a>
        </div>
      </div>
    </div>
  `;
}

test('adds .is-active to a dropdown after click a button', () => {
  document.body.innerHTML = fixture();
  dropdown();

  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeFalsy();
  expect(document.querySelector('[data-test="dropdown-2"]').classList.contains('is-active')).toBeFalsy();
  document.querySelector('[data-test="button-2"]').click();
  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeFalsy();
  expect(document.querySelector('[data-test="dropdown-2"]').classList.contains('is-active')).toBeTruthy();
});

test('removes .is-active from a dropdown after click outside of a dropdown', () => {
  document.body.innerHTML = fixture(true);
  dropdown();

  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeTruthy();
  document.querySelector('[data-test="outside-element"]').click();
  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeFalsy();
});

test('does not remove .is-active from a dropdown after click inside of a dropdown', () => {
  document.body.innerHTML = fixture(true);
  dropdown();

  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeTruthy();
  document.querySelector('[data-test="inside-element"]').click();
  expect(document.querySelector('[data-test="dropdown-1"]').classList.contains('is-active')).toBeTruthy();
});
