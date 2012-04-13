var outerLayout; 

$(document).ready(function () { 

outerLayout = $('body').layout({ 
    center__paneSelector: ".outer-center", 
    west__paneSelector: ".outer-west", 
    east__paneSelector: ".outer-east",
    north__paneSelector: ".outer-north",
    contentSelector: ".content",
    west__size: 280 ,
    spacing_open: 8, // ALL panes
    spacing_closed: 12, // ALL panes
    //north__spacing_open: 0,
    //south__spacing_open: 0,
    north__size: 40,
    north__resizable: false,
    north__closable: false,
    north__spacing_open: 0
    }); 
}); 



jQuery(document).ready(function() {
    $('#autocomplete').typeahead({
      source: [{value: 'Charlie'}, {value: 'Gudbergur'}]
    });
});
