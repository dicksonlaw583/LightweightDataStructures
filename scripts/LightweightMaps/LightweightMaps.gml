///@class Map(...)
///@param {Any} ... Pairs of keys and values to seed the map with.
///@desc Lightweight Map class equivalent to DS Maps.
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
	
	///@func clear()
	///@self Map
	///@desc Clear this map.
	static clear = function() {
		delete _data;
		delete _exists;
		_data = {};
		_exists = {};
		_size = 0;
		_keysCache = [];
		_keysCachePos = 0;
	};
	
	///@func size()
	///@self Map
	///@return {Real}
	///@desc Return the size of this map.
	static size = function() {
		return _size;
	};
	
	///@func empty()
	///@self Map
	///@return {Bool}
	///@desc Return whether this map is empty.
	static empty = function() {
		return _size == 0;
	};
	
	///@func get(k)
	///@self Map
	///@param {String} k The key value to use.
	///@return {Any}
	///@desc Return the value stored under the given key.
	static get = function(k) {
		var kn = string(k);
		if (!variable_struct_exists(_exists, kn)) {
			throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		}
		return variable_struct_get(_data, kn);
	};
	///@func findValue(k)
	///@self Map
	///@param {String} k The key value to use.
	///@return {Any}
	///@desc Return the value stored under the given key.
	static findValue = get;
	
	///@func setValue(k, v)
	///@self Map
	///@param {String} k The key value to use.
	///@param {Any} v The value to store.
	///@desc Store a value under the given key in this map.
	static set = function(k, v) {
		var kn = string(k);
		variable_struct_set(_data, kn, v);
		if (!variable_struct_exists(_exists, kn)) {
			variable_struct_set(_exists, kn, _keysCachePos);
			_keysCache[_keysCachePos++] = kn;
			++_size;
		}
	}
	///@func add(k, v)
	///@self Map
	///@param {String} k The key value to use.
	///@param {Any} v The value to store.
	///@desc Store a value under the given key in this map.
	static add = set;
	///@func replace(k, v)
	///@self Map
	///@param {String} k The key value to use.
	///@param {Any} v The value to store.
	///@desc Store a value under the given key in this map.
	static replace = set;
	
	///@func exists(k)
	///@self Map
	///@param {String} k The key value to use.
	///@return {Bool}
	///@desc Return whether the given key exists in this map.
	static exists = function(k) {
		var kn = string(k);
		return variable_struct_exists(_data, kn);
	};
	
	///@func remove(k)
	///@self Map
	///@param {String} k The key value to use.
	///@desc Remove the value under the given key in this map.
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
	
	///@func findFirst()
	///@self Map
	///@return {String,Undefined}
	///@desc Return the first key in this map. If not found, return undefined.
	static findFirst = function() {
		for (var i = 0; i < _keysCachePos; ++i) {
			///Feather disable GM1045
			if (!is_undefined(_keysCache[i])) return _keysCache[i];
			///Feather enable GM1045
		}
		return undefined;
	};
	
	///@func findLast()
	///@self Map
	///@return {String,Undefined}
	///@desc Return the last key in this map. If not found, return undefined.
	static findLast = function() {
		for (var i = _keysCachePos-1; i >= 0; --i) {
			///Feather disable GM1045
			if (!is_undefined(_keysCache[i])) return _keysCache[i];
			///Feather enable GM1045
		}
		return undefined;
	};
	
	///@func findNext(k)
	///@self Map
	///@param {String} k The key value to use.
	///@return {String,Undefined}
	///@desc Return the key after the given key in this map. If not found, return undefined.
	static findNext = function(k) {
		var __next = undefined;
		var i = _keysCachePos-1;
		for (; i >= 0; --i) {
			var kci = _keysCache[i];
			if (is_undefined(kci)) continue;
			if (k == kci) break;
			__next = kci;
		}
		if (i < 0) throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		///Feather disable GM1045
		return __next;
		///Feather enable GM1045
	};
	
	///@func findPrevious(k)
	///@self Map
	///@param {String} k The key value to use.
	///@return {String,Undefined}
	///@desc Return the key before the given key in this map. If not found, return undefined.
	static findPrevious = function(k) {
		var __prev = undefined;
		var i = 0;
		for (; i < _keysCachePos; ++i) {
			var kci = _keysCache[i];
			if (is_undefined(kci)) continue;
			if (k == kci) break;
			__prev = kci;
		}
		if (i >= _keysCachePos) throw new MapKeyMissingException("Map has no key " + string(k) + ".");
		///Feather disable GM1045
		return __prev;
		///Feather enable GM1045
	};
	
	///@func keys()
	///@self Map
	///@return {Array<String>}
	///@desc Return an array of keys used in this map.
	static keys = function() {
		var _keys = array_create(_size);
		var ii = 0;
		for (var i = 0; i < _keysCachePos; ++i) {
			var kci = _keysCache[i];
			if (!is_undefined(kci)) {
				_keys[ii++] = kci;
			}
		}
		///Feather disable GM1045
		return _keys;
		///Feather enable GM1045
	};

	///@func copy(source)
	///@self Map
	///@param {Struct.Map} source The map to copy from.
	///@desc Shallow copy from another map.
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
	
	///@func clone()
	///@self Map
	///@return {Struct.Map}
	///@desc Return a shallow clone of this map.
	static clone = function() {
		var theClone = new Map();
		theClone.copy(self);
		return theClone;
	}
	
	///@func reduceToData()
	///@self Map
	///@return {Any}
	///@desc Return a reduction this map to a representation in basic data types.
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
	
	///@func expandFromData(data)
	///@self Map
	///@param {Array<Any>} data
	///@return {Struct.Map}
	///@desc Expand the reduced data to overwrite this map. Return self for chaining.
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
	
	///@func copyDeep(source)
	///@self Map
	///@param {Struct.Map} source The map to copy from.
	///@desc Deep copy from another map.
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
	
	///@func cloneDeep()
	///@self Map
	///@return {Struct.Map}
	///@desc Return a deep clone of this map.
	static cloneDeep = function() {
		var theClone = new Map();
		theClone.copyDeep(self);
		return theClone;
	}
	
	///@func read(datastr)
	///@self Map
	///@param {String} datastr The data string to use.
	///@desc Load from the given data string into this map.
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	///@func write()
	///@self Map
	///@return {String}
	///@desc Save this map into data string and return it.
	static write = function() {
		return lds_write(self);
	};
	
	///@func forEach(func)
	///@self Map
	///@param {Function} func A predicate taking the value and the key as arguments.
	///@desc Perform a function for each entry in the map.
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
	
	
	///@func mapEach(func)
	///@self Map
	///@param {Function} func A predicate taking the value and the key as arguments.
	///@desc Replace each entry in the map with the return value of the function.
	///
	///Delete those that cause the function to throw undefined.
	static mapEach = function(func) {
		for (var i = 0; i < _keysCachePos; ++i) {
			var k = _keysCache[i];
			var kn = string(k);
			var v = variable_struct_get(_data, kn);
			try {
				var funcResult = undefined;
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
	
	///@func iterator()
	///@self Map
	///@return {Struct.MapIterator}
	///@desc Return an iterator for this map.
	static iterator = function() {
		return new MapIterator(self);
	};
}

///@class MapIterator(map)
///@param {Struct.Map} map The map to iterate over.
///@desc Utility for iterating through the given map.
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
	
	///@func hasNext()
	///@self MapIterator
	///@return {Bool}
	///@desc Return whether there are more entries to iterate.
	static hasNext = function() {
		return !is_undefined(key);
	};
	
	///@func next()
	///@self MapIterator
	///@desc Iterate to the next entry.
	static next = function() {
		var kc = _map._keysCache;
		var kcSize = _map._keysCachePos;
		key = undefined;
		while (is_undefined(key) && ++_keyPos < kcSize) {
			key = kc[_keyPos];
		}
		value = is_undefined(key) ? undefined : _map.get(key);
	};
	
	///@func set(val)
	///@self MapIterator
	///@param {Any} val 
	///@desc Set the value that the current iteration points to.
	static set = function(val) {
		_map.set(key, val);
		value = val;
	};
	
	///@func remove()
	///@self MapIterator
	///@desc Remove the value that the current iteration points to.
	static remove = function() {
		_map.remove(key);
	};
}

///@class MapKeyMissingException(msg)
///@param {String} msg The message to display.
///@desc Exception for when trying to access a missing key in a map.
function MapKeyMissingException(msg) constructor {
	self.msg = msg;
	
	///@func toString()
	///@self MapKeyMissingException
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return msg;
	};
}
