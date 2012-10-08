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
  $("#linkedin_import_submit").click(function() { $("#linkedin_import").submit(); });

});

$(function() {
  $('#search_form').submit(function(e, ui) { 
      e.preventDefault();
  });
  $('#search_form').click(function(e, ui) { 
      e.preventDefault();
  });
  
  $('#autocomplete').catcomplete({ 
    source: function (request, response) {
        $.getJSON("../autocomplete/wonderbar", {"term": request.term}, function(results){
            results.push({
              label: 'Add Contact',
              category: 'Actions',
	      icon: 'dicon-contact',
              value: request.term
            }
            );
            results.push({
              label: 'Add Group',
              category: 'Actions',
	      icon: 'dicon-circles',
              value: request.term
            }
            );
            response(results);
            return false;
        });
    },
    delay: 300,       
    minLength: 3, 
    autoFocus: true,
    select: function (event, ui) {
        $(event.target).val(ui.item.value);
        if (ui.item.label == "Add Contact") {
            var show_id,
            addName = ui.item.value;           
            $("#search_form").attr('action','/help');
            var newContact = new RippleApp.Models.Contact({name: addName});
            newContact.save({name: addName}, {success: 
                function(model, response) {
                    show_id = response._id;
                    var url = "/app/#contacts/show/" + show_id;
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
                var url = "/app/#groups/show/" + show_id;
                window.location.href = url;
              }
            });
        } else {
            addName = ui.item.value;
            if (ui.item.category == "Contact"){
              var url = "/app/#contacts/show/" + ui.item.id;              
            } else if (ui.item.category == "Group"){
              var url = "/app/#groups/show/" + ui.item.id;
            } else if (ui.item.category == "User"){
              var url = "/app/#users/preview/" + ui.item.id;
            }          
            window.location.href = url;
            console.log(ui.item.category)
        }
        $('#autocomplete').val('')
        return false;
    }
    }).data( "catcomplete" )._renderItem = function( ul, item ) {
      if (item.avatar == null) {
	var avatar = "<span class='" + item.icon + "'></span>"
      } else {
	var avatar = "<img src='" + item.avatar + "'></img>"
      }      
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a><span class='search-avatar'>" + avatar + "</span><span class='search-label'>" + item.label + "</span></a>" )
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

