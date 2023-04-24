///@class Stack(...)
///@param {any} ... (optional) Contents to start the stack with, from the top down.
///@desc Lightweight Stack class equivalent to DS Stacks.
function Stack() constructor {
	// Set up basic properties and starting entries
	_canonType = "Stack";
	_type = "Stack";
	_data = array_create(argument_count);
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}
	
	///@func size()
	///@self Stack
	///@return {Real}
	///@desc Get the size of this stack.
	static size = function() {
		return array_length(_data);
	};
	
	///@func clear()
	///@self Stack
	///@desc Clear this stack.
	static clear = function() {
		_data = [];
	};
	
	///@func empty()
	///@return {Bool}
	///@desc Return whether this stack is empty.
	static empty = function() {
		return array_length(_data) == 0;
	};
	
	///@func push(...)
	///@self Stack
	///@param {Any} ... 
	///@desc Push one or more entries onto this stack.
	static push = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_insert(_data, 0, argument[i]);
		}
	};
	
	///@func pop()
	///@self Stack
	///@return {Any}
	///@desc Pop from this stack and return the result.
	static pop = function() {
		if (array_length(_data) == 0) {
			throw new StackEmptyException("Trying to pop from an empty stack.");
		}
		var result = _data[0];
		array_delete(_data, 0, 1);
		return result;
	};
	
	///@func top()
	///@self Stack
	///@return {Any}
	///@desc Peek at the stack's top and return the result.
	static top = function() {
		if (array_length(_data) == 0) {
			throw new StackEmptyException("Trying to peek at an empty stack.");
		}
		return _data[0];
	};
	///@func get()
	///@self Stack
	///@return {Any}
	///@desc Peek at the stack's top and return the result.
	static get = top;
	///@func peek()
	///@self Stack
	///@return {Any}
	///@desc Peek at the stack's top and return the result.
	static peek = top;
	
	///@func copy(source)
	///@self Stack
	///@param {Struct.Stack} source 
	///@desc Clear the stack and shallow-copy contents from another stack.
	static copy = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, sourceData, 0, _length);
	};
	
	///@func clone()
	///@self Stack
	///@return {Struct.Stack}
	///@desc Return a shallow clone of this stack
	static clone = function() {
		var theClone = new Stack();
		theClone.copy(self);
		return theClone;
	};
	
	///@func reduceToData()
	///@self Stack
	///@return {Any}
	///@desc Return a data reduction of this stack's contents as an array.
	static reduceToData = function() {
		var _length = array_length(_data);
		var dataArray = array_create(_length);
		for (var i = _length-1; i >= 0; --i) {
			dataArray[i] = lds_reduce(_data[i]);
		}
		///Feather disable GM1045
		return dataArray;
		///Feather enable GM1045
	};
	
	///@func expandFromData(data)
	///@self Stack
	///@param {Any} data 
	///@return {Struct.Stack}
	///@desc Expand the reduced data to overwrite this stack, then return self for chaining.
	static expandFromData = function(data) {
		var _length = array_length(data);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
	
	///@func copyDeep(source)
	///@self Stack
	///@param {Struct.Stack} source 
	///@desc Clear the stack and deep-copy contents from another stack.
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
	};
	
	///@func cloneDeep()
	///@self Stack
	///@return {Struct.Stack}
	///@desc Return a deep clone of this stack.
	static cloneDeep = function() {
		var theClone = new Stack();
		theClone.copyDeep(self);
		return theClone;
	};
	
	///@func read(datastr)
	///@self Stack
	///@param {String} datastr The data string to read from.
	///@desc Load from data string.
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	///@func write()
	///@self Stack
	///@return {String}
	///@desc Save into data string and return it.
	static write = function() {
		return lds_write(self);
	};
}

///@class StackEmptyException(msg)
///@param {String} msg The message to show.
///@desc Exception for trying to access entries from an empty stack.
function StackEmptyException(msg) constructor {
	self.msg = msg;
	
	///@func toString()
	///@self StackEmptyException
	///@return {String}
	///@desc Return the message carried by this exception.
	static toString = function() {
		return msg;
	};
}
