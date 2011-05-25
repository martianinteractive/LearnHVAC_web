$(document).ready(function() {
        if($('#user_role_code').val() != 1){
            $('#students').hide();
        }else{
            $('#students').show();
        }
        
	$("#scenario_longterm_start_date").datepicker();
	$("#scenario_longterm_stop_date").datepicker();	
	
	$(function() {
		$("#tabs").no_ajax_tabs();
		$("#inner-tabs").no_ajax_tabs();
	});
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
      
});