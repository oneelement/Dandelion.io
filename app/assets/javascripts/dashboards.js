
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
ContactArray = $.map(tags, function(i) { return i.label; });
$(function() {
  $('#autocomplete').autocomplete({
   source: function (request, response) {
        var results = $.ui.autocomplete.filter(ContactArray, request.term);

        if (!results.length) {
            $("#searchbutton").attr('value','Add');
            $("#search_form").attr('action','/contacts/new');
        } else {
           $("#searchbutton").attr('value','Search');
            $("#search_form").attr('action','/contacts');

        }
        response(results);
   }
    ,
    delay: 100,
    minLength: 2
  });});
