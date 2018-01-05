/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "blood pack"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_NORMAL
	volume = 100
	possible_transfer_amounts = "0.2;1;2"
	amount_per_transfer_from_this = REM
	flags = OPENCONTAINER

	var/blood_type = null
	var/mob/living/carbon/human/attached

/obj/item/weapon/reagent_containers/blood/New()
	..()
	if(blood_type)
		name = "blood pack [blood_type]"
		reagents.add_reagent(/datum/reagent/blood, volume, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null, "virus2" = list(), "antibodies" = list()))

/obj/item/weapon/reagent_containers/blood/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached = null
	..()

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	overlays.Cut()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', "[round(percent,25)]")
		filling.color = reagents.get_color()
		overlays += filling
	overlays += image('icons/obj/bloodpack.dmi', "top")
	if(attached)
		overlays += image('icons/obj/bloodpack.dmi', "dongle")

/obj/item/weapon/reagent_containers/blood/MouseDrop(over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return
	if(!ismob(loc))
		return
	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
	else if(ishuman(over_object))
		visible_message("<span class = 'warning'>\The [usr] starts hooking \the [over_object] up to \the [src] .")
		if(do_after(usr, 30))
			to_chat(usr, "You hook \the [over_object] up to \the [src].")
			attached = over_object
			START_PROCESSING(SSobj,src)
	update_icon()

/obj/item/weapon/reagent_containers/blood/Process()
	if(!ismob(loc))
		return PROCESS_KILL

	if(attached)
		if(!loc.Adjacent(attached))
			attached = null
			visible_message("\The [attached] detaches from \the [src]")
			update_icon()
			return PROCESS_KILL
	else
		return PROCESS_KILL

	var/mob/M = loc
	if(M.l_hand != src && M.r_hand != src)
		return

	if(!reagents.total_volume)
		return

	reagents.trans_to_mob(attached, amount_per_transfer_from_this, CHEM_BLOOD)
	update_icon()

/obj/item/weapon/reagent_containers/blood/neo/New()
	..()
	reagents.del_reagent(/datum/reagent/blood)
	reagents.add_reagent(/datum/reagent/neoblood, volume)

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
