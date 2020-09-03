$(document).ready(function () {


  $("#course_form").on("submit", function() {
    var formValid = true;

    if($("#name_input").prop("validity").valid){
      $("#nameError").addClass("hidden");
    } else {
      $("#nameError").removeClass("hidden");
      formValid = false;
    };

    if($("#email_input").prop("validity").valid){
      $("#emailError").addClass("hidden");
    } else {
      $("#emailError").removeClass("hidden");
      formValid = false;
    };

    if($("#experience").prop("validity").valid){
      $("#experienceError").addClass("hidden");
    } else {
      $("#experienceError").removeClass("hidden");
      formValid = false;
    };

    if($("#age_input").prop("validity").valid){
      $("#ageError").addClass("hidden");
    } else {
      $("#ageError").removeClass("hidden");
      formValid = false;
    };

    if($("#country_input").prop("validity").valid){
      $("#countryError").addClass("hidden");
    } else {
      $("#countryError").removeClass("hidden");
      formValid = false;
    };

    if($("#duration_input").prop("validity").valid){
      $("#durationError").addClass("hidden");
    } else {
      $("#durationError").removeClass("hidden");
      formValid = false;
    };

    if($("#rating_1").prop("validity").valid){
      $("#difficultyError").addClass("hidden");
    } else {
      $("#difficultyError").removeClass("hidden");
      formValid = false;
    };

    if($("#rate_1").prop("validity").valid){
      $("#organizationError").addClass("hidden");
    } else {
      $("#organizationError").removeClass("hidden");
      formValid = false;
    };

    if($("#rate_one").prop("validity").valid){
      $("#clarityError").addClass("hidden");
    } else {
      $("#clarityError").removeClass("hidden");
      formValid = false;
    };


    return formValid;
  });
  
  $("#reset").click(function(){
    $("#nameError").addClass("hidden");
    $("#emailError").addClass("hidden");
    $("#experienceError").addClass("hidden");
    $("#ageError").addClass("hidden");
    $("#countryError").addClass("hidden");
    $("#durationError").addClass("hidden");
    $("#difficultyError").addClass("hidden");
    $("#organizationError").addClass("hidden");
    $("#clarityError").addClass("hidden");
  });
});
