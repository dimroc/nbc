(function() {

  describe("Graphics", function() {
    describe("#constructor", function() {
      return it("should create the camera, scene, and renderer", function() {
        var graphic;
        graphic = new Graphics();
        expect(graphic.scene).toBeDefined();
        expect(graphic.renderer).toBeDefined();
        expect(graphic.camera).toBeDefined();
        return graphic.destroy();
      });
    });
    return describe("when constructed", function() {
      var graphic;
      graphic = null;
      beforeEach(function() {
        return graphic = new Graphics();
      });
      afterEach(function() {
        return graphic.destroy();
      });
      describe("#attachToDom", function() {
        return it("should append a canvas element", function() {
          var dom;
          dom = $("<div></div>");
          graphic.attachToDom(dom);
          return expect(dom).toContain("canvas");
        });
      });
      describe("#addCube", function() {});
      describe("#animate", function() {});
      return describe("#render", function() {});
    });
  });

}).call(this);
