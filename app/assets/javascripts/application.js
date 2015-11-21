//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require global/toast

const HOVER_CLASS = 'hover';

$(function ready() {
  $('input.icon-button').hover(function mouseenter() {
    $(this).addClass(HOVER_CLASS);
  }, function mouseleave() {
    $(this).removeClass(HOVER_CLASS);
  });
});

