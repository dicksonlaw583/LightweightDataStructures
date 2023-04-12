///@func lds_reduce(thing)
///@param {Any} thing The LDS or basic data type value to work with
///@return {Any}
///@desc Return a representation of the given value in terms of GML basic types (array, untyped struct, number, string, undefined).
function lds_reduce(thing) {
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
///@param {Any} data The reduced data.
///@return {Any}
///@desc Return the restored output of lds_reduce().
function lds_expand(data) {
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
						var regenFunction = variable_struct_get(global.__lds_registry__, data.t);
						expanded = regenFunction();
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

///@func lds_copy(target, source)
///@param {Any*} target The copy target
///@param {Any*} source The copy source
///@return {Any*}
///@desc Shallow-copy data from the source array, untyped struct or lightweight data structure to the target.
function lds_copy(target, source) {
	var copyType = typeof(target);
	if (copyType != typeof(source) || (copyType == "struct" && instanceof(target) != instanceof(source))) throw new IncompatibleCopyException(target, source);
	var copySize;
	switch (copyType) {
		case "array":
			copySize = array_length(source);
			array_resize(target, copySize);
			__lds_array_copy__(target, 0, source, 0, copySize);
		break;
		case "struct":
			copyType = instanceof(source);
			if (copyType == "struct") {
				// Transfer their keys to mine
				var copyKeys = variable_struct_get_names(source);
				copySize = array_length(copyKeys);
				for (var i = copySize-1; i >= 0; --i) {
					var copyKey = copyKeys[i];
					variable_struct_set(target, copyKey, variable_struct_get(source, copyKey));
				}
				// Set keys that are not theirs to undefined
				var myKeys = variable_struct_get_names(target);
				var mySize = array_length(myKeys);
				for (var i = mySize-1; i >= 0; --i) {
					var myKey = myKeys[i];
					if (!variable_struct_exists(source, myKey)) {
						variable_struct_set(target, myKey, undefined);
					}
				}
			} else {
				target.copy(source);
			}
		break;
		default:
			return source;
	}
	return target;
}

///@func lds_copy_deep(target, source)
///@param {Any*} target The copy target
///@param {Any*} source The copy source
///@return {Any*}
///@desc Deep-copy data from the source array, untyped struct or lightweight data structure to the target.
function lds_copy_deep(target, source) {
	var copyType = __lds_typeof__(target);
	if (copyType != __lds_typeof__(source)) throw new IncompatibleCopyException(target, source);
	var copySize, targetEntry, sourceEntry, sourceType;
	switch (typeof(target)) {
		case "array":
			copySize = array_length(source);
			array_resize(target, copySize);
			for (var i = copySize-1; i >= 0; --i) {
				targetEntry = target[i];
				sourceEntry = source[i];
				sourceType = __lds_typeof__(sourceEntry);
				if (sourceType == __lds_typeof__(targetEntry) && (is_array(targetEntry) || is_struct(targetEntry))) {
					lds_copy_deep(targetEntry, sourceEntry);
				} else {
					array_set(target, i, lds_clone_deep(sourceEntry));
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
					targetEntry = variable_struct_get(target, copyKey);
					sourceEntry = variable_struct_get(source, copyKey);
					sourceType = __lds_typeof__(sourceEntry);
					if (sourceType == __lds_typeof__(targetEntry) && (is_array(targetEntry) || is_struct(targetEntry))) {
						lds_copy_deep(targetEntry, sourceEntry);
					} else {
						variable_struct_set(target, copyKey, lds_clone_deep(sourceEntry));
					}
				}
				// Set keys that are not theirs to undefined
				var myKeys = variable_struct_get_names(target);
				var mySize = array_length(myKeys);
				for (var i = mySize-1; i >= 0; --i) {
					var myKey = myKeys[i];
					if (!variable_struct_exists(source, myKey)) {
						variable_struct_set(target, myKey, undefined);
					}
				}
			} else {
				target.copyDeep(source);
			}
		break;
		default:
			return source;
	}
	return target;
}

///@func lds_clone(thing)
///@param {Any*} thing The LDS or basic data type value to work with
///@return {Any*}
///@desc Return a shallow clone of the given array, untyped struct or lightweight data structure.
function lds_clone(thing) {
	var cloneType = typeof(thing);
	var theClone;
	switch (cloneType) {
		case "array":
			var cloneSize = array_length(thing);
			theClone = array_create(cloneSize);
			__lds_array_copy__(theClone, 0, thing, 0, cloneSize);
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

///@func lds_clone_deep(thing)
///@param {Any*} thing The LDS or basic data type value to work with
///@return {Any*}
///@desc Return a deep clone of the given array, untyped struct or lightweight data structure.
function lds_clone_deep(thing) {
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

///@func lds_write(thing)
///@param {Any} thing The LDS or basic data type value to work with
///@return {String}
///@desc Return a data string representing the contents of given value.
function lds_write(thing) {
	return json_stringify(lds_reduce(thing));
}

///@func lds_read(datastr)
///@param {String} datastr The data string to read
///@return {Any}
///@desc Return the restored result of the given data string.
function lds_read(datastr) {
	return lds_expand(json_parse(str));
}

///@func lds_save(thing, filename)
///@param {Any} thing The LDS or basic data type value to work with
///@param {String} filename The file name to save into
///@desc Save the data string representing the contents of the given value into a file.
function lds_save(thing, filename) {
	var f = file_text_open_write(filename);
	file_text_write_string(f, json_stringify(lds_reduce(thing)));
	file_text_close(f);
}

///@func lds_load(filename)
///@param {String} filename The file name to load from
///@return {Any}
///@desc Return the restored result of the data string in the given file.
function lds_load(filename) {
	var f = file_text_open_read(filename);
	var jsonstr = file_text_eof(f) ? "" : file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return lds_expand(json_parse(jsonstr));
}

///@func lds_encrypt(thing, enckey, encfunc)
///@param {Any} thing The LDS or basic data type value to work with
///@param {String} enckey The encryption key to use
///@param {Function} encfunc The encryption function to use taking plaintext and key
///@return {String}
///@desc Return an encrypted data string representing the contents of the given value.
function lds_encrypt(thing, enckey="myLdsSecretKey", encfunc=__lds_rc4_encrypt__) {
	var data = lds_reduce(thing);
	return is_method(encfunc) ? encfunc(json_stringify(data), enckey) : script_execute(encfunc, json_stringify(data), enckey);
}

///@func lds_decrypt(datastr, deckey, decfunc)
///@param {String} datastr The encrypted data string to decrypt
///@param {String} deckey The decryption key
///@param {Function} decfunc The decryption function use taking ciphertext and key
///@return {Any}
///@desc Return the restored result of the given data string.
function lds_decrypt(datastr, deckey="myLdsSecretKey", decfunc=__lds_rc4_decrypt__) {
	return lds_expand(json_parse(is_method(decfunc) ? decfunc(datastr, deckey) : script_execute(decfunc, datastr, deckey)));
}

///@func lds_save_encrypted(thing, filename, enckey, encfunc)
///@param {Any} thing The LDS or basic data type value to work with
///@param {String} filename The file name to save to
///@param {String} enckey The encryption key to use
///@param {Function} encfunc The encryption function to use taking plaintext and key
///@desc Save and encrypt the data string representing the contents of the given value into a file.
function lds_save_encrypted(thing, filename, enckey="myLdsSecretKey", encfunc=__lds_rc4_encrypt__) {
	var f = file_text_open_write(filename);
	file_text_write_string(f, lds_encrypt(thing, enckey, encfunc));
	file_text_close(f);
}

///@func lds_load_encrypted(filename, deckey, decfunc)
///@param {String} filename The file name to load from
///@param {String} deckey The decryption key
///@param {Function} decfunc The decryption function use taking ciphertext and key
///@return {Any}
///@desc Return the restored result of the encrypted data string in the given file.
function lds_load_encrypted(filename, deckey="myLdsSecretKey", decfunc=__lds_rc4_decrypt__) {
	var f = file_text_open_read(filename);
	var result = lds_decrypt(file_text_read_string(f), deckey, decfunc);
	file_text_close(f);
	return result;
}

///@class UnrecognizedLdsTypeException(type)
///@param type The encountered type.
///@desc Exception for when an LDS type spec is not recognized during loading.
function UnrecognizedLdsTypeException(type) constructor {
	self.type = type;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return "Unrecognized LDS type \"" + type + "\".";
	};
}

///@class IncompatibleCopyException(target, source)
///@param {Any} target The target being copied to.
///@param {Any} source The source being copied from.
///@desc Exception for when a copy operation is attempted between incompatible types (e.g. a map to a list).
function IncompatibleCopyException(target, source) constructor {
	self.target = target;
	self.source = source;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		var typeOfTarget = typeof(target);
		if (typeOfTarget == "struct") typeOfTarget = instanceof(target);
		var typeOfSource = typeof(source);
		if (typeOfSource == "struct") typeOfSource = instanceof(source);
		return "Cannot copy to " + typeOfTarget + " from " + typeOfSource + ".";
	};
}

///@class IncompatibleDataException(targetType, sourceType)
///@param {String} targetType The name of the target's type.
///@param {String} sourceType The name of the type stated by the source string.
///@desc Exception for when a read operation tries to load into an incompatible target (e.g. map data string into a list).
function IncompatibleDataException(targetType, sourceType) constructor {
	self.targetType = targetType;
	self.sourceType = sourceType;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return "Cannot read data intended for " + string(sourceType) + " into " + string(targetType) + ".";
	};
}
