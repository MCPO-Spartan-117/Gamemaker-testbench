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
