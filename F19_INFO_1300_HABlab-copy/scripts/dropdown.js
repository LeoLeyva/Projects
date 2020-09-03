// When the document is ready
$(document).ready(function() {

  // When the rooms nav item is clicked
  $("#members-tab").hover( function () {
    $("#membersDropdown").removeClass("hidden");
    }, function(){
    $("#membersDropdown").addClass("hidden");
  });

  $("#membersDropdown").hover( function () {
    $("#membersDropdown").removeClass("hidden");
    }, function(){
    $("#membersDropdown").addClass("hidden");
  });
});
