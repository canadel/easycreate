<% unless flash[:error].blank? %>
  $("#flash_notice").hide();
  $("#flash_notice").html("<%= escape_javascript(flash[:error])%>");
  $("#flash_notice").fadeIn(500).delay(1000).fadeOut(1000);
<% else %>
  $('#content').html("<%= escape_javascript(render :partial => 'domain', :collection => @domains) %>");
<% end %>