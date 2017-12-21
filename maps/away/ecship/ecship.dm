/obj/effect/overmap/ship/ec
	name = "SEV Horizon"
	color = "#7ac9f9"
	vessel_mass = 60

/obj/effect/overmap/ship/ec/New()
	name = "SEV [pick("Magellan", "Gagarin", "Drake", "Horizon", "Aurora")]"
	for(var/area/ecship/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()

/datum/map_template/ruin/away_site/ec
	name = "Expeditionary Ship"
	id = "awaysite_bearcat_wreck"
	description = "An abandoned ancient STL exploration ship."
	suffixes = list("ecship/ecship.dmm")
	cost = 0.5

/area/ecship/crew
	name = "\improper Crew Area"
	icon_state = "crew_quarters"

/area/ecship/science
	name = "\improper Science Module"
	icon_state = "xeno_lab"

/area/ecship/cryo
	name = "\improper Cryosleep Module"
	icon_state = "cryo"

/area/ecship/engineering
	name = "\improper Engineering"
	icon_state = "engineering_supply"

/area/ecship/engine
	name = "\improper Engine Exterior"
	icon_state = "engine"
	area_flags = AREA_FLAG_EXTERNAL
	has_gravity = FALSE
	dynamic_lighting = 0

/area/ecship/cockpit
	name = "\improper Cockpit"
	icon_state = "bridge"

//Low pressure setup
/obj/machinery/atmospherics/unary/vent_pump/low
	use_power = 1
	icon_state = "map_vent_out"
	external_pressure_bound = 0.25 * ONE_ATMOSPHERE

/obj/machinery/alarm/low/Initialize()
	. = ..()
	TLV["pressure"] = list(ONE_ATMOSPHERE*0.10,ONE_ATMOSPHERE*0.20,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20)
