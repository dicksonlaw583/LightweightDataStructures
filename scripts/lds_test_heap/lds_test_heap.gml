///@func lds_test_heap()
function lds_test_heap() {
	var heap;
	
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
}