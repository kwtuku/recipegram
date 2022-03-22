export default () => {
  const signup = document.getElementById('signup');
  const signin = document.getElementById('signin');
  const updateAccount = document.getElementById('update_account');
  const destroyAccount = document.getElementById('destroy_account');
  const resetPassword = document.getElementById('reset_password');
  const updateUser = document.getElementById('update_user');
  const createComment = document.getElementById('create_comment');
  const searchInput = document.getElementById('q');

  const inputs = [].slice.call(document.querySelectorAll('input'), 0);

  const username = document.getElementById('user_username');
  const nickname = document.getElementById('user_nickname');
  const email = document.getElementById('user_email');
  const password = document.getElementById('user_password');
  const passwordConfirmation = document.getElementById('user_password_confirmation');
  const currentPassword = document.getElementById('user_current_password');

  if (signup) {
    inputs.forEach((input) => {
      input.addEventListener('input', () => {
        if (
          username.value.trim() &&
          nickname.value.trim() &&
          email.value.trim() &&
          password.value.trim().length >= 6 &&
          passwordConfirmation.value.trim().length >= 6
        ) {
          signup.disabled = false;
        } else {
          signup.disabled = true;
        }
      });
    });
  }

  if (signin) {
    inputs.forEach((input) => {
      input.addEventListener('input', () => {
        if (email.value.trim() && password.value.trim().length >= 6) {
          signin.disabled = false;
        } else {
          signin.disabled = true;
        }
      });
    });
  }

  if (updateAccount) {
    inputs.forEach((input) => {
      input.addEventListener('input', () => {
        if (username.value.trim() && email.value.trim() && currentPassword.value.trim().length >= 6) {
          updateAccount.disabled = false;
        } else {
          updateAccount.disabled = true;
        }
      });
    });
  }

  if (destroyAccount) {
    currentPassword.addEventListener('input', () => {
      if (currentPassword.value.trim().length >= 6) {
        destroyAccount.disabled = false;
      } else {
        destroyAccount.disabled = true;
      }
    });
  }

  if (resetPassword) {
    email.addEventListener('input', () => {
      if (email.value.trim()) {
        resetPassword.disabled = false;
      } else {
        resetPassword.disabled = true;
      }
    });
  }

  if (updateUser) {
    const profile = document.getElementById('user_profile');

    inputs.forEach((input) => {
      input.addEventListener('input', () => {
        if (nickname.value.trim()) {
          updateUser.disabled = false;
        } else {
          updateUser.disabled = true;
        }
      });
    });
    profile.addEventListener('input', () => {
      if (nickname.value.trim()) {
        updateUser.disabled = false;
      }
    });
  }

  if (createComment) {
    const commentBody = document.getElementById('comment_body');

    commentBody.addEventListener('input', () => {
      if (commentBody.value.trim()) {
        createComment.disabled = false;
      } else {
        createComment.disabled = true;
      }
    });
  }

  if (searchInput) {
    searchInput.addEventListener('keydown', (e) => {
      if (!searchInput.value.trim() && e.key === 'Enter') {
        e.preventDefault();
      }
    });
  }
};
