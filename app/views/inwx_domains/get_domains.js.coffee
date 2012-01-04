if "<%= escape_javascript(flash[:error])%>"?
  $("#flash_notice").hide();
  $("#flash_notice").html("<%= escape_javascript(flash[:error])%>");
  $("#flash_notice").fadeIn(500).delay(1000).fadeOut(1000);
end