///@func __lds_array_copy__(destArray, destIndex, sourceArray, sourceIndex, length)
///@param {Array} destArray The destination array to copy to
///@param {Real} destIndex The position in the destination array to start
///@param {Array} sourceArray The source array to copy from
///@param {Real} sourceIndex The position in the source arrray to start
///@param {Real} length The length to copy
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) HTML5 shim for array_copy.
function __lds_array_copy__(destArray, destIndex, sourceArray, sourceIndex, length) {
	if (os_browser == browser_not_a_browser) {
		array_copy(destArray, destIndex, sourceArray, sourceIndex, length);
	} else {
		for (var i = length-1; i >= 0; --i) {
			destArray[@destIndex+i] = sourceArray[sourceIndex+i];
		}
	}
}

///@func __lds_array_shuffle__(arr)
///@param {Array} arr The array to shuffle
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Shim for shuffling an array.
function __lds_array_shuffle__(arr) {
	for (var i = array_length(arr)-1; i > 0; --i) {
		var j = irandom(i);
		var temp = arr[i];
		arr[@i] = arr[j];
		arr[@j] = temp;
	}
}

///@func __lds_array_sort__(arr, ascend, keyer, comparer)
///@param {Array} arr The array to sort
///@param {Bool} ascend Whether to sort in ascending (true) or descending (false) order
///@param {Function} keyer A function that extracts a key value from incoming values
///@param {Function} comparer A function that takes arguments a and b, and returns whether a > b
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Shim for sorting an array.
function __lds_array_sort__(arr, ascend=true, keyer=function(v) { return v; }, comparer=function(a, b) { return a > b; }) {
	__lds_array_sort_kernel__(arr, 0, array_length(arr), ascend, keyer, comparer);
}

///@func __lds_array_sort_kernel__(arr, lo, hi, ascend, keyer, comparer)
///@param {Array} arr The array to sort
///@param {Real} lo The lower bound
///@param {Real} hi The upper bound
///@param {Bool} ascend Whether to sort in ascending (true) or descending (false) order
///@param {Function} keyer A function that extracts a key value from incoming values
///@param {Function} comparer A function that takes arguments a and b, and returns whether a > b
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) The recursive kernel of the array merge sort.
function __lds_array_sort_kernel__(arr, lo, hi, ascend, keyer, comparer) {
	var span = hi-lo;
	switch (span) {
		case 1: case 0: break;
		case 2:
			var k1 = keyer(arr[lo]);
			var k2 = keyer(arr[lo+1])
			if (ascend == comparer(k1, k2)) {
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

///@func __lds_array_sort_merger__(arr, lo, mid, hi, ascend, keyer, comparer)
///@param {Array} arr The array to sort
///@param {Real} lo The lower bound
///@param {Real} mid The midpoint
///@param {Real} hi The upper bound
///@param {Bool} ascend Whether to sort in ascending (true) or descending (false) order
///@param {Function} keyer A function that extracts a key value from incoming values
///@param {Function} comparer A function that takes arguments a and b, and returns whether a > b
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) The merging kernel of the array merge sort.
function __lds_array_sort_merger__(arr, lo, mid, hi, ascend, keyer, comparer) {
	var i = 0,
		j = 0,
		iSize = mid-lo,
		jSize = hi-mid,
		ii = 0,
		span = hi-lo,
		_arr = array_create(span);
	///Feather disable GM2023
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
	///Feather enable GM2023
	__lds_array_copy__(arr, lo, _arr, 0, span);
}

///@func __lds_rc4__(buffer, key, offset, length)
///@param {Id.Buffer} buffer The buffer to work with
///@param {String} key The key to use
///@param {Real} offset The offset from the start
///@param {Real} length The number of bytes to run for
///@return {Id.Buffer}
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Apply RC4 to a buffer in-place and return it.
function __lds_rc4__(buffer, key, offset, length) {
	var i, j, s, temp, keyLength, pos;
	s = array_create(256);
	keyLength = string_byte_length(key);
	for (i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for (i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(key, i mod keyLength)) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
	}
	i = 0;
	j = 0;
	pos = 0;
	buffer_seek(buffer, buffer_seek_start, offset);
	repeat (length) {
		i = (i+1) mod 256;
		j = (j+s[i]) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		var currentByte = buffer_peek(buffer, pos++, buffer_u8);
		buffer_write(buffer, buffer_u8, s[(s[i]+s[j]) mod 256] ^ currentByte);
	}
	return buffer;
}

///@func __lds_rc4_decrypt__(str, key)
///@param {String} str The string to decrypt
///@param {String} key The decryption key
///@return {String}
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Decrypt the Base64 string with RC4.
function __lds_rc4_decrypt__(str, key) {
	var buffer = buffer_base64_decode(str);
	__lds_rc4__(buffer, string(key), 0, buffer_get_size(buffer));
	buffer_seek(buffer, buffer_seek_start, 0);
	var decoded = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	///Feather disable GM1045
	return decoded;
	///Feather enable GM1045
}

///@func __lds_rc4_encrypt__(str, key)
///@param {String} str The string to encrypt
///@param {String} key The encryption key
///@return {String}
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Encrypt the string with RC4 and encode in Base64.
function __lds_rc4_encrypt__(str, key) {
	var length = string_byte_length(str);
	var buffer = buffer_create(length+1, buffer_fixed, 1);
	buffer_write(buffer, buffer_string, str);
	__lds_rc4__(buffer, string(key), 0, buffer_tell(buffer));
	var encoded = buffer_base64_encode(buffer, 0, length);
	buffer_delete(buffer);
	return encoded;
}

///@func __lds_typeof__(val)
///@param {Any} val The value to detect the type of
///@return {String}
///@ignore
///@desc (INTERNAL: Lightweight Data Structures) Return the type of the given value.
function __lds_typeof__(val) {
	gml_pragma("forceinline");
	return is_struct(val) ? instanceof(val) : typeof(val);
}
