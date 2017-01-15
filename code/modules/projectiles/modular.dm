/obj/item/weapon/gun/modular
	name = "gun"
	icon = 'icons/obj/modgun.dmi'
	icon_state = "chamber"
	appearance_flags = KEEP_TOGETHER

	accuracy = -3
	recoil   = 3

	var/list/parts = list()

/obj/item/weapon/gun/modular/attackby(obj/item/weapon/W, mob/user)
	if(istype(W,/obj/item/gun_part))
		if(do_after(user, 20, W))
			install(W,user)
	else if(istype(W, /obj/item/weapon/screwdriver))
		var/slot = input("What part do you want to remove?","Weapon disassembly") as null|anything in parts
		if(slot)
			var/obj/item/gun_part/part = parts[slot]
			if(do_after(user, 20, src))
				remove(part,user)
	else ..()

/obj/item/weapon/gun/modular/proc/install(obj/item/gun_part/part, mob/user)
	if(parts[part.slot])
		user << "<span class='warning'>[src] already has a [part.slot].</span>"
		return
	if(user)
		user.remove_from_mob(part)
		user << "<span class='notice'>You install [part] into [src].</span>"
	parts[part.slot] = part
	accuracy += part.acc_mod
	recoil += part.rec_mod
	w_class += part.size_mod
	part.forceMove(src)
	update_icon(1)

/obj/item/weapon/gun/modular/proc/remove(obj/item/gun_part/part, mob/user)
	parts -= part.slot
	accuracy -= part.acc_mod
	recoil -= part.rec_mod
	w_class = max(1,w_class - part.size_mod)
	if(user)
		user.put_in_hands(part)
	else
		forceMove(get_turf(src))
	update_icon(1)

/obj/item/weapon/gun/modular/update_icon(rebuild)
	if(rebuild)
		overlays.Cut()
		for(var/P in parts)
			var/obj/item/gun_part/part = parts[P]
			if(part)
				var/image/I = part.appearance
				overlays += I
	..()

/obj/item/weapon/gun/modular/examine(mob/user)
	..()
	user << "Accuracy: [accuracy], recoil: [recoil]."

/obj/item/weapon/gun/modular/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return
	if(!pointblank && !(parts["barrel"] && (parts["grip"] || parts["stock"])))
		user << "<span class='warning'>You can't control [src] and the shot goes wild!</span>"
		target = pick(trange(get_dist(target,user), get_turf(target)))
		new/obj/effect/sparks(target)
	..()

/obj/item/gun_part
	icon = 'icons/obj/modgun.dmi'
	icon_state = "chamber"
	name = "gun part"
	randpixel = 0
	appearance_flags = RESET_COLOR
	var/slot = "butt"
	var/acc_mod = 0
	var/rec_mod	= 0
	var/size_mod = 0

/obj/item/gun_part/barrel
	name = "barrel"
	icon_state = "barrel"
	slot = "barrel"
	acc_mod = 2
	rec_mod	= -1
	size_mod = 1

/obj/item/gun_part/grip
	name = "grip"
	icon_state = "grip"
	slot = "grip"
	acc_mod = 1

/obj/item/gun_part/stock
	name = "stock"
	icon_state = "stock"
	slot = "stock"
	acc_mod = 1
	rec_mod	= -2
	size_mod = 1