#macro INITIALIZE true
	#macro INITIALIZE_ARRAY true
	#macro INIT_ARRAY_CREATE true

	#macro INITIALIZE_STRUCT true

#macro PICK true
	#macro ARRAYPICK true

	#macro STRUCTPICK true
	#macro STRUCTPICK_SET true
		#macro STRUCTPICK_CHOOSE false

#macro CONTAINS true
	#macro ARRAY_CONTAINS true

	#macro STRUCT_CONTAINS true
	#macro STRUCT_CONTAINS_HASH true
		#macro STRUCT_CONTAINS_CHOOSE false

#macro ITERATE true
	#macro ITERATE_DSMAP true

	#macro ITERATE_STRUCT true
	#macro ITERATE_STRUCT_FOREACH true

	#macro ITERATE_ARRAY true

#macro CAST_STRUCT_TO_ARRAY true
#macro CAST_STRUCT_FOREACH true
	#macro ARRAY_CREATE true

#macro SPAMOUTPUT false
#macro ITERATIONS 500
#macro DATA_SIZE 100000

iterations = ITERATIONS; // Number of test runs
data_size = DATA_SIZE; // Number of element
data_size_offset = DATA_SIZE - 1;

if (INITIALIZE) {
	if (INITIALIZE_ARRAY || INIT_ARRAY_CREATE) {
		function initialize_array(farray_create = false) constructor {
			obj = other;
			var data_size = obj.data_size;
			insarray = [];
			if (farray_create) {
				var temps = get_timer();
				insarray = array_create(data_size, 0);
				var tempe = get_timer();
				var tt_array_create = tempe - temps;
				show_debug_message($"CREATE ARRAY_PREALLOC {tt_array_create}")
			}

			var array_count;
			if (farray_create) {
				array_count = array_length(insarray);
			} else {
				array_count = data_size;
			}

			var funct;
			if (farray_create) {
				funct = function() {
					insarray[i] = $"key{i}";
				}
			} else {
				funct = function() {
					array_push(insarray, $"key{i}");
				}
			}

			var temps = get_timer();
			for (i = 0; i < array_count; i++) {
				funct();
			}
			var tempe = get_timer();
			var tt_array_init = tempe - temps;

			var str;
			if (!farray_create) {
				str = "_PUSH";
			} else {
				str = "_PREALLOC";
			}
			
			show_debug_message($"INITIALIZE ARRAY{str} {tt_array_init}");
		}
	}

	if (INITIALIZE_STRUCT) {
		function initialize_struct() {
			var tempstruct = {};
			var temps = get_timer();
			for (var i = 0; i < data_size; i++) {
				struct_set(tempstruct, $"key{i}", 0);
			}
			var tempe = get_timer();
			var tt_struct = tempe - temps;
			show_debug_message($"INITIALIZE STRUCT {tt_struct}");
		}
	}
}

if (PICK) {
	if (ARRAYPICK) {
		function arraypick() {
			var temparray = array_create(data_size, 0);

			var temps = get_timer();
			temparray[data_size_offset] = 20;
			var tempe = get_timer();
			var tt = tempe - temps;
			show_debug_message($"ARRAYPICK {tt}");
		}
	}

	if (STRUCTPICK || STRUCTPICK_SET) {
		function structpick(fset = false) {
			var tempstruct = {}
			for (var i = 0; i < data_size; i++) {
				struct_set(tempstruct, $"key{i}", 0);
			}

			var key;
			if (STRUCTPICK_CHOOSE) {
				key = choose($"key{data_size_offset}", $"key{data_size_offset - 1}")
			} else {
				key = $"key{data_size_offset}";
			}

			var temps = get_timer();
			if (fset) {
				struct_set(tempstruct, key, 20);
			} else {
				tempstruct[$ key] = 20;
			}
			var tempe = get_timer();
			var tt = tempe - temps;

			var str;
			if (fset) {
				str = "_SET";
			} else {
				str = "_ACCESSOR"
			}

			show_debug_message($"STRUCTPICK{str} {tt}");
		}
	}
}

if (ITERATE) {
	if (ITERATE_DSMAP) {
		function iterate_dsmap() {
			var test_map = ds_map_create();
			for (var i = 0; i < data_size; i++) {
				ds_map_add(test_map, "key" + string(i), { val : 0 });
			}
			var total_time = 0;

			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				var key_list = ds_map_keys_to_array(test_map);
				var key_count = array_length(key_list);

				for (var i = 0; i < key_count; i++) {
					var _temp = key_list[i]
					test_map[? _temp].val = 5;
				}

				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;
			ds_map_destroy(test_map);
			show_debug_message($"Average ds_map iteration time: {tt} ms");
		}
	}

	if (ITERATE_STRUCT || ITERATE_STRUCT_FOREACH) {
		function iterate_struct(fforeach = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;
			var test_struct = {};
			for (var i = 0; i < data_size; i++) {
				struct_set(test_struct, "key" + string(i), { val : 0 });
			}
			var total_time = 0;
			if (ITERATE_STRUCT_FOREACH) {
				function _foreach(_name, _val) {
					_val.val = 5;
				}
			}

			if (fforeach) {
				// Making if perform both normal and preprocessor tasks was a mistake
				if (ITERATE_STRUCT_FOREACH) {
					var start_time = get_timer();

					struct_foreach(test_struct, _foreach);

					var end_time = get_timer();
					total_time += (end_time - start_time);
					var tt = total_time / iterations;
					show_debug_message($"Average struct foreach iteration time: {tt} ms");
				}
			} else {
				for (var k = 0; k < iterations; k++) {
					var start_time = get_timer();
					var member_names = struct_get_names(test_struct);
					var member_count = array_length(member_names);

					for (var i = 0; i < member_count; i++) {
						var _temp = member_names[i];
						var _temp_struct = struct_get(test_struct, _temp);
						_temp_struct.val = 5;
					}

					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt = total_time / iterations;
				show_debug_message($"Average struct iteration time: {tt} ms");
			}
		}
	}

	if (ITERATE_ARRAY) {
		function iterate_array() {
			var test_array = array_create(data_size, { val : 0 });
			var total_time = 0;

			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				var _array_length = array_length(test_array);

				for (var i = 0; i < _array_length; i++) {
					test_array[i].val = 5;
				}

				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;
			show_debug_message($"Average array iteration time: {tt} ms");
		}
	}
}

if (CONTAINS) {
	if (STRUCT_CONTAINS || STRUCT_CONTAINS_HASH) {
		function struct_contains(fhash = false) {
			var test_struct = {};
			for (var i = 0; i < data_size; i++) {
				struct_set(test_struct, "key" + string(i), { val : 0 });
			}
			var total_time = 0;

			var key;
			var key_null = "";
			if (STRUCT_CONTAINS_CHOOSE) {
				key = choose($"key{data_size_offset}", $"key{data_size_offset - 1}")
			} else {
				key = $"key{data_size_offset}";
			}

			var key_hash;
			var key_null_hash;
			if (fhash) {
				key_hash = variable_get_hash(key);
				key_null_hash = variable_get_hash(key_null);
			}

			var structfunct;
			var keytemp;
			var keytempnull;
			if (fhash) {
				structfunct = method(self, struct_exists_from_hash);
				keytemp = key_hash;
				keytempnull = key_null_hash;
			} else {
				structfunct = method(self, struct_exists);
				keytemp = key;
				keytempnull = key_null;
			}

			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				structfunct(test_struct, keytemp);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;

			total_time = 0;
			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				structfunct(test_struct, keytempnull);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_null = total_time / iterations;

			var str;
			if (fhash) {
				str = "_HASH";
			} else {
				str = "_STRING"
			}

			show_debug_message($"STRUCT_CONTAINS{str} {tt}");
			show_debug_message($"STRUCT_CONTAINS_NULL{str} {tt_null}");
		}
	}

	if (ARRAY_CONTAINS) {
		function obj_array_contains() {
			var test_array = array_create(data_size, 0);
			for (var i = 0; i < data_size; i++) {
				test_array[i] = i;
			}
			var total_time = 0;
			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				array_contains(test_array, 0);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_start = total_time / iterations;

			total_time = 0;
			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				array_contains(test_array, floor(data_size_offset / 2));
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_mid = total_time / iterations;

			total_time = 0;
			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				array_contains(test_array, data_size_offset);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_end = total_time / iterations;

			total_time = 0;
			for (var k = 0; k < iterations; k++) {
				var start_time = get_timer();
				array_contains(test_array, undefined);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_null = total_time / iterations;

			show_debug_message($"ARRAY_CONTAINS_START {tt_start}");
			show_debug_message($"ARRAY_CONTAINS_MID {tt_mid}");
			show_debug_message($"ARRAY_CONTAINS_END {tt_end}");
			show_debug_message($"ARRAY_CONTAINS_NULL {tt_null}");
		}
	}
}

if (CAST_STRUCT_TO_ARRAY || CAST_STRUCT_FOREACH) {
	function cast_struct_to_array(fforeach = false) constructor {
		obj = other;
		var iterations = obj.iterations;
		var data_size = obj.data_size;
		var tempstruct = {};
		if (ARRAY_CREATE) {
			insarray = array_create(data_size, 0);
		} else {
			insarray = [];
		}

		var str;
		if (fforeach) {
			str = "_FOREACH";
		} else {
			str = "_FORLOOP";
		}

		for (i = 0; i < data_size; i++) {
			struct_set(tempstruct, $"key{i}", 100);
		}

		if (CAST_STRUCT_FOREACH) {
			static funct = function(_name, _val) {
				if (ARRAY_CREATE) {
					insarray[i] = _val;
					i += 1;
				} else {
					array_push(insarray, _val);
				}
			}
		}

		var total_time = 0;
		for (k = 0; k < iterations; k++) {
			var start_time = get_timer();
			if (fforeach) {
				if (ARRAY_CREATE) {
					i = 0;
				}

				struct_foreach(tempstruct, funct);
			} else {
				var struct_names = struct_get_names(tempstruct);
				var struct_count = array_length(struct_names);
				for (i = 0; i < struct_count; i++) {
					if (ARRAY_CREATE) {
						insarray[i] = struct_get(tempstruct, struct_names[i]);
					} else {
						var struct_val = struct_get(tempstruct, struct_names[i]);
						array_push(insarray, struct_val);
					}
				}
			}
			var end_time = get_timer();
			var ct = end_time - start_time;
			if (SPAMOUTPUT) {
				show_debug_message($"CAST_STRUCT_TO_ARRAY{str} {ct} ITER {k}");
			}
			total_time += ct;
			if (ARRAY_CREATE) {
				insarray = array_create(data_size, 0);
			} else {
				insarray = [];
			}
		}
		tt = total_time / iterations;
		show_debug_message($"CAST_STRUCT_TO_ARRAY{str} {tt} FIN");
	}
}


if (INITIALIZE) {
	if (INITIALIZE_ARRAY) { new initialize_array(); }
	if (INIT_ARRAY_CREATE) { new initialize_array(true); }
	if (INITIALIZE_STRUCT) { initialize_struct(); }
}

if (PICK) {
	if (ARRAYPICK) { arraypick(); }
	if (STRUCTPICK) { structpick(); }
	if (STRUCTPICK_SET) { structpick(true); }
}

if (ITERATE) {
	if (ITERATE_DSMAP) { iterate_dsmap(); }
	if (ITERATE_ARRAY) { iterate_array(); }
	if (ITERATE_STRUCT) { new iterate_struct(); }
	if (ITERATE_STRUCT_FOREACH) { new iterate_struct(true); }
}

if (CONTAINS) {
	if (ARRAY_CONTAINS) { obj_array_contains(); }
	if (STRUCT_CONTAINS) { struct_contains(); }
	if (STRUCT_CONTAINS_HASH) { struct_contains(true); }
}

if (CAST_STRUCT_TO_ARRAY) { new cast_struct_to_array(); }
if (CAST_STRUCT_FOREACH) { new cast_struct_to_array(true); }
