///@func lds_test_sort()
function lds_test_sort() {
	var got;
	
	// Make sure it sorts properly
	got = [4, 9, 6, 8, 0, 7, 2, 5, 3, 1];
	__lds_array_sort__(got);
	assert_equal(got, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "Sort kernel fails to sort simple upward!");
	__lds_array_sort__(got, false);
	assert_equal(got, [9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "Sort kernel fails to sort simple downward!");
	
	// Make sure it sorts properly with comparers
	got = ["F", "C", "G", "B", "A", "E", "D"];
	__lds_array_sort__(got, true, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(got, ["A", "B", "C", "D", "E", "F", "G"], "Sort kernel fails to sort compared upward!");
	__lds_array_sort__(got, false, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(got, ["G", "F", "E", "D", "C", "B", "A"], "Sort kernel fails to sort compared downward!");
	
	// Make sure it sorts properly with comparers and keyers
	got = [{k:"F"}, {k:"C"}, {k:"G"}, {k:"B"}, {k:"A"}, {k:"E"}, {k:"D"}];
	__lds_array_sort__(got, true, function(v) { return v.k; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(got, [{k:"A"}, {k:"B"}, {k:"C"}, {k:"D"}, {k:"E"}, {k:"F"}, {k:"G"}], "Sort kernel fails to sort keyed compared upward!");
	__lds_array_sort__(got, false, function(v) { return v.k; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(got, [{k:"G"}, {k:"F"}, {k:"E"}, {k:"D"}, {k:"C"}, {k:"B"}, {k:"A"}], "Sort kernel fails to sort keyed compared downward!");
}