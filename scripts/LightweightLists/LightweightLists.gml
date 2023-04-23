///@class List(...)
///@param {Any*} ... Values to seed the list with.
///@desc A Lightweight list class equivalent to a DS List.
function List() constructor {
	// Set up basic properties and starting entries
	_canonType = "List";
	_type = "List";
	_data = array_create(argument_count);
	for (var i = argument_count-1; i >= 0; --i) {
		_data[i] = argument[i];
	}

	///@func clear()
	///@self List
	///@desc Clear this list.
	static clear = function() {
		_data = [];
	};

	///@func empty()
	///@self List
	///@return {Bool}
	///@desc Return whether this list is empty.
	static empty = function() {
		return array_length(_data) == 0;
	};

	///@func size()
	///@self List
	///@return {Real}
	///@desc Return the size of this list.
	static size = function() {
		return array_length(_data);
	};

	///@func add(...)
	///@self List
	///@param {Any} ... Values to add.
	///@desc Append any number of entries to the back of the list.
	static add = function() {
		for (var i = 0; i < argument_count; ++i) {
			array_push(_data, argument[i]);
		}
	};

	///@func _normPos(pos)
	///@self List
	///@param {Real} pos
	///@return {Real}
	///@ignore
	///@desc (INTERNAL: Lightweight Data Structure List) Get the normalized value of the given list position.
	static _normPos = function(pos) {
		var _length = array_length(_data);
		if (pos >= _length || pos < -_length) {
			throw new ListIndexOutOfBoundsException(pos);
		}
		return (pos >= 0) ? pos : (_length+pos);
	};

	///@func set(pos, val)
	///@self List
	///@param {Real} pos The position to set.
	///@param {Any} val The new value to set.
	///@desc Set the value at the given position.
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

	///@func remove(pos)
	///@self List
	///@param {Real} pos The position to remove at.
	///@desc Remove the entry at the given position.
	static remove = function(pos) {
		var _pos = _normPos(pos);
		var val = _data[_pos];
		array_delete(_data, _pos, 1);
		return val;
	};

	///@func findIndex(val)
	///@self List
	///@param {Any} val The value to find.
	///@return {Real}
	///@desc Return the index at which the given value is found. If not found, return -1.
	static findIndex = function(val) {
		var _length = array_length(_data);
		for (var i = 0; i < _length; ++i) {
			if (_data[i] == val) return i;
		}
		return -1;
	};

	///@func findValue(pos)
	///@self List
	///@param {Real} pos The position to fetch.
	///@return {Any}
	///@desc Return the value at the given position.
	static findValue = function(pos) {
		return _data[_normPos(pos)];
	};
	///@func get(pos)
	///@self List
	///@param {Real} pos The position to fetch.
	///@return {Any}
	///@desc Return the value at the given position.
	static get = findValue;

	///@func insert(pos, val)
	///@self List
	///@param {Real} pos The position to insert at.
	///@param {Any} val The value to insert.
	///@desc Insert a value at the given position, pushing back other entries after it.
	static insert = function(pos, val) {
		if (pos == array_length(_data)) {
			array_push(_data, val);
		} else {
			array_insert(_data, _normPos(pos), val);
		}
	};

	///@func replace(pos, val)
	///@self List
	///@param {Real} pos The position to replace.
	///@param {Any} val The new replacement value.
	///@desc Replace the value at the given position.
	static replace = function(pos, val) {
		_data[@_normPos(pos)] = val;
	};

	///@func toArray()
	///@self List
	///@return {Array}
	///@desc Return the equivalent array of this list.
	static toArray = function() {
		var _length = array_length(_data);
		var arr = array_create(_length);
		__lds_array_copy__(arr, 0, _data, 0, _length);
		return arr;
	};

	///@func shuffle()
	///@self List
	///@desc Shuffle the entries in this list.
	static shuffle = function() {
		__lds_array_shuffle__(_data);
	};

	///@func exists(val)
	///@self List
	///@param {Any} val The value to look for.
	///@return {Bool}
	///@desc Return whether the given value is in the list.
	static exists = function(val) {
		for (var i = array_length(_data)-1; i >= 0; --i) {
			if (_data[i] == val) return true;
		}
		return false;
	};

	///@func sort(ascend, keyer, comparer)
	///@self List
	///@param {Bool} ascend Whether to sort upwards (true, default) or downwards (false).
	///@param {Function,Undefined} keyer (optional) A method returning a reference value to sort by.
	///@param {Function,Undefined} comparer (optional) A method for comparing a and b, returning true if a > b.
	///@desc Sort this list.
	static sort = function(ascend=true, keyer=undefined, comparer=undefined) {
		__lds_array_sort__(_data, ascend, keyer, comparer);
	};
	
	///@func copy(source)
	///@self List
	///@param {Struct.List} source The list to copy from.
	///@desc Shallow copy from another list.
	static copy = function(source) {
		var _length = array_length(source._data);
		array_resize(_data, _length);
		__lds_array_copy__(_data, 0, source._data, 0, _length);
	};
	
	///@func clone()
	///@self List
	///@return {Struct.List}
	///@desc Return a shallow clone of this list.
	static clone = function() {
		var theClone = new List();
		theClone.copy(self);
		return theClone;
	};
	
	///@func reduceToData()
	///@self List
	///@return {Any}
	///@desc Return a reduction of this list to a representation in basic data types.
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
	///@self List
	///@param {Any} data The reduced data to expand.
	///@return {Struct.List}
	///@desc Expand the reduced data to overwrite this list. Return self for chaining.
	static expandFromData = function(data) {
		var _length = array_length(data);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
	
	///@func copyDeep(source)
	///@self List
	///@param {Struct.List} source The list to copy from.
	///@desc Deep copy from another list.
	static copyDeep = function(source) {
		var sourceData = source._data;
		var _length = array_length(sourceData);
		array_resize(_data, _length);
		for (var i = _length-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
	};
	
	///@func cloneDeep()
	///@self List
	///@return {Struct.List}
	///@desc Return a deep clone of this list.
	static cloneDeep = function() {
		var theClone = new List();
		theClone.copyDeep(self);
		return theClone;
	};
	
	///@func read(datastr)
	///@self List
	///@param {String} datastr The data string to load from.
	///@desc Load from the given data string into this list.
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	///@func write()
	///@self List
	///@return {String}
	///@desc Save this list into a data string and return it.
	static write = function() {
		return lds_write(self);
	};
	
	///@func forEach(func)
	///@self List
	///@param {Function} func A predicate taking a list entry as an argument.
	///@desc Perform a function for each entry in the list.
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
	
	///@func mapEach(func)
	///@self List
	///@param {Function} func A predicate taking a list entry as an argument.
	///@desc Replace each entry in the list with the return value of the function.
	///
	///Delete those that cause the function to throw undefined.
	static mapEach = function(func) {
		var _length = array_length(_data);
		for (var i = 0; i < _length; ++i) {
			try {
				var funcResult = undefined;
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
	
	///@func iterator()
	///@self List
	///@return {Struct.ListIterator}
	///@desc Return an iterator for this list.
	static iterator = function() {
		return new ListIterator(self);
	};
}

///@class ListIterator(list)
///@param {Struct.List} list The list to iterate over.
///@desc Utility for iterating through the given list.
function ListIterator(list) constructor {
	_list = list;
	index = 0;
	value = array_length(list._data) ? list._data[0] : undefined;
	_intact = true;
	
	///@func hasNext()
	///@self ListIterator
	///@return {Bool}
	///@desc Return whether there are more entries to iterate.
	static hasNext = function() {
		return index < array_length(_list._data);
	};
	
	///@func next()
	///@self ListIterator
	///@desc Iterate to the next entry.
	static next = function() {
		if (_intact) {
			++index;
		}
		value = (index < array_length(_list._data)) ? _list._data[index] : undefined;
		_intact = true;
	};
	
	///@func set(val)
	///@self ListIterator
	///@param {Any} val 
	///@desc Set the value that the current iteration points to.
	static set = function(val) {
		_list._data[@index] = val;
		value = val;
	};
	
	///@func remove()
	///@self ListIterator
	///@desc Remove the value that the current iteration points to.
	static remove = function() {
		array_delete(_list._data, index, 1);
		_intact = false;
	};
}

///@class ListIndexOutOfBoundsException(index)
///@param {Real} index The invalid index position.
///@desc Exception for when trying to access a position that doesn't exist in the list.
function ListIndexOutOfBoundsException(index) constructor {
	self.index = index;
	
	///@func toString()
	///@self ListIndexOutOfBoundsException
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return "List index " + string(index) + " is out of bounds.";
	}
}
