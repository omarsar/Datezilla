
$(function() {


  $('[data-toggle=offcanvas]').click(function() {
      $(this).toggleClass('visible-xs text-center');
      $(this).find('i').toggleClass('fa-bars fa-bars');
      $('.row-offcanvas').toggleClass('active');
      $('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
      $('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
      $('#btnShow').toggle();
  });




  var $container;
  $container = $("#pins");
  $container.imagesLoaded(function() {
    $container.show();
    $container.masonry({
      itemSelector: "#pinbox",
      isFitWidth: true,
      transitionDuration: 0
    });
  });
  /*
  $container.infinitescroll({
    navSelector: "#page-nav",
    nextSelector: "#page-nav a",
    itemSelector: "#pinboxsdsds",
    loading: {
      finishedMsg: "No more items to load.",
      msgText: "Loading the next set of items...",
      img: "http://i.imgur.com/6RMhx.gif",
      speed: "fast"
    }
  }, function(newElements) {
    var $newElems;
    $newElems = $(newElements).css({
      opacity: 0
    });
    $newElems.imagesLoaded(function() {
      $newElems.animate({
        opacity: 1
      });
      $container.masonry("appended", $newElems, true);
    });
  });
  */


});


