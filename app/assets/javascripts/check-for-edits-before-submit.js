(function ($) {
  'use strict';

  var dataForm = $('.js-check-for-edits-before-submit');
  var dataFormOriginalData = dataForm.serialize();

  var displayedMonthForm = $('.js-month-form');
  var displayedMonthField = $('.js-month');
  var hiddenMonthField = $('.js-month-hidden');

  var linkToDifferentMonth = $('.js-before-submit');

  var message = "Do you want to leave this site?\nChanges you have made may not be saved.";

  dataForm.submit(function() {
    dataFormOriginalData = dataForm.serialize();
  });

  $(window).bind('beforeunload', function(e) {
    if (dataForm.serialize() != dataFormOriginalData) {
      setTimeout(function() {
        displayedMonthField.val(hiddenMonthField.val());
      }, 10);

      e.returnValue = message; // Cross-browser compatibility (src: MDN)
      return message;
    }
  });

  linkToDifferentMonth.on('click', function(e) {
    if (dataForm.serialize() != dataFormOriginalData) {
      if (!confirm(message)) {
        e.preventDefault();
      }
    }
  });

  displayedMonthField.on('change', function() {
    displayedMonthForm.submit();
  });
})(jQuery);
