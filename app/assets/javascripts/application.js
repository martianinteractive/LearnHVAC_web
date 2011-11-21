//= require jquery.min
//= require jquery-ui
//= require jquery_ujs
//= require jquery.dataTables.min
//= require jquery.tablesorter
//= require prettify
//= require jquery.fcbkcomplete.min

$(document).ready(function() {
  if($('#user_role_code').val() != 1){
    $('#students').hide();
  } else {
    $('#students').show();
  }

  $("#scenario_longterm_start_date").datepicker();
  $("#scenario_longterm_stop_date").datepicker();

  $('#user_role_code_0').click(function(){
    groups = $('#groups');
    scenarios = $('#scenarios');
    if((groups.val()+scenarios.val()) > 0){
      var x = confirm('You have groups and/or scenarios. If you change your profile to guest, you will loose access to the groups. Are you sure?');
      if(!x){
        $('#user_role_code_2').click();
      }
    }
  });
  $('#user_role_code').change(function(){
    if(this.value != 1){
      $('#students').hide();
    }else{
      $('#students').show();
    }
  });
  $('#instructor').change(function(){
    $.ajax({
      type: 'get',
      url: '/list_groups/'+this.value,
      success: function(data) {
      },
      error : function(){
        alert("FAILURE");
      }
    });
  });
  $("#class_notification_email_recipients").fcbkcomplete({cache: true, filter_case: true, filter_hide: true, newel: true});
});
