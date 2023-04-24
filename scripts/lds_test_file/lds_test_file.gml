///@func lds_test_file()
///@desc Test Lightweight Data Structure file saving and loading routines.
function lds_test_file(){
	var testFile = working_directory + "testfile.bin";
	var lds_roundtrip_file = function(filename, thing) {
		lds_save(thing, filename);
		return lds_load(filename);
	};
	var lds_roundtrip_encrypted_file = function(filename, thing, key="foobar") {
		lds_save_encrypted(thing, filename, key);
		return lds_load_encrypted(filename, key);
	};
	
	var target, source, nestedEntry;
	
	#region Test basic roundtrip save-loads
	assert_equal(lds_roundtrip_file(testFile, "foo"), "foo", "Test basic roundtrip save-loads string");
	assert_equal(lds_roundtrip_file(testFile, 583.25), 583.25, "Test basic roundtrip save-loads real");
	// Array
	source = [1, 2, [3, 4]];
	target = lds_roundtrip_file(testFile, source);
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip save-loads array 1a");
	source[0] = 11;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip save-loads array 1b");
	source[2][0] = 33;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip save-loads array 1c");
	// Struct
	source = { foo: 1, bar: { baz: 2 } };
	target = lds_roundtrip_file(testFile, source);
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip save-loads struct 1a");
	source.foo = 11;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip save-loads struct 1b");
	source.bar.baz = 22;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip save-loads struct 1c");
	#endregion
	
	#region Test data structure roundtrip save-loads
	// Stack
	source = new Stack([1, 2], [3, 4]);
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip save-loads 1a");
	nestedEntry = source.top();
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip save-loads 1b");
	source.push("boo");
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip save-loads 1c");
	// Queue
	source = new Queue([1, 2], [3, 4], [5, 6]);
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip save-loads 1a");
	nestedEntry = source.tail();
	nestedEntry[@0] = 55;
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip save-loads 1b");
	source.enqueue("boo");
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip save-loads 1c");
	// List
	source = new List([1, 2], 3, 4);
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip save-loads 1a");
	nestedEntry = source.get(0);
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip save-loads 1b");
	source.add(5);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip save-loads 1c");
	// Grid
	source = new Grid(3, 2,
		{foo: 11}, 22, 33,
		44, 55, 66
	);
	target = lds_roundtrip_file(testFile, source);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip save-loads 1a");
	nestedEntry = source.get(0, 0);
	nestedEntry.foo = 111;
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip save-loads 1b");
	source.set(0, 0, 1111);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip save-loads 1c");
	// Heap
	source = new Heap("qux", 44, {foo: 11}, 11, "bar", 22, "baz", 33);
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip save-loads 1a");
	nestedEntry = source.getMin();
	nestedEntry.foo = 111;
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip save-loads 1b");
	source.deleteMin();
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip save-loads 1c");
	// Map
	source = new Map("foo", "bar", "baz", {qux: 22});
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip save-loads 1a");
	nestedEntry = source.get("baz");
	nestedEntry.qux = 222;
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip save-loads 1b");
	source.remove("baz");
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip save-loads 1c");
	// Nested
	source = new List("foo", new Map("bar", 33), "baz");
	target = lds_roundtrip_file(testFile, source);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip save-loads 1a");
	nestedEntry = source.get(1);
	nestedEntry.set("bar", 333);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip save-loads 1b");
	source.remove(1);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip save-loads 1c");
	#endregion

	#region Test basic roundtrip encrypted save-loads
	assert_equal(lds_roundtrip_encrypted_file(testFile, "foo"), "foo", "Test basic roundtrip encrypted save-loads string");
	assert_equal(lds_roundtrip_encrypted_file(testFile, 583.25), 583.25, "Test basic roundtrip encrypted save-loads real");
	// Array
	source = [1, 2, [3, 4]];
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encrypted save-loads array 1a");
	source[0] = 11;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encrypted save-loads array 1b");
	source[2][0] = 33;
	assert_equal(target, [1, 2, [3, 4]], "Test basic roundtrip encrypted save-loads array 1c");
	// Struct
	source = { foo: 1, bar: { baz: 2 } };
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encrypted save-loads struct 1a");
	source.foo = 11;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encrypted save-loads struct 1b");
	source.bar.baz = 22;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic roundtrip encrypted save-loads struct 1c");
	#endregion
	
	#region Test data structure roundtrip encrypted save-loads
	// Stack
	source = new Stack([1, 2], [3, 4]);
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encrypted save-loads 1a");
	nestedEntry = source.top();
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encrypted save-loads 1b");
	source.push("boo");
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack roundtrip encrypted save-loads 1c");
	// Queue
	source = new Queue([1, 2], [3, 4], [5, 6]);
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encrypted save-loads 1a");
	nestedEntry = source.tail();
	nestedEntry[@0] = 55;
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encrypted save-loads 1b");
	source.enqueue("boo");
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue roundtrip encrypted save-loads 1c");
	// List
	source = new List([1, 2], 3, 4);
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encrypted save-loads 1a");
	nestedEntry = source.get(0);
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encrypted save-loads 1b");
	source.add(5);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list roundtrip encrypted save-loads 1c");
	// Grid
	source = new Grid(3, 2,
		{foo: 11}, 22, 33,
		44, 55, 66
	);
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encrypted save-loads 1a");
	nestedEntry = source.get(0, 0);
	nestedEntry.foo = 111;
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encrypted save-loads 1b");
	source.set(0, 0, 1111);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid roundtrip encrypted save-loads 1c");
	// Heap
	source = new Heap("qux", 44, {foo: 11}, 11, "bar", 22, "baz", 33);
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encrypted save-loads 1a");
	nestedEntry = source.getMin();
	nestedEntry.foo = 111;
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encrypted save-loads 1b");
	source.deleteMin();
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap roundtrip encrypted save-loads 1c");
	// Map
	source = new Map("foo", "bar", "baz", {qux: 22});
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encrypted save-loads 1a");
	nestedEntry = source.get("baz");
	nestedEntry.qux = 222;
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encrypted save-loads 1b");
	source.remove("baz");
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map roundtrip encrypted save-loads 1c");
	// Nested
	source = new List("foo", new Map("bar", 33), "baz");
	target = lds_roundtrip_encrypted_file(testFile, source);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encrypted save-loads 1a");
	nestedEntry = source.get(1);
	nestedEntry.set("bar", 333);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encrypted save-loads 1b");
	source.remove(1);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested roundtrip encrypted save-loads 1c");
	#endregion

	// Cleanup
	if (file_exists(testFile)) {
		file_delete(testFile);
	}
}
