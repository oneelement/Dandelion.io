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

        if (!results.length) {
	    $(".icon-search").addClass('disabled');
	    $(".icon-plus").removeClass('disabled');
            $("#searchbutton").attr('value','');
            $("#search_form").attr('action','/contacts/');
	    $("ul.ui-autocomplete").css('display','block');
	    $("ul.ui-autocomplete").after("<ul id='ripple-search-add'></ul>");
	    $("#ripple-search-add").html();
	    $("#ripple-search-add").html("<li><a><span class='rip-search-label'>Add Contact</span></a></li>");
	    
        } else {
	    $(".icon-search").removeClass('disabled');
	    $(".icon-plus").addClass('disabled');
            $("#searchbutton").attr('value','');
            $("#search_form").attr('action','/contacts');
	    $("#ripple-search-add").remove();
        }
        response(results);
        return false;
    },
    delay: 100,       
    minLength: 2,  
    select: function (event, ui) {
        $(event.target).val(ui.item.id);
        var url =   "/contacts/#show/" + ui.item.id;
        window.location.href = url;
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



