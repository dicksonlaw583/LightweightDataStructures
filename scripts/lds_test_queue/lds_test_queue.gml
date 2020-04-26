///@func lds_test_queue()
function lds_test_queue() {
	var queue;
	
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
}
