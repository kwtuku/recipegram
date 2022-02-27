/**
 * @jest-environment jsdom
 */

import modal from '../modal';

function fixture(isActive = false) {
  return `
    <div class="navbar"></div>
    <figure id="show-image-modal" data-test="trigger"></figure>
    <div class="modal ${isActive ? 'is-active' : ''}" id="image-modal" data-test="modal">
      <div class="modal-background" data-test="modal-background"></div>
      <div class="modal-content"></div>
      <button class="modal-close" data-test="close-button"></button>
    </div>
  `;
}

test('adds .is-active to a modal after click a button', () => {
  document.body.innerHTML = fixture();
  modal();

  document.querySelector('[data-test="trigger"]').click();
  expect(document.querySelector('[data-test="modal"]').classList.contains('is-active')).toBeTruthy();
});

test('removes .is-active from a modal after click a modal background', () => {
  document.body.innerHTML = fixture(true);
  modal();

  expect(document.querySelector('[data-test="modal"]').classList.contains('is-active')).toBeTruthy();
  document.querySelector('[data-test="modal-background"]').click();
  expect(document.querySelector('[data-test="modal"]').classList.contains('is-active')).toBeFalsy();
});

test('removes .is-active from a modal after click a close button', () => {
  document.body.innerHTML = fixture(true);
  modal();

  expect(document.querySelector('[data-test="modal"]').classList.contains('is-active')).toBeTruthy();
  document.querySelector('[data-test="close-button"]').click();
  expect(document.querySelector('[data-test="modal"]').classList.contains('is-active')).toBeFalsy();
});
