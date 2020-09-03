$(document).ready(function() {

  var images = [
    "images/gallerypic2.jpg", // index 0 <!-- Source: (original work) Matthew Velasco -->
    "images/homepagepic2.jpg", // index 1 <!-- Source: (original work) Angel Nugroho -->
    "images/homepagepic3.jpg", // index 2 <!-- Source: (original work) Angel Nugroho -->
    "images/homepagepic4.jpg", // index 3 <!-- Source: (original work) Angel Nugroho -->
  ];

  var currentIndex = 0;
  var the_image = document.getElementById("slideshowImage");

  $("#slideshowNext").on("click", function () {
    if (currentIndex == 3){
        the_image.src = images[0];
        currentIndex = 0;
    }
    else {
        currentIndex = currentIndex+1;
        the_image.src = images[currentIndex];
    }
  });
});
