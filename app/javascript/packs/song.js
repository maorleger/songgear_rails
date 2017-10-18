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
      requestAnimationFrame(function() {
        player = new YT.Player('player', {
          videoId: videoId,
        });
      });
    });

    app.ports.seekTo.subscribe(function(seconds) {
      requestAnimationFrame(function() {
        player.seekTo(seconds);
      });
    });
  }
})
