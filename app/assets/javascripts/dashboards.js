$(function() {
  $('#autocomplete').autocomplete({
    source: "/contacts/autocomplete",
    delay: 100,
    minLength: 2,
    select: function (event, ui) {
		$(event.target).val(ui.item.id);
		window.location = "/contacts/" + ui.item.id;
		return false;
	}
  });
});






