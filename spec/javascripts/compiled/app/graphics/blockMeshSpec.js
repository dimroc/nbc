(function() {

  describe("BlockMesh", function() {
    return it("should respond to animate", function() {
      var block;
      block = Fixtures.nyc_blocks[0];
      return expect(new App.BlockMesh(block)).toRespondTo("animate");
    });
  });

}).call(this);
