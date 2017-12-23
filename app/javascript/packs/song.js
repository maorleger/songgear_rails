import Elm from '../Main';

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
var videoId = null;
document.addEventListener('turbolinks:load', () => {
  const target = document.getElementById('elm-main')

  if (target) {
    var app = Elm.Main.embed(target, { songId: target.dataset.songId });
    app.ports.loadVideo.subscribe(function(videoId) {
      videoId = videoId;
      setupPlayer(videoId, app.ports.playerSpeedsReceived);
    });

    app.ports.seekTo.subscribe(function(seconds) {
      requestAnimationFrame(function() {
        player.seekTo(seconds);
      });
    });

    app.ports.setYTPlayerSpeed.subscribe(function(speed) {
      requestAnimationFrame(function() {
        player.setPlaybackRate(speed);
      });
    });

    app.ports.getYTPlayerTime.subscribe(function() {
      app.ports.currentYTPlayerTime.send(Math.round(player.getCurrentTime()));
    });

    app.ports.startLoop.subscribe(function(loop) {
      var position = null;
      var start = 5 || loop[0];
      var end = 10 || loop[1];
      setInterval(function() {
        position = player.getCurrentTime();
        if (position >= end) {
          player.seekTo(start);
        }
      }, 500);
      player.seekTo(start);
      player.loadVideoById
    });
  }
})

function setupPlayer(videoId, callback) {
  var videoId = videoId;
  var retryCount = 0;
  var numRetries = 10;

  (function setupPlayerWithRetry() {
    setTimeout(function() {
      try {
        player = new YT.Player('player', {
          videoId: videoId,
          playerVars: { 'playsinline': 1 },
        });
        setTimeout(() => { callback.send(player.getAvailablePlaybackRates()) }, 1000);
      } catch (err) {
        if (retryCount < numRetries) {
          console.log("retrying YT player");
          retryCount += 1;
          setupPlayerWithRetry();
        } else {
          console.log("Unable to instantiate YT player after " + numRetries + " retries... giving up");
          throw err;
        }
      }
    }, 100 * numRetries);
  })();
}
