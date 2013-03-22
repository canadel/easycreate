$('.thumbnail').live('click', function() {
  
  $('input#package').val($(this).data('package'));
  
  $('.thumbnail').each(function() {
    $(this).removeClass('template-selected');
  });
    
  $(this).addClass('template-selected');

});

