$(document).ready(function() {
  $('.animated').live('click', function() {
    $(this).parent().html('<div id="circle"><div id="circle_1" class="circle"></div><div id="circle_2" class="circle"></div><div id="circle_3" class="circle"></div><div class="clearfix"></div>');
  });
});
