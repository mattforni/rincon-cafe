const HOVER_CLASS = 'hover';

$(function ready() {
  $('div#order-button').hover(function mouseenter() {
    $(this).addClass(HOVER_CLASS);
  }, function mouseleave() {
    $(this).removeClass(HOVER_CLASS);
  });
});

