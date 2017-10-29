import Elm from '../Main';

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
document.addEventListener('turbolinks:load', () => {
  const target = document.getElementById('elm-main')

  if (target) {
    var app = Elm.Main.embed(target, { songId: target.dataset.songId });
    app.ports.loadVideo.subscribe(function(videoId) {
      setupPlayer(videoId);
    });

    app.ports.seekTo.subscribe(function(seconds) {
      requestAnimationFrame(function() {
        player.seekTo(seconds);
      });
    });

    app.ports.getYTPlayerTime.subscribe(function() {
      app.ports.currentYTPlayerTime.send(Math.round(player.getCurrentTime()));
    });
  }
})

function setupPlayer(videoId) {
  var videoId = videoId;
  var retryCount = 0;
  var numRetries = 10;

  (function setupPlayerWithRetry() {
    requestAnimationFrame(function() {
      try {
        player = new YT.Player('player', {
          videoId: videoId,
          playerVars: { 'playsinline': 1 },
        });
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
    });
  })();
}
