#define __lds_array_copy__
{
	if (os_browser == browser_not_a_browser) {
		array_copy(argument0, argument1, argument2, argument3, argument4);
	} else {
		for (var i = argument4-1; i >= 0; --i) {
			argument0[@argument1+i] = argument2[argument3+i];
		}
	}
}

#define __lds_array_shuffle__
{
	var arr = argument0;
	for (var i = array_length(arr)-1; i > 0; --i) {
		var j = irandom(i);
		var temp = arr[i];
		arr[@i] = arr[j];
		arr[@j] = temp;
	}
}

#define __lds_array_sort__
{
	var keyer = function(v) { return v; };
	var comparer = function(a, b) { return a > b; };
	var ascend = true;
	switch (argument_count) {
		case 4: if (!is_undefined(argument[3])) comparer = argument[3];
		case 3: if (!is_undefined(argument[2])) keyer = argument[2];
		case 2: ascend = bool(argument[1]);
		case 1: break;
		default:
			show_error("Expected 1-4 arguments, got " + string(argument_count) + ".", true);
	}
	var arr = argument[0];
	__lds_array_sort_kernel__(arr, 0, array_length(arr), ascend, keyer, comparer);
}

#define __lds_array_sort_kernel__
{
	var arr = argument0,
		lo = argument1,
		hi = argument2,
		ascend = argument3,
		keyer = argument4,
		comparer = argument5;
	var span = hi-lo;
	switch (span) {
		case 1: case 0: break;
		case 2:
			if (ascend == (comparer(keyer(arr[lo]), keyer(arr[lo+1])))) {
				var temp = arr[lo];
				arr[@lo] = arr[lo+1];
				arr[@lo+1] = temp;
			}
			break;
		default:
			var halfSpan = span div 2;
			__lds_array_sort_kernel__(arr, lo, lo+halfSpan, ascend, keyer, comparer);
			__lds_array_sort_kernel__(arr, lo+halfSpan, hi, ascend, keyer, comparer);
			__lds_array_sort_merger__(arr, lo, lo+halfSpan, hi, ascend, keyer, comparer);
	}
}

#define __lds_array_sort_merger__
{
	var arr = argument0,
		lo = argument1,
		mid = argument2,
		hi = argument3,
		ascend = argument4,
		keyer = argument5,
		comparer = argument6;
	var i = 0,
		j = 0,
		iSize = mid-lo,
		jSize = hi-mid,
		ii = 0,
		span = hi-lo,
		_arr = array_create(span);
	repeat (span) {
		if (i >= iSize) {
			_arr[ii++] = arr[mid+j++];
		} else if (j >= jSize) {
			_arr[ii++] = arr[lo+i++];
		} else if (ascend == (comparer(keyer(arr[lo+i]), keyer(arr[mid+j])))) {
			_arr[ii++] = arr[mid+j++];
		} else {
			_arr[ii++] = arr[lo+i++];
		}
	}
	__lds_array_copy__(arr, lo, _arr, 0, span);
}

#define __lds_rc4__
{
	var i, j, s, temp, keyLength, pos;
	s = array_create(256);
	keyLength = string_byte_length(argument1);
	for (var i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for (var i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(argument1, i mod keyLength)) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
	}
	i = 0;
	j = 0;
	pos = 0;
	buffer_seek(argument0, buffer_seek_start, argument2);
	repeat (argument3) {
		i = (i+1) mod 256;
		j = (j+s[i]) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		var currentByte = buffer_peek(argument0, pos++, buffer_u8);
		buffer_write(argument0, buffer_u8, s[(s[i]+s[j]) mod 256] ^ currentByte);
	}
	return argument0;
}

#define __lds_rc4_decrypt__
///@func __lds_rc4_decrypt__(str, key)
///@param str
///@param key
{
	var buffer = buffer_base64_decode(argument0);
	__lds_rc4__(buffer, string(argument1), 0, buffer_get_size(buffer));
	buffer_seek(buffer, buffer_seek_start, 0);
	var decoded = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	return decoded;
}

#define __lds_rc4_encrypt__
///@func __lds_rc4_encrypt__(str, key)
///@param str
///@param key
{
	var length = string_byte_length(argument0);
	var buffer = buffer_create(length+1, buffer_fixed, 1);
	buffer_write(buffer, buffer_string, argument0);
	__lds_rc4__(buffer, string(argument1), 0, buffer_tell(buffer));
	var encoded = buffer_base64_encode(buffer, 0, length);
	buffer_delete(buffer);
	return encoded;
}

#define __lds_typeof__
{
	gml_pragma("forceinline");
	return is_struct(argument0) ? instanceof(argument0) : typeof(argument0);
}

#define lds_reduce
///@func lds_reduce(thing)
///@param thing
///@desc Reduce thing to terms of JSON-encodable GML elementary types
{
	var thing = argument0;
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

#define lds_expand
///@func lds_expand(data)
///@param data
///@desc Restore the output of lds_reduce()
{
	var data = argument0;
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

#define lds_copy
///@func lds_copy(thing, source)
///@param thing
///@param source
///@desc Shallow copy to thing from source
{
	var thing = argument0;
	var source = argument1;
	var copyType = typeof(thing);
	if (copyType != typeof(source) || (copyType == "struct" && instanceof(thing) != instanceof(source))) throw new IncompatibleCopyException(thing, source);
	var copySize;
	switch (copyType) {
		case "array":
			copySize = array_length(source);
			array_resize(thing, copySize);
			__lds_array_copy__(thing, 0, source, 0, copySize);
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

#define lds_copy_deep
///@func lds_copy_deep(thing, source)
///@param thing
///@param source
///@desc Deep copy to thing from source
{
	var thing = argument0;
	var source = argument1;
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

#define lds_clone
///@func lds_clone(thing)
///@param thing
///@desc Return shallow clone of thing
{
	var thing = argument0;
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

#define lds_clone_deep
///@func lds_clone_deep(thing)
///@param thing
///@desc Return deep clone of thing
{
	var thing = argument0;
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

#define lds_write
{
	var thing = argument0;
	return json_stringify(lds_reduce(thing));
}

#define lds_read
{
	var str = argument0;
	return lds_expand(json_parse(str));
}

#define lds_save
{
	var thing = argument0,
		filename = argument1;
	var f = file_text_open_write(filename);
	file_text_write_string(f, json_stringify(lds_reduce(thing)));
	file_text_close(f);
}

#define lds_load
{
	var filename = argument0;
	var f = file_text_open_read(filename);
	var jsonstr = file_text_eof(f) ? "" : file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return lds_expand(json_parse(jsonstr));
}

#define lds_encrypt
{
	var thing = lds_reduce(argument[0]),
		enckey = "myLdsSecretKey",
		encfunc = function(v, k) { return __lds_rc4_encrypt__(v, k); }; //__lds_rc4_encrypt__
	switch (argument_count) {
		case 3:
			encfunc = argument[2];
		case 2:
			enckey = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	return is_method(encfunc) ? encfunc(json_stringify(thing), enckey) : script_execute(encfunc, json_stringify(thing), enckey);
}

#define lds_decrypt
{
	var deckey = "myLdsSecretKey",
		decfunc = function(v, k) { return __lds_rc4_decrypt__(v, k); }; //__lds_rc4_decrypt__
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	return lds_expand(json_parse(is_method(decfunc) ? decfunc(argument[0], deckey) : script_execute(decfunc, argument[0], deckey)));
}

#define lds_save_encrypted
{
	var enckey = "myLdsSecretKey",
		encfunc = function(v, k) { return __lds_rc4_encrypt__(v, k); }; //__lds_rc4_encrypt__
	switch (argument_count) {
		case 4:
			encfunc = argument[3];
		case 3:
			enckey = argument[2];
		case 2: break;
		default:
			show_error("Expected 2-4 arguments, got " + string(argument_count) + ".", true);
	}
	var f = file_text_open_write(argument[1]);
	file_text_write_string(f, lds_encrypt(argument[0], enckey, encfunc));
	file_text_close(f);
}

#define lds_load_encrypted
{
	var deckey = "myLdsSecretKey",
		decfunc = function(v, k) { return __lds_rc4_decrypt__(v, k); }; //__lds_rc4_decrypt__
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	var f = file_text_open_read(argument[0]);
	var result = lds_decrypt(file_text_read_string(f), deckey, decfunc);
	file_text_close(f);
	return result;
}
