function Map() constructor {
	// Set up basic properties and starting entries
	_canonType = "Map";
	_type = "Map";
	_data = {};
	_exists = {};
	_size = argument_count div 2;
	_keysCache = array_create(argument_count >> 1);
	_keysCachePos = 0;
	for (var i = 0; i < argument_count; i += 2) {
		var kn = _toKeyName(argument[i]);
		variable_struct_set(_data, kn, argument[i+1]);
		variable_struct_set(_exists, kn, _keysCachePos);
		_keysCache[_keysCachePos++] = argument[i];
	}
	
	static _toKeyName = function(k) {
		return "_" + string_replace_all(string_replace_all(string_replace_all(base64_encode(k), "+", "_3"), "/", "_4"), "=", "_p");
	};
	
	//static _fromKeyName = function(kn) {
	//	return base64_decode(string_replace_all(string_replace_all(string_replace_all(string_delete(kn, 1, 1), "_3", "+"), "_4", "/"), "_p", "="));
	//};
	
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
		var kn = _toKeyName(k);
		if (is_undefined(variable_struct_get(_exists, kn))) {
			throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		}
		return variable_struct_get(_data, kn);
	};
	static findValue = get;
	
	static set = function(k, v) {
		var kn = _toKeyName(k);
		variable_struct_set(_data, kn, v);
		if (is_undefined(variable_struct_get(_exists, kn))) {
			variable_struct_set(_exists, kn, _keysCachePos);
			_keysCache[_keysCachePos++] = k;
			++_size;
		}
	}
	static add = set;
	static replace = set;
	
	static exists = function(k) {
		var kn = _toKeyName(k);
		return !is_undefined(variable_struct_get(_exists, kn));
	};
	
	static remove = function(k) {
		var kn = _toKeyName(k),
			knp = variable_struct_get(_exists, kn);
		if (is_undefined(knp)) {
			throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		}
		variable_struct_set(_data, kn, undefined);
		_keysCache[knp] = undefined;
		variable_struct_set(_exists, kn, undefined);
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
			if (!is_undefined(sourceKeyExists)) {
				variable_struct_set(_exists, sourceKey, sourceKeyExists);
				variable_struct_set(_data, sourceKey, variable_struct_get(source._data, sourceKey));
			}
		}
		// Copy keys cache
		_keysCache = array_create(source._keysCachePos);
		array_copy(_keysCache, 0, source._keysCache, 0, source._keysCachePos);
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
			valuesArray[i] = lds_reduce(variable_struct_get(_data, _toKeyName(key)));
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
		array_copy(_keysCache, 0, data[0], 0, _size);
		for (var i = _size-1; i >= 0; --i) {
			var keyName = _toKeyName(dataKeys[i])
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
			if (!is_undefined(sourceKeyExists)) {
				variable_struct_set(_exists, sourceKey, sourceKeyExists);
				variable_struct_set(_data, sourceKey, lds_clone_deep(variable_struct_get(source._data, sourceKey)));
			}
		}
		// Copy keys cache
		_keysCache = array_create(source._keysCachePos);
		array_copy(_keysCache, 0, source._keysCache, 0, source._keysCachePos);
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
		var data = jsons_decode(datastr);
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	// Save into data string
	static write = function() {
		return lds_write(self);
	};
}

function MapKeyMissingException(_msg) constructor {
	msg = _msg;
	static toString = function() {
		return msg;
	};
}
