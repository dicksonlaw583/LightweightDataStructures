///@func lds_reduce(thing)
///@param thing
///@desc Reduce thing to terms of JSON-encodable GML elementary types
function lds_reduce(thing) {
	//var thing = argument0;
	var reduced, thingSize, thingData, thingType;
	thingType = typeof(thing);
	switch (thingType) {
		case "int64":
			reduced = { t: "int64", d: string(thing) };
			break;
		case "array":
			thingSize = array_length(thing);
			reduced = array_create(thingSize);
			for (var i = thingSize-1; i >= 0; --i) {
				reduced[i] = lds_reduce(thing[i]);
			}
			break;
		case "struct":
			thingType = instanceof(thing);
			if (thingType == "struct") {
				var keys = variable_struct_get_names(thing);
				thingData = {};
				for (var i = array_length(keys)-1; i >= 0; --i) {
					var key = keys[i];
					variable_struct_set(thingData, key, lds_reduce(variable_struct_get(thing, key)));
				}
			} else {
				thingData = thing.reduceToData();
			}
			reduced = { t: thingType, d: thingData };
			break;
		default:
			return thing;
	}
	return reduced;
}

///@func lds_expand(data)
///@param data
///@desc Restore the output of lds_reduce()
function lds_expand(data) {
	//var data = argument0;
	var expanded, expandedSize;
	switch (typeof(data)) {
		case "struct":
			switch (data.t) {
				case "int64": return int64(data.d);
				case "struct":
					expanded = {};
					var expandedKeys = variable_struct_get_names(data.d);
					for (var i = array_length(expandedKeys)-1; i >= 0; --i) {
						var key = expandedKeys[i];
						variable_struct_set(expanded, key, lds_expand(variable_struct_get(data.d, key)));
					}
					break;
				default:
					if (variable_struct_exists(global.__lds_registry__, data.t)) {
						expanded = variable_struct_get(global.__lds_registry__, data.t)();
						expanded.expandFromData(data.d);
					} else {
						throw new UnrecognizedLdsTypeException(data.t);
					}
					break;
			}
			break;
		case "array":
			expandedSize = array_length(data);
			expanded = array_create(expandedSize);
			for (var i = expandedSize-1; i >= 0; --i) {
				expanded[i] = lds_expand(data[i]);
			}
			break;
		default:
			return data;
	}
	return expanded;
}

///@func lds_copy(thing, source)
///@param thing
///@param source
///@desc Shallow copy to thing from source
function lds_copy(thing, source) {
	//var thing = argument0;
	//var source = argument1;
	var copyType = typeof(thing);
	if (copyType != typeof(source) || (copyType == "struct" && instanceof(thing) != instanceof(source))) throw new IncompatibleCopyException(thing, source);
	var copySize;
	switch (copyType) {
		case "array":
			copySize = array_length(source);
			array_resize(thing, copySize);
			array_copy(thing, 0, source, 0, copySize);
		break;
		case "struct":
			copyType = instanceof(source);
			if (copyType == "struct") {
				// Transfer their keys to mine
				var copyKeys = variable_struct_get_names(source);
				copySize = array_length(copyKeys);
				for (var i = copySize-1; i >= 0; --i) {
					var copyKey = copyKeys[i];
					variable_struct_set(thing, copyKey, variable_struct_get(source, copyKey));
				}
				// Set keys that are not theirs to undefined
				var myKeys = variable_struct_get_names(thing);
				var mySize = array_length(myKeys);
				for (var i = mySize-1; i >= 0; --i) {
					var myKey = myKeys[i];
					if (!variable_struct_exists(source, myKey)) {
						variable_struct_set(thing, myKey, undefined);
					}
				}
			} else {
				thing.copy(source);
			}
		break;
		default:
			return source;
	}
	return thing;
}

///@func lds_copy_deep(thing, source)
///@param thing
///@param source
///@desc Deep copy to thing from source
function lds_copy_deep(thing, source) {
	//var thing = argument0;
	//var source = argument1;
	var copyType = __lds_typeof__(thing);
	if (copyType != __lds_typeof__(source)) throw new IncompatibleCopyException(thing, source);
	var copySize, thingEntry, sourceEntry, sourceType;
	switch (typeof(thing)) {
		case "array":
			copySize = array_length(source);
			array_resize(thing, copySize);
			for (var i = copySize-1; i >= 0; --i) {
				thingEntry = thing[i];
				sourceEntry = source[i];
				sourceType = __lds_typeof__(sourceEntry);
				if (sourceType == __lds_typeof__(thingEntry) && (is_array(thingEntry) || is_struct(thingEntry))) {
					lds_copy_deep(thingEntry, sourceEntry);
				} else {
					array_set(thing, i, lds_clone_deep(sourceEntry));
				}
			}
		break;
		case "struct":
			if (copyType == "struct") {
				// Transfer their keys to mine
				var copyKeys = variable_struct_get_names(source);
				copySize = array_length(copyKeys);
				for (var i = copySize-1; i >= 0; --i) {
					var copyKey = copyKeys[i];
					thingEntry = variable_struct_get(thing, copyKey);
					sourceEntry = variable_struct_get(source, copyKey);
					sourceType = __lds_typeof__(sourceEntry);
					if (sourceType == __lds_typeof__(thingEntry) && (is_array(thingEntry) || is_struct(thingEntry))) {
						lds_copy_deep(thingEntry, sourceEntry);
					} else {
						variable_struct_set(thing, copyKey, lds_clone_deep(sourceEntry));
					}
				}
				// Set keys that are not theirs to undefined
				var myKeys = variable_struct_get_names(thing);
				var mySize = array_length(myKeys);
				for (var i = mySize-1; i >= 0; --i) {
					var myKey = myKeys[i];
					if (!variable_struct_exists(source, myKey)) {
						variable_struct_set(thing, myKey, undefined);
					}
				}
			} else {
				thing.copyDeep(source);
			}
		break;
		default:
			return source;
	}
	return thing;
}

///@func lds_clone(thing)
///@param thing
///@desc Return shallow clone of thing
function lds_clone(thing) {
	//var thing = argument0;
	var cloneType = typeof(thing);
	var theClone;
	switch (cloneType) {
		case "array":
			var cloneSize = array_length(thing);
			theClone = array_create(cloneSize);
			array_copy(theClone, 0, thing, 0, cloneSize);
		break;
		case "struct":
			cloneType = instanceof(thing);
			if (cloneType == "struct") {
				var cloneKeys = variable_struct_get_names(thing);
				theClone = {};
				for (var i = array_length(cloneKeys)-1; i >= 0; --i) {
					var cloneKey = cloneKeys[i];
					variable_struct_set(theClone, cloneKey, variable_struct_get(thing, cloneKey));
				}
			} else {
				theClone = thing.clone();
			}
		break;
		default:
			return thing;
	}
	return theClone;
}

///@func lds_clone_deep(thing) ???
///@param thing
///@desc Return deep clone of thing
function lds_clone_deep(thing) {
	//var thing = argument0;
	var cloneType = typeof(thing);
	var theClone;
	switch (cloneType) {
		case "array":
			var cloneSize = array_length(thing);
			theClone = array_create(cloneSize);
			for (var i = cloneSize-1; i >= 0; --i) {
				theClone[i] = lds_clone_deep(thing[i]);
			}
		break;
		case "struct":
			cloneType = instanceof(thing);
			if (cloneType == "struct") {
				var cloneKeys = variable_struct_get_names(thing);
				theClone = {};
				for (var i = array_length(cloneKeys)-1; i >= 0; --i) {
					var cloneKey = cloneKeys[i];
					variable_struct_set(theClone, cloneKey, lds_clone_deep(variable_struct_get(thing, cloneKey)));
				}
			} else {
				theClone = thing.cloneDeep();
			}
		break;
		default:
			return thing;
	}
	return theClone;
}

function UnrecognizedLdsTypeException(_type) constructor {
	type = _type;
	static toString = function() {
		return "Unrecognized LDS type \"" + type + "\".";
	};
}

function IncompatibleCopyException(_target, _source) constructor {
	target = _target;
	source = _source;
	static toString = function() {
		var typeOfTarget = typeof(target);
		if (typeOfTarget == "struct") typeOfTarget = instanceof(target);
		var typeOfSource = typeof(source);
		if (typeOfSource == "struct") typeOfSource = instanceof(source);
		return "Cannot copy to " + typeOfTarget + " from " + typeOfSource + ".";
	};
}

function IncompatibleDataException(_targetType, _sourceType) constructor {
	targetType = _targetType;
	sourceType = _sourceType;
	static toString = function() {
		return "Cannot read data intended for " + string(sourceType) + " into " + string(targetType) + ".";
	};
}
