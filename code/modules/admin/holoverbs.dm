
/datum/admins/proc/ai_hologram_set(mob/appear as mob in world)
	set name = "Set AI Hologram"
	set desc = "Set an AI's hologram to a mob. Use this verb on the mob you want the hologram to look like."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	var/list/AIs = list()
	for(var/mob/living/silicon/ai/AI in mob_list)
		AIs += AI

	var/mob/living/silicon/ai/AI = input("Which AI do you want to apply [appear] to as a hologram?") as null|anything in AIs
	if(!AI) return

	AI.holo_icon = make_hologram(appear)

	AI << "Your hologram icon has been set to [appear]."
	log_and_message_admins("set [key_name(AI)]'s hologram icon to [key_name(appear)]")