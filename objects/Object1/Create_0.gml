#macro ARRAYPICK false
#macro ARRAY_CONTAINS false
#macro STRUCTPICK false
    #macro STRUCTPICK_CHOOSE true
    #macro STRUCTPICK_SET false
#macro STRUCT_CONTAINS false
    #macro STRUCT_CONTAINS_CHOOSE false
    #macro STRUCT_CONTAINS_HASH true
#macro ITERATE false
    #macro ITERATE_DSMAP true
    #macro ITERATE_STRUCT true
    #macro ITERATE_ARRAY true
    #macro ITERATE_STRUCT_FOREACH true
#macro CAST_STRUCT_TO_ARRAY true
    #macro STRUCT_FOREACH true
    #macro ARRAY_CREATE true
#macro SPAMOUTPUT false
#macro ITERATIONS 500
#macro DATA_SIZE 100000

var iterations = ITERATIONS; // Number of test runs
var data_size = DATA_SIZE; // Number of element
var data_size_offset = DATA_SIZE - 1;

if (ARRAYPICK) {
    var temparray = array_create(data_size, 0);

    var temps = get_timer();
    temparray[data_size_offset] = 20;
    var tempe = get_timer();
    var tt = tempe - temps;
    show_debug_message($"ARRAYPICK {tt}");
}

if (STRUCTPICK) {
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
    if (STRUCTPICK_SET) {
        struct_set(tempstruct, key, 20);
    } else {
        tempstruct[$ key] = 20;
    }
    var tempe = get_timer();
    var tt = tempe - temps;
    show_debug_message($"STRUCTPICK {tt}");
}

if (ITERATE) {
    if (ITERATE_DSMAP) {
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
        show_debug_message($"Average ds_map iteration time: {tt} ms");
    }

    if (ITERATE_STRUCT) {
        var test_struct = {};
        for (var i = 0; i < data_size; i++) {
            struct_set(test_struct, "key" + string(i), { val : 0 });
        }
        var total_time = 0;

        for (var k = 0; k < iterations; k++) {
            var start_time = get_timer();
            var member_names = struct_get_names(test_struct);
            var member_count = array_length(member_names);

            for (var i = 0; i < member_count; i++) {
                var _temp = member_names[i];
                var _temp_struct = test_struct[$ _temp];
                _temp_struct.val = 5;
            }

            var end_time = get_timer();
            total_time += (end_time - start_time);
        }
        var tt = total_time / iterations;
        show_debug_message($"Average struct iteration time: {tt} ms");
    }

    if (ITERATE_ARRAY) {
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

    if (ITERATE_STRUCT_FOREACH) {
        var test_struct = {};
        for (var i = 0; i < data_size; i++) {
            struct_set(test_struct, "key" + string(i), { val : 0 });
        }
        var total_time = 0;
        function _foreach(_name, _val) {
            _val.val = 5;
        }

        for (var k = 0; k < iterations; k++) {
            var start_time = get_timer();

            struct_foreach(test_struct, _foreach);

            var end_time = get_timer();
            total_time += (end_time - start_time);
        }
        var tt = total_time / iterations;
        show_debug_message($"Average struct foreach iteration time: {tt} ms");
    }
}

if (STRUCT_CONTAINS) {
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
    if (STRUCT_CONTAINS_HASH) {
        key_hash = variable_get_hash(key);
        key_null_hash = variable_get_hash(key_null);
    }

    for (var k = 0; k < iterations; k++) {
        var start_time = get_timer();
        if (STRUCT_CONTAINS_HASH) {
            struct_exists_from_hash(test_struct, key_hash);
        } else {
            struct_exists(test_struct, key);
        }
        var end_time = get_timer();
        total_time += (end_time - start_time);
    }
    var tt = total_time / iterations;

    total_time = 0;
    for (var k = 0; k < iterations; k++) {
        var start_time = get_timer();
        if (STRUCT_CONTAINS_HASH) {
            struct_exists_from_hash(test_struct, key_null_hash);
        } else {
            struct_exists(test_struct, key_null);
        }
        var end_time = get_timer();
        total_time += (end_time - start_time);
    }
    var tt_null = total_time / iterations;
    show_debug_message($"STRUCT_CONTAINS {tt}");
    show_debug_message($"STRUCT_CONTAINS_NULL {tt_null}");
}

if (ARRAY_CONTAINS) {
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

if (CAST_STRUCT_TO_ARRAY) {
    var tempstruct = {};
    if (ARRAY_CREATE) {
        insarray = array_create(data_size, 0);
    } else {
        insarray = [];
    }

    for (var i = 0; i < data_size; i++) {
        struct_set(tempstruct, $"key{i}", 100);
    }

    function cast_struct_to_array(_name, _val) {
        if (ARRAY_CREATE) {
            insarray[global.i] = _val;
            global.i += 1;
        } else {
            array_push(insarray, _val);
        }
    }

    var total_time = 0;
    for (var k = 0; k < iterations; k++) {
        var start_time = get_timer();
        if (STRUCT_FOREACH) {
            if (ARRAY_CREATE) {
                global.i = 0;
            }

            struct_foreach(tempstruct, cast_struct_to_array);
        } else {
            var struct_names = struct_get_names(tempstruct);
            var struct_count = array_length(struct_names);
            for (var i = 0; i < struct_count; i++) {
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
            show_debug_message($"CAST_STRUCT_TO_ARRAY {ct} ITER {k}");
        }
        total_time += ct;
        if (ARRAY_CREATE) {
            insarray = array_create(data_size, 0);
        } else {
            insarray = [];
        }
    }
    var tt = total_time / iterations;
    show_debug_message($"CAST_STRUCT_TO_ARRAY {tt} FIN");
}
