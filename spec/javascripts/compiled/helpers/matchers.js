(function() {

  beforeEach(function() {
    return this.addMatchers({
      toIncludeText: function(expectedText) {
        var text;
        if (Helpers.getTypeName(this.actual) === "String") {
          text = this.actual;
        } else {
          text = this.actual.text();
        }
        return _.str.include(text, expectedText);
      },
      toBeAnAction: function() {
        Helpers.getTypeName(this.actual.isActive) === "Function";
        Helpers.getTypeName(this.actual.render) === "Function";
        Helpers.getTypeName(this.actual.activate) === "Function";
        return Helpers.getTypeName(this.actual.deactivate) === "Function";
      }
    });
  });

}).call(this);
