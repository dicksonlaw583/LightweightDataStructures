///@func lds_test_grid()
function lds_test_grid() {
	var grid, grid2;

	#region Test mini grid constructors
	grid = new Grid();
	assert_equal([grid.width(), grid.height()], [0, 0], "Test mini grid constructors 1");
	grid = new Grid(4);
	assert_equal([grid.width(), grid.height(), grid.get(2, 0)], [4, 1, undefined], "Test mini grid constructors 2");
	#endregion

	#region Test new grid (with basic gets and sets)
	grid = new Grid(3, 2);
	assert_equal([grid.width(), grid.height(), grid.get(0, 0)], [3, 2, undefined], "Test new grid 1");
	grid = new Grid(3, 2,
		"foo", "goo", "hoo",
		"FOO", "GOO", "HOO"
	);
	assert_equal([grid.width(), grid.height(), grid.get(0, 0), grid.get(1, 0), grid.get(2, 0), grid.get(0, 1), grid.get(1, 1), grid.get(2, 1)], [3, 2, "foo", "goo", "hoo", "FOO", "GOO", "HOO"], "Test new grid 2");
	assert_throws(method({ grid: grid }, function() {
		grid.get(-1, 0);
	}), new GridIndexOutOfBoundsException(-1, 0), "Test new grid 3a");
	assert_throws(method({ grid: grid }, function() {
		grid.get(4, 0);
	}), new GridIndexOutOfBoundsException(4, 0), "Test new grid 3b");
	assert_throws(method({ grid: grid }, function() {
		grid.get(0, -1);
	}), new GridIndexOutOfBoundsException(0, -1), "Test new grid 3c");
	assert_throws(method({ grid: grid }, function() {
		grid.get(0, 2);
	}), new GridIndexOutOfBoundsException(0, 2), "Test new grid 3d");
	assert_throws(method({ grid: grid }, function() {
		grid.set(-1, 0);
	}), new GridIndexOutOfBoundsException(-1, 0), "Test new grid 3e");
	assert_throws(method({ grid: grid }, function() {
		grid.set(4, 0);
	}), new GridIndexOutOfBoundsException(4, 0), "Test new grid 3f");
	assert_throws(method({ grid: grid }, function() {
		grid.set(0, -1);
	}), new GridIndexOutOfBoundsException(0, -1), "Test new grid 3g");
	assert_throws(method({ grid: grid }, function() {
		grid.set(0, 2);
	}), new GridIndexOutOfBoundsException(0, 2), "Test new grid 3h");
	assert_throws(method({ grid: grid }, function() {
		grid.add(-1, 0, 6);
	}), new GridIndexOutOfBoundsException(-1, 0), "Test new grid 3i");
	assert_throws(method({ grid: grid }, function() {
		grid.add(4, 0, 6);
	}), new GridIndexOutOfBoundsException(4, 0), "Test new grid 3j");
	assert_throws(method({ grid: grid }, function() {
		grid.add(0, -1, 6);
	}), new GridIndexOutOfBoundsException(0, -1), "Test new grid 3k");
	assert_throws(method({ grid: grid }, function() {
		grid.add(0, 2, 6);
	}), new GridIndexOutOfBoundsException(0, 2), "Test new grid 3l");
	assert_throws(method({ grid: grid }, function() {
		grid.multiply(-1, 0, 6);
	}), new GridIndexOutOfBoundsException(-1, 0), "Test new grid 3m");
	assert_throws(method({ grid: grid }, function() {
		grid.multiply(4, 0, 6);
	}), new GridIndexOutOfBoundsException(4, 0), "Test new grid 3n");
	assert_throws(method({ grid: grid }, function() {
		grid.multiply(0, -1, 6);
	}), new GridIndexOutOfBoundsException(0, -1), "Test new grid 3o");
	assert_throws(method({ grid: grid }, function() {
		grid.multiply(0, 2, 6);
	}), new GridIndexOutOfBoundsException(0, 2), "Test new grid 3p");
	assert_equal(grid.to2dArray(), [["foo", "goo", "hoo"], ["FOO", "GOO", "HOO"]], "Test new grid 4");
	grid.set(1, 1, "FUGU");
	assert_equal(grid.to2dArray(), [["foo", "goo", "hoo"], ["FOO", "FUGU", "HOO"]], "Test new grid 5");
	#endregion
	
	#region Test grid resize
	grid = new Grid(3, 3,
		1, 2, 3,
		11, 22, 33,
		111, 222, 333
	);
	assert_equal(grid.to2dArray(), [[1, 2, 3], [11, 22, 33], [111, 222, 333]], "Test grid resize 1a");
	grid.resize(3, 4);
	assert_equal(grid.to2dArray(), [[1, 2, 3], [11, 22, 33], [111, 222, 333], [undefined, undefined, undefined]], "Test grid resize 1b");
	grid = new Grid(3, 3,
		1, 2, 3,
		11, 22, 33,
		111, 222, 333
	);
	grid.resize(4, 2);
	assert_equal(grid.to2dArray(), [[1, 2, 3, undefined], [11, 22, 33, undefined]], "Test grid resize 2");
	grid = new Grid(3, 3,
		1, 2, 3,
		11, 22, 33,
		111, 222, 333
	);
	grid.resize(2, 4);
	assert_equal(grid.to2dArray(), [[1, 2], [11, 22], [111, 222], [undefined, undefined]], "Test grid resize 3");
	grid = new Grid(3, 3,
		1, 2, 3,
		11, 22, 33,
		111, 222, 333
	);
	grid.resize(4, 4);
	assert_equal(grid.to2dArray(), [[1, 2, 3, undefined], [11, 22, 33, undefined], [111, 222, 333, undefined], [undefined, undefined, undefined, undefined]], "Test grid resize 4");
	#endregion

	#region Test region sets
	grid = new Grid(5, 5,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0
	);
	grid.setDisk(1, 1, 2, 1);
	assert_equal(grid.to2dArray(), [
		[1, 1, 1, 0, 0],
		[1, 1, 1, 1, 0],
		[1, 1, 1, 0, 0],
		[0, 1, 0, 0, 0],
		[0, 0, 0, 0, 0]
	], "Test region sets 1");
	grid.setDisk(2, 2, 2, 2);
	assert_equal(grid.to2dArray(), [
		[1, 1, 2, 0, 0],
		[1, 2, 2, 2, 0],
		[2, 2, 2, 2, 2],
		[0, 2, 2, 2, 0],
		[0, 0, 2, 0, 0]
	], "Test region sets 2");
	grid.setDisk(-1, -1, 3, 3);
	assert_equal(grid.to2dArray(), [
		[3, 3, 2, 0, 0],
		[3, 2, 2, 2, 0],
		[2, 2, 2, 2, 2],
		[0, 2, 2, 2, 0],
		[0, 0, 2, 0, 0]
	], "Test region sets 3");
	grid.setDisk(5, 5, 4, 4);
	assert_equal(grid.to2dArray(), [
		[3, 3, 2, 0, 0],
		[3, 2, 2, 2, 0],
		[2, 2, 2, 2, 4],
		[0, 2, 2, 4, 4],
		[0, 0, 4, 4, 4]
	], "Test region sets 4");
	grid.setRegion(1, 2, 3, 3, 5);
	assert_equal(grid.to2dArray(), [
		[3, 3, 2, 0, 0],
		[3, 2, 2, 2, 0],
		[2, 5, 5, 5, 4],
		[0, 5, 5, 5, 4],
		[0, 0, 4, 4, 4]
	], "Test region sets 5");
	grid.setRegion(3, -2, 9, 2, 6);
	assert_equal(grid.to2dArray(), [
		[3, 3, 2, 6, 6],
		[3, 2, 2, 6, 6],
		[2, 5, 5, 6, 6],
		[0, 5, 5, 5, 4],
		[0, 0, 4, 4, 4]
	], "Test region sets 6");
	grid.setRegion(-2, 3, 2, 6, 7);
	assert_equal(grid.to2dArray(), [
		[3, 3, 2, 6, 6],
		[3, 2, 2, 6, 6],
		[2, 5, 5, 6, 6],
		[7, 7, 7, 5, 4],
		[7, 7, 7, 4, 4]
	], "Test region sets 7");
	#endregion

	#region Test grid shuffle
	grid = new Grid(2, 5,
		0, 1,
		2, 3,
		4, 5,
		6, 7,
		8, 9
	);
	grid.shuffle();
	assert_not_equal(grid.to2dArray(), [[0, 1], [2, 3], [4, 5], [6, 7], [8, 9]], "Test grid shuffle 1a");
	for (var i = 0; i < 10; ++i) {
		assert_contains_2d(grid.to2dArray(), i, "Test grid shuffle 1b");
	}
	grid = new Grid(2, 5,
		0, 1,
		2, 3,
		4, 5,
		6, 7,
		8, 9
	);
	grid.shuffleRows();
	assert_not_equal(grid.to2dArray(), [[0, 1], [2, 3], [4, 5], [6, 7], [8, 9]], "Test grid shuffle 2a");
	for (var i = 0; i < 10; i += 2) {
		assert_contains(grid.to2dArray(), [i, i+1], "Test grid shuffle 2b");
	}
	#endregion
	
	#region Test sort
	grid = new Grid(2, 5,
		0, "A",
		3, "B",
		-4, "C",
		-6, "D",
		2, "E", 
	);
	grid.sort(0);
	assert_equal(grid.to2dArray(), [[-6, "D"], [-4, "C"], [0, "A"], [2, "E"], [3, "B"]], "Test grid sort 1a");
	grid.sort(0, false);
	assert_equal(grid.to2dArray(), [[3, "B"], [2, "E"], [0, "A"], [-4, "C"], [-6, "D"]], "Test grid sort 1b");
	grid.sort(1, true, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(grid.to2dArray(), [[0, "A"], [3, "B"], [-4, "C"], [-6, "D"], [2, "E"]], "Test grid sort 2a");
	grid.sort(1, false, undefined, function(a, b) { return ord(a) > ord(b); });
	assert_equal(grid.to2dArray(), [[2, "E"], [-6, "D"], [-4, "C"], [3, "B"], [0, "A"]], "Test grid sort 2b");
	grid = new Grid(2, 5,
		{k: 0}, {q: "A"},
		{k: 3}, {q: "B"},
		{k: -4}, {q: "C"},
		{k: -6}, {q: "D"},
		{k: 2}, {q: "E"}, 
	);
	grid.sort(0, true, function(v) { return v.k; });
	assert_equal(grid.to2dArray(), [[{k: -6}, {q: "D"}], [{k: -4}, {q: "C"}], [{k: 0}, {q: "A"}], [{k: 2}, {q: "E"}], [{k: 3}, {q: "B"}]], "Test grid sort 3a");
	grid.sort(0, false, function(v) { return v.k; });
	assert_equal(grid.to2dArray(), [[{k: 3}, {q: "B"}], [{k: 2}, {q: "E"}], [{k: 0}, {q: "A"}], [{k: -4}, {q: "C"}], [{k: -6}, {q: "D"}]], "Test grid sort 3b");
	grid.sort(1, true, function(v) { return v.q; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(grid.to2dArray(), [[{k: 0}, {q: "A"}], [{k: 3}, {q: "B"}], [{k: -4}, {q: "C"}], [{k: -6}, {q: "D"}], [{k: 2}, {q: "E"}]], "Test grid sort 4a");
	grid.sort(1, false, function(v) { return v.q; }, function(a, b) { return ord(a) > ord(b); });
	assert_equal(grid.to2dArray(), [[{k: 2}, {q: "E"}], [{k: -6}, {q: "D"}], [{k: -4}, {q: "C"}], [{k: 3}, {q: "B"}], [{k: 0}, {q: "A"}]], "Test grid sort 4b");
	#endregion

	#region Test grid region adds
	grid = new Grid(5, 5,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1
	);
	grid.addDisk(2, 2, 1, 2);
	assert_equal(grid.to2dArray(), [
		[1, 1, 1, 1, 1],
		[1, 1, 3, 1, 1],
		[1, 3, 3, 3, 1],
		[1, 1, 3, 1, 1],
		[1, 1, 1, 1, 1]
	], "Test grid region adds 1");
	grid.addDisk(5, -1, 3, 3);
	assert_equal(grid.to2dArray(), [
		[1, 1, 1, 4, 4],
		[1, 1, 3, 1, 4],
		[1, 3, 3, 3, 1],
		[1, 1, 3, 1, 1],
		[1, 1, 1, 1, 1]
	], "Test grid region adds 2");
	grid.addDisk(-1, 5, 4, 1);
	assert_equal(grid.to2dArray(), [
		[1, 1, 1, 4, 4],
		[1, 1, 3, 1, 4],
		[2, 3, 3, 3, 1],
		[2, 2, 3, 1, 1],
		[2, 2, 2, 1, 1]
	], "Test grid region adds 3");
	grid.addRegion(0, 0, 2, 2, 2);
	assert_equal(grid.to2dArray(), [
		[3, 3, 3, 4, 4],
		[3, 3, 5, 1, 4],
		[4, 5, 5, 3, 1],
		[2, 2, 3, 1, 1],
		[2, 2, 2, 1, 1]
	], "Test grid region adds 4");
	grid.addRegion(2, 2, 5, 5, 2);
	assert_equal(grid.to2dArray(), [
		[3, 3, 3, 4, 4],
		[3, 3, 5, 1, 4],
		[4, 5, 7, 5, 3],
		[2, 2, 5, 3, 3],
		[2, 2, 4, 3, 3]
	], "Test grid region adds 5");
	grid.addRegion(-1, -1, 3, 1, 1);
	assert_equal(grid.to2dArray(), [
		[4, 4, 4, 5, 4],
		[4, 4, 6, 2, 4],
		[4, 5, 7, 5, 3],
		[2, 2, 5, 3, 3],
		[2, 2, 4, 3, 3]
	], "Test grid region adds 6");
	#endregion

	#region Test grid region multiplies
	grid = new Grid(5, 5,
		01, 01, 01, 01, 01,
		01, 01, 01, 01, 01,
		01, 01, 01, 01, 01,
		01, 01, 01, 01, 01,
		01, 01, 01, 01, 01
	);
	grid.multiplyDisk(2, 2, 2, 2);
	assert_equal(grid.to2dArray(), [
		[01, 01, 02, 01, 01],
		[01, 02, 02, 02, 01],
		[02, 02, 02, 02, 02],
		[01, 02, 02, 02, 01],
		[01, 01, 02, 01, 01],
	], "Test grid region multiplies 1");
	grid.multiplyDisk(-1, -1, 3, 2);
	assert_equal(grid.to2dArray(), [
		[02, 02, 02, 01, 01],
		[02, 02, 02, 02, 01],
		[02, 02, 02, 02, 02],
		[01, 02, 02, 02, 01],
		[01, 01, 02, 01, 01],
	], "Test grid region multiplies 2");
	grid.multiplyDisk(5, 5, 4, 2);
	assert_equal(grid.to2dArray(), [
		[02, 02, 02, 01, 01],
		[02, 02, 02, 02, 01],
		[02, 02, 02, 02, 04],
		[01, 02, 02, 04, 02],
		[01, 01, 04, 02, 02],
	], "Test grid region multiplies 3");
	grid.multiplyRegion(1, 1, 3, 3, 2);
	assert_equal(grid.to2dArray(), [
		[02, 02, 02, 01, 01],
		[02, 04, 04, 04, 01],
		[02, 04, 04, 04, 04],
		[01, 04, 04, 08, 02],
		[01, 01, 04, 02, 02],
	], "Test grid region multiplies 4");
	grid.multiplyRegion(-1, 3, 3, 5, 2);
	assert_equal(grid.to2dArray(), [
		[02, 02, 02, 01, 01],
		[02, 04, 04, 04, 01],
		[02, 04, 04, 04, 04],
		[02, 08, 08, 16, 02],
		[02, 02, 08, 04, 02],
	], "Test grid region multiplies 5");
	grid.multiplyRegion(3, -1, 5, 5, 2);
	assert_equal(grid.to2dArray(), [
		[02, 02, 02, 02, 02],
		[02, 04, 04, 08, 02],
		[02, 04, 04, 08, 08],
		[02, 08, 08, 32, 04],
		[02, 02, 08, 08, 04],
	], "Test grid region multiplies 6");
	#endregion

	#region Test grid value exists
	grid = new Grid(5, 5,
		00, 01, 02, 03, 04,
		05, 06, 07, 08, 09,
		10, 11, 12, 13, 14,
		15, 16, 17, 18, 19,
		20, 21, 22, 23, 24
	);
	assert(grid.valueExists(1, 1, 3, 3, 18), "Test grid value exists 1a");
	assert_fail(grid.valueExists(1, 1, 3, 3, 24), "Test grid value exists 1b");
	assert(grid.valueExists(-1, -1, 3, 3, 05), "Test grid value exists 2a");
	assert_fail(grid.valueExists(-1, -1, 3, 3, 20), "Test grid value exists 2b");
	assert(grid.valueDiskExists(3, 3, 2, 24), "Test grid value exists 3a");
	assert_fail(grid.valueDiskExists(3, 3, 2, 06), "Test grid value exists 3b");
	assert(grid.valueDiskExists(3, 5, 2, 22), "Test grid value exists 4a");
	assert_fail(grid.valueDiskExists(3, 5, 2, 13), "Test grid value exists 4b");
	#endregion

	#region Test grid value positions
	grid = new Grid(5, 5,
		00, 01, 02, 03, 04,
		05, 06, 07, 08, 09,
		10, 11, 12, 13, 14,
		15, 16, 17, 18, 19,
		20, 21, 22, 23, 24
	);
	assert_equal(grid.valueX(1, 1, 3, 3, 17), 2, "Test grid value positions 1a");
	assert_equal(grid.valueY(1, 1, 3, 3, 17), 3, "Test grid value positions 1b");
	assert_equal(grid.valueX(1, 1, 3, 3, 24), -1, "Test grid value positions 1c");
	assert_equal(grid.valueY(1, 1, 3, 3, 24), -1, "Test grid value positions 1d");
	assert_equal(grid.valueX(-1, -1, 3, 3, 05), 0, "Test grid value positions 2a");
	assert_equal(grid.valueY(-1, -1, 3, 3, 05), 1, "Test grid value positions 2b");
	assert_equal(grid.valueX(-1, -1, 3, 3, 20), -1, "Test grid value positions 2c");
	assert_equal(grid.valueY(-1, -1, 3, 3, 20), -1, "Test grid value positions 2d");
	assert_equal(grid.valueDiskX(3, 3, 2, 23), 3, "Test grid value positions 3a");
	assert_equal(grid.valueDiskY(3, 3, 2, 23), 4, "Test grid value positions 3b");
	assert_equal(grid.valueDiskX(3, 3, 2, 06), -1, "Test grid value positions 3c");
	assert_equal(grid.valueDiskY(3, 3, 2, 06), -1, "Test grid value positions 3d");
	assert_equal(grid.valueDiskX(3, 5, 2, 22), 2, "Test grid value positions 4a");
	assert_equal(grid.valueDiskY(3, 5, 2, 22), 4, "Test grid value positions 4b");
	assert_equal(grid.valueDiskX(3, 5, 2, 13), -1, "Test grid value positions 4c");
	assert_equal(grid.valueDiskY(3, 5, 2, 13), -1, "Test grid value positions 4d");
	#endregion

	#region Test grid region-to-region sets
	grid = new Grid(4, 4,
		00, 02, 04, 08,
		10, 12, 14, 16,
		18, 20, 22, 24,
		26, 28, 30, 32
	);
	grid2 = new Grid(3, 3,
		01, 03, 05,
		07, 09, 11,
		13, 15, 17
	);
	grid.setGridRegion(grid2, 1, 0, 2, 1, 1, 2);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 14, 16],
		[18, 03, 05, 24],
		[26, 09, 11, 32]
	], "Test grid region-to-region sets 1");
	grid.setGridRegion(grid2, -2, -1, 1, 2, 0, 0);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 01, 03],
		[18, 03, 07, 09],
		[26, 09, 13, 15]
	], "Test grid region-to-region sets 2");
	grid.setGridRegion(grid2, 2, 1, 4, 5, 0, 1);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[11, 12, 01, 03],
		[17, 03, 07, 09],
		[26, 09, 13, 15]
	], "Test grid region-to-region sets 3");
	#endregion

	#region Test grid region-to-region adds
	grid = new Grid(4, 4,
		00, 02, 04, 08,
		10, 12, 14, 16,
		18, 20, 22, 24,
		26, 28, 30, 32
	);
	grid2 = new Grid(3, 3,
		01, 03, 05,
		07, 09, 11,
		13, 15, 17
	);
	grid.addGridRegion(grid2, 1, 0, 2, 1, 1, 2);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 14, 16],
		[18, 20+3, 22+5, 24],
		[26, 28+9, 30+11, 32]
	], "Test grid region-to-region adds 1");
	grid.addGridRegion(grid2, -2, -1, 1, 2, 0, 0);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 14+1, 16+3],
		[18, 20+3, 22+5+7, 24+9],
		[26, 28+9, 30+11+13, 32+15]
	], "Test grid region-to-region adds 2");
	grid.addGridRegion(grid2, 2, 1, 4, 5, 0, 1);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10+11, 12, 14+1, 16+3],
		[18+17, 20+3, 22+5+7, 24+9],
		[26, 28+9, 30+11+13, 32+15]
	], "Test grid region-to-region adds 3");
	#endregion

	#region Test grid region-to-region multiplies
	grid = new Grid(4, 4,
		00, 02, 04, 08,
		10, 12, 14, 16,
		18, 20, 22, 24,
		26, 28, 30, 32
	);
	grid2 = new Grid(3, 3,
		01, 03, 05,
		07, 09, 11,
		13, 15, 17
	);
	grid.multiplyGridRegion(grid2, 1, 0, 2, 1, 1, 2);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 14, 16],
		[18, 20*3, 22*5, 24],
		[26, 28*9, 30*11, 32]
	], "Test grid region-to-region multiplies 1");
	grid.multiplyGridRegion(grid2, -2, -1, 1, 2, 0, 0);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10, 12, 14*1, 16*3],
		[18, 20*3, 22*5*7, 24*9],
		[26, 28*9, 30*11*13, 32*15]
	], "Test grid region-to-region multiplies 2");
	grid.multiplyGridRegion(grid2, 2, 1, 4, 5, 0, 1);
	assert_equal(grid.to2dArray(), [
		[00, 02, 04, 08],
		[10*11, 12, 14*1, 16*3],
		[18*17, 20*3, 22*5*7, 24*9],
		[26, 28*9, 30*11*13, 32*15]
	], "Test grid region-to-region multiplies 3");
	#endregion

	#region Test grid stats
	grid = new Grid(5, 5,
		0, 1, 2, 3, 4,
		5, 6, 7, 8, 9,
		9, 8, 7, 6, 5,
		4, 3, 2, 1, 0,
		0, 1, 2, 3, 4
	);
	assert_equal(grid.getMax(1, 1, 3, 3), 8, "Test grid stats 1a");
	assert_equalish(grid.getMean(1, 1, 3, 3), 48/9, "Test grid stats 1b");
	assert_equal(grid.getMin(1, 1, 3, 3), 1, "Test grid stats 1c");
	assert_equal(grid.getSum(1, 1, 3, 3), 48, "Test grid stats 1d");
	assert_equal(grid.getMax(2, 2, 5, 5), 7, "Test grid stats 2a");
	assert_equalish(grid.getMean(2, 2, 5, 5), 30/9, "Test grid stats 2b");
	assert_equal(grid.getMin(2, 2, 5, 5), 0, "Test grid stats 2c");
	assert_equal(grid.getSum(2, 2, 5, 5), 30, "Test grid stats 2d");
	assert_equal(grid.getDiskMax(2, 2, 1), 8, "Test grid stats 3a");
	assert_equalish(grid.getDiskMean(2, 2, 1), 6, "Test grid stats 3b");
	assert_equal(grid.getDiskMin(2, 2, 1), 2, "Test grid stats 3c");
	assert_equal(grid.getDiskSum(2, 2, 1), 30, "Test grid stats 3d");
	assert_equal(grid.getDiskMax(5, 5, 4), 5, "Test grid stats 4a");
	assert_equalish(grid.getDiskMean(5, 5, 4), 15/6, "Test grid stats 4b");
	assert_equal(grid.getDiskMin(5, 5, 4), 0, "Test grid stats 4c");
	assert_equal(grid.getDiskSum(5, 5, 4), 15, "Test grid stats 4d");
	#endregion

	#region Test grid copy
	grid = new Grid(3, 2,
		11, 22, 33,
		44, 55, 66
	);
	grid2 = new Grid(2, 1,
		111, 222
	);
	grid2.copy(grid);
	assert_equal(grid2.to2dArray(), [[11, 22, 33], [44, 55, 66]], "Test grid copy 1");
	grid2.set(1, 1, 555);
	assert_equal(grid.to2dArray(), [[11, 22, 33], [44, 55, 66]], "Test grid copy 2");
	#endregion

	#region Test grid clone
	grid = new Grid(3, 2,
		111, 222, 333,
		444, 555, 666
	);
	grid2 = grid.clone();
	assert_equal(grid2.to2dArray(), [[111, 222, 333], [444, 555, 666]], "Test grid copy 1");
	grid2.set(1, 1, 5555);
	assert_equal(grid.to2dArray(), [[111, 222, 333], [444, 555, 666]], "Test grid copy 2");
	#endregion

	#region Test grid reduction
	grid = new Grid(2, 3,
		11, 22,
		33, 44,
		55, 66
	);
	assert_equal(grid.reduceToData(), [11, 22, 33, 44, 55, 66, 2, 3], "Test grid reduction 1");
	grid = new Grid(3, 2,
		111, [222, 333], { foo: 444 },
		"555", { bar: 666, baz: 777 }, "888");
	assert_equal(grid.reduceToData(), [111, [222, 333], {t: "struct", d: {foo: 444}}, "555", {t: "struct", d: {bar: 666, baz: 777}}, "888", 3, 2], "Test grid reduction 2");
	#endregion
	
	#region Test grid expansion
	grid = new Grid(1, 1,
		0
	);
	grid.expandFromData([11, 22, 33, 44, 55, 66, 2, 3]);
	assert_equal(grid.to2dArray(), [[11, 22], [33, 44], [55, 66]], "Test grid expansion 1");
	grid = new Grid(1, 1,
		0
	);
	grid.expandFromData([111, [222, 333], {t: "struct", d: {foo: 444}}, "555", {t: "struct", d: {bar: 666, baz: 777}}, "888", 3, 2]);
	assert_equal(grid.to2dArray(), [[111, [222, 333], { foo: 444 }], ["555", { bar: 666, baz: 777 }, "888"]], "Test grid expansion 2");
	#endregion

	#region Test grid read/write
	grid = new Grid(1, 1, 0);
	grid2 = new Grid(2, 3, 11, 22, 33, 44, 55, 66);
	got = grid.write();
	grid2.read(got);
	assert_equal(grid.to2dArray(), [[0]], "Test grid read/write 1");
	grid = new Grid(2, 2, "foo", "bar", "baz", "qux");
	grid2 = new Grid(4, 4);
	got = grid.write();
	grid2.read(got);
	assert_equal([grid2.width(), grid2.height(), grid2.get(0, 0), grid2.get(1, 0), grid2.get(0, 1), grid2.get(1, 1)], [2, 2, "foo", "bar", "baz", "qux"], "Test grid read/write 2");
	grid = new Grid(1, 1, "foo");
	assert_throws(method({ grid: grid }, function() {
		grid.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("Grid", "struct"), "Test grid read/write 3");
	#endregion

	#region Test grid forEach
	grid = new Grid(3, 3,
		0, 1, 2,
		3, 4, 5,
		6, 7, 8,
	);
	grid2 = new Grid(3, 3);
	grid.forEach(method({ g2: grid2 }, function(v, xx, yy) {
		g2.set(xx, yy, v+10);
	}));
	assert_equal(grid2.to2dArray(), [[10, 11, 12], [13, 14, 15], [16, 17, 18]], "Test grid forEach 1");
	grid = new Grid(3, 3,
		0, 1, 2,
		3, 4, 5,
		6, 7, 8,
	);
	grid2 = new Grid(3, 3,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
	);
	grid.forEachInDisk(method({ g2: grid2 }, function(v, xx, yy) {
		g2.set(xx, yy, v+100);
	}), 2, 2, 1);
	assert_equal(grid2.to2dArray(), [[000, 000, 000], [000, 000, 105], [000, 107, 108]], "Test grid forEachInDisk 1");
	grid2 = new Grid(3, 3,
		000, 000, 000,
		000, 000, 105,
		000, 107, 108,
	);
	grid.forEachInRegion(method({ g2: grid2 }, function(v, xx, yy) {
		g2.set(xx, yy, v+110);
	}), -1, -1, 1, 1);
	assert_equal(grid2.to2dArray(), [[110, 111, 000], [113, 114, 105], [000, 107, 108]], "Test grid forEachInRegion 1");
	#endregion
	
	#region Test grid mapEach
	grid = new Grid(3, 3,
		0, 1, 2,
		3, 4, 5,
		6, 7, 8,
	);
	grid.mapEach(function(v) {
		return v+20;
	});
	assert_equal(grid.to2dArray(), [[20, 21, 22], [23, 24, 25], [26, 27, 28]], "Test grid mapEach 1");
	grid = new Grid(3, 3,
		20, 21, 22,
		23, 24, 25,
		26, 27, 28,
	);
	grid.mapEachInDisk(function(v) {
		return v+20;
	}, 2, 0, 1);
	assert_equal(grid.to2dArray(), [[20, 41, 42], [23, 24, 45], [26, 27, 28]], "Test grid mapEachInDisk 1");
	grid = new Grid(3, 3,
		20, 41, 42,
		23, 24, 45,
		26, 27, 28,
	);
	grid.mapEachInRegion(function(v) {
		return v+30;
	}, -1, 1, 1, 3);
	assert_equal(grid.to2dArray(), [[20, 41, 42], [53, 54, 45], [56, 57, 28]], "Test grid mapEachInRegion 1");
	#endregion

	#region Test grid iterators
	grid = new Grid(3, 3,
		0, 1, 2,
		3, 4, 5,
		6, 7, 8,
	);
	grid2 = new Grid(3, 3);
	for (var i = grid.iterator(); i.hasNext(); i.next()) {
		assert_is_real(i.value, "Test grid iterator 1 is_real");
		grid2.set(i.x, i.y, real(i.value)+30); //(GMS 2.3 beta 10) Work around YYC "unable to add a number to a string" false positive
	}
	assert_equal(grid2.to2dArray(), [[30, 31, 32], [33, 34, 35], [36, 37, 38]], "Test grid iterator 1");
	grid2.clear(0);
	for (var i = grid.diskIterator(2, 2, 1); i.hasNext(); i.next()) {
		assert_is_real(i.value, "Test grid disk iterator 1 is_real");
		grid2.set(i.x, i.y, real(i.value)+40); //(GMS 2.3 beta 10) Work around YYC "unable to add a number to a string" false positive
	}
	assert_equal(grid2.to2dArray(), [[00, 00, 00], [00, 00, 45], [00, 47, 48]], "Test grid disk iterator 1");
	grid2.clear(0);
	for (var i = grid.regionIterator(-1, -1, 1, 3); i.hasNext(); i.next()) {
		assert_is_real(i.value, "Test grid region iterator 1 is_real");
		grid2.set(i.x, i.y, real(i.value)+50); //(GMS 2.3 beta 10) Work around YYC "unable to add a number to a string" false positive
	}
	assert_equal(grid2.to2dArray(), [[50, 51, 00], [53, 54, 00], [56, 57, 00]], "Test grid region iterator 1");
	#endregion
}
