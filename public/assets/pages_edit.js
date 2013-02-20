$(document).ready(function() {

  var errorTimeout = setTimeout(function() {
    if (typeof tbody == 'undefined') {
      $('#page-form-status').html('Can\'t connect to DumboCMS').fadeIn('slow');
    }
  }, 10000);


  var apiUrl     = $('#page-form').data('api');
  var apiToken  = $('#page-form').data('token');
  var requestUrl = apiUrl + '?token=' + apiToken + '&callback=?';

  $.getJSON(requestUrl, function(data) {
    clearTimeout(errorTimeout);
    $('input#page_title').val(data[0].title);
    $('input#page_description').val(data[0].description);
    $('#page-form-status').fadeOut('slow');
    $('#page-form').fadeIn('slow');
  });

  submitButton = $('#submit');

  submitButton.click(function() {

    submitButton.val('Please, wait...');

    var requestData = 'token=' + apiToken + '&' + $('#page-form > form').serialize();

    $.ajax({
      url: apiUrl,
      type: 'post',
      data: requestData,
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-Http-Method-Override', 'PUT');
      },
      success: function(data) {
        window.location.href = '/pages'; 
      }
    });

    return false;
  });

});
