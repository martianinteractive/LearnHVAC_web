function setup_group_scenarios() { 
	$('.add').live('click', function() { Group.addItem(this); })
    $('.delete').live('click', function() { Group.deleteItem(this); })
}

Group = {
    addItem: function(item) {
        template = eval(item.href.replace(/.*#/, ''));
        template = replace_ids(template);
        element = $(item).parent().before(template);
        return false;
    },

    deleteItem: function(item) {
        $(item).parent().remove();
    }
}


replace_ids = function(s) {
    var new_id = new Date().getTime();
    return s.replace(/NEW_RECORD/g, new_id);
}

