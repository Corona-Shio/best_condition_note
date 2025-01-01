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