(function() {

  beforeEach(function() {
    return this.addMatchers({
      toBePlaying: function(expectedSong) {
        var player;
        player = this.actual;
        return player.currentlyPlayingSong === expectedSong && player.isPlaying;
      }
    });
  });

}).call(this);
