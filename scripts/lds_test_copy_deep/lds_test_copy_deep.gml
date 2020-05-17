///@func lds_test_copy_deep()
function lds_test_copy_deep() {
	var target, source, nestedEntry;
	
	#region Test basic deep copies
	assert_equal(lds_copy_deep("boo", "foo"), "foo", "Test basic deep copies string");
	assert_equal(lds_copy_deep(583.25, 295.725), 295.725, "Test basic deep copies real");
	// Array
	source = [1, 2, [3, 4]];
	target = [];
	assert_equal(lds_copy_deep(target, source), [1, 2, [3, 4]], "Test basic deep copies array 1a");
	source[0] = 11;
	assert_equal(target, [1, 2, [3, 4]], "Test basic deep copies array 1b");
	source[2][0] = 33;
	assert_equal(target, [1, 2, [3, 4]], "Test basic deep copies array 1c");
	// Struct
	source = { foo: 1, bar: { baz: 2 } };
	target = { qux: "bad" };
	assert_equal(lds_copy_deep(target, source), { foo: 1, bar: { baz: 2 }, qux: undefined }, "Test basic deep copies struct 1a");
	source.foo = 11;
	assert_equal(target, { foo: 1, bar: { baz: 2 }, qux: undefined }, "Test basic deep copies struct 1b");
	source.bar.baz = 22;
	assert_equal(target, { foo: 1, bar: { baz: 2 }, qux: undefined }, "Test basic deep copies struct 1c");
	#endregion
	
	#region Test data structure deep copies
	// Stack
	source = new Stack([1, 2], [3, 4]);
	target = new Stack(undefined);
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep copies 1a");
	nestedEntry = source.top();
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep copies 1b");
	source.push("boo");
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep copies 1c");
	// Queue
	source = new Queue([1, 2], [3, 4], [5, 6]);
	target = new Queue(undefined);
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep copies 1a");
	nestedEntry = source.tail();
	nestedEntry[@0] = 55;
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep copies 1b");
	source.enqueue("boo");
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep copies 1c");
	// List
	source = new List([1, 2], 3, 4);
	target = new List("bad", "bad");
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep copies 1a");
	nestedEntry = source.get(0);
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep copies 1b");
	source.add(5);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep copies 1c");
	// Grid
	source = new Grid(3, 2,
		{foo: 11}, 22, 33,
		44, 55, 66
	);
	target = new Grid(1, 1, "boo");
	lds_copy_deep(target, source);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep copies 1a");
	nestedEntry = source.get(0, 0);
	nestedEntry.foo = 111;
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep copies 1b");
	source.set(0, 0, 1111);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep copies 1c");
	// Heap
	source = new Heap("qux", 44, {foo: 11}, 11, "bar", 22, "baz", 33);
	target = new Heap("bad", 55);
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep copies 1a");
	nestedEntry = source.getMin();
	nestedEntry.foo = 111;
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep copies 1b");
	source.deleteMin();
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep copies 1c");
	// Map
	source = new Map("foo", "bar", "baz", {qux: 22});
	target = new Map("bad", 666);
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep copies 1a");
	nestedEntry = source.get("baz");
	nestedEntry.qux = 222;
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep copies 1b");
	source.remove("baz");
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep copies 1c");
	// Nested
	source = new List("foo", new Map("bar", 33), "baz");
	target = new List("qux");
	lds_copy_deep(target, source);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep copies 1a");
	nestedEntry = source.get(1);
	nestedEntry.set("bar", 333);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep copies 1b");
	source.remove(1);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep copies 1c");
	#endregion
	
	#region Test basic deep clones
	assert_equal(lds_clone_deep("foo"), "foo", "Test basic deep clones string");
	assert_equal(lds_clone_deep(583.25), 583.25, "Test basic deep clones real");
	// Array
	source = [1, 2, [3, 4]];
	target = lds_clone_deep(source);
	assert_equal(target, [1, 2, [3, 4]], "Test basic deep clones array 1a");
	source[0] = 11;
	assert_equal(target, [1, 2, [3, 4]], "Test basic deep clones array 1b");
	source[2][0] = 33;
	assert_equal(target, [1, 2, [3, 4]], "Test basic deep clones array 1c");
	// Struct
	source = { foo: 1, bar: { baz: 2 } };
	target = lds_clone_deep(source);
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic deep clones struct 1a");
	source.foo = 11;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic deep clones struct 1b");
	source.bar.baz = 22;
	assert_equal(target, { foo: 1, bar: { baz: 2 } }, "Test basic deep clones struct 1c");
	#endregion
	
	#region Test data structure deep clones
	// Stack
	source = new Stack([1, 2], [3, 4]);
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep clones 1a");
	nestedEntry = source.top();
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep clones 1b");
	source.push("boo");
	assert_equal([target.size(), target.top()], [2, [1, 2]], "Test LDS stack deep clones 1c");
	// Queue
	source = new Queue([1, 2], [3, 4], [5, 6]);
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep clones 1a");
	nestedEntry = source.tail();
	nestedEntry[@0] = 55;
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep clones 1b");
	source.enqueue("boo");
	assert_equal([target.size(), target.head(), target.tail()], [3, [1, 2], [5, 6]], "Test LDS queue deep clones 1c");
	// List
	source = new List([1, 2], 3, 4);
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep clones 1a");
	nestedEntry = source.get(0);
	nestedEntry[@0] = 11;
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep clones 1b");
	source.add(5);
	assert_equal([target.size(), target.get(0), target.get(1), target.get(2)], [3, [1, 2], 3, 4], "Test LDS list deep clones 1c");
	// Grid
	source = new Grid(3, 2,
		{foo: 11}, 22, 33,
		44, 55, 66
	);
	target = lds_clone_deep(source);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep clones 1a");
	nestedEntry = source.get(0, 0);
	nestedEntry.foo = 111;
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep clones 1b");
	source.set(0, 0, 1111);
	assert_equal(target.to2dArray(), [[{foo: 11}, 22, 33], [44, 55, 66]], "Test LDS grid deep clones 1c");
	// Heap
	source = new Heap("qux", 44, {foo: 11}, 11, "bar", 22, "baz", 33);
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep clones 1a");
	nestedEntry = source.getMin();
	nestedEntry.foo = 111;
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep clones 1b");
	source.deleteMin();
	assert_equal([target.size(), target.getMin(), target.getMax()], [4, {foo: 11}, "qux"], "Test LDS heap deep clones 1c");
	// Map
	source = new Map("foo", "bar", "baz", {qux: 22});
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep clones 1a");
	nestedEntry = source.get("baz");
	nestedEntry.qux = 222;
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep clones 1b");
	source.remove("baz");
	assert_equal([target.size(), target.get("foo"), target.get("baz")], [2, "bar", {qux: 22}], "Test LDS map deep clones 1c");
	// Nested
	source = new List("foo", new Map("bar", 33), "baz");
	target = lds_clone_deep(source);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep clones 1a");
	nestedEntry = source.get(1);
	nestedEntry.set("bar", 333);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep clones 1b");
	source.remove(1);
	assert_equal([target.size(), target.get(0), (target.get(1)).get("bar"), target.get(2)], [3, "foo", 33, "baz"], "Test LDS nested deep clones 1c");
	#endregion
}
