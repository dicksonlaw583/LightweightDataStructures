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
}