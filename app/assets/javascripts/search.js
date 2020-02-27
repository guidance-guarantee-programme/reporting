(function($) {
  'use strict';

  var search = {
    init: function() {
      this.$form = $('.js-form');
      this.$query = $('.js-query');
      this.$search = $('.js-search');
      this.$results = $('.js-results-body');

      this.$query.val('');
      this.applications = this.$form.data('applications');
      this.bindEvents();
    },

    bindEvents: function() {
      this.$form.on('submit', this.performSearch.bind(this));
      this.$search.on('click', this.performSearch.bind(this));
    },

    performSearch: function(e) {
      e.preventDefault();
      this.$results.empty();

      $.each(this.applications, this.searchApplication.bind(this));
    },

    searchApplication: function(i, obj) {
      $.ajax({
        url: obj.url,
        datatype: 'json',
        data: { query: this.$query.val() },
        success: this.bindResults.bind(this),
        headers: { Authorization: 'Bearer ' + obj.bearer }
      });
    },

    bindResults: function(data) {
      $.each(data, this.bindResult.bind(this));
    },

    bindResult: function(i, json) {
      this.$results.append(HandlebarsTemplates['result'](json));
    },
  };

  window.Reporting = window.Reporting || {};
  window.Reporting.search = search;

})(jQuery);
