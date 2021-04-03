function Heap() constructor {
	// Clear the heap
	static clear = function() {
		delete _data;
		delete _priority;
		_data = [undefined];
		_priority = [undefined];
		_length = 0;
	};
	
	// Return whether the heap is empty
	static empty = function() {
		return _length == 0;
	};
	
	// Return the size of the heap
	static size = function() {
		return _length;
	};
	
	// Add entries to the heap
	static add = function() {
		for (var i = 0; i < argument_count; i += 2) {
			_data[++_length] = argument[i];
			_priority[_length] = argument[i+1];
			_pushUp(_length);
		}
	};
	
	// Change priority
	static changePriority = function(val, priority) {
		for (var i = _length; i >= 1; --i) {
			if (_data[i] == val) {
				break;
			}
		}
		if (i == 0) {
			throw new HeapValueNotFoundException("Cannot find " + string(val) + " in the heap.");
		}
		_priority[i] = priority;
		_pushUp(i);
		_pushDown(i);
	};
	
	// Delete max
	static deleteMax = function() {
		switch (_length) {
			case 0: throw new HeapEmptyException("Trying to remove max from an empty heap.");
			case 1:
				var result = _data[1];
				clear();
				break;
			case 2:
				var result = _data[_length];
				_data[_length--] = undefined;
				break;
			default:
				var deletePos = (_priority[2] > _priority[3]) ? 2 : 3,
					result = _data[deletePos];
				if (deletePos < _length) {
					_swap(deletePos, _length);
					_data[_length--] = undefined;
					_pushUp(deletePos);
					_pushDownMax(deletePos);
				} else {
					_data[_length--] = undefined;
				}
		}
		return result;
	};
	
	// Delete min
	static deleteMin = function() {
		switch (_length) {
			case 0: throw new HeapEmptyException("Trying to remove min from an empty heap.");
			case 1:
				var result = _data[1];
				clear();
				break;
			default:
				var result = _data[1];
				_swap(1, _length);
				_data[_length--] = undefined;
				_pushDownMin(1);
		}
		return result;
	};
	
	// Delete value
	static deleteValue = function(val) {
		if (_length == 0) {
			throw new HeapEmptyException("Trying to remove a value from an empty heap.");
		}
		for (var i = _length; i >= 1; --i) {
			if (_data[i] == val) {
				break;
			}
		}
		if (i == 0) {
			throw new HeapValueNotFoundException("Cannot find " + string(val) + " in the heap.");
		}
		var result = _data[i];
		if (i < _length) {
			_swap(i, _length);
			_data[_length--] = undefined;
			_pushUp(i);
			_pushDown(i);
		} else {
			data[_length--] = undefined;
		}
		if (_length == 0) clear();
		return result;
	};
	
	// Find max
	static findMax = function() {
		switch (_length) {
			case 0: throw new HeapEmptyException("Trying to get max from an empty heap.");
			case 1: case 2: return _data[_length];
			default:
				return (_priority[2] > _priority[3]) ? _data[2] : _data[3];
		}
	};
	static getMax = findMax;
	
	// Find min
	static findMin = function() {
		if (_length == 0) {
			throw new HeapEmptyException("Trying to get min from an empty heap.");
		}
		return _data[1];
	};
	static getMin = findMin;
	
	// Find value
	static findValue = function(val) {
		if (_length == 0) {
			throw new HeapEmptyException("Trying to get a value from an empty heap.");
		}
		for (var i = _length; i >= 1; --i) {
			if (_data[i] == val) {
				break;
			}
		}
		if (i == 0) {
			throw new HeapValueNotFoundException("Cannot find " + string(val) + " in the heap.");
		}
		return _priority[i];
	};
	
	// Shallow copy from another heap
	static copy = function(source) {
		_length = source._length;
		_data = array_create(1+_length, undefined);
		_priority = array_create(1+_length, undefined);
		if (_length > 0) {
			__lds_array_copy__(_data, 1, source._data, 1, _length);
			__lds_array_copy__(_priority, 1, source._priority, 1, _length);
		}
	};
	
	// Return a shallow clone of this heap
	static clone = function() {
		var theClone = new Heap();
		theClone.copy(self);
		return theClone;
	};
	
	// Reduce this heap to a representation in basic data types
	static reduceToData = function() {
		var priorityArray = array_create(_length);
		__lds_array_copy__(priorityArray, 0, _priority, 1, _length);
		var dataArray = array_create(_length);
		for (var i = _length; i >= 1; --i) {
			dataArray[i-1] = lds_reduce(_data[i]);
		}
		return [priorityArray, dataArray];
	};
	
	// Expand the data to overwrite this heap
	static expandFromData = function(data) {
		_length = array_length(data[0]);
		array_resize(_priority, 1+_length);
		__lds_array_copy__(_priority, 1, data[0], 0, _length);
		array_resize(_data, 1+_length);
		var dataData = data[1];
		for (var i = _length; i >= 1; --i) {
			_data[i] = lds_expand(dataData[i-1]);
		}
		return self;
	};
	
	// Deep copy from another heap
	static copyDeep = function(source) {
		_length = source._length;
		_data = array_create(1+_length, undefined);
		_priority = array_create(1+_length, undefined);
		if (_length > 0) {
			var sourceData = source._data;
			for (var i = _length; i >= 1; --i) {
				_data[i] = lds_clone_deep(sourceData[i]);
			}
			__lds_array_copy__(_priority, 1, source._priority, 1, _length);
		}
	};
	
	// Return a deep clone of this heap
	static cloneDeep = function() {
		var theClone = new Heap();
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
	
	
	// (INTERNAL) Set up the heap
	static _formHeap = function() {
		for (var i = _length >> 1; i >= 1; --i) {
			_pushDown(i);
		}
	};
	
	// (INTERNAL) Calculate level
	static _level = function(i) {
		var lvl = -1;
		do {
			i = i >> 1;
			++lvl;
		} until (i == 0);
		return lvl;
	};
	
	// (INTERNAL) Swap two positions
	static _swap = function(i, j) {
		var q = _data[i];
		_data[i] = _data[j];
		_data[j] = q;
		q = _priority[i];
		_priority[i] = _priority[j];
		_priority[j] = q;
	};
	
	// (INTERNAL) Push down
	static _pushDown = function(i) {
		if (_level(i) mod 2 == 0) {
			_pushDownMin(i);
		} else {
			_pushDownMax(i);
		}
	};
	
	// (INTERNAL) Push down min
	static _pushDownMin = function(_m) {
		var m = _m;
		// While m has children
		while (_length >= m << 1) {
			var i = m;
			// m is the smallest child or grandchild of i
			m = i << 1;
			if (_length >= m+1 && _priority[m+1] < _priority[m]) {
				++m;
			}
			var fgc = i << 2; // First grandchild
			for (var gc = min(_length, fgc+3); gc >= fgc; --gc) {
				if (_priority[gc] < _priority[m]) {
					m = gc;
				}
			}
			// If m is a grandchild of i
			if (m >= fgc) {
				if (_priority[m] < _priority[i]) {
					_swap(m, i);
					var parm = m >> 1;
					if (_priority[m] > _priority[parm]) {
						_swap(m, parm);
					}
				}
			} else if (_priority[m] < _priority[i]) {
				_swap(m, i);
			}
		}
	};
	
	// (INTERNAL) Push down max
	static _pushDownMax = function(_m) {
		var m = _m;
		// While m has children
		while (_length >= m << 1) {
			var i = m;
			// m is the biggest child or grandchild of i
			m = i << 1;
			if (_length >= m+1 && _priority[m+1] > _priority[m]) {
				++m;
			}
			var fgc = i << 2; // First grandchild
			for (var gc = min(_length, fgc+3); gc >= fgc; --gc) {
				if (_priority[gc] > _priority[m]) {
					m = gc;
				}
			}
			// If m is a grandchild of i
			if (m >= fgc) {
				if (_priority[m] > _priority[i]) {
					_swap(m, i);
					var parm = m >> 1;
					if (_priority[m] < _priority[parm]) {
						_swap(m, parm);
					}
				}
			} else if (_priority[m] > _priority[i]) {
				_swap(m, i);
			}
		}
	};
	
	// (INTERNAL) Push up
	static _pushUp = function(i) {
		// If i is not the root
		if (i > 1) {
			// Then it must have a parent
			var dad = i >> 1;
			// If i is on a min level
			if (_level(i) & 1 == 0) {
				if (_priority[i] > _priority[dad]) {
					_swap(i, dad);
					_pushUpMax(dad);
				} else {
					_pushUpMin(i);
				}
			}
			// If i is on max level
			else {
				if (_priority[i] < _priority[dad]) {
					_swap(i, dad);
					_pushUpMin(dad);
				} else {
					_pushUpMax(i);
				}
			}
		}
	};
	
	// (INTERNAL) Push up min
	static _pushUpMin = function(i) {
		// While i has a grandparent and i < grandparent
		var grandpa = i >> 2;
		while (grandpa != 0 && _priority[i] < _priority[grandpa]) {
			_swap(i, grandpa);
			i = grandpa;
		}
	};
	
	// (INTERNAL) Push up max
	static _pushUpMax = function(i) {
		// While i has a grandparent and i > grandparent
		var grandpa = i >> 2;
		while (grandpa != 0 && _priority[i] > _priority[grandpa]) {
			_swap(i, grandpa);
			i = grandpa;
		}
	};
	
	// Set up basic properties and starting entries
	_canonType = "Heap";
	_type = "Heap";
	_length = argument_count div 2;
	_data = array_create(_length+1);
	_priority = array_create(_length+1);
	for (var i = 0; i < argument_count; i += 2) {
		var ii = (i >> 1)+1;
		_data[ii] = argument[i];
		_priority[ii] = argument[i+1];
	}
	_formHeap();
}

function HeapValueNotFoundException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}

function HeapEmptyException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}