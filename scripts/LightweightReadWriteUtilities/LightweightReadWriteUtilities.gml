function lds_write(thing) {
	//var thing = argument0;
	return jsons_encode(lds_reduce(thing));
}

function lds_read(str) {
	//var str = argument0;
	return lds_expand(jsons_decode(str));
}

function lds_save(thing, filename) {
	//var thing = argument0,
	//	filename = argument1;
	return jsons_save(filename, lds_reduce(thing));
}

function lds_load(filename) {
	//var filename = argument0;
	return lds_expand(jsons_load(filename));
}

function lds_encrypt() {
	var thing = lds_reduce(argument[0]),
		key = "myLdsSecretKey",
		encfunc = function(v, k) { return __jsons_encrypt__(v, k); }; //__jsons_encrypt__
	switch (argument_count) {
		case 3:
			encfunc = argument[2];
		case 2:
			key = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	return jsons_encrypt(thing, key, encfunc);
}

function lds_decrypt() {
	var key = "myLdsSecretKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); }; //__jsons_decrypt__
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			key = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	return lds_expand(jsons_decrypt(argument[0], key, decfunc));
}

function lds_save_encrypted() {
	var thing = lds_reduce(argument[1]),
		key = "myLdsSecretKey",
		encfunc = function(v, k) { return __jsons_encrypt__(v, k); }; //__jsons_encrypt__
	switch (argument_count) {
		case 4:
			encfunc = argument[3];
		case 3:
			key = argument[2];
		case 2: break;
		default:
			show_error("Expected 2-4 arguments, got " + string(argument_count) + ".", true);
	}
	return jsons_save_encrypted(argument[0], thing, key, encfunc);
}

function lds_load_encrypted() {
	var key = "myLdsSecretKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); }; //__jsons_decrypt__
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			key = argument[1];
		case 1: break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
	}
	return lds_expand(jsons_load_encrypted(argument[0], key, decfunc));
}
