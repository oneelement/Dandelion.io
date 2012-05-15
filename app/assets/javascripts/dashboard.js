if (window.location.hash == '#_=_')window.location.hash = '';

$(document).ready(function(){
  $('#select_all').click(function(event) { 
        $(':checkbox').each(function() {
            this.checked = true;                        
        });
  });
  $('#deselect_all').click(function(event) { 
        $(':checkbox').each(function() {
            this.checked = false;                        
        });
  });
  $("#facebook_import_submit").click(function() { $("#facebook_import").submit(); });

});



var tags = (function () {
    var json = null;
    $.ajax({
        'async': false,
        'global': false,
        'url':"../contacts/autocomplete" ,
        'dataType': "json",
        'success': function (data) {
            json = data;
        }
    });
    return json;
})(); 
$(function() {
  $('#autocomplete').catcomplete({ 
    source: function (request, response) {
        var results = $.ui.autocomplete.filter(tags, request.term);
	results.push({
	  label: 'Add Contact',
	  category: 'Actions',
	  value: request.term
	}
	);
	results.push({
	  label: 'Add Group',
	  category: 'Actions',
	  value: request.term
	}
	);
	results.push({
	  label: 'Add Task',
	  category: 'Actions',
	  value: request.term
	}
	);
	
        if (!results.length) {
	    $(".icon-search").addClass('disabled');
	    $(".icon-plus").removeClass('disabled');
            $("#searchbutton").attr('value','');
            $("#search_form").attr('action','/');
	    
        } else {
	    $(".icon-search").removeClass('disabled');
	    $(".icon-plus").addClass('disabled');
            $("#searchbutton").attr('value','');
            $("#search_form").attr('action','/');
        }
        response(results);
        return false;
    },
    delay: 100,       
    minLength: 2,  
    select: function (event, ui) {
        $(event.target).val(ui.item.id);
	
	if (ui.item.label == "Add Contact") {
	    var show_id
	    var addName = ui.item.value;
	    $("#search_form").attr('action','/help');
	    console.log(addName);
	    console.log(ui);
	    console.log(event);
	    var newContact = new RippleApp.Models.Contact({name: addName})
	    newContact.save({name: addName}, {success: 
	      function(model, response) {
		  show_id = response._id;
		  console.log(show_id);
		  var url = "/#contacts/show/" + show_id;
		  window.location.href = url;
	      }
	    });	    
	    
	} else if (ui.item.label == "Add Group") {
	    var show_id
	    var addGroup = ui.item.value;
	    $("#search_form").attr('action','/help');
	    console.log(addGroup);
	    console.log(ui);
	    console.log(event);
	    var newGroup = new RippleApp.Models.Group({name: addGroup})
	    newGroup.save({name: addGroup}, {success: 
	      function(model, response) {
		  show_id = response._id;
		  console.log(show_id);
		  var url = "/#groups/show/" + show_id;
		  window.location.href = url;
	      }
	    });	    
	    
	} else {
	    var url =   "/#contacts/show/" + ui.item.id;
	    window.location.href = url;
	} 	
        return false;
    }
  })
  .data( "catcomplete" )._renderItem = function( ul, item ) {
	  return $( "<li></li>" )
		  .data( "item.autocomplete", item )
		  .append( "<a><span class='rip-search-label'>" + item.label + "</span><span class='ripicon " + item.icon + "'></span></a>" )
		  .appendTo( ul );
  };
  
});

$.widget( "custom.catcomplete", $.ui.autocomplete, {
	_renderMenu: function( ul, items ) {
		var self = this,
			currentCategory = "";
		$.each( items, function( index, item ) {
			if ( item.category != currentCategory ) {
				ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
				currentCategory = item.category;
			}
			self._renderItem( ul, item );
		});
	}
});



