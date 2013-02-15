$(document).ready(function() {

  var errorTimeout = setTimeout(function() {
    if (typeof tbody == 'undefined') {
      $('#pages-info').html('You don\'t have any pages yet').fadeIn('slow');
    }
  }, 5000);


  $.getJSON($('#pages-content').data('url'), function(data) {
    clearTimeout(errorTimeout); 
    
    var tbody = '';

    $.each(data, function(key, val) {
        tbody += '<tr>';
        tbody += '<td>' + val.name + '</td>';
        tbody += '<td>' + val.title + '</td>';
        tbody += '<td>' + val.description + '</td>';
        tbody += '</tr>';
    });

    $('#pages-content tbody').html(tbody);
    $('#pages-info').fadeOut('slow');
    $('#pages-content table').fadeIn('slow');
  });


});
