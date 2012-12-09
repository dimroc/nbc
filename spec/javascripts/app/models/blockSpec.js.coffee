describe "models.block", ->
  describe "Validations", ->
    it "should validate presence of attributes", ->
      expect(App.Block).toValidatePresenceOf("point")
