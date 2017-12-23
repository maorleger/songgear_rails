import Elm from '../Main';

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
var playerControls = {
  interval: null,
  position: null,
  loopStart: null,
  loopEnd: null,
}
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
      playerControls.loopStart = loop[0];
      playerControls.loopEnd = loop[1];
      var checkCurrentTime = function() {
        playerControls.position = player.getCurrentTime();
        if (playerControls.position >= playerControls.loopEnd) {
          player.seekTo(playerControls.loopStart);
        }
      }
      if (playerControls.interval) {
        clearInterval(playerControls.interval)
      }
      playerControls.interval = setInterval(checkCurrentTime, 500);
      player.seekTo(playerControls.loopStart);
      player.loadVideoById
    });

    app.ports.endLoop.subscribe(function() {
      if (playerControls.interval) {
        clearInterval(playerControls.interval)
      };
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
