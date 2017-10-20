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

  (function setupPlayerWithRetry() {
    setTimeout(function() {
      try {
        player = new YT.Player('player', {
          videoId: videoId,
        });
      } catch (err) {
        if (retryCount < 5) {
          retryCount += 1;
          setupPlayerWithRetry();
        } else {
          console.log("Unable to instantiate YT player after 5 retries... giving up");
          throw err;
        }
      }
    }, retryCount * 1000);
  })();
}
