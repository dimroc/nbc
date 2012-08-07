describe "models.block", ->
  describe "Validations", ->
    it "should validate presence of attributes", ->
      expect(App.Block).toValidatePresenceOf("bottom")
      expect(App.Block).toValidatePresenceOf("left")
      expect(App.Block).toValidatePresenceOf("point")
