///@func lds_test_all()
///@return {Bool}
///@desc Test all Lightweight Data Structure functionality. Return whether successful.
function lds_test_all() {
	global.__test_fails__ = 0;
	var timeA, timeB;
	timeA = current_time;
	
	lds_test_shuffle();
	lds_test_sort();
	lds_test_stack();
	lds_test_queue();
	lds_test_heap();
	lds_test_map();
	lds_test_list();
	lds_test_grid();
	lds_test_reduce();
	lds_test_copy_shallow();
	lds_test_copy_deep();
	lds_test_crypto();
	lds_test_file();
	
	timeB = current_time;
	show_debug_message("Lightweight Data Structure tests done in " + string(timeB-timeA) + "ms.");
	return global.__test_fails__ == 0;
}