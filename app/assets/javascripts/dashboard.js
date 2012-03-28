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
  $('#autocomplete').autocomplete({ 
    source: function (request, response) {
        var results = $.ui.autocomplete.filter(tags, request.term);

        if (!results.length) {
            $("#searchbutton").attr('value','Add');
            $("#search_form").attr('action','/contacts/new');
        } else {
           $("#searchbutton").attr('value','Search');
            $("#search_form").attr('action','/contacts');

        }
        response(results);
        return false;
    },
    delay: 100,       
    minLength: 2,  
    select: function (event, ui) {
        $(event.target).val(ui.item.id);
        var url =   "/contacts/" + ui.item.id;
        window.location.href = url;
        return false;
    }
  });
});
