//= require application

function BackgroundRefresh() {
  const DISMISS_DELAY = 3000; // In millis
  const FADE_IN_LENGTH = 250; // In millis
  const REFRESH_DELAY = 15000; // In millis
  const QUEUE_UPDATE_MESSAGE = 'Queue Updated.';
  const URL = '' // Root URL

  var started = false;

  var get = function() {
    $.get(URL, {
      refresh: true
    }).done(function success(data) {
      if (typeof data === 'string' && data.length > 0) {
        $('div#content').html(data);
        showToast(QUEUE_UPDATE_MESSAGE, DISMISS_DELAY);
      }
      refresh(); // Continually refresh
    }).fail(function error(data) {
      alert(data);
    });
  };

  var refresh = function() {
    setTimeout(get, REFRESH_DELAY);
  };

  return {
    start: function() {
      if (started) { return; }
      refresh();
    }
  }
}


$(function ready() {
  $('div#add').hover(function mouseenter() {
    $(this).addClass(HOVER_CLASS);
  }, function mouseleave() {
    $(this).removeClass(HOVER_CLASS);
  });

  new BackgroundRefresh().start();
});

