describe "block", ->
  describe "Validations", ->
    it "should validate presence of attributes", ->
      expect(App.Block).toValidatePresenceOf("top")
      expect(App.Block).toValidatePresenceOf("left")
