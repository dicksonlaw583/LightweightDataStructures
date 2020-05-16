///@func lds_test_reduce()
function lds_test_reduce() {
	
	// Test basic reductions
	assert_equal(lds_reduce("foo"), "foo", "Test basic reductions 1");
	assert_equal(lds_reduce(345.678), 345.678, "Test basic reductions 2");
	assert_equal(lds_reduce(undefined), undefined, "Test basic reductions 3");
	assert_equal(lds_reduce(bool(true)), bool(true), "Test basic reductions 4a");
	assert_equal(lds_reduce(bool(false)), bool(false), "Test basic reductions 4b");
	assert_equal(lds_reduce(int64(1112345678999)), {t: "int64", d: "1112345678999"}, "Test basic reductions 5");
	assert_equal(lds_reduce([]), [], "Test basic reductions 6a");
	assert_equal(lds_reduce([1, "two", [345.678, int64(1112345678999)]]), [1, "two", [345.678, {t: "int64", d: "1112345678999"}]], "Test basic reductions 6b");
	assert_equal(lds_reduce({}), {t: "struct", d: {}}, "Test basic reductions 7a");
	assert_equal(lds_reduce({foo: "bar", baz: 1375, qux: { foobar: 2468 }}), {t: "struct", d: {foo: "bar", baz: 1375, qux: {t: "struct", d: {foobar: 2468}}}}, "Test basic reductions 7b");
	
	// Test data structure reductions
	assert_equal(lds_reduce(new Stack(1, 2, 3)), {t: "Stack", d: [1, 2, 3]}, "Test data structure reductions for stacks");
	assert_equal(lds_reduce(new Queue(11, 22, 33)), {t: "Queue", d: [11, 22, 33]}, "Test data structure reductions for queues");
	assert_equal(lds_reduce(new List(111, 222, 333)), {t: "List", d: [111, 222, 333]}, "Test data structure reductions for lists");
	assert_equal(lds_reduce(new Grid(2, 3, 11, 22, 33, 44, 55, 66)), {t: "Grid", d: [11, 22, 33, 44, 55, 66, 2, 3]}, "Test data structure reductions for grids");
	assert_equal(lds_reduce(new Map("foo", 11, "bar", 22, "baz", 33)), {t: "Map", d: [["foo", "bar", "baz"], [11, 22, 33]]}, "Test data structure reductions for maps");
	assert_equal(lds_reduce(new Heap("foo", 111, "bar", 222)), {t: "Heap", d: [[111, 222], ["foo", "bar"]]}, "Test data structure reductions for heaps");
	assert_equal(lds_reduce({
		foobar: ["coo", "doo",
			new Stack(1, 2, 3),
			new Queue(11, 22, 33),
			new List(111, 222, 333),
			new Grid(2, 3, 11, 22, 33, 44, 55, 66),
			new Map("foo", 11, "bar", 22, "baz", 33),
			new Heap("foo", 111, "bar", 222)
		]
	}), {
		t: "struct",
		d: {
			foobar: ["coo", "doo",
				{t: "Stack", d: [1, 2, 3]},
				{t: "Queue", d: [11, 22, 33]},
				{t: "List", d: [111, 222, 333]},
				{t: "Grid", d: [11, 22, 33, 44, 55, 66, 2, 3]},
				{t: "Map", d: [["foo", "bar", "baz"], [11, 22, 33]]},
				{t: "Heap", d: [[111, 222], ["foo", "bar"]]}
			]
		}
	}, "Test data structure reductions fully");

	// Test basic expansions
	assert_equal(lds_expand("foo"), "foo", "Test basic expansions 1");
	assert_equal(lds_expand(345.678), 345.678, "Test basic expansions 2");
	assert_equal(lds_expand(undefined), undefined, "Test basic expansions 3");
	assert_equal(lds_expand(bool(true)), bool(true), "Test basic expansions 4a");
	assert_equal(lds_expand(bool(false)), bool(false), "Test basic expansions 4b");
	assert_equal(lds_expand({t: "int64", d: "1112345678999"}), int64(1112345678999), "Test basic expansions 5");
	assert_equal(lds_expand([]), [], "Test basic expansions 6a");
	assert_equal(lds_expand([1, "two", [345.678, {t: "int64", d: "1112345678999"}]]), [1, "two", [345.678, int64(1112345678999)]], "Test basic expansions 6b");
	assert_equal(lds_expand({t: "struct", d: {}}), {}, "Test basic expansions 7a");
	assert_equal(lds_expand({t: "struct", d: {foo: "bar", baz: 1375, qux: {t: "struct", d: {foobar: 2468}}}}), {foo: "bar", baz: 1375, qux: { foobar: 2468 }}, "Test basic expansions 7b");
	
	// Test data structure expansions
	var expanded;
	// Stack
	expanded = lds_expand({t: "Stack", d: [2]});
	assert_equal([expanded.size(), expanded.top()], [1, 2], "Test data structure expansion stack");
	// Queue
	expanded = lds_expand({t: "Queue", d: [3]});
	assert_equal([expanded.size(), expanded.head()], [1, 3], "Test data structure expansion queue");
	// List
	expanded = lds_expand({t: "List", d: [4, 5]});
	assert_equal([expanded.size(), expanded.get(0), expanded.get(1)], [2, 4, 5], "Test data structure expansion list");
	// Grid
	expanded = lds_expand({t: "Grid", d: [111, 222, 333, 444, 555, 666, 2, 3]});
	assert_equal(expanded.to2dArray(), [[111, 222], [333, 444], [555, 666]], "Test data structure expansion grid");
	// Map
	expanded = lds_expand({t: "Map", d: [["foo"], ["bar"]]});
	assert_equal([expanded.size(), expanded.get("foo")], [1, "bar"], "Test data structure expansion map");
	// Heap
	expanded = lds_expand({t: "Heap", d: [[111, 222], ["baz", "qux"]]});
	assert_equal([expanded.size(), expanded.getMin(), expanded.getMax()], [2, "baz", "qux"], "Test data structure expansion heap");
	// Mixed
	expanded = lds_expand({
		t: "List",
		d: [
			{t: "Map", d: [["foo"], ["bar"]]}
		]
	});
	assert_equal([expanded.size(), (expanded.get(0)).get("foo")], [1, "bar"], "Test data structure expansion nested");
}
