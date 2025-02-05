document.addEventListener("turbo:load", function() {
  const radioGroups = document.querySelectorAll('.radio-group');

  radioGroups.forEach(group => {
    group.addEventListener('keydown', (event) => {
      if (event.key >= '1' && event.key <= '5') {
        const selectedValue = event.key;
        const radioInput = group.querySelector(`input[type="radio"][value="${selectedValue}"]`);
        
        if (radioInput) {
          radioInput.checked = true;
          radioInput.focus();
          event.preventDefault();
        }
      }
    });
  });
});

document.addEventListener("turbo:load", () => {
  const toggleButtons = document.querySelectorAll('.toggle-password');

  toggleButtons.forEach(button => {
    button.addEventListener('click', () => {
      const targetSelector = button.getAttribute('data-target');
      const passwordField = document.querySelector(targetSelector);

      if (passwordField) {
        const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordField.setAttribute('type', type);

        const icon = button.querySelector('span');
        if (type === 'text') {
          icon.classList.remove('glyphicon-eye-open');
          icon.classList.add('glyphicon-eye-close');
        } else {
          icon.classList.remove('glyphicon-eye-close');
          icon.classList.add('glyphicon-eye-open');
        }
      }
    });
  });
});
