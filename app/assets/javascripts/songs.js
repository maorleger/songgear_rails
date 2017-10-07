var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
	player = new YT.Player('player', {
		height: '390',
		width: '640',
		videoId: $('#player').data('videoId'),
		events: {
			'onReady': onPlayerReady,
			// 'onStateChange': onPlayerStateChange
		}
	});
}

function onPlayerReady(event) {
	// event.target.playVideo();
}

function stopVideo() {
	player.stopVideo();
}

$(document).ready(function() {
	$("a[data-seek-to]").click(function(e) {
    player.seekTo($(this).data('seek-to'));
	});

  $("#addBookmark").click(function(e) {
    debugger;
  });
});
