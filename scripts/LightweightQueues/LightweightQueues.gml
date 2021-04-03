function Queue() constructor {
	// Set up basic properties and starting entries
	_canonType = "Queue";
	_type = "Queue";
	_head = undefined;
	_tail = undefined;
	_length = 0;
	
	// Initialize from seed
	if (argument_count > 0) {
		_tail = [argument[0], undefined];
		_head = _tail;
		for (var _i = 1; _i < argument_count; ++_i) {
			var _newtail = [argument[_i], undefined];
			_tail[@1] = _newtail;
			_tail = _newtail;
		}
		_length = argument_count;
	}
	
	// Get the size
	static size = function() {
		return _length;
	};
	
	// Clear the queue
	static clear = function() {
		_head = undefined;
		_tail = undefined;
	};

	// Return whether empty
	static empty = function() {
		return _length == 0;
	};
	
	// Add onto the queue
	static enqueue = function() {
		var i = 0;
		// Set up starter head and tail if starting from scratch
		if (is_undefined(_tail)) {
			_tail = [argument[0], undefined];
			_head = _tail;
			++i;
		}
		// Enqueue each new entry in turn
		for (; i < argument_count; ++i) {
			var newtail = [argument[i], undefined];
			_tail[@1] = newtail;
			_tail = newtail;
		}
		_length += argument_count;
	};
	
	// Remove from the queue
	static dequeue = function() {
		if (_length == 0) {
			throw new QueueEmptyException("Trying to dequeue from an empty queue.");
		}
		// Dequeue head
		var result = _head[0];
		_head = _head[1];
		// Blank out tail if it is the last
		if (--_length == 0) {
			_tail = undefined;
		}
		return result;
	};
	
	// Get from the head of the queue
	static head = function() {
		if (_length == 0) {
			throw new QueueEmptyException("Trying to get the head of an empty queue.");
		}
		return _head[0];
	}
	static get = head;
	
	// Get from the tail of the queue
	static tail = function() {
		if (_length == 0) {
			throw new QueueEmptyException("Trying to get the tail of an empty queue.");
		}
		return _tail[0];
	}

	// Shallow-copy from another stack
	static copy = function(source) {
		_head = undefined;
		_tail = undefined;
		if (source._length > 0) {
			var currentSourceNode = source._head;
			var currentNewNode = [currentSourceNode[0], undefined];
			_head = currentNewNode;
			currentSourceNode = currentSourceNode[1];
			while (is_array(currentSourceNode)) {
				currentNewNode[@1] = [currentSourceNode[0], undefined];
				currentNewNode = currentNewNode[1];
				currentSourceNode = currentSourceNode[1];
			}
			_tail = currentNewNode;
		}
		_length = source._length;
	};
	
	// Return a shallow clone of this queue
	static clone = function(source) {
		var theClone = new Queue();
		theClone.copy(self);
		return theClone;
	};
	
	// Return a reduction of this queue
	static reduceToData = function() {
		var dataArray = array_create(_length);
		var currentNode = _head;
		for (var i = 0; i < _length; ++i) {
			dataArray[i] = lds_reduce(currentNode[0]);
			currentNode = currentNode[1];
		}
		return dataArray;
	};
	
	// Expand the data to overwrite this queue
	static expandFromData = function(data) {
		clear();
		_length = array_length(data);
		if (_length > 0) {
			var currentNewNode = [lds_expand(data[0]), undefined];
			_head = currentNewNode;
			for (var i = 1; i < _length; ++i) {
				currentNewNode[@1] = [lds_expand(data[i]), undefined];
				currentNewNode = currentNewNode[1];
			}
			_tail = currentNewNode;
		}
		return self;
	};
	
	// Deep-copy from another queue
	static copyDeep = function(source) {
		_head = undefined;
		_tail = undefined;
		if (source._length > 0) {
			var currentSourceNode = source._head;
			var currentNewNode = [lds_clone_deep(currentSourceNode[0]), undefined];
			_head = currentNewNode;
			currentSourceNode = currentSourceNode[1];
			while (is_array(currentSourceNode)) {
				currentNewNode[@1] = [lds_clone_deep(currentSourceNode[0]), undefined];
				currentNewNode = currentNewNode[1];
				currentSourceNode = currentSourceNode[1];
			}
			_tail = currentNewNode;
		}
		_length = source._length;
	};
	
	// Return a deep clone of this queue
	static cloneDeep = function(source) {
		var theClone = new Queue();
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

function QueueEmptyException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}
