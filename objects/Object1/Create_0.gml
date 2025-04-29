#macro INITIALIZE true
	#macro INITIALIZE_DSMAP true
	#macro INITIALIZE_DSMAP_SET true

	#macro INITIALIZE_DSLIST true
	#macro INITIALIZE_DSLIST_CREATE true

	#macro INITIALIZE_ARRAY true
	#macro INIT_ARRAY_CREATE true

	#macro INITIALIZE_STRUCT true

#macro PICK true
	#macro ARRAYPICK true

	#macro STRUCTPICK true
	#macro STRUCTPICK_SET true
		#macro STRUCTPICK_CHOOSE false

#macro CONTAINS true
	#macro DSMAP_CONTAINS true

	#macro DSLIST_CONTAINS true

	#macro ARRAY_CONTAINS true

	#macro STRUCT_CONTAINS true
	#macro STRUCT_CONTAINS_HASH true
		#macro STRUCT_CONTAINS_CHOOSE false

#macro ITERATE true
	#macro ITERATE_DSMAP true

	#macro ITERATE_DSLIST true

	#macro ITERATE_STRUCT true
	#macro ITERATE_STRUCT_FOREACH true

	#macro ITERATE_ARRAY true
	#macro ITERATE_ARRAY_FOREACH true

#macro REMOVE true
	#macro REMOVE_DSMAP true
	#macro REMOVE_DSMAP_ALL true

	#macro REMOVE_DSLIST true
	#macro REMOVE_DSLIST_ALL true

	#macro REMOVE_STRUCT true
	#macro REMOVE_STRUCT_ALL true
	#macro REMOVE_STRUCT_ALL_FOREACH false

	#macro REMOVE_ARRAY true
	#macro REMOVE_ARRAY_ALL true
	#macro REMOVE_ARRAY_ALL_FOREACH false

#macro CAST true
	#macro CAST_STRUCT_TO_ARRAY true
	#macro CAST_STRUCT_FOREACH true
		#macro ARRAY_CREATE true

	#macro CAST_DSMAP_TO_ARRAY_NAMES true
	#macro CAST_DSMAP_TO_ARRAY_VALS true

#macro SPAMOUTPUT false
#macro ITERATIONS 10
#macro DATA_SIZE 100000

iterations = ITERATIONS; // Number of test runs
data_size = DATA_SIZE; // Number of element
data_size_offset = DATA_SIZE - 1;

if (INITIALIZE) {
	if (INITIALIZE_DSMAP || INITIALIZE_DSMAP_SET) {
		function initialize_dsmap(fset = false) constructor {
			obj = other;
			data_size = obj.data_size;
			var tempmap = ds_map_create();

			var funct;
			if (fset) {
				funct = method(self, ds_map_set);
			} else {
				funct = method(self, ds_map_add);
			}

			var temps = get_timer();
			for (i = 0; i < data_size; i++) {
				funct(tempmap, $"key{i}", 0);
			}
			var tempe = get_timer();
			var tt = tempe - temps;
	
			var str;
			if (fset) {
				str = "_SET";
			} else {
				str = "_ADD"
			}
			
			show_debug_message($"INITIALIZE DSMAP{str} {tt}")
			ds_map_destroy(tempmap);
		}
	}

	if (INITIALIZE_DSLIST || INITIALIZE_DSLIST_CREATE) {
		function initialize_dslist(flist_create = false) constructor {
			obj = other;
			data_size = obj.data_size;
			data_size_offset = obj.data_size_offset;
			templist = ds_list_create();

			var funct;
			if (flist_create) {
				ds_list_set(templist, data_size_offset, 0);
				funct = function() {
					ds_list_set(templist, i, $"key{i}");
				}
			} else {
				funct = function() {
					ds_list_add(templist, $"key{i}");
				}
			}

			var temps = get_timer();
			for (i = 0; i < data_size; i++) {
				funct();
			}
			var tempe = get_timer();
			var tt = tempe - temps;

			var str;
			if (flist_create) {
				str = "_PREALLOC";
			} else {
				str = "_PUSH"
			}

			show_debug_message($"INITIALIZE DSLIST{str} {tt}")
			ds_list_destroy(templist);
		}
	}
	
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

			repeat(iterations) {
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
			show_debug_message($"Average ds_map iteration time: {tt} us");
		}
	}

	if (ITERATE_DSLIST) {
		function iterate_dslist() {
			var templist = ds_list_create();
			ds_list_set(templist, data_size_offset, 0);
			for (var k = 0; k < data_size; k++) {
				ds_list_set(templist, k, { val : 0 });
			}

			var total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				var _list_count = ds_list_size(templist);
				for (var i = 0; i < _list_count; i++) {
					templist[| i].val = 5
				}
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}

			var tt = total_time / iterations;
			show_debug_message($"Average ds_list iteration time: {tt} us")
			ds_list_destroy(templist);
		}
	}

	if (ITERATE_STRUCT || ITERATE_STRUCT_FOREACH) {
		function iterate_struct(fforeach = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;
			test_struct = {};
			for (var i = 0; i < data_size; i++) {
				struct_set(test_struct, "key" + string(i), { val : 0 });
			}
			var total_time = 0;
			if (ITERATE_STRUCT_FOREACH) {
				function _foreach(_name, _val) {
					_val.val = 5;
				}
			}

			var funct;
			if (fforeach) {
				funct = function() {
					struct_foreach(test_struct, _foreach);
				}
			} else {
				funct = function() {
					var member_names = struct_get_names(test_struct);
					var member_count = array_length(member_names);

					for (var i = 0; i < member_count; i++) {
						var _temp = member_names[i];
						var _temp_struct = struct_get(test_struct, _temp);
						_temp_struct.val = 5;
					}
				}
			}

			repeat(iterations) {
				var start_time = get_timer();

				funct();

				var end_time = get_timer();
				total_time += (end_time - start_time);
			}

			var str;
			if (fforeach) {
				str = " foreach";
			} else {
				str = ""
			}

			var tt = total_time / iterations;
			show_debug_message($"Average struct{str} iteration time: {tt} us");
		}
	}

	if (ITERATE_ARRAY || ITERATE_ARRAY_FOREACH) {
		function iterate_array(fforeach = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;
			test_array = array_create(data_size, 0);
			var array_count = array_length(test_array);
			for (var i = 0; i < array_count; i++) {
				test_array[i] = { val : 0 };
			}

			if (ITERATE_ARRAY_FOREACH) {
				function iterate_array_foreach(_val, _index) {
					_val.val = 5;
				}
			}

			var funct;
			if (fforeach) {
				funct = function() {
					array_foreach(test_array, iterate_array_foreach);
				}
			} else {
				funct = function() {
					var _array_length = array_length(test_array);
					for (var i = 0; i < _array_length; i++) {
						test_array[i].val = 5;
					}
				}
			}

			var total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();

				funct();

				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;

			var str;
			if (fforeach) {
				str = "_foreach";
			} else {
				str = "";
			}

			show_debug_message($"Average array{str} iteration time: {tt} us");
		}
	}
}

if (REMOVE) {
	if (REMOVE_DSMAP || REMOVE_DSMAP_ALL) {
		function dsmap_remove(fall = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;
			
			tempmap = ds_map_create();
			for (var i = 0; i < data_size; i++) {
				ds_map_add(tempmap, $"key{i}", 0);
			}

			tempmap2 = undefined;
			var init_funct;
			var funct;
			if (fall) {
				tempmap2 = ds_map_create();

				init_funct = function() {
					ds_map_copy(tempmap2, tempmap);
				}

				funct = function() {
					var keys = ds_map_keys_to_array(tempmap2);
					var key_count = array_length(keys);
					for (var k = 0; k < key_count; k++) {
						ds_map_delete(tempmap2, keys[k]);
					}
				}
			} else {
				tempmap2 = tempmap;

				init_funct = function() {
					ds_map_add(tempmap2, "key0", 0);
				}

				funct = function() {
					ds_map_delete(tempmap2, "key0");
				}
			}

			var start_time, end_time, total_time = 0;
			repeat(iterations) {
				init_funct();
				start_time = get_timer();
				funct();
				end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;

			var str;
			if (fall) {
				str = "_ALL";
			} else {
				str = ""
			}

			show_debug_message($"REMOVE_DSMAP{str} {tt}")
			ds_map_destroy(tempmap);
			if (fall) {
				ds_map_destroy(tempmap2);
			}
		}
	}

	if (REMOVE_DSLIST || REMOVE_DSLIST_ALL) {
		function dslist_remove(fall = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;

			templist = ds_list_create();
			for (var i = 0; i < data_size; i++) {
				ds_list_add(templist, $"key{i}");
			}

			templist2 = undefined;
			var init_funct;
			var funct;
			var end_funct;
			if (fall) {
				templist2 = ds_list_create();

				init_funct = function() {
					ds_list_copy(templist2, templist);
				}

				end_funct = function() {}

				funct = function() {
					var key_count = ds_list_size(templist2);
					repeat(key_count) {
						ds_list_delete(templist2, 0);
					}
				}
			} else {
				templist2 = templist;

				init_funct = function() {}

				end_funct = function() {
					ds_list_add(templist2, "key0");
				}

				funct = function() {
					ds_list_delete(templist2, 0);
				}
			}

			var start_time, end_time, total_time = 0;
			repeat(iterations) {
				init_funct();
				start_time = get_timer();
				funct();
				end_time = get_timer();
				total_time += (end_time - start_time);
				end_funct();
			}
			var tt = total_time / iterations;

			var str;
			if (fall) {
				str = "_ALL";
			} else {
				str = ""
			}

			show_debug_message($"REMOVE_DSLIST{str} {tt}")
			ds_list_destroy(templist);
			if (fall) {
				ds_list_destroy(templist2);
			}
		}
	}

	if (REMOVE_STRUCT || REMOVE_STRUCT_ALL || REMOVE_STRUCT_ALL_FOREACH) {
		function struct_remove_funct(fall = false, fforeach = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			var data_size = obj.data_size;
			test_struct = {};
			for (var i = 0; i < data_size; i++) {
				struct_set(test_struct, "key" + string(i), { val : 0 });
			}

			if (REMOVE_STRUCT_ALL_FOREACH) {
				function remove_struct_foreach(_name, _val) {
					struct_remove(test_struct2, _name);
				}
			}

			var init_funct;
			var funct;
			var end_funct;
			if (!fall) {
				funct = function() {
					struct_remove(test_struct2, struct_names[0]);
				}
			} else if (fforeach) {
				funct = function() {
					struct_foreach(test_struct2, remove_struct_foreach);
				}
			} else {
				funct = function() {
					var struct_names = struct_get_names(test_struct2);
					var struct_count = array_length(struct_names);
					for (var i = 0; i < struct_count; i++) {
						struct_remove(test_struct2, struct_names[i]);
					}
				}
			}

			var start_time;
			var end_time;
			if (fall) {
				init_funct = function() {
					test_struct2 = variable_clone(test_struct);
				}

				end_funct = function() {
					delete test_struct2;
				}

				test_struct2 = {};
			} else {
				init_funct = function() {
					struct_names = struct_get_names(test_struct2);
				}

				end_funct = function() {
					struct_set(test_struct2, struct_names[0], { val : 0 });
				}

				test_struct2 = test_struct;
			}
			var total_time = 0;
			repeat(iterations) {
				init_funct();
				start_time = get_timer();
				funct();
				end_time = get_timer();
				total_time += (end_time - start_time);
				end_funct();
			}

			var tt = total_time / iterations;

			var str;
			if (fforeach) {
				str = "_ALL_FOREACH"
			} else if (fall) {
				str = "_ALL"
			} else {
				str = ""
			}

			show_debug_message($"STRUCT_REMOVE{str} {tt}");
		}
	}

	if (REMOVE_ARRAY || REMOVE_ARRAY_ALL || REMOVE_ARRAY_ALL_FOREACH) {
		function array_remove_funct(fall = false, fforeach = false) constructor {
			obj = other;
			var iterations = obj.iterations;
			if (fall && iterations > 5) {
				iterations = 5;
			}
			var data_size = obj.data_size;
			data_size_temp = floor(data_size / 2);
			test_array = array_create(data_size, 0);
			var array_count = array_length(test_array);
			for (var i = 0; i < array_count; i++) {
				test_array[i] = { val : 0 };
			}

			if (REMOVE_ARRAY_ALL_FOREACH) {
				function remove_array_foreach(_val, _index) {
					array_delete(test_array2, 0, 1);
				}
			}

			var funct;
			if (!fall) {
				funct = function() {
					array_delete(test_array2, data_size_temp, 1);
				}
			} else if (fforeach) {
				funct = function() {
					array_foreach(test_array2, remove_array_foreach);
				}
			} else {
				funct = function() {
					var _array_length = array_length(test_array);
					for (var i = 0; i < _array_length; i++) {
						array_delete(test_array2, 0, 1);
					}
				}
			}

			var init_funct;
			if (fall) {
				init_funct = function() {
					test_array2 = variable_clone(test_array);
				}
				test_array2 = [];
			} else {
				init_funct = function() {
					array_push(test_array2, { val : 0 });
				}
				test_array2 = test_array;
			}

			var total_time = 0;
			repeat(iterations) {
				init_funct();
				var start_time = get_timer();

				funct();

				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt = total_time / iterations;

			var str;
			if (fforeach) {
				str = "_ALL_FOREACH";
			} else if (fall) {
				str = "_ALL"
			} else {
				str = "";
			}

			show_debug_message($"ARRAY_REMOVE{str} {tt}");
		}
	}
}

if (CONTAINS) {
	if (DSMAP_CONTAINS) {
		function dsmap_contains() {
			var tempmap = ds_map_create();
			for (var i = 0; i < data_size; i++) {
				ds_map_add(tempmap, $"key{i}", 0);
			}

			var keytp = choose("0", "1");
			var total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_map_exists(tempmap, $"key{keytp}");
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_start = total_time / iterations;

			var midkey = floor(data_size_offset / 2);
			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_map_exists(tempmap, $"key{midkey}");
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_mid = total_time / iterations;

			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_map_exists(tempmap, $"key{data_size_offset}");
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_end = total_time / iterations;

			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_map_exists(tempmap, undefined);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_null = total_time / iterations;

			show_debug_message($"DSMAP_CONTAINS_START {tt_start}")
			show_debug_message($"DSMAP_CONTAINS_MID {tt_mid}")
			show_debug_message($"DSMAP_CONTAINS_END {tt_end}")
			show_debug_message($"DSMAP_CONTAINS_NULL {tt_null}")
			ds_map_destroy(tempmap);
		}
	}

	if (DSLIST_CONTAINS) {
		function dslist_contains() {
			var templist = ds_list_create();
			ds_list_set(templist, data_size_offset, 0);
			for (var k = 0; k < data_size; k++) {
				ds_list_set(templist, k, k);
			}

			var total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_list_find_index(templist, 0);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_start = total_time / iterations;

			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_list_find_index(templist, floor(data_size_offset / 2));
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_mid = total_time / iterations;

			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_list_find_index(templist, data_size_offset);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_end = total_time / iterations;

			total_time = 0;
			repeat(iterations) {
				var start_time = get_timer();
				ds_list_find_index(templist, undefined);
				var end_time = get_timer();
				total_time += (end_time - start_time);
			}
			var tt_null = total_time / iterations;

			show_debug_message($"DSLIST_CONTAINS_START {tt_start}");
			show_debug_message($"DSLIST_CONTAINS_MID {tt_mid}");
			show_debug_message($"DSLIST_CONTAINS_END {tt_end}");
			show_debug_message($"DSLIST_CONTAINS_NULL {tt_null}");
			ds_list_destroy(templist);
		}
	}

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

				repeat(iterations) {
					var start_time = get_timer();
					structfunct(test_struct, keytemp);
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt = total_time / iterations;

				total_time = 0;
				repeat(iterations) {
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
				repeat(iterations) {
					var start_time = get_timer();
					array_contains(test_array, 0);
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt_start = total_time / iterations;

				total_time = 0;
				repeat(iterations) {
					var start_time = get_timer();
					array_contains(test_array, floor(data_size_offset / 2));
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt_mid = total_time / iterations;

				total_time = 0;
				repeat(iterations) {
					var start_time = get_timer();
					array_contains(test_array, data_size_offset);
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt_end = total_time / iterations;

				total_time = 0;
				repeat(iterations) {
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

if (CAST) {
	if (CAST_DSMAP_TO_ARRAY_NAMES || CAST_DSMAP_TO_ARRAY_VALS) {
		function cast_dsmap_to_array(fkeys = true, fvals = false) {
			var test_map = ds_map_create();
			for (var i = 0; i < data_size; i++) {
				ds_map_add(test_map, "key" + string(i), { val : 0 });
			}

			var total_time = 0;
			if (fkeys) {
				repeat(iterations) {
					var start_time = get_timer();
					ds_map_keys_to_array(test_map);
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt = total_time / iterations;
				show_debug_message($"CAST_DSMAP_TO_ARRAY_NAMES {tt}");
			}

			total_time = 0;
			if (fvals) {
				repeat(iterations) {
					var start_time = get_timer();
					ds_map_keys_to_array(test_map);
					var end_time = get_timer();
					total_time += (end_time - start_time);
				}
				var tt = total_time / iterations;
				show_debug_message($"CAST_DSMAP_TO_ARRAY_VALS {tt}");
			}
			ds_map_destroy(test_map);
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
			repeat(iterations) {
				var start_time = get_timer();
				if (fforeach) {
					if (CAST_STRUCT_FOREACH) {
						if (ARRAY_CREATE) {
							i = 0;
						}

						struct_foreach(tempstruct, funct);
					}
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
}


if (INITIALIZE) {
	if (INITIALIZE_DSMAP) { new initialize_dsmap(); }
	if (INITIALIZE_DSMAP_SET) { new initialize_dsmap(true); }
	if (INITIALIZE_DSLIST) { new initialize_dslist(); }
	if (INITIALIZE_DSLIST_CREATE) { new initialize_dslist(true); }
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
	if (ITERATE_DSLIST) { iterate_dslist(); }
	if (ITERATE_ARRAY) { new iterate_array(); }
	if (ITERATE_ARRAY_FOREACH) { new iterate_array(true); }
	if (ITERATE_STRUCT) { new iterate_struct(); }
	if (ITERATE_STRUCT_FOREACH) { new iterate_struct(true); }
}

if (REMOVE) {
	if (REMOVE_DSLIST) { new dslist_remove(); }
	if (REMOVE_DSLIST_ALL) { new dslist_remove(true); }
	if (REMOVE_DSMAP) { new dsmap_remove(); }
	if (REMOVE_DSMAP_ALL) { new dsmap_remove(true); }
	if (REMOVE_STRUCT) { new struct_remove_funct(); }
	if (REMOVE_STRUCT_ALL) { new struct_remove_funct(true); }
	if (REMOVE_STRUCT_ALL_FOREACH) { new struct_remove_funct(true, true); }
	if (REMOVE_ARRAY) { new array_remove_funct(); }
	if (REMOVE_ARRAY_ALL) { new array_remove_funct(true); }
	if (REMOVE_ARRAY_ALL_FOREACH) { new array_remove_funct(true, true); }
}

if (CONTAINS) {
	if (DSMAP_CONTAINS) { dsmap_contains(); }
	if (DSLIST_CONTAINS) { dslist_contains(); }
	if (ARRAY_CONTAINS) { obj_array_contains(); }
	if (STRUCT_CONTAINS) { struct_contains(); }
	if (STRUCT_CONTAINS_HASH) { struct_contains(true); }
}

if (CAST) {
	if (CAST_DSMAP_TO_ARRAY_NAMES) { cast_dsmap_to_array(); }
	if (CAST_DSMAP_TO_ARRAY_VALS) { cast_dsmap_to_array(false, true); }
	if (CAST_STRUCT_TO_ARRAY) { new cast_struct_to_array(); }
	if (CAST_STRUCT_FOREACH) { new cast_struct_to_array(true); }
}
