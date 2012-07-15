(function() {

  describe("World", function() {
    describe("#constructor", function() {
      return it("should create the camera, scene, and renderer", function() {
        var world;
        world = new App.World();
        expect(world.scene).toBeDefined();
        expect(world.renderer).toBeDefined();
        expect(world.camera).toBeDefined();
        return world.destroy();
      });
    });
    return describe("when constructed", function() {
      var world;
      world = null;
      beforeEach(function() {
        return world = new App.World();
      });
      afterEach(function() {
        return world.destroy();
      });
      describe("#attachToDom", function() {
        return it("should append a canvas element", function() {
          var dom;
          dom = $("<div></div>");
          world.attachToDom(dom);
          return expect(dom).toContain("canvas");
        });
      });
      describe("#add", function() {
        return it("should add to its children", function() {
          var mesh;
          mesh = new THREE.Mesh();
          world.add(mesh);
          return expect(world.scene.children).toInclude(mesh);
        });
      });
      return describe("#animate", function() {
        return it("should animate its children", function() {
          var blockMesh;
          blockMesh = new App.BlockMesh(Fixtures.nyc_blocks[0]);
          spyOn(blockMesh, "animate").andCallThrough();
          world.add(blockMesh);
          world.animate();
          return expect(blockMesh.animate).toHaveBeenCalled();
        });
      });
    });
  });

}).call(this);
