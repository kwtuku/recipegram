// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';

import activateButton from '../src/activateButton';
import countCharacters from '../src/countCharacters';
import deleteNotification from '../src/deleteNotification';
import dropdown from '../src/dropdown';
import handleSearchInput from '../src/handleSearchInput';
import handlePagination from '../src/handlePagination';
import handlePasswordMask from '../src/handlePasswordMask';
import handleTag from '../src/handleTag';
import modal from '../src/modal';
import moveConfirmation from '../src/moveConfirmation';
import readmore from '../src/readmore';
import resizeTextarea from '../src/resizeTextarea';
import searchHistory from '../src/searchHistory';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

document.addEventListener('turbolinks:load', () => {
  activateButton();
  countCharacters();
  deleteNotification();
  dropdown();
  handleSearchInput();
  handleTag();
  handlePagination();
  modal();
  moveConfirmation();
  readmore();
  handlePasswordMask();
  resizeTextarea();
  searchHistory();
});
