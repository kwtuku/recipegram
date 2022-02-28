/**
 * @jest-environment jsdom
 */

import deleteNotification from '../deleteNotification';

test('removes a notification after click a button', () => {
  document.body.innerHTML = `
    <div class="notification" data-test="notification-1">
      <button class="delete"></button>
      <p>レシピを投稿しました。</p>
    </div>
    <div class="notification" data-test="notification-2">
      <button class="delete" data-test="button-2"></button>
      <p>レシピを投稿しました。</p>
    </div>
  `;
  deleteNotification();

  expect(document.querySelector('[data-test="notification-1"]')).toBeTruthy();
  expect(document.querySelector('[data-test="notification-2"]')).toBeTruthy();
  document.querySelector('[data-test="button-2"]').click();
  expect(document.querySelector('[data-test="notification-1"]')).toBeTruthy();
  expect(document.querySelector('[data-test="notification-2"]')).toBeNull();
});
