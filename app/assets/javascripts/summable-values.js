(function ($) {
  'use strict';

  function format(value) {
    return ('' + value).replace(/(\d)(?=(\d{3})+$)/g, '$1,');
  }

  $('.js-summable').on('change', function() {
    var summedValue, group;

    $.each($('.js-summed-value'), function(i, sumElement) {
      group = $(sumElement).data('group') || 'all';
      summedValue = 0;

      $.each($('.js-summable'), function(i, el) {
        if(group === 'all' || group === $(el).data('group')) {
          summedValue += parseInt(el.value);
        }
      });

      $(sumElement).html('£' + format(summedValue))
    });
  })
})(jQuery);
