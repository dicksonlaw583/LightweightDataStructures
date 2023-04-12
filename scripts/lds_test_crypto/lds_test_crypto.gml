///@func lds_test_crypto()
///@desc Test Lightweight Data Structure encryption and decryption utilities.
function lds_test_crypto(){
	var lds_roundtrip = function(thing, key="foobar") {
		return lds_decrypt(lds_encrypt(thing, key), key);
	};
	
	var target, source, nestedEntry;
	
	#region Test basic roundtrip encryptions
	assert_equal(lds_roundtrip("foo"), "foo", "Test basic roundtrip encryptions string");
	assert_equal(lds_roundtrip(583.25), 583.25, "Test basic roundtrip encryptions real");
	// Array
	source = [1, 2, [3, 4]];
	target = lds_roundtrip(source);
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encryptions array 1a");
	source[0] = 11;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encryptions array 1b");
	source[2][0] = 33;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encryptions array 1c");
	// Struct
	source = { foo: 1, bar: { baz: 2 } };
	target = lds_roundtrip(source);
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encryptions struct 1a");
	source.foo = 11;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encryptions struct 1b");
	source.bar.baz = 22;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encryptions struct 1c");
	#endregion
	
	#region Test data structure roundtrip encryptions
	// Stack
	source = new Stack([1, 2], [3, 4]);
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encryptions 1a");
	nestedEntry = source.top();
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encryptions 1b");
	source.push("boo");
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encryptions 1c");
	// Queue
	source = new Queue([1, 2], [3, 4], [5, 6]);
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encryptions 1a");
	nestedEntry = source.tail();
	nestedEntry[@0] = 55;
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encryptions 1b");
	source.enqueue("boo");
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encryptions 1c");
	// List
	source = new List([1, 2], 3, 4);
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encryptions 1a");
	nestedEntry = source.get(0);
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encryptions 1b");
	source.add(5);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encryptions 1c");
	// Grid
	source = new Grid(3, 2,
		{foo: 11}, 22, 33,
		44, 55, 66
	);
	target = lds_roundtrip(source);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encryptions 1a");
	nestedEntry = source.get(0, 0);
	nestedEntry.foo = 111;
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encryptions 1b");
	source.set(0, 0, 1111);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encryptions 1c");
	// Heap
	source = new Heap("qux", 44, {foo: 11}, 11, "bar", 22, "baz", 33);
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encryptions 1a");
	nestedEntry = source.getMin();
	nestedEntry.foo = 111;
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encryptions 1b");
	source.deleteMin();
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encryptions 1c");
	// Map
	source = new Map("foo", "bar", "baz", {qux: 22});
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encryptions 1a");
	nestedEntry = source.get("baz");
	nestedEntry.qux = 222;
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encryptions 1b");
	source.remove("baz");
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encryptions 1c");
	// Nested
	source = new List("foo", new Map("bar", 33), "baz");
	target = lds_roundtrip(source);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encryptions 1a");
	nestedEntry = source.get(1);
	nestedEntry.set("bar", 333);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encryptions 1b");
	source.remove(1);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encryptions 1c");
	#endregion
}
