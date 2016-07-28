(function ($) {
  'use strict';

  function format(value) {
    return ('' + value).replace(/(\d)(?=(\d{3})+$)/g, '$1,');
  }

  $('.js-summable').on('change', function() {
    var summedValue = 0;

    $.each($('.js-summable'), function(i, el) {
      summedValue += parseInt(el.value);
    });

    $('.js-summed-value').html('£' + format(summedValue))
  })
})(jQuery);
