function Stack() constructor {
	// Set up basic properties and starting entries
	_canonType = "Stack";
	_type = "Stack";
	_data = undefined;
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
	
	// Clear the stack and shallow-copy contents from another stack
	static copy = function(source) {
		_data = undefined;
		var currentSourceNode = source._data;
		if (source._length > 0) {
			var currentNewNode = [currentSourceNode[0], undefined];
			_data = currentNewNode;
			currentSourceNode = currentSourceNode[1];
			while (is_array(currentSourceNode)) {
				currentNewNode[@1] = [currentSourceNode[0], undefined];
				currentNewNode = currentNewNode[1];
				currentSourceNode = currentSourceNode[1];
			}
		}
		_length = source._length;
	};
	
	// Return a shallow clone of this stack
	static clone = function(source) {
		var theClone = new Stack();
		theClone.copy(self);
		return theClone;
	};
	
	// Return a reduction of this stack
	static reduceToData = function() {
		var dataArray = array_create(_length);
		var currentNode = _data;
		for (var i = 0; i < _length; ++i) {
			dataArray[i] = lds_reduce(currentNode[0]);
			currentNode = currentNode[1];
		}
		return dataArray;
	};
	
	// Expand the data to overwrite this stack
	static expandFromData = function(data) {
		clear();
		_length = array_length(data);
		if (_length > 0) {
			for (var i = _length-1; i >= 0; --i) {
				_data = [lds_expand(data[i]), _data];
			}
		}
		return self;
	};
	
	// Clear the stack and deep-copy contents from another stack
	static copyDeep = function(source) {
		_data = undefined;
		var currentSourceNode = source._data;
		if (source._length > 0) {
			var currentNewNode = [lds_clone_deep(currentSourceNode[0]), undefined];
			_data = currentNewNode;
			currentSourceNode = currentSourceNode[1];
			while (is_array(currentSourceNode)) {
				currentNewNode[@1] = [lds_clone_deep(currentSourceNode[0]), undefined];
				currentNewNode = currentNewNode[1];
				currentSourceNode = currentSourceNode[1];
			}
		}
		_length = source._length;
	};
	
	// Return a deep clone of this stack
	static cloneDeep = function() {
		var theClone = new Stack();
		theClone.copyDeep(self);
		return theClone;
	};
	
	// Load from data string
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	// Save into data string
	static write = function() {
		return lds_write(self);
	};
}

function StackEmptyException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}
