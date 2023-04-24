///@func lds_test_queue()
///@desc Test Lightweight Data Structure queues.
function lds_test_queue() {
	var queue, queue2;
	
	// Test empty queue
	queue = new Queue();
	assert_equal(queue.size(), 0, "Test empty queue 1");
	assert(queue.empty(), "Test empty queue 2");
	assert_throws(method({ queue: queue }, function() {
		queue.dequeue();
	}), new QueueEmptyException("Trying to dequeue from an empty queue."), "Test empty queue 3");
	assert_throws(method({ queue: queue }, function() {
		queue.head();
	}), new QueueEmptyException("Trying to get the head of an empty queue."), "Test empty queue 4");
	assert_throws(method({ queue: queue }, function() {
		queue.tail();
	}), new QueueEmptyException("Trying to get the tail of an empty queue."), "Test empty queue 5");
	queue.clear();
	assert_equal(queue.size(), 0, "Test empty queue 6");
	assert(queue.empty(), "Test empty queue 7");
	assert_throws(method({ queue: queue }, function() {
		queue.dequeue();
	}), new QueueEmptyException("Trying to dequeue from an empty queue."), "Test empty queue 8");
	assert_throws(method({ queue: queue }, function() {
		queue.head();
	}), new QueueEmptyException("Trying to get the head of an empty queue."), "Test empty queue 9");
	assert_throws(method({ queue: queue }, function() {
		queue.tail();
	}), new QueueEmptyException("Trying to get the tail of an empty queue."), "Test empty queue 10");
	
	// Test empty queue enqueue
	queue.enqueue("foo");
	assert_equal([queue.size(), queue.head(), queue.tail()], [1, "foo", "foo"], "Test empty queue enqueue 1");
	assert_fail(queue.empty(), "Test empty queue enqueue 2");
	queue.enqueue("bar");
	assert_equal([queue.size(), queue.head(), queue.tail()], [2, "foo", "bar"], "Test empty queue enqueue 3");
	assert_fail(queue.empty(), "Test empty queue enqueue 4");
	queue.enqueue("baz");
	assert_equal([queue.size(), queue.head(), queue.tail()], [3, "foo", "baz"], "Test empty queue enqueue 5");
	assert_fail(queue.empty(), "Test empty queue enqueue 6");
	// Test filled queue dequeue
	assert_equal(queue.dequeue(), "foo", "Test filled queue dequeue 1");
	assert_equal([queue.size(), queue.head(), queue.tail()], [2, "bar", "baz"], "Test filled queue dequeue 2");
	assert_equal(queue.dequeue(), "bar", "Test filled queue dequeue 3");
	assert_equal([queue.size(), queue.head(), queue.tail()], [1, "baz", "baz"], "Test filled queue dequeue 4");
	assert_equal(queue.dequeue(), "baz", "Test filled queue dequeue 5");
	assert(queue.empty(), "Test filled queue dequeue 6");
	assert_throws(method({ queue: queue }, function() {
		queue.dequeue();
	}), new QueueEmptyException("Trying to dequeue from an empty queue."), "Test filled queue dequeue 7");
	assert_throws(method({ queue: queue }, function() {
		queue.head();
	}), new QueueEmptyException("Trying to get the head of an empty queue."), "Test filled queue dequeue 8");
	assert_throws(method({ queue: queue }, function() {
		queue.tail();
	}), new QueueEmptyException("Trying to get the tail of an empty queue."), "Test filled queue dequeue 9");
	
	// Test multi-enqueue from init
	queue = new Queue(111, 222, 333);
	assert_equal([queue.size(), queue.head(), queue.tail()], [3, 111, 333], "Test multi-enqueue from init 1");
	assert_equal(queue.dequeue(), 111, "Test multi-enqueue from init 2");
	assert_equal([queue.size(), queue.head(), queue.tail()], [2, 222, 333], "Test multi-enqueue from init 3");
	assert_equal(queue.dequeue(), 222, "Test multi-enqueue from init 4");
	assert_equal([queue.size(), queue.head(), queue.tail()], [1, 333, 333], "Test multi-enqueue from init 5");
	assert_equal(queue.dequeue(), 333, "Test multi-enqueue from init 6");
	assert(queue.empty(), "Test multi-enqueue from init 7");
	assert_throws(method({ queue: queue }, function() {
		queue.dequeue();
	}), new QueueEmptyException("Trying to dequeue from an empty queue."), "Test multi-enqueue from init 8");
	assert_throws(method({ queue: queue }, function() {
		queue.head();
	}), new QueueEmptyException("Trying to get the head of an empty queue."), "Test multi-enqueue from init 9");
	assert_throws(method({ queue: queue }, function() {
		queue.tail();
	}), new QueueEmptyException("Trying to get the tail of an empty queue."), "Test multi-enqueue from init 10");
	
	// Test queue copy
	queue = new Queue(11, 22, 33);
	queue2 = new Queue(44);
	queue2.copy(queue);
	assert_equal(queue2.size(), 3, "Test queue copy 1a");
	assert_equal([queue2.head(), queue2.tail()], [11, 33], "Test queue copy 1b");
	assert_equal(queue2.dequeue(), 11, "Test queue copy 1c");
	assert_equal(queue2.dequeue(), 22, "Test queue copy 1d");
	assert_equal(queue2.dequeue(), 33, "Test queue copy 1e");
	assert(queue2.empty(), "Test queue copy 1f");
	assert_equal(queue.size(), 3, "Test queue copy 2a");
	assert_equal([queue.head(), queue.tail()], [11, 33], "Test queue copy 2b");
	assert_equal(queue.dequeue(), 11, "Test queue copy 2c");
	assert_equal(queue.dequeue(), 22, "Test queue copy 2d");
	assert_equal(queue.dequeue(), 33, "Test queue copy 2e");
	assert(queue.empty(), "Test queue copy 2f");
	
	// Test queue clone
	queue = new Queue(111, 222, 333);
	queue2 = queue.clone();
	assert_equal(queue2.size(), 3, "Test queue clone 1a");
	assert_equal([queue2.head(), queue2.tail()], [111, 333], "Test queue clone 1b");
	assert_equal(queue2.dequeue(), 111, "Test queue clone 1c");
	assert_equal(queue2.dequeue(), 222, "Test queue clone 1d");
	assert_equal(queue2.dequeue(), 333, "Test queue clone 1e");
	assert(queue2.empty(), "Test queue clone 1f");
	assert_equal(queue.size(), 3, "Test queue clone 2a");
	assert_equal([queue.head(), queue.tail()], [111, 333], "Test queue clone 2b");
	assert_equal(queue.dequeue(), 111, "Test queue clone 2c");
	assert_equal(queue.dequeue(), 222, "Test queue clone 2d");
	assert_equal(queue.dequeue(), 333, "Test queue clone 2e");
	assert(queue.empty(), "Test queue clone 2f");
	
	// Test queue reduction
	queue = new Queue();
	assert_equal(queue.reduceToData(), [], "Test queue reduction 1");
	queue = new Queue(2);
	assert_equal(queue.reduceToData(), [2], "Test queue reduction 2");
	queue = new Queue("three", 3);
	assert_equal(queue.reduceToData(), ["three", 3], "Test queue reduction 3");
	queue = new Queue(111, [222, 333], { foo: 444 }, "555");
	assert_equal(queue.reduceToData(), [111, [222, 333], {t: "struct", d: {foo: 444}}, "555"], "Test queue reduction 4");
	
	// Test queue expansion
	//1
	queue = new Queue();
	queue.expandFromData([]);
	assert(queue.empty(), "Test queue expansion 1");
	//2
	queue = new Queue();
	queue.expandFromData([2]);
	assert_equal([queue.size(), queue.head()], [1, 2], "Test queue expansion 2");
	//3
	queue = new Queue();
	queue.expandFromData(["three", 3]);
	assert_equal([queue.size(), queue.head()], [2, "three"], "Test queue expansion 3a");
	assert_equal(queue.dequeue(), "three", "Test queue expansion 3b");
	assert_equal([queue.size(), queue.head()], [1, 3], "Test queue expansion 3c");
	assert_equal(queue.dequeue(), 3, "Test queue expansion 3d");
	assert(queue.empty(), "Test queue expansion 3e");
	//4
	queue = new Queue();
	queue.expandFromData([111, [222, 333], {t: "struct", d: {foo: 444}}, "555"]);
	assert_equal([queue.size(), queue.head()], [4, 111], "Test queue expansion 4a");
	assert_equal(queue.dequeue(), 111, "Test queue expansion 4b");
	assert_equal([queue.size(), queue.head()], [3, [222, 333]], "Test queue expansion 4c");
	assert_equal(queue.dequeue(), [222, 333], "Test queue expansion 4d");
	assert_equal([queue.size(), queue.head()], [2, {foo: 444}], "Test queue expansion 4e");
	assert_equal(queue.dequeue(), {foo: 444}, "Test queue expansion 4f");
	assert_equal([queue.size(), queue.head()], [1, "555"], "Test queue expansion 4g");
	assert_equal(queue.dequeue(), "555", "Test queue expansion 4h");
	assert(queue.empty(), "Test queue expansion 4g");
	
	// Test queue read/write
	queue = new Queue();
	queue2 = new Queue(1, 2, 3);
	got = queue.write();
	queue2.read(got);
	assert(queue2.empty(), "Test queue read/write 1");
	queue = new Queue("foo", "bar", "baz");
	queue2 = new Queue();
	got = queue.write();
	queue2.read(got);
	assert_equal([queue2.size(), queue2.head(), queue2.tail()], [3, "foo", "baz"], "Test queue read/write 2");
	queue = new Queue("foo");
	assert_throws(method({ queue: queue }, function() {
		queue.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("Queue", "struct"), "Test queue read/write 3");
}
