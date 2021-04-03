function Map() constructor {
	// Set up basic properties and starting entries
	_canonType = "Map";
	_type = "Map";
	_data = {};
	_exists = {};
	_size = argument_count div 2;
	_keysCache = array_create(_size);
	_keysCachePos = 0;
	for (var i = 0; i < argument_count; i += 2) {
		var kn = string(argument[i]);
		variable_struct_set(_data, kn, argument[i+1]);
		variable_struct_set(_exists, kn, _keysCachePos);
		_keysCache[_keysCachePos++] = argument[i];
	}
	
	static clear = function() {
		delete _data;
		delete _exists;
		_data = {};
		_exists = {};
		_size = 0;
		_keysCache = [];
		_keysCachePos = 0;
	};
	
	static size = function() {
		return _size;
	};
	
	static empty = function() {
		return _size == 0;
	};
	
	static get = function(k) {
		var kn = string(k);
		if (!variable_struct_exists(_exists, kn)) {
			throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		}
		return variable_struct_get(_data, kn);
	};
	static findValue = get;
	
	static set = function(k, v) {
		var kn = string(k);
		variable_struct_set(_data, kn, v);
		if (!variable_struct_exists(_exists, kn)) {
			variable_struct_set(_exists, kn, _keysCachePos);
			_keysCache[_keysCachePos++] = kn;
			++_size;
		}
	}
	static add = set;
	static replace = set;
	
	static exists = function(k) {
		var kn = string(k);
		return variable_struct_exists(_data, kn);
	};
	
	static remove = function(k) {
		var kn = string(k);
		if (!variable_struct_exists(_data, kn)) {
			throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		}
		var knp = variable_struct_get(_exists, kn);
		variable_struct_remove(_data, kn);
		_keysCache[knp] = undefined;
		variable_struct_remove(_exists, kn);
		if (--_size == 0) {
			clear();
		}
	};
	
	static findFirst = function() {
		for (var i = 0; i < _keysCachePos; ++i) {
			if (!is_undefined(_keysCache[i])) return _keysCache[i];
		}
		return undefined;
	};
	
	static findLast = function() {
		for (var i = _keysCachePos-1; i >= 0; --i) {
			if (!is_undefined(_keysCache[i])) return _keysCache[i];
		}
		return undefined;
	};
	
	static findNext = function(k) {
		var __next = undefined;
		for (var i = _keysCachePos-1; i >= 0; --i) {
			var kci = _keysCache[i];
			if (is_undefined(kci)) continue;
			if (k == kci) break;
			__next = kci;
		}
		if (i < 0) throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		return __next;
	};
	
	static findPrevious = function(k) {
		var __prev = undefined;
		for (var i = 0; i < _keysCachePos; ++i) {
			var kci = _keysCache[i];
			if (is_undefined(kci)) continue;
			if (k == kci) break;
			__prev = kci;
		}
		if (i >= _keysCachePos) throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		return __prev;
	};
	
	static keys = function() {
		var _keys = array_create(_size);
		var ii = 0;
		for (var i = 0; i < _keysCachePos; ++i) {
			var kci = _keysCache[i];
			if (!is_undefined(kci)) {
				_keys[ii++] = kci;
			}
		}
		return _keys;
	};

	// Shallow copy from another map
	static copy = function(source) {
		delete _data;
		delete _exists;
		_size = source._size;
		_data = {};
		_exists = {};
		// Copy struct keys that exist
		var sourceKeys = variable_struct_get_names(source._exists);
		for (var i = array_length(sourceKeys)-1; i >= 0; --i) {
			var sourceKey = sourceKeys[i],
				sourceKeyExists = variable_struct_get(source._exists, sourceKey);
			variable_struct_set(_exists, sourceKey, sourceKeyExists);
			variable_struct_set(_data, sourceKey, variable_struct_get(source._data, sourceKey));
		}
		// Copy keys cache
		_keysCache = array_create(source._keysCachePos);
		__lds_array_copy__(_keysCache, 0, source._keysCache, 0, source._keysCachePos);
		_keysCachePos = source._keysCachePos;
	};
	
	// Shallow clone of this map
	static clone = function() {
		var theClone = new Map();
		theClone.copy(self);
		return theClone;
	}
	
	// Reduce this map to a representation in basic data types
	static reduceToData = function() {
		var keysArray = array_create(_size);
		var valuesArray = array_create(_size);
		var i = 0;
		for (var ii = 0; ii < _keysCachePos; ++ii) {
			var key = _keysCache[ii];
			if (is_undefined(key)) continue;
			keysArray[i] = key;
			valuesArray[i] = lds_reduce(variable_struct_get(_data, string(key)));
			++i;
		}
		return [keysArray, valuesArray];
	};
	
	// Expand the data to overwrite this map
	static expandFromData = function(data) {
		clear();
		var dataKeys = data[0],
			dataData = data[1];
		_size = array_length(data[0]);
		_keysCachePos = _size;
		array_resize(_keysCache, _size);
		__lds_array_copy__(_keysCache, 0, data[0], 0, _size);
		for (var i = _size-1; i >= 0; --i) {
			var keyName = string(dataKeys[i])
			variable_struct_set(_data, keyName, lds_expand(dataData[i]));
			variable_struct_set(_exists, keyName, i);
		}
		return self;
	};
	
	// Deep copy from another map
	static copyDeep = function(source) {
		delete _data;
		delete _exists;
		_size = source._size;
		_data = {};
		_exists = {};
		// Copy struct keys that exist
		var sourceKeys = variable_struct_get_names(source._exists);
		for (var i = array_length(sourceKeys)-1; i >= 0; --i) {
			var sourceKey = sourceKeys[i],
				sourceKeyExists = variable_struct_get(source._exists, sourceKey);
			variable_struct_set(_exists, sourceKey, sourceKeyExists);
			variable_struct_set(_data, sourceKey, lds_clone_deep(variable_struct_get(source._data, sourceKey)));
		}
		// Copy keys cache
		_keysCache = array_create(source._keysCachePos);
		__lds_array_copy__(_keysCache, 0, source._keysCache, 0, source._keysCachePos);
		_keysCachePos = source._keysCachePos;
	};
	
	// Deep clone of this map
	static cloneDeep = function() {
		var theClone = new Map();
		theClone.copyDeep(self);
		return theClone;
	}
	
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
	
	// Perform a function for each entry in the map
	static forEach = function(func) {
		for (var i = 0; i < _keysCachePos; ++i) {
			var k = _keysCache[i];
			var kn = string(k);
			var v = variable_struct_get(_data, kn);
			if (is_method(func)) {
				func(v, k);
			} else {
				script_execute(func, v, k);
			}
		}
	};
	
	// Replace each entry in the map with the return value of the function
	// Delete those that cause the function to throw undefined
	static mapEach = function(func) {
		for (var i = 0; i < _keysCachePos; ++i) {
			var k = _keysCache[i];
			var kn = string(k);
			var v = variable_struct_get(_data, kn);
			try {
				var funcResult;
				if (is_method(func)) {
					funcResult = func(v);
				} else {
					funcResult = script_execute(func, v);
				}
				variable_struct_set(_data, kn, funcResult);
			} catch (ex) {
				if (is_undefined(ex)) {
					variable_struct_set(_data, kn, undefined);
					variable_struct_set(_exists, kn, undefined);
					_keysCache[i] = undefined;
					--_size;
				} else {
					throw ex;
				}
			}
		}
	};
	
	// Return an iterator for this map
	static iterator = function() {
		return new MapIterator(self);
	};
}

function MapIterator(map) constructor {
	_map = map;
	_keyPos = 0;
	key = undefined;
	value = undefined;
	var kcSize = _map._keysCachePos;
	var kc = _map._keysCache;
	for (; _keyPos < kcSize; ++_keyPos) {
		if (!is_undefined(kc[_keyPos])) {
			key = kc[_keyPos];
			value = _map.get(key);
			break;
		}
	}
	
	static hasNext = function() {
		return !is_undefined(key);
	};
	
	static next = function() {
		var kc = _map._keysCache;
		var kcSize = _map._keysCachePos;
		key = undefined;
		while (is_undefined(key) && ++_keyPos < kcSize) {
			key = kc[_keyPos];
		}
		value = is_undefined(key) ? undefined : _map.get(key);
	};
	
	static set = function(val) {
		_map.set(key, val);
		value = val;
	};
	
	static remove = function() {
		_map.remove(key);
	};
}

function MapKeyMissingException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}
