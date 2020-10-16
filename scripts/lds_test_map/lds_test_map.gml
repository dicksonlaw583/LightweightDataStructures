///@func lds_test_map()
function lds_test_map() {
	var map;
	
	// Test empty map
	map = new Map();
	assert_equal(map.size(), 0, "Test empty map 1");
	assert(map.empty(), "Test empty map 2");
	assert_throws(method({ map: map }, function() {
		map.findValue("abc");
	}), new MapKeyMissingException("Map has no key abc."), "Test empty map 3");
	
	// Test simple map adds
	map.add("foo", 4);
	map.add("bar", 6);
	assert_equal(map.size(), 2, "Test simple map adds 1");
	assert_equal([map.findValue("foo"), map.get("bar")], [4, 6], "Test simple map adds 2");
	assert_throws(method({ map: map }, function() {
		map.findValue("baz");
	}), new MapKeyMissingException("Map has no key baz."), "Test simple map adds 3");
	assert_fail(map.exists("baz"), "Test simple map adds 3+");
	map.remove("bar");
	assert_equal(map.size(), 1, "Test simple map adds 4");
	assert_throws(method({ map: map }, function() {
		map.findValue("bar");
	}), new MapKeyMissingException("Map has no key bar."), "Test simple map adds 5");
	assert_fail(map.exists("bar"), "Test simple map adds 5+");
	assert_throws(method({ map: map }, function() {
		map.remove("bar");
	}), new MapKeyMissingException("Map has no key bar."), "Test simple map adds 6");
	map.add("bar", 7);
	assert_equal([map.size(), map.get("bar")], [2, 7], "Test simple map adds 7");
	assert(map.exists("bar"), "Test simple map adds 8");
	// Test simple map iteration
	assert_equal([
		map.findFirst(),
		map.findLast(),
		map.findNext("foo"),
		map.findNext("bar"),
		map.findPrevious("foo"),
		map.findPrevious("bar"),
		map.keys()
	], [
		"foo",
		"bar",
		"bar",
		undefined,
		undefined,
		"foo",
		["foo", "bar"]
	], "Test simple map iteration 1");
	
	// Test map copy
	var map2;
	map = new Map("FOO", 11, "BAR", 22, "BAZ", 33);
	map2 = new Map("foobar", 583);
	map2.copy(map);
	assert_equal([map2.size(), map2.get("FOO"), map2.get("BAR"), map2.get("BAZ"), bool(map2.exists("foobar"))], [3, 11, 22, 33, bool(false)], "Test map copy 1");
	map2.set("FOO", 111);
	assert_equal([map.size(), map.get("FOO"), map.get("BAR"), map.get("BAZ"), bool(map.exists("foobar"))], [3, 11, 22, 33, bool(false)], "Test map copy 2");

	// Test map clone
	map = new Map("FOO", 111, "BAR", 222, "BAZ", 333);
	map2 = map.clone();
	assert_equal([map2.size(), map2.get("FOO"), map2.get("BAR"), map2.get("BAZ"), bool(map2.exists("foobar"))], [3, 111, 222, 333, bool(false)], "Test map clone 1");
	map2.set("FOO", 1111);
	assert_equal([map.size(), map.get("FOO"), map.get("BAR"), map.get("BAZ"), bool(map.exists("foobar"))], [3, 111, 222, 333, bool(false)], "Test map clone 2");

	// Test map reduction
	map = new Map()
	assert_equal(map.reduceToData(), [[], []], "Test map reduction 1");
	map = new Map("foo", 111);
	assert_equal(map.reduceToData(), [["foo"], [111]], "Test map reduction 2");
	map = new Map("foo", 111, "bar", [222, 2222], "baz", {foobar: 333});
	assert_equal(map.reduceToData(), [["foo", "bar", "baz"], [111, [222, 2222], {t: "struct", d: {foobar: 333}}]], "Test map reduction 3");
	
	// Test map expansion
	map = new Map("bad", 583);
	map.expandFromData([[], []]);
	assert(map.empty(), "Test map expansion 1");
	map = new Map("bad", 583);
	map.expandFromData([["foo"], [111]]);
	assert_equal([map.size(), map.get("foo")], [1, 111], "Test map expansion 2");
	map = new Map("bad", 583);
	map.expandFromData([["foo", "bar", "baz"], [111, [222, 2222], {t: "struct", d: {foobar: 333}}]]);
	assert_equal([map.size(), map.get("foo"), map.get("bar"), map.get("baz")], [3, 111, [222, 2222], {foobar: 333}], "Test map expansion 3");
	
	// Test map read/write
	map = new Map();
	map2 = new Map("foo", 123);
	got = map.write();
	map2.read(got);
	assert(map2.empty(), "Test map read/write 1");
	map = new Map("foo", 123, "bar", 234);
	map2 = new Map();
	got = map.write();
	map2.read(got);
	assert_equal([map2.size(), map2.get("foo"), map2.get("bar")], [2, 123, 234], "Test map read/write 2");
	map = new Map("foo", 567);
	assert_throws(method({ map: map }, function() {
		map.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("Map", "struct"), "Test map read/write 3");
	
	// Test map iteration
	map = new Map();
	map2 = new Map();
	map.forEach(method({ m2: map2 }, function(v, k) {
		m2.add(k, v);
		m2.add(string_upper(k), string_upper(v));
	}));
	assert(map2.empty(), "Test map forEach 1");
	map = new Map("a", "foo", "b", "bar", "c", "baz");
	map2 = new Map();
	map.forEach(method({ m2: map2 }, function(v, k) {
		m2.add(k, v);
		m2.add(string_upper(k), string_upper(v));
	}));
	assert_equal([map2.size(), map2.get("a"), map2.get("A"), map2.get("b"), map2.get("B"), map2.get("c"), map2.get("C")], [6, "foo", "FOO", "bar", "BAR", "baz", "BAZ"], "Test map forEach 2");
	map = new Map("a", "foo", "b", "bar", "c", "baz", "d", "qux", "e", "waahoo");
	map.mapEach(function(v) {
		if (v == "foo" || v == "baz" || v == "waahoo") throw undefined;
		return string_upper(v);
	});
	assert_equal([map.size(), map.get("b"), map.get("d")], [2, "BAR", "QUX"], "Test map mapEach 1");
	map = new Map("a", "foo", "b", "bar", "c", "baz");
	map2 = new Map();
	for (var i = map.iterator(); i.hasNext(); i.next()) {
		map2.add(i.key, string_upper(i.value));
	}
	assert_equal([map2.size(), map2.get("a"), map2.get("b"), map2.get("c")], [3, "FOO", "BAR", "BAZ"], "Test map iterator 1");
	map = new Map("a", "foo", "b", "bar", "c", "baz", "d", "qux", "e", "waahoo");
	for (var i = map.iterator(); i.hasNext(); i.next()) {
		if (i.key == "a" || i.key == "c" || i.key == "e") {
			i.remove();
		} else {
			i.set(string_upper(i.value));
		}
	}
	assert_equal([map.size(), map.get("b"), map.get("d")], [2, "BAR", "QUX"], "Test map iterator 2");
}