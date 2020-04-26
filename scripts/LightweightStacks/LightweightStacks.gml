function Stack() constructor {
	// Set up basic properties and starting entries
	_canonType = "Stack";
	_type = "Stack";
	_data = array_create(argument_count);
	_length = argument_count;
	for (var i = argument_count-1; i >= 0; --i) {
		_data = [argument[i], _data];
	}
	
	// Get the size of this stack
	static size = function() {
		return _length;
	};
	
	// Clear this stack
	static clear = function() {
		_length = 0;
		_data = undefined;
	};
	
	// Return whether empty
	static empty = function() {
		return _length == 0;
	};
	
	// Push one or more entries onto this stack
	static push = function() {
		for (var i = 0; i < argument_count; ++i) {
			_data = [argument[i], _data];
		}
		_length += argument_count;
	};
	
	// Pop from this stack
	static pop = function() {
		if (_length == 0) {
			throw new StackEmptyException("Trying to pop from an empty stack.");
		}
		var result = _data[0];
		_data = _data[1];
		--_length;
		return result;
	};
	
	// Peek at the stack's top
	static top = function() {
		if (_length == 0) {
			throw new StackEmptyException("Trying to peek at an empty stack.");
		}
		return _data[0];
	};
	static get = top;
	static peek = top;
}

function StackEmptyException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}
