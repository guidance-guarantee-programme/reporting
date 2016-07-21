(function ($) {
  'use strict';

  var fileSelectInput = $('.js-file-select');
  var fileNameOutput = $('.js-file-select__name');

  fileSelectInput.on('change', function(e) {
    if(this.files[0]) {
      fileNameOutput.html(this.files[0].name);
    } else {
      fileNameOutput.html('');
    }
  });
})(jQuery);
