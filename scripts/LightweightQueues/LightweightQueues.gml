function Queue() constructor {
	// Set up basic properties and starting entries
	_canonType = "Queue";
	_type = "Queue";
	_data = array_create(argument_count);
	
	// Initialize from seed
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}
	
	// Get the size
	static size = function() {
		return array_length(_data);
	};
	
	// Clear the queue
	static clear = function() {
		delete _data;
		_data = [];
	};

	// Return whether empty
	static empty = function() {
		return array_length(_data) == 0;
	};
	
	// Add onto the queue
	static enqueue = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_push(_data, argument[i]);
		}
	};
	
	// Remove from the queue
	static dequeue = function() {
		if (array_length(_data) == 0) {
			throw new QueueEmptyException("Trying to dequeue from an empty queue.");
		}
		var result = _data[0];
		array_delete(_data, 0, 1);
		return result;
	};
	
	// Get from the head of the queue
	static head = function() {
		if (array_length(_data) == 0) {
			throw new QueueEmptyException("Trying to get the head of an empty queue.");
		}
		return _data[0];
	}
	static get = head;
	
	// Get from the tail of the queue
	static tail = function() {
		var _length = array_length(_data);
		if (_length == 0) {
			throw new QueueEmptyException("Trying to get the tail of an empty queue.");
		}
		return _data[_length-1];
	}

	// Shallow-copy from another queue
	static copy = function(source) {
		var _length = array_length(source._data);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, source._data, 0, _length);
	};
	
	// Return a shallow clone of this queue
	static clone = function(source) {
		var theClone = new Queue();
		theClone.copy(self);
		return theClone;
	};
	
	// Return a reduction of this queue
	static reduceToData = function() {
		var _length = array_length(_data);
		var dataArray = array_create(_length);
		for (var i = _length-1; i >= 0; --i) {
			dataArray[i] = lds_reduce(_data[i]);
		}
		return dataArray;
	};
	
	// Expand the data to overwrite this queue
	static expandFromData = function(data) {
		var _length = array_length(data);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
	
	// Deep-copy from another queue
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
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
