// When the document is ready
$(document).ready(function() {
  // List of images
  var images = [
    "images/research_pic1.jpg", // index 0 <!-- Source: (original work) Matthew Velasco -->
    "images/research_pic2.jpg", // index 1 <!-- Source: (original work) Matthew Velasco -->
    "images/research_pic3.jpg", // index 2 <!-- Source: (original work) Matthew Velasco -->
  ];

  // The index of the image that is currently displayed
  var currentIndex = 0;

  // When the next button is clicked
  $("#slides_next").on("click", function () {
    currentIndex = currentIndex + 1;

    if (currentIndex > 2){
      currentIndex = 0;
    }

    document.getElementById("slides_image").src = images[currentIndex];
  });
});
