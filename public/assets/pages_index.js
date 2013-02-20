$(document).ready(function() {

  var errorTimeout = setTimeout(function() {
    if (typeof tbody == 'undefined') {
      $('#status').html('You don\'t have any pages yet').fadeIn('slow');
    }
  }, 10000);

  var requestUrl = $('#page-list').data('api') + '?' + $('#page-list').data('params') 

  $.getJSON(requestUrl, function(data) {
    clearTimeout(errorTimeout); 
    
    var tbody = '';

    var editPath = $('#page-list').data('edit');

    $.each(data, function(key, val) {
        tbody += '<tr>';
        tbody += '<td>' + val.name + '</td>';
        tbody += '<td>' + val.title + '</td>';
        tbody += '<td>' + val.description + '</td>';
        tbody += '<td><a href="' + editPath + '/' + val.id + '/edit">Edit</a></td>';
        tbody += '</tr>';
    });

    $('#page-list tbody').html(tbody);
    $('#page-list-status').fadeOut('slow');
    $('#page-list').fadeIn('slow');
  });


});
