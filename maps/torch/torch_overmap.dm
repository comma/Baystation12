/obj/effect/overmap/ship/torch
	name = "SEV Torch"
	fore_dir = WEST
	vessel_mass = 800
	default_delay = 12 SECONDS
/*	landing_areas = list(
						 /area/aquila_hangar/fourthdeck, /area/calypso_hangar/fourthdeck, /area/guppy_hangar/fourthdeck,
						 /area/aquila_hangar/thirddeck, /area/calypso_hangar/thirddeck, /area/guppy_hangar/thirddeck,
						 /area/aquila_hangar/seconddeck, /area/calypso_hangar/seconddeck, /area/guppy_hangar/seconddeck,
						 /area/aquila_hangar/firstdeck, /area/calypso_hangar/firstdeck, /area/guppy_hangar/firstdeck,
						 /area/aquila_hangar/bridge, /area/calypso_hangar/bridge, /area/guppy_hangar/bridge)
*/

/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_cluster_1",
		"nav_cluster_2",
		"nav_cluster_3",
		"nav_cluster_4",
		"nav_cluster_5",
		"nav_cluster_6",
		"nav_cluster_7"
	)

/obj/effect/shuttle_landmark/cluster/guppy
	name = "Asteroid Navpoint #1"
	landmark_tag = "nav_cluster_1"

/obj/effect/shuttle_landmark/cluster/aquila
	name = "Asteroid Navpoint #2"
	landmark_tag = "nav_cluster_2"

/obj/effect/shuttle_landmark/cluster/calypso
	name = "Asteroid Navpoint #3"
	landmark_tag = "nav_cluster_3"

/obj/effect/shuttle_landmark/cluster/ert
	name = "Asteroid Navpoint #4"
	landmark_tag = "nav_cluster_4"

/obj/effect/shuttle_landmark/cluster/ninja
	name = "Asteroid Navpoint #5"
	landmark_tag = "nav_cluster_6"

/obj/effect/shuttle_landmark/cluster/syndie
	name = "Asteroid Landing zone #1"
	landmark_tag = "nav_cluster_5"
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/cluster/skipjack
	name = "Asteroid Landing zone #2"
	landmark_tag = "nav_cluster_7"
	base_area = /area/mine/explored

//	landing_areas = list(/area/aquila_hangar/mining, /area/calypso_hangar/mining, /area/guppy_hangar/mining)

/obj/effect/overmap/sector/derelict
	name = "debris field"
	desc = "A large field of miscellanious debris."
	icon_state = "object"

//	landing_areas = list(/area/aquila_hangar/salvage, /area/calypso_hangar/salvage, /area/guppy_hangar/salvage)
	generic_waypoints = list(
		"nav_derelict_1",
		"nav_derelict_2",
		"nav_derelict_3",
		"nav_derelict_4",
		"nav_derelict_5",
		"nav_derelict_6",
		"nav_derelict_7"
	)

/obj/effect/shuttle_landmark/derelict/guppy
	name = "Debris Navpoint #1"
	landmark_tag = "nav_derelict_1"

/obj/effect/shuttle_landmark/derelict/aquila
	name = "Debris Navpoint #2"
	landmark_tag = "nav_derelict_2"

/obj/effect/shuttle_landmark/derelict/calypso
	name = "Debris Navpoint #3"
	landmark_tag = "nav_derelict_3"

/obj/effect/shuttle_landmark/derelict/ert
	name = "Debris Navpoint #4"
	landmark_tag = "nav_derelict_4"

/obj/effect/shuttle_landmark/derelict/ninja
	name = "Debris Navpoint #5"
	landmark_tag = "nav_derelict_5"

/obj/effect/shuttle_landmark/derelict/syndie
	name = "Debris Navpoint #6"
	landmark_tag = "nav_derelict_6"

/obj/effect/shuttle_landmark/derelict/skipjack
	name = "Debris Navpoint #7"
	landmark_tag = "nav_derelict_7"

/obj/effect/overmap/sector/away
	name = "faint signal"
	desc = "Faint signal detected, originating from the site's surface."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_away_1",
		"nav_away_2",
		"nav_away_3",
		"nav_away_4",
		"nav_away_5",
		"nav_away_6",
		"nav_away_7"
	)

/obj/effect/shuttle_landmark/away
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/away/guppy
	name = "Away Landing zone #1"
	landmark_tag = "nav_away_1"

/obj/effect/shuttle_landmark/away/aquila
	name = "Away Landing zone #2"
	landmark_tag = "nav_away_2"

/obj/effect/shuttle_landmark/away/calypso
	name = "Away Landing zone #3"
	landmark_tag = "nav_away_3"

/obj/effect/shuttle_landmark/away/ert
	name = "Away Landing zone #4"
	landmark_tag = "nav_away_4"

/obj/effect/shuttle_landmark/away/syndie
	name = "Away Landing zone #5"
	landmark_tag = "nav_away_5"

/obj/effect/shuttle_landmark/away/ninja
	name = "Away Landing zone #6"
	landmark_tag = "nav_away_6"

/obj/effect/shuttle_landmark/away/skipjack
	name = "Away Landing zone #7"
	landmark_tag = "nav_away_7"

/obj/machinery/computer/shuttle_control/explore/aquila
	name = "aquila control console"
	shuttle_tag = "Aquila"
	req_access = list(access_aquila_helm)

/obj/machinery/computer/shuttle_control/explore/calypso
	name = "calypso control console"
	shuttle_tag = "Calypso"
	req_access = list(access_calypso_helm)

/obj/machinery/computer/shuttle_control/explore/guppy
	name = "guppy control console"
	shuttle_tag = "Guppy"
	req_access = list(access_guppy_helm)