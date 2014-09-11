(function($) {
  /*
    ======== A Handy Little QUnit Reference ========
    http://api.qunitjs.com/

    Test methods:
      module(name, {[setup][ ,teardown]})
      test(name, callback)
      expect(numberOfAssertions)
      stop(increment)
      start(decrement)
    Test assertions:
      ok(value, [message])
      equal(actual, expected, [message])
      notEqual(actual, expected, [message])
      deepEqual(actual, expected, [message])
      notDeepEqual(actual, expected, [message])
      strictEqual(actual, expected, [message])
      notStrictEqual(actual, expected, [message])
      throws(block, [expected], [message])
  */

  module('jQuery#waterfall', {
    // This will run before each test in this module.
    setup: function() {
      this.elems = $('#qunit-fixture').children();
    }
  });

  test('is chainable', function() {
    expect(1);
    // Not a bad test to run on collection methods.
    strictEqual(this.elems.waterfall(), this.elems, 'should be chainable');
  });

  test('is waterfall', function() {
    expect(1);
    strictEqual(this.elems.waterfall().text(), 'waterfall0waterfall1waterfall2', 'should be waterfall');
  });

  module('jQuery.waterfall');

  test('is waterfall', function() {
    expect(2);
    strictEqual($.waterfall(), 'waterfall.', 'should be waterfall');
    strictEqual($.waterfall({punctuation: '!'}), 'waterfall!', 'should be thoroughly waterfall');
  });

  module(':waterfall selector', {
    // This will run before each test in this module.
    setup: function() {
      this.elems = $('#qunit-fixture').children();
    }
  });

  test('is waterfall', function() {
    expect(1);
    // Use deepEqual & .get() when comparing jQuery objects.
    deepEqual(this.elems.filter(':waterfall').get(), this.elems.last().get(), 'knows waterfall when it sees it');
  });

}(jQuery));
