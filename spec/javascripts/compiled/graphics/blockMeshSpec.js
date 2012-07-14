(function() {

  describe("BlockMesh", function() {
    return it("should respond to animate", function() {
      var block;
      block = Fixtures.nyc_blocks[0];
      return expect(Graphics.createBlockMesh(block)).toRespondTo("animate");
    });
  });

}).call(this);
