describe "models.region", ->
  describe "Validations", ->
    it "should validate the presence of attributes", ->
      expect(App.Region).toValidatePresenceOf("name")
      expect(App.Region).toValidatePresenceOf("slug")
      expect(App.Region).toValidatePresenceOf("left")
      expect(App.Region).toValidatePresenceOf("bottom")
