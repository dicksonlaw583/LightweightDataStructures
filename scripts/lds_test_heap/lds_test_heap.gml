///@func lds_test_heap()
///@desc Test Lightweight Data Structure heaps.
function lds_test_heap() {
	var heap, heap2, expectedStressArray;
	
	#region Test empty heap
	heap = new Heap();
	assert_equal(heap.size(), 0, "Test empty heap 1");
	assert(heap.empty(), "Test empty heap 2");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteMin();
	}), new HeapEmptyException("Trying to remove min from an empty heap."), "Test empty heap 3");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteMax();
	}), new HeapEmptyException("Trying to remove max from an empty heap."), "Test empty heap 4");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteValue("foo");
	}), new HeapEmptyException("Trying to remove a value from an empty heap."), "Test empty heap 5");
	assert_throws(method({ heap: heap }, function() {
		heap.findMin();
	}), new HeapEmptyException("Trying to get min from an empty heap."), "Test empty heap 6");
	assert_throws(method({ heap: heap }, function() {
		heap.findMax();
	}), new HeapEmptyException("Trying to get max from an empty heap."), "Test empty heap 7");
	assert_throws(method({ heap: heap }, function() {
		heap.findValue("foo");
	}), new HeapEmptyException("Trying to get a value from an empty heap."), "Test empty heap 8");
	#endregion
	
	#region Test a quick heap add
	heap.add("foo", 5);
	assert_equal([
		heap.size(),
		heap.findMin(),
		heap.findMax(),
		heap.findValue("foo")
	], [
		1,
		"foo",
		"foo",
		5
	], "Test quick heap add 1");
	heap.add("bar", 7, "baz", 3);
	assert_equal([
		heap.size(),
		heap.findMin(),
		heap.findMax(),
		heap.findValue("foo")
	],[
		3,
		"baz",
		"bar",
		5
	], "Test quick heap add 2");
	heap.add("qux", 4, "QUX", 6, "QuX", 8);
	assert_equal([
		heap.size(),
		heap.findMin(),
		heap.findMax()
	],[
		6,
		"baz",
		"QuX"
	], "Test quick heap add 3");
	assert_equal([
		heap.deleteMin(),
		heap.deleteMax()
	], [
		"baz",
		"QuX"
	], "Test quick heap add 4");
	assert_equal([
		heap.size(),
		heap.findMin(),
		heap.findMax()
	],[
		4,
		"qux",
		"bar"
	], "Test quick heap add 5");
	assert_equal([
		heap.deleteMin(),
		heap.deleteMax()
	], [
		"qux",
		"bar"
	], "Test quick heap add 6");
	assert_equal([
		heap.size(),
		heap.getMin(),
		heap.getMax()
	],[
		2,
		"foo",
		"QUX"
	], "Test quick heap add 7");
	assert_equal([
		heap.deleteMax(),
		heap.deleteMin()
	],[
		"QUX",
		"foo"
	], "Test quick heap add 8");
	#endregion
	#region Test clearing heap
	heap.add("qux", 4, "QUX", 6, "QuX", 8);
	heap.clear();
	assert_equal(heap.size(), 0, "Test clearing heap 1");
	assert(heap.empty(), "Test clearing heap 2");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteMin();
	}), new HeapEmptyException("Trying to remove min from an empty heap."), "Test clearing heap 3");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteMax();
	}), new HeapEmptyException("Trying to remove max from an empty heap."), "Test clearing heap 4");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteValue("foo");
	}), new HeapEmptyException("Trying to remove a value from an empty heap."), "Test clearing heap 5");
	assert_throws(method({ heap: heap }, function() {
		heap.findMin();
	}), new HeapEmptyException("Trying to get min from an empty heap."), "Test clearing heap 6");
	assert_throws(method({ heap: heap }, function() {
		heap.findMax();
	}), new HeapEmptyException("Trying to get max from an empty heap."), "Test clearing heap 7");
	assert_throws(method({ heap: heap }, function() {
		heap.findValue("foo");
	}), new HeapEmptyException("Trying to get a value from an empty heap."), "Test clearing heap 8");
	#endregion
	
	#region Test changing priorities (with one deletion)
	heap = new Heap("alpha", 7, "beta", 2, "gamma", 10, "delta", 5, "epsilon", 0);
	heap.changePriority("alpha", 4);
	heap.changePriority("beta", 7);
	heap.changePriority("gamma", 10);
	heap.changePriority("delta", 13);
	heap.changePriority("epsilon", 16);
	assert_throws(method({ heap: heap }, function() {
		heap.changePriority("omega", 20);
	}), new HeapValueNotFoundException("Cannot find omega in the heap."), "Test changing priorities A0");
	assert_equal(heap.deleteMin(), "alpha", "Test changing priorities A1");
	assert_equal(heap.deleteMin(), "beta", "Test changing priorities A2");
	assert_equal(heap.deleteMin(), "gamma", "Test changing priorities A3");
	assert_equal(heap.deleteMin(), "delta", "Test changing priorities A4");
	assert_equal(heap.deleteMin(), "epsilon", "Test changing priorities A5");
	heap = new Heap("alpha", 7, "beta", 2, "zeta", 4, "gamma", 10, "delta", 5, "epsilon", 0);
	heap.changePriority("alpha", 16);
	heap.changePriority("beta", 12);
	heap.changePriority("gamma", 8);
	heap.deleteValue("zeta");
	assert_throws(method({ heap: heap }, function() {
		heap.deleteValue("zeta");
	}), new HeapValueNotFoundException("Cannot find zeta in the heap."), "Test changing priorities B");
	heap.changePriority("delta", 4);
	heap.changePriority("epsilon", 0);
	assert_throws(method({ heap: heap }, function() {
		heap.changePriority("omega", 20);
	}), new HeapValueNotFoundException("Cannot find omega in the heap."), "Test changing priorities B0");
	assert_equal(heap.deleteMax(), "alpha", "Test changing priorities B1");
	assert_equal(heap.deleteMax(), "beta", "Test changing priorities B2");
	assert_equal(heap.deleteMax(), "gamma", "Test changing priorities B3");
	assert_equal(heap.deleteMax(), "delta", "Test changing priorities B4");
	assert_equal(heap.deleteMax(), "epsilon", "Test changing priorities B5");
	#endregion

	#region Test heap copy
	heap = new Heap("foo", 5, "bar", 7, "baz", 4, "qux", 6, "gone", 9);
	heap2 = new Heap("foobar", 583, "barbaz", 907);
	heap.deleteMax();
	heap2.copy(heap);
	assert_equal(heap2.size(), 4, "Test heap copy 1a");
	assert_equal(heap2.deleteMin(), "baz", "Test heap copy 1b");
	assert_equal(heap2.deleteMin(), "foo", "Test heap copy 1c");
	assert_equal(heap2.deleteMax(), "bar", "Test heap copy 1d");
	assert_equal(heap2.deleteMax(), "qux", "Test heap copy 1e");
	assert(heap2.empty(), "Test heap copy 1f");
	assert_equal(heap.size(), 4, "Test heap copy 2a");
	assert_equal(heap.deleteMin(), "baz", "Test heap copy 2b");
	assert_equal(heap.deleteMin(), "foo", "Test heap copy 2c");
	assert_equal(heap.deleteMax(), "bar", "Test heap copy 2d");
	assert_equal(heap.deleteMax(), "qux", "Test heap copy 2e");
	assert(heap.empty(), "Test heap copy 2f");
	#endregion
	
	#region Test heap clone
	heap = new Heap("foo", 5, "bar", 7, "baz", 4, "qux", 6);
	heap2 = heap.clone();
	assert_equal(heap2.size(), 4, "Test heap clone 1a");
	assert_equal(heap2.deleteMin(), "baz", "Test heap clone 1b");
	assert_equal(heap2.deleteMin(), "foo", "Test heap clone 1c");
	assert_equal(heap2.deleteMax(), "bar", "Test heap clone 1d");
	assert_equal(heap2.deleteMax(), "qux", "Test heap clone 1e");
	assert(heap2.empty(), "Test heap clone 1f");
	assert_equal(heap.size(), 4, "Test heap clone 2a");
	assert_equal(heap.deleteMin(), "baz", "Test heap clone 2b");
	assert_equal(heap.deleteMin(), "foo", "Test heap clone 2c");
	assert_equal(heap.deleteMax(), "bar", "Test heap clone 2d");
	assert_equal(heap.deleteMax(), "qux", "Test heap clone 2e");
	assert(heap.empty(), "Test heap clone 2f");
	#endregion

	#region Test heap reduction
	heap = new Heap();
	assert_equal(heap.reduceToData(), [[], []], "Test heap reduction 1");
	heap = new Heap("foo", 2);
	assert_equal(heap.reduceToData(), [[2], ["foo"]], "Test heap reduction 2");
	heap = new Heap("foo", 7, "bar", 5);
	assert_equal(heap.reduceToData(), [[5, 7], ["bar", "foo"]], "Test heap reduction 3");
	heap = new Heap([222, 333], 7, { foo: 444 }, 5, "666", 6);
	assert_equal(heap.reduceToData(), [[5, 7, 6], [{t: "struct", d: {foo: 444}}, [222, 333], "666"]], "Test heap reduction 4");
	#endregion
	
	#region Test heap expansion
	heap = new Heap("bad", 583);
	heap.expandFromData([[], []]);
	assert(heap.empty(), "Test heap expansion 1");
	heap = new Heap("bad", 583);
	heap.expandFromData([[2], ["foo"]]);
	assert_equal([heap.size(), heap.getMin(), heap.getMax()], [1, "foo", "foo"], "Test heap expansion 2");
	heap = new Heap("bad", 583);
	heap.expandFromData([[5, 7], ["bar", "foo"]]);
	assert_equal([heap.size(), heap.getMin(), heap.getMax()], [2, "bar", "foo"], "Test heap expansion 3");
	heap = new Heap("bad", 583);
	heap.expandFromData([[5, 7, 6], [{t: "struct", d: {foo: 444}}, [222, 333], "666"]]);
	assert_equal([heap.size(), heap.getMin(), heap.getMax()], [3, {foo: 444}, [222, 333]], "Test heap expansion 4");
	#endregion
	
	#region Test heap read/write
	heap = new Heap();
	heap2 = new Heap("foo", 123);
	got = heap.write();
	heap2.read(got);
	assert(heap2.empty(), "Test heap read/write 1");
	heap = new Heap("foo", 123, "bar", 234);
	heap2 = new Heap();
	got = heap.write();
	heap2.read(got);
	assert_equal([heap2.size(), heap2.getMin(), heap2.getMax()], [2, "foo", "bar"], "Test heap read/write 2");
	heap = new Heap("foo", 567);
	assert_throws(method({ heap: heap }, function() {
		heap.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("Heap", "struct"), "Test heap read/write 3");
	#endregion

	#region Stress test
	var stressTries = 200;
	var stressArrayN = 50;
	expectedStressArray = array_create(stressArrayN);
	var shuffledStressArray = array_create(stressArrayN);
	var gotStressArray = array_create(stressArrayN, 0);
	
	// Stress test A (deleteMin)
	for (var i = 0; i < stressArrayN; ++i) {
		expectedStressArray[@i] = i;
	}
	heap = new Heap();
	repeat (stressTries) {
		__lds_array_copy__(shuffledStressArray, 0, expectedStressArray, 0, stressArrayN);
		array_sort(shuffledStressArray, function() { return choose(-1, 1); });
		for (var i = 0; i < stressArrayN; ++i) {
			heap.add(shuffledStressArray[i], shuffledStressArray[i]/10);
		}
		for (var i = 0; i < stressArrayN; ++i) {
			gotStressArray[i] = heap.deleteMin();
		}
		assert_equal(gotStressArray, expectedStressArray, "Heap stress test A failed for: " + string(shuffledStressArray));
	}
	
	// Stress test B (deleteMax)
	expectedStressArray = array_create(stressArrayN);
	for (var i = 0; i < stressArrayN; ++i) {
		expectedStressArray[@i] = stressArrayN-i;
	}
	heap = new Heap();
	repeat (stressTries) {
		__lds_array_copy__(shuffledStressArray, 0, expectedStressArray, 0, stressArrayN);
		array_sort(shuffledStressArray, function() { return choose(-1, 1); });
		heap = new Heap();
		for (var i = 0; i < stressArrayN; ++i) {
			heap.add(shuffledStressArray[i], shuffledStressArray[i]/10);
		}
		for (var i = 0; i < stressArrayN; ++i) {
			gotStressArray[i] = heap.deleteMax();
		}
		assert_equal(gotStressArray, expectedStressArray, "Heap stress test B failed for: " + string(shuffledStressArray));
	}
	#endregion
}