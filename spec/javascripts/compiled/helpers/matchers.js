(function() {

  beforeEach(function() {
    return this.addMatchers({
      toBeAnAction: function() {
        Helpers.getTypeName(this.actual.isActive) === "Function";
        Helpers.getTypeName(this.actual.render) === "Function";
        Helpers.getTypeName(this.actual.activate) === "Function";
        return Helpers.getTypeName(this.actual.deactivate) === "Function";
      },
      toValidatePresenceOf: function(attribute) {
        var instance;
        this.message = function() {
          return "Expected Spine Model to validate the presence of " + attribute;
        };
        instance = new this.actual();
        return instance.save() === false && _.has(instance.validate(), attribute);
      }
    });
  });

}).call(this);
