var outerLayout; 
var innerLayout; 

$(document).ready(function () { 
  
outerLayout = $('body').layout({ 
    center__paneSelector: ".outer-center", 
    west__paneSelector: ".outer-west", 
    east__paneSelector: ".outer-east",
    north__paneSelector: ".outer-north",
    contentSelector: ".content",
    west__size: 400 ,
    spacing_open: 8, // ALL panes
    spacing_closed: 12, // ALL panes
    //north__spacing_open: 0,
    //south__spacing_open: 0,
    north__size: 40,
    north__resizable: false,
    north__closable: false,
    north__spacing_open: 0,
    west__resizable: false,
    west__closable: false,
    west__spacing_open: 0
    }); 

innerLayout = $('div.outer-west').layout({ 
    center__paneSelector: ".inner-center", 
    west__paneSelector: ".inner-west", 
    south__paneSelector: ".footer",
    contentSelector: ".content",
    south__size: 40 ,
    south__resizable: false,
    south__closable: false,
    west__size: 70 ,
    west__resizable: false,
    west__closable: false,
    center__size: 400 ,
    center__resizable: false,
    center__closable: false,
    spacing_open: 0, // ALL panes
    spacing_closed: 0 // ALL panes
    }); 

}); 