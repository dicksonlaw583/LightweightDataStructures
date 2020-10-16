///@func lds_test_list()
function lds_test_list() {
	var list;
	
	// Test empty list
	list = new List();
	assert_equal(list.size(), 0, "Test empty list 1");
	assert(list.empty(), "Test empty list 2");
	
	// Test fill with default content
	list = new List("foo", "bar", "baz");
	assert_equal(list.size(), 3, "Test fill list default 1");
	assert_equal([list.get(0), list.get(1), list.get(2)], ["foo", "bar", "baz"], "Test fill list default 2");
	assert_equal([list.get(-3), list.get(-2), list.get(-1)], ["foo", "bar", "baz"], "Test fill list default 3");
	list.clear();
	assert_equal(list.size(), 0, "Test fill list default 4");
	assert(list.empty(), "Test fill list default 5");
	
	// Test list add
	list = new List();
	list.add(11, 22);
	assert_equal([list.size(), list.get(0), list.get(1)], [2, 11, 22], "Test list add 1");
	list.add(33);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, 11, 22, 33], "Test list add 2");
	
	// Test list set/stretch
	list = new List("foo");
	list.set(1, "bar");
	assert_equal([list.size(), list.get(0), list.get(1)], [2, "foo", "bar"], "Test list set/stretch 1");
	list.set(0, "FOO");
	list.set(-1, "BAR");
	assert_equal([list.size(), list.get(0), list.get(1)], [2, "FOO", "BAR"], "Test list set/stretch 2");
	list.set(3, "baz");
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, "FOO", "BAR", undefined, "baz"], "Test list set/stretch 3");
	
	// Test list delete
	list = new List("foo", "bar", "baz", "qux", "waa", "hoo");
	list.remove(0);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3), list.get(4)], [5, "bar", "baz", "qux", "waa", "hoo"], "Test list delete 1");
	list.remove(-1);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, "bar", "baz", "qux", "waa"], "Test list delete 2");
	list.remove(2);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, "bar", "baz", "waa"], "Test list delete 3");
	
	// Test list find index
	list = new List("foo", "bar", "baz", "qux", "waa", "hoo");
	assert_equal(list.findIndex("foo"), 0, "Test list find index 1");
	assert_equal(list.findIndex("hoo"), 5, "Test list find index 2");
	assert_equal(list.findIndex("baz"), 2, "Test list find index 3");
	assert_equal(list.findIndex(undefined), -1, "Test list find index 4");
	
	// Test list find value
	list = new List(111, 222, 333, 444);
	assert_equal([list.findValue(0), list.findValue(1), list.findValue(2), list.findValue(3)], [111, 222, 333, 444], "Test list find value 1");
	assert_equal([list.findValue(-4), list.findValue(-3), list.findValue(-2), list.findValue(-1)], [111, 222, 333, 444], "Test list find value 2");
	assert_throws(method({ list: list }, function() {
		list.findValue(4);
	}), new ListIndexOutOfBoundsException(4), "Test list find value 3");
	list = new List("foo", "bar", "baz");
	assert_equal([list.get(0), list.get(1), list.get(2)], ["foo", "bar", "baz"], "Test list find value 4");
	assert_equal([list.get(-3), list.get(-2), list.get(-1)], ["foo", "bar", "baz"], "Test list find value 5");
	assert_throws(method({ list: list }, function() {
		list.get(-4);
	}), new ListIndexOutOfBoundsException(-4), "Test list find value 6");
	
	// Test list insert
	list = new List();
	list.insert(0, "foo");
	assert_equal([list.size(), list.get(0)], [1, "foo"], "Test list insert 1");
	list.insert(1, "bar");
	assert_equal([list.size(), list.get(0), list.get(1)], [2, "foo", "bar"], "Test list insert 2");
	list.insert(-1, "baz");
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, "foo", "baz", "bar"], "Test list insert 3");
	list.insert(-2, "qux");
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, "foo", "qux", "baz", "bar"], "Test list insert 4");
	
	// Test list replace
	list = new List(111, 222, 333);
	list.replace(1, 22);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, 111, 22, 333], "Test list replace 1");
	list.replace(-1, 33);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, 111, 22, 33], "Test list replace 2");
	list.replace(0, 11);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2)], [3, 11, 22, 33], "Test list replace 3");
	
	// Test list to array
	list = new List();
	assert_equal(list.toArray(), [], "Test list to array 1");
	list = new List("foo");
	assert_equal(list.toArray(), ["foo"], "Test list to array 2");
	list = new List(123, "foo", "bar", undefined, 456);
	assert_equal(list.toArray(), [123, "foo", "bar", undefined, 456], "Test list to array 3");
	
	// Test list sort
	list = new List();
	list.sort();
	assert_equal(list.toArray(), [], "Test list sort 0");
	list = new List(4, 9, 6, 8, 0, 7, 2, 5, 3, 1);
	list.sort();
	assert_equal(list.toArray(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "Test list sort 1");
	list.sort(false);
	assert_equal(list.toArray(), [9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "Test list sort 2");
	list = new List("F", "C", "G", "B", "A", "E", "D");
	list.sort(true, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(list.toArray(), ["A", "B", "C", "D", "E", "F", "G"], "Test list sort 3");
	list.sort(false, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(list.toArray(), ["G", "F", "E", "D", "C", "B", "A"], "Test list sort 4");
	list = new List({k:"F"}, {k:"C"}, {k:"G"}, {k:"B"}, {k:"A"}, {k:"E"}, {k:"D"});
	list.sort(true, function(v) { return v.k; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(list.toArray(), [{k:"A"}, {k:"B"}, {k:"C"}, {k:"D"}, {k:"E"}, {k:"F"}, {k:"G"}], "Test list sort 5");
	list.sort(false, function(v) { return v.k; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(list.toArray(), [{k:"G"}, {k:"F"}, {k:"E"}, {k:"D"}, {k:"C"}, {k:"B"}, {k:"A"}], "Test list sort 6");
	
	// Test list copy
	var list2;
	list = new List(11, 22, 33, 44);
	list2 = new List(44, 55);
	list2.copy(list);
	assert_equal([list2.size(), list2.get(0), list2.get(1), list2.get(2), list2.get(3)], [4, 11, 22, 33, 44], "Test list copy 1");
	list2.remove(1);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, 11, 22, 33, 44], "Test list copy 2");

	// Test list clone
	list = new List(111, 222, 333, 444);
	list2 = list.clone();
	assert_equal([list2.size(), list2.get(0), list2.get(1), list2.get(2), list2.get(3)], [4, 111, 222, 333, 444], "Test list clone 1");
	list2.remove(1);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, 111, 222, 333, 444], "Test list clone 2");
	
	// Test list reduction
	list = new List();
	assert_equal(list.reduceToData(), [], "Test list reduction 1");
	list = new List(2);
	assert_equal(list.reduceToData(), [2], "Test list reduction 2");
	list = new List("three", 3);
	assert_equal(list.reduceToData(), ["three", 3], "Test list reduction 3");
	list = new List(111, [222, 333], { foo: 444 }, "555");
	assert_equal(list.reduceToData(), [111, [222, 333], {t: "struct", d: {foo: 444}}, "555"], "Test list reduction 4");
	
	// Test list expansion
	//1
	list = new List();
	list.expandFromData([]);
	assert(list.empty(), "Test list expansion 1");
	//2
	list = new List();
	list.expandFromData([2]);
	assert_equal([list.size(), list.get(0)], [1, 2], "Test list expansion 2");
	//3
	list = new List();
	list.expandFromData(["three", 3]);
	assert_equal([list.size(), list.get(0), list.get(1)], [2, "three", 3], "Test list expansion 3");
	//4
	list = new List();
	list.expandFromData([111, [222, 333], {t: "struct", d: {foo: 444}}, "555"]);
	assert_equal([list.size(), list.get(0), list.get(1), list.get(2), list.get(3)], [4, 111, [222, 333], {foo: 444}, "555"], "Test list expansion 4");
	
	// Test list read/write
	list = new List();
	list2 = new List(1, 2, 3);
	got = list.write();
	list2.read(got);
	assert(list2.empty(), "Test list read/write 1");
	list = new List("foo", "bar", "baz");
	list2 = new List();
	got = list.write();
	list2.read(got);
	assert_equal([list2.size(), list2.get(0), list2.get(1), list2.get(2)], [3, "foo", "bar", "baz"], "Test list read/write 2");
	list = new List("foo");
	assert_throws(method({ list: list }, function() {
		list.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("List", "struct"), "Test list read/write 3");
	
	// Test list iteration
	list = new List();
	list2 = new List();
	list.forEach(method({ l2: list2 }, function(v, i) {
		l2.add(i);
		l2.add(v);
	}));
	assert_equal(list2.toArray(), [], "Test list forEach 1");
	list = new List("a", "b", "c");
	list2 = new List();
	list.forEach(method({ l2: list2 }, function(v, i) {
		l2.add(i);
		l2.add(v);
	}));
	assert_equal(list2.toArray(), [0, "a", 1, "b", 2, "c"], "Test list forEach 2");
	list = new List("alpha", "beta", "gamma", "delta", "epsilon");
	list.mapEach(function(v) {
		if (v == "alpha" || v == "epsilon" || v == "gamma") throw undefined;
		return string_upper(v);
	});
	assert_equal([list.size(), list.get(0), list.get(1)], [2, "BETA", "DELTA"], "Test list mapEach 1");
	list = new List("a", "b", "c");
	list2 = new List();
	for (var i = list.iterator(); i.hasNext(); i.next()) {
		list2.add(i.index);
		list2.add(i.value);
	}
	assert_equal(list2.toArray(), [0, "a", 1, "b", 2, "c"], "Test list ListIterator 1");
	list = new List("a", "b", "c", "d", "e");
	for (var i = list.iterator(); i.hasNext(); i.next()) {
		if (i.value == "a" || i.value == "c" || i.value == "e") {
			i.remove();
		} else {
			i.set(string_upper(i.value));
		}
	}
	assert_equal([list.size(), list.toArray()], [2, ["B", "D"]], "Test list ListIterator 2");
}