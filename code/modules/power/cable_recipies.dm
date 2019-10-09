
GLOBAL_LIST_INIT(cable_recipies, generate_cable_recipies())

/proc/generate_cable_recipies()
	. = list()
	for(var/T in subtypesof(/datum/stack_recipe/cable))
		. += new T()

/datum/stack_recipe/cable/restraints
	title = "makeshift restraints"
	result_type = /obj/item/weapon/handcuffs/cable
	req_amount = 15
	time = 10

/datum/stack_recipe/cable/rope
	title = "makeshift climbing rope"
	result_type = /obj/item/stack/rope/makeshift
	req_amount = 3
	res_amount = 1
	max_res_amount = 10
	time = 5

/obj/item/stack/rope
	name = "climbing rope"
	desc = "Strudy climbing rope woven with nanofibers. Now you just need a ten foot pole."
	singular_name = "length"
	icon = 'icons/obj/rope.dmi'
	icon_state = "bundle"
	color = COLOR_BEIGE
	max_amount = 10

/obj/item/stack/rope/full
	mount = 10

/obj/item/stack/rope/makeshift
	name = "makeshift climbing rope"
	desc = "Makeshift climbing rope made from several cables. Warranty void if used."
