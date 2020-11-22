function Stack() constructor {
	// Set up basic properties and starting entries
	_canonType = "Stack";
	_type = "Stack";
	_data = array_create(argument_count);
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}
	
	// Get the size of this stack
	static size = function() {
		return array_length(_data);
	};
	
	// Clear this stack
	static clear = function() {
		delete _data;
		_data = [];
	};
	
	// Return whether empty
	static empty = function() {
		return array_length(_data) == 0;
	};
	
	// Push one or more entries onto this stack
	static push = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_insert(_data, 0, argument[i]);
		}
	};
	
	// Pop from this stack
	static pop = function() {
		if (array_length(_data) == 0) {
			throw new StackEmptyException("Trying to pop from an empty stack.");
		}
		var result = _data[0];
		array_delete(_data, 0, 1);
		return result;
	};
	
	// Peek at the stack's top
	static top = function() {
		if (array_length(_data) == 0) {
			throw new StackEmptyException("Trying to peek at an empty stack.");
		}
		return _data[0];
	};
	static get = top;
	static peek = top;
	
	// Clear the stack and shallow-copy contents from another stack
	static copy = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, sourceData, 0, _length);
	};
	
	// Return a shallow clone of this stack
	static clone = function(source) {
		var theClone = new Stack();
		theClone.copy(self);
		return theClone;
	};
	
	// Return a reduction of this stack
	static reduceToData = function() {
		var _length = array_length(_data);
		var dataArray = array_create(_length);
		for (var i = _length-1; i >= 0; --i) {
			dataArray[i] = lds_reduce(_data[i]);
		}
		return dataArray;
	};
	
	// Expand the data to overwrite this stack
	static expandFromData = function(data) {
		var _length = array_length(data);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
	
	// Clear the stack and deep-copy contents from another stack
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
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
