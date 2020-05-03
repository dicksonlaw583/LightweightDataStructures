function List() constructor {
	// Set up basic properties and starting entries
	_canonType = "List";
	_type = "List";
	_head = undefined;
	_tail = undefined;
	if (argument_count != 0) {
		_tail = [undefined, undefined, argument[argument_count-1]];
		_head = _tail;
	}
	for (var i = argument_count-2; i >= 0; --i) {
		var prevHead = _head;
		_head = [undefined, prevHead, argument[i]];
		prevHead[@0] = _head;
	}
	_length = argument_count;

	// Clear
	static clear = function() {
		delete _head;
		delete _tail;
		_head = undefined;
		_tail = undefined;
		_length = 0;
	};

	// Empty
	static empty = function() {
		return _length == 0;
	};

	// Size
	static size = function() {
		return _length;
	};

	// Add
	static add = function() {
		var i = 0;
		if (_length == 0) {
			_head = [undefined, undefined, argument[0]];
			_tail = _head;
			++i;
		}
		for (; i < argument_count; ++i) {
			var newTail = [_tail, undefined, argument[i]];
			_tail[@1] = newTail;
			_tail = newTail;
		}
		_length += argument_count;
	};

	// Get the node
	static _getNode = function(pos) {
		if (pos >= _length || pos < -_length) {
			throw new ListIndexOutOfBoundsException(pos);
		}
		var halfLength = _length >> 1,
			currentNode;
		if (pos >= 0) {
			if (pos < halfLength) {
				currentNode = _head;
				repeat (pos) {
					currentNode = currentNode[1];
				}
			} else {
				currentNode = _tail;
				repeat (_length-pos-1) {
					currentNode = currentNode[0];
				}
			}
		} else {
			if (pos < -halfLength) {
				currentNode = _head;
				repeat (_length+pos) {
					currentNode = currentNode[1];
				}
			} else {
				currentNode = _tail;
				repeat (-pos-1) {
					currentNode = currentNode[0];
				}
			}
		}
		return currentNode;
	};

	// Stretch the list
	static _stretch = function(newMaxIndex) {
		repeat (newMaxIndex-_length+1) {
			var newTail = [_tail, undefined, undefined];
			_tail[@1] = newTail;
			_tail = newTail;
		}
		_length = newMaxIndex+1;
	};

	// Set
	static set = function(pos, val) {
		if (pos >= _length) {
			_stretch(pos);
			_tail[@2] = val;
		} else {
			var node = _getNode(pos);
			node[@2] = val;
		}
	};

	// Delete
	static remove = function(pos) {
		var node = _getNode(pos);
		var prevNode = node[0],
			nextNode = node[1];
		if (!is_undefined(prevNode)) {
			prevNode[@1] = nextNode;
		}
		if (!is_undefined(nextNode)) {
			nextNode[@0] = prevNode;
		}
		if (node == _head) {
			_head = nextNode;
		}
		if (node == _tail) {
			_tail = prevNode;
		}
		--_length;
	};

	// Find index
	static findIndex = function(val) {
		var node = _head,
			i = 0;
		while (!is_undefined(node)) {
			if (node[2] == val) return i;
			node = node[1];
			++i;
		}
		return -1;
	};

	// Find value
	static findValue = function(pos) {
		var node = _getNode(pos);
		return node[2];
	};
	static get = findValue;

	// Insert
	static insert = function(pos, val) {
		if (pos > _length) {
			throw new ListIndexOutOfBoundsException(pos);
		} else if (pos == _length) {
			var newNode = [_tail, undefined, val];
			if (!is_undefined(_tail)) {
				_tail[@1] = newNode;
			}
			_tail = newNode;
			if (is_undefined(_head)) {
				_head = newNode;
			}
		} else {
			var node = _getNode(pos),
				prevNode = node[0],
				newNode = [prevNode, node, val];
			if (is_undefined(prevNode)) {
				_head = newNode;
			} else {
				prevNode[@1] = newNode;
			}
			node[@0] = newNode;
		}
		++_length;
	};

	// Replace
	static replace = function(pos, val) {
		var node = _getNode(pos);
		node[@2] = val;
	};

	// To array
	static toArray = function() {
		var arr = array_create(_length),
			currentNode = _head,
			i = 0;
		repeat (_length) {
			arr[i++] = currentNode[2];
			currentNode = currentNode[1];
		}
		return arr;
	};

	// Shuffle
	static shuffle = function() {
		var content = toArray();
		__lds_array_shuffle__(content);
		var i = 0,
			currentNode = _head;
		repeat (_length) {
			currentNode[@2] = content[i++];
			currentNode = currentNode[1];
		}
	};

	// Exists
	static exists = function(val) {
		var currentNode = _head;
		repeat (_length) {
			if (currentNode[2] == val) return true;
			currentNode = currentNode[1];
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
		var content = toArray();
		__lds_array_sort__(content, ascend, keyer, comparer);
		var i = 0,
			currentNode = _head;
		repeat (_length) {
			currentNode[@2] = content[i++];
			currentNode = currentNode[1];
		}
	};
	
}

function ListIndexOutOfBoundsException(_index) constructor {
	index = _index;
	static toString = function() {
		return "List index " + string(index) + " is out of bounds.";
	}
}
