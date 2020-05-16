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
				var reducer = variable_struct_get(global.__lds_reducers__, thingType);
				if (is_method(reducer)) {
					thingData = reducer(thing);
				} else {
					throw new UnrecognizedLdsTypeException(thingType);
				}
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
					var expander = variable_struct_get(global.__lds_expanders__, data.t);
					if (is_method(expander)) {
						expanded = expander(data.d);
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
				var copier = variable_struct_get(global.__lds_copiers__, copyType);
				if (is_method(copier)) {
					copier(thing, source);
				} else {
					throw new UnrecognizedLdsTypeException(copyType);
				}
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
				var cloner = variable_struct_get(global.__lds_cloners__, cloneType);
				if (is_method(cloner)) {
					theClone = cloner(thing);
				} else {
					throw new UnrecognizedLdsTypeException(cloneType);
				}
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
