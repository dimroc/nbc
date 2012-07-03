(function() {

  Factories.$mockEvent = function($object) {
    var mockEvent;
    mockEvent = jasmine.createSpyObj("Mock$Event", ["preventDefault", "target"]);
    mockEvent.target.andReturn($object);
    return mockEvent;
  };

}).call(this);
