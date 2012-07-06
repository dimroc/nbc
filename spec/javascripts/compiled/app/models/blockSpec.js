(function() {

  describe("block", function() {
    return describe("Validations", function() {
      return it("should validate presence of attributes", function() {
        expect(App.Block).toValidatePresenceOf("top");
        return expect(App.Block).toValidatePresenceOf("left");
      });
    });
  });

}).call(this);
