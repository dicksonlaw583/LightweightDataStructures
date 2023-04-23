///@class Queue(...)
///@param {any} ... (optional) Contents to start the queue with, from the head down.
///@desc Lightweight Queue class equivalent to DS Queues.
function Queue() constructor {
	// Set up basic properties and starting entries
	_canonType = "Queue";
	_type = "Queue";
	_data = array_create(argument_count);
	
	// Initialize from seed
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}
	
	///@func size()
	///@self Queue
	///@return {Real}
	///@desc Get the size
	static size = function() {
		return array_length(_data);
	};
	
	///@func clear()
	///@self Queue
	///@desc Clear the queue.
	static clear = function() {
		_data = [];
	};

	///@func empty()
	///@self Queue
	///@return {Bool}
	///@desc Return whether empty
	static empty = function() {
		return array_length(_data) == 0;
	};
	
	///@func enqueue(...)
	///@self Queue
	///@param {any*} ... Entries to add onto the queue
	///@desc Add onto the queue
	static enqueue = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_push(_data, argument[i]);
		}
	};
	
	///@func dequeue()
	///@self Queue
	///@return {Any*}
	///@desc Remove from the queue
	static dequeue = function() {
		if (array_length(_data) == 0) {
			throw new QueueEmptyException("Trying to dequeue from an empty queue.");
		}
		var result = _data[0];
		array_delete(_data, 0, 1);
		return result;
	};
	
	///@func head()
	///@self Queue
	///@return {Any*}
	///@desc Get from the head of the queue
	static head = function() {
		if (array_length(_data) == 0) {
			throw new QueueEmptyException("Trying to get the head of an empty queue.");
		}
		return _data[0];
	}
	///@func get()
	///@self Queue
	///@return {Any*}
	///@desc Alias of head()
	static get = head;
	
	///@func tail()
	///@self Queue
	///@return {Any*}
	///@desc Get from the tail of the queue
	static tail = function() {
		var _length = array_length(_data);
		if (_length == 0) {
			throw new QueueEmptyException("Trying to get the tail of an empty queue.");
		}
		return _data[_length-1];
	}

	///@func copy(source)
	///@self Queue
	///@param {Struct.Queue} source
	///@desc Shallow-copy from another queue
	static copy = function(source) {
		var _length = array_length(source._data);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, source._data, 0, _length);
	};
	
	///@func clone()
	///@self Queue
	///@return {Struct.Queue}
	///@desc Return a shallow clone of this queue
	static clone = function() {
		var theClone = new Queue();
		theClone.copy(self);
		return theClone;
	};
	
	///@func reduceToData()
	///@self Queue
	///@return {Any}
	///@desc Return a reduction of this queue
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
	///@self Queue
	///@param {Any} data
	///@return {Struct.Queue}
	///@desc Expand the data to overwrite this queue
	static expandFromData = function(data) {
		var _length = array_length(data);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
	
	///@func copyDeep(source)
	///@self Queue
	///@param {Struct.Queue} source
	///@desc Deep-copy from another queue
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
	};
	
	///@func cloneDeep()
	///@self Queue
	///@return {Struct.Queue}
	///@desc Return a deep clone of this queue
	static cloneDeep = function() {
		var theClone = new Queue();
		theClone.copyDeep(self);
		return theClone;
	};
	
	///@func read(datastr)
	///@self Queue
	///@param {String} datastr
	///@desc Load from data string
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	///@func write()
	///@self Queue
	///@return {String}
	///@desc Save into data string.
	static write = function() {
		return lds_write(self);
	};
}

///@class QueueEmptyException(msg)
///@param {String} msg The message to show.
///@desc Exception for trying to access entries from an empty queue.
function QueueEmptyException(msg) constructor {
	self.msg = msg;
	
	///@func toString()
	///@self QueueEmptyException
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return msg;
	};
}
