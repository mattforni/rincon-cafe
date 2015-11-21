$(function ready() {
  $('div#add').hover(function mouseenter() {
    $(this).addClass(HOVER_CLASS);
  }, function mouseleave() {
    $(this).removeClass(HOVER_CLASS);
  });
});

