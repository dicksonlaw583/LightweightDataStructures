///@func lds_test_shuffle()
function lds_test_shuffle() {
	var got;
	
	// Make sure it moves something around and has everything
	got = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
	__lds_array_shuffle__(got);
	assert_not_equal(got, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "Shuffle kernel doesn't shuffle!");
	assert_equal(array_length(got), 10, "Shuffle kernel changed the size!");
	for (var i = 0; i < 10; ++i) {
		assert_contains(got, i, "Shuffle kernel cut out " + string(i) + "!");
	}
}