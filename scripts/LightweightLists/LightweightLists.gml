function List() constructor {
	// Set up basic properties and starting entries
	_canonType = "List";
	_type = "List";
	_data = array_create(argument_count);
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}

	// Clear
	static clear = function() {
		delete _data;
		_data = [];
	};

	// Empty
	static empty = function() {
		return array_length(_data) == 0;
	};

	// Size
	static size = function() {
		return array_length(_data);
	};

	// Add
	static add = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_push(_data, argument[i]);
		}
	};

	// Get the normalized position
	static _normPos = function(pos) {
		var _length = array_length(_data);
		if (pos >= _length || pos < -_length) {
			throw new ListIndexOutOfBoundsException(pos);
		}
		return (pos >= 0) ? pos : (_length+pos);
	};

	// Set
	static set = function(pos, val) {
		var _length = array_length(_data);
		if (pos >= _length) {
			array_set(_data, pos, val);
			for (var i = _length; i < pos; ++i) {
				_data[i] = undefined;
			}
		} else {
			_data[@_normPos(pos)] = val;
		}
	};

	// Delete
	static remove = function(pos) {
		var _pos = _normPos(pos);
		var val = _data[_pos];
		array_delete(_data, _pos, 1);
		return val;
	};

	// Find index
	static findIndex = function(val) {
		var _length = array_length(_data);
		for (var i = 0; i < _length; ++i) {
			if (_data[i] == val) return i;
		}
		return -1;
	};

	// Find value
	static findValue = function(pos) {
		return _data[_normPos(pos)];
	};
	static get = findValue;

	// Insert
	static insert = function(pos, val) {
		if (pos == array_length(_data)) {
			array_push(_data, val);
		} else {
			array_insert(_data, _normPos(pos), val);
		}
	};

	// Replace
	static replace = function(pos, val) {
		_data[@_normPos(pos)] = val;
	};

	// To array
	static toArray = function() {
		var _length = array_length(_data);
		var arr = array_create(_length);
		__lds_array_copy__(arr, 0, _data, 0, _length);
		return arr;
	};

	// Shuffle
	static shuffle = function() {
		__lds_array_shuffle__(_data);
	};

	// Exists
	static exists = function(val) {
		for (var i = array_length(_data)-1; i >= 0; --i) {
			if (_data[i] == val) return true;
		}
		return false;
	};

	// Sort
	static sort = function() {
		var ascend = true,
			keyer = undefined,
			comparer = undefined;
		switch (argument_count) {
			case 3: comparer = argument[2];
			case 2: keyer = argument[1];
			case 1: ascend = bool(argument[0]);
			case 0: break;
			default: show_error("Expected 0-2 arguments, got " + string(argument_count) + ".", true);
		}
		__lds_array_sort__(_data, ascend, keyer, comparer);
	};
	
	// Shallow copy from another list
	static copy = function(source) {
		var _length = array_length(source._data);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, source._data, 0, _length);
	};
	
	// Shallow clone of this list
	static clone = function() {
		var theClone = new List();
		theClone.copy(self);
		return theClone;
	};
	
	// Reduce this list to a representation in basic data types
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
	
	// Deep copy from another list
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
	};
	
	// Deep clone of this list
	static cloneDeep = function() {
		var theClone = new List();
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
	
	// Perform a function for each entry in the list
	static forEach = function(func) {
		var _length = array_length(_data);
		for (var i = 0; i < _length; ++i) {
			if (is_method(func)) {
				func(_data[i], i);
			} else {
				script_execute(func, _data[i], i);
			}
		}
	};
	
	// Replace each entry in the list with the return value of the function
	// Delete those that cause the function to throw undefined
	static mapEach = function(func) {
		var _length = array_length(_data);
		for (var i = 0; i < _length; ++i) {
			try {
				var funcResult;
				if (is_method(func)) {
					funcResult = func(_data[i]);
				} else {
					funcResult = script_execute(func, _data[i]);
				}
				_data[@i] = funcResult;
			} catch (ex) {
				if (is_undefined(ex)) {
					array_delete(_data, i--, 1);
					--_length;
				} else {
					throw ex;
				}
			}
		}
	};
	
	// Return an iterator for this list
	static iterator = function() {
		return new ListIterator(self);
	};
}

function ListIterator(list) constructor {
	_list = list;
	index = 0;
	value = array_length(list._data) ? list._data[0] : undefined;
	_intact = true;
	
	static hasNext = function() {
		return index < array_length(_list._data);
	};
	
	static next = function() {
		if (_intact) {
			++index;
		}
		value = (index < array_length(_list._data)) ? _list._data[index] : undefined;
		_intact = true;
	};
	
	static set = function(val) {
		_list._data[@index] = val;
		value = val;
	};
	
	static remove = function() {
		array_delete(_list._data, index, 1);
		_intact = false;
	};
}

function ListIndexOutOfBoundsException(_index) constructor {
	index = _index;
	static toString = function() {
		return "List index " + string(index) + " is out of bounds.";
	}
}
