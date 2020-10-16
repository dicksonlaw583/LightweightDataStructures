///@func lds_test_stack()
function lds_test_stack() {
	var stack, got;
	
	// Test empty stack
	stack = new Stack();
	assert_equal(stack.size(), 0, "Test empty stack 1");
	assert(stack.empty(), "Test empty stack 2");
	assert_throws(method({ stack: stack }, function() {
		stack.pop();
	}), new StackEmptyException("Trying to pop from an empty stack."), "Test empty stack 3");
	assert_throws(method({ stack: stack }, function() {
		stack.top();
	}), new StackEmptyException("Trying to peek at an empty stack."), "Test empty stack 4");
	stack.clear();
	assert_equal(stack.size(), 0, "Test empty stack 5");
	assert(stack.empty(), "Test empty stack 6");
	assert_throws(method({ stack: stack }, function() {
		stack.pop();
	}), new StackEmptyException("Trying to pop from an empty stack."), "Test empty stack 7");
	assert_throws(method({ stack: stack }, function() {
		stack.top();
	}), new StackEmptyException("Trying to peek at an empty stack."), "Test empty stack 8");
	
	// Test empty stack push
	stack.push("foo");
	assert_equal(stack.size(), 1, "Test empty stack push 1");
	assert_fail(stack.empty(), "Test empty stack push 2");
	assert_equal(stack.top(), "foo", "Test empty stack push 3");
	stack.push("bar");
	assert_equal(stack.size(), 2, "Test empty stack push 4");
	assert_fail(stack.empty(), "Test empty stack push 5");
	assert_equal(stack.top(), "bar", "Test empty stack push 6");
	stack.push("baz");
	assert_equal(stack.size(), 3, "Test empty stack push 7");
	assert_fail(stack.empty(), "Test empty stack push 8");
	assert_equal(stack.top(), "baz", "Test empty stack push 9");
	// Test pushed stack pop
	assert_equal(stack.pop(), "baz", "Test pushed stack pop 1");
	assert_equal(stack.size(), 2, "Test pushed stack pop 2");
	assert_equal(stack.top(), "bar", "Test pushed stack pop 3");
	assert_equal(stack.pop(), "bar", "Test pushed stack pop 4");
	assert_equal(stack.size(), 1, "Test pushed stack pop 5");
	assert_equal(stack.top(), "foo", "Test pushed stack pop 6");
	assert_equal(stack.pop(), "foo", "Test pushed stack pop 7");
	assert(stack.empty(), "Test pushed stack pop 8");
	assert_throws(method({ stack: stack }, function() {
		stack.pop()
	}), new StackEmptyException("Trying to pop from an empty stack."), "Test pushed stack pop 9");
	assert_throws(method({ stack: stack }, function() {
		stack.top()
	}), new StackEmptyException("Trying to peek at an empty stack."), "Test pushed stack pop 10");
	stack.clear();
	
	// Test multi-push from init
	stack = new Stack(111, 222, 333);
	assert_equal(stack.size(), 3, "Test multi-push from init 1");
	assert_equal(stack.top(), 111, "Test multi-push from init 2");
	assert_equal(stack.pop(), 111, "Test multi-push from init 3");
	assert_equal(stack.size(), 2, "Test multi-push from init 4");
	assert_equal(stack.top(), 222, "Test multi-push from init 5");
	assert_equal(stack.pop(), 222, "Test multi-push from init 6");
	assert_equal(stack.size(), 1, "Test multi-push from init 7");
	assert_equal(stack.top(), 333, "Test multi-push from init 8");
	assert_equal(stack.pop(), 333, "Test multi-push from init 9");
	assert(stack.empty(), "Test multi-push from init 10");
	assert_throws(method({ stack: stack }, function() {
		stack.pop()
	}), new StackEmptyException("Trying to pop from an empty stack."), "Test multi-push from init 11");
	assert_throws(method({ stack: stack }, function() {
		stack.top()
	}), new StackEmptyException("Trying to peek at an empty stack."), "TTest multi-push from init 12");
	
	// Test multi-push after init
	stack = new Stack(111);
	stack.push(222, 333);
	assert_equal(stack.size(), 3, "Test multi-push after init 1");
	assert_equal(stack.top(), 333, "Test multi-push after init 2");
	assert_equal(stack.pop(), 333, "Test multi-push after init 3");
	assert_equal(stack.size(), 2, "Test multi-push after init 4");
	assert_equal(stack.top(), 222, "Test multi-push after init 5");
	assert_equal(stack.pop(), 222, "Test multi-push after init 6");
	assert_equal(stack.size(), 1, "Test multi-push after init 7");
	assert_equal(stack.top(), 111, "Test multi-push after init 8");
	assert_equal(stack.pop(), 111, "Test multi-push after init 9");
	assert(stack.empty(), "Test multi-push after init 10");
	assert_throws(method({ stack: stack }, function() {
		stack.pop()
	}), new StackEmptyException("Trying to pop from an empty stack."), "Test multi-push after init 11");
	assert_throws(method({ stack: stack }, function() {
		stack.top()
	}), new StackEmptyException("Trying to peek at an empty stack."), "Test multi-push after init 12");
	
	// Test stack copy
	var stack2;
	stack = new Stack(11, 22, 33);
	stack2 = new Stack(44);
	stack2.copy(stack);
	assert_equal(stack2.size(), 3, "Test stack copy 1a");
	assert_equal(stack2.pop(), 11, "Test stack copy 1b");
	assert_equal(stack2.pop(), 22, "Test stack copy 1c");
	assert_equal(stack2.pop(), 33, "Test stack copy 1d");
	assert(stack2.empty(), "Test stack copy 1e");
	assert_equal(stack.size(), 3, "Test stack copy 2a");
	assert_equal(stack.pop(), 11, "Test stack copy 2b");
	assert_equal(stack.pop(), 22, "Test stack copy 2c");
	assert_equal(stack.pop(), 33, "Test stack copy 2d");
	assert(stack.empty(), "Test stack copy 2e");
	
	// Test stack clone
	stack = new Stack(111, 222, 333);
	stack2 = stack.clone();
	assert_equal(stack2.size(), 3, "Test stack clone 1a");
	assert_equal(stack2.pop(), 111, "Test stack clone 1b");
	assert_equal(stack2.pop(), 222, "Test stack clone 1c");
	assert_equal(stack2.pop(), 333, "Test stack clone 1d");
	assert(stack2.empty(), "Test stack clone 1e");
	assert_equal(stack.size(), 3, "Test stack clone 2a");
	assert_equal(stack.pop(), 111, "Test stack clone 2b");
	assert_equal(stack.pop(), 222, "Test stack clone 2c");
	assert_equal(stack.pop(), 333, "Test stack clone 2d");
	assert(stack.empty(), "Test stack clone 2e");
	
	// Test stack reduction
	stack = new Stack();
	assert_equal(stack.reduceToData(), [], "Test stack reduction 1");
	stack = new Stack(2);
	assert_equal(stack.reduceToData(), [2], "Test stack reduction 2");
	stack = new Stack("three", 3);
	assert_equal(stack.reduceToData(), ["three", 3], "Test stack reduction 3");
	stack = new Stack(111, [222, 333], { foo: 444 }, "555");
	assert_equal(stack.reduceToData(), [111, [222, 333], {t: "struct", d: {foo: 444}}, "555"], "Test stack reduction 4");
	
	// Test stack expansion
	//1
	stack = new Stack();
	stack.expandFromData([]);
	assert(stack.empty(), "Test stack expansion 1");
	//2
	stack = new Stack();
	stack.expandFromData([2]);
	assert_equal([stack.size(), stack.top()], [1, 2], "Test stack expansion 2");
	//3
	stack = new Stack();
	stack.expandFromData(["three", 3]);
	assert_equal([stack.size(), stack.top()], [2, "three"], "Test stack expansion 3a");
	assert_equal(stack.pop(), "three", "Test stack expansion 3b");
	assert_equal([stack.size(), stack.top()], [1, 3], "Test stack expansion 3c");
	assert_equal(stack.pop(), 3, "Test stack expansion 3d");
	assert(stack.empty(), "Test stack expansion 3e");
	//4
	stack = new Stack();
	stack.expandFromData([111, [222, 333], {t: "struct", d: {foo: 444}}, "555"]);
	assert_equal([stack.size(), stack.top()], [4, 111], "Test stack expansion 4a");
	assert_equal(stack.pop(), 111, "Test stack expansion 4b");
	assert_equal([stack.size(), stack.top()], [3, [222, 333]], "Test stack expansion 4c");
	assert_equal(stack.pop(), [222, 333], "Test stack expansion 4d");
	assert_equal([stack.size(), stack.top()], [2, {foo: 444}], "Test stack expansion 4e");
	assert_equal(stack.pop(), {foo: 444}, "Test stack expansion 4f");
	assert_equal([stack.size(), stack.top()], [1, "555"], "Test stack expansion 4g");
	assert_equal(stack.pop(), "555", "Test stack expansion 4h");
	assert(stack.empty(), "Test stack expansion 4g");
	
	// Test stack read/write
	stack = new Stack();
	stack2 = new Stack(1, 2, 3);
	got = stack.write();
	stack2.read(got);
	assert(stack2.empty(), "Test stack read/write 1");
	stack = new Stack("foo", "bar");
	stack2 = new Stack();
	got = stack.write();
	stack2.read(got);
	assert_equal([stack2.size(), stack2.top()], [2, "foo"], "Test stack read/write 2");
	stack = new Stack("foo");
	assert_throws(method({ stack: stack }, function() {
		stack.read(lds_write({ foo: "bar" }));
	}), new IncompatibleDataException("Stack", "struct"), "Test stack read/write 3");
}
