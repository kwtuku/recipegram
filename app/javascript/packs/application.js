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
import handleTag from '../src/handleTag';
import imagePreview from '../src/imagePreview';
import infiniteScroll from '../src/infiniteScroll';
import modal from '../src/modal';
import moveConfirmation from '../src/moveConfirmation';
import readmore from '../src/readmore';
import removePasswordMask from '../src/removePasswordMask';
import resizeTextarea from '../src/resizeTextarea';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

activateButton();
countCharacters();
deleteNotification();
dropdown();
handleTag();
imagePreview();
infiniteScroll();
modal();
moveConfirmation();
readmore();
removePasswordMask();
resizeTextarea();
