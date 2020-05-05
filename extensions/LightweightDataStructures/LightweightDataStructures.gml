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
	array_copy(arr, lo, _arr, 0, span);
}
