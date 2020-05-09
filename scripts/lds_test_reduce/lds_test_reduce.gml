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
}
