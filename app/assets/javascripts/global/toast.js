const DEFAULT_DELAY = 0;
const DEFAULT_DURATION = 1000;

function showToast(message, dismissDelay) {
  $('div#toast div#message').text(message);
  $('div#toast').show();
  if (typeof dismissDelay === 'number') { dismissToast(dismissDelay); }
};

function dismissToast(delay, duration) {
  if (typeof delay !== 'number') { delay = DEFAULT_DELAY; }
  if (typeof duration !== 'number') { duration = DEFAULT_DURATION; }

  var dismiss = function() {
    var toast = $('div#toast');
    if (toast.length > 0 && toast.css('display') !== 'none') {
      toast.fadeOut(duration);
    }
  }

  setTimeout(dismiss, delay);
};

$(function ready() {
  // On click dismiss the toast
  $('div#dismiss-toast').click(function() { dismissToast(); });

  // Dismiss the toast after ten seconds
  dismissToast(10000);
});

