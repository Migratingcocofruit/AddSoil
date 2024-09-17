/// Total energy to decypher the cache: 100MWh
#define DECYPHER_ENERGY 3.6e3 * 100 MW

// ID

/obj/item/card/id/engineer_trainee
	name = "Engineer Trainee ID"
	desc = "An identification card for an engineer trainee"
	icon_state = "engineering"
	access = list(ACCESS_ENGINEER_TRAINEE, ACCESS_CE, ACCESS_MINERAL_STOREROOM, ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
	untrackable = TRUE

// Outfit

/datum/outfit/engineer_trainee
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	back = /obj/item/mod/control/pre_equipped/engineering/trainee
	shoes = /obj/item/clothing/shoes/magboots/advance
	belt = /obj/item/storage/belt/utility/chief/full
	gloves = /obj/item/clothing/gloves/color/yellow
	id = /obj/item/card/id/engineer_trainee
	mask = /obj/item/clothing/mask/gas
	glasses = /obj/item/clothing/glasses/meson/engine
	r_ear = /obj/item/radio/headset/headset_eng_trainee
	r_pocket = /obj/item/t_scanner

/datum/outfit/engineer_trainee/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/random_name = random_name(pick(MALE,FEMALE), H.dna.species.name)
	H.rename_character(H.real_name, random_name)
	H.job = "Engineer Trainee" // ensures they show up right in player panel for admins

// Spawners

/obj/effect/mob_spawn/human/alive/engineer_trainee
	roundstart = FALSE
	death = FALSE
	name = "Engineer Trainee sleeper"
	mob_name = "Engineer Trainee"
	description = "Experiment with power production and atmospherics, including an unexplodable Supermatter Crystal"
	flavour_text = "You are an engineer trainee in the Engineer Training Facility. Experiment with construction, power prudction and atmospherics to better your understanding of all facets of engineering without any worries about destroying the station"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	assignedrole = "Engineer Trainee"
	outfit = /datum/outfit/engineer_trainee
	del_types = list() // Necessary to prevent del_types from removing radio!
	allow_species_pick = TRUE
	skin_tone = 255

/obj/effect/mob_spawn/human/alive/engineer_trainee/Destroy()
	var/obj/structure/fluff/empty_sleeper/S = new /obj/structure/fluff/empty_sleeper(get_turf(src))
	S.setDir(dir)
	. = ..()

// Modsuits

/obj/item/mod/control/pre_equipped/advanced/trainee
	applied_cell = /obj/item/stock_parts/cell/high/slime

/obj/item/mod/control/pre_equipped/engineering/trainee
	theme = /datum/mod_theme/engineering/trainee
	applied_cell = /obj/item/stock_parts/cell/high/slime

/obj/item/mod/control/pre_equipped/atmospheric/trainee
	applied_cell = /obj/item/stock_parts/cell/high/slime

// Radio

/obj/item/radio/headset/headset_eng_trainee
	name = "engineering trainee radio headset"
	desc = "Let's the crystal tell you when it's angry"
	icon_state = "eng_headset"
	item_state = "headset"
	ks1type = /obj/item/encryptionkey/headset_engineer_training

/obj/item/radio/headset/headset_eng_trainee/New()
	. = ..()
	freqlock = TRUE
	set_frequency(ENG_TRNE_FREQ)

// lockers

/obj/structure/closet/secure_closet/atmos_personal/trainee

/obj/structure/closet/secure_closet/atmos_personal/trainee/populate_contents()
	new /obj/item/cartridge/atmos(src)
	new /obj/item/storage/toolbox/mechanical(src)
	if(prob(50))
		new /obj/item/storage/backpack/industrial/atmos(src)
	else
		new /obj/item/storage/backpack/satchel_atmos(src)
	new /obj/item/storage/backpack/duffel/atmos(src)
	new /obj/item/extinguisher(src)
	new /obj/item/grenade/gas/oxygen(src)
	new /obj/item/grenade/gas/oxygen(src)
	new /obj/item/clothing/suit/storage/hazardvest/staff(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/tank/internals/emergency_oxygen/engi(src)
	new /obj/item/holosign_creator/atmos(src)
	new /obj/item/watertank/atmos(src)
	new /obj/item/clothing/suit/fire/atmos(src)
	new /obj/item/clothing/head/hardhat/atmos(src)
	new /obj/item/clothing/glasses/meson/engine(src)
	new /obj/item/rpd(src)

// Soda Fountain
/obj/item/circuitboard/chem_dispenser/soda/engineer_training
	build_path = /obj/machinery/chem_dispenser/soda/engineer_training

/obj/machinery/chem_dispenser/soda/engineer_training
	dispensable_reagents = list("coffee", "hot_ramen")

/obj/machinery/chem_dispenser/soda/engineer_training/Initialize(mapload)
	. = ..()
	QDEL_LIST_CONTENTS(component_parts)
	component_parts += new /obj/item/circuitboard/chem_dispenser/soda/engineer_training(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new cell_type(null)
	RefreshParts()

// Alien Cache

/obj/item/salvage/ruin/nanotrasen/alien
	name = "lost research notes"
	desc = "A collection of research notes bearing a Nanotrasen logo.\
			The disorgenized writing describes mind bending concepts along with maddened raving you cannot make sense of.\
			And the dates recorded randomly vary from the distant past to the far future"

/obj/item/salvage/ruin/nanotrasen/alien/Initialize(mapload)
	. = ..()
	origin_tech = "alien=8;bluespace=8"

/obj/machinery/power/alien_cache
	name = "Alien Technology Cache"
	icon = 'icons/obj/machines/alien_cache.dmi'
	icon_state = "base"
	base_icon_state = "base"
	power_state = NO_POWER_USE
	density = TRUE
	interact_offline = TRUE
	luminosity = 1
	pixel_x = -160	//many tiles
	pixel_y = 0
	/// Amount of power being consumed (Watts)
	var/consuming = 0
	/// The type of the highetst area in the local hirarchy(That isn't a prototype)
	var/parent_area_type
	/// Total amount of energy invested in decyphering (Joules)
	var/total_energy = 0
	/// The types of the rewards you get upon fully decyphering the cache(random generation on init)
	var/list/possible_contents = list()

/obj/machinery/power/alien_cache/Initialize(mapload)
	. = ..()
	if(!powernet)
		connect_to_network()

	AddComponent(/datum/component/multitile, 10, list(
		list(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,	   		   1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,	   		   1, 1, 1, 1, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,	   		   1, 1, 1, 1, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,	   		   1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, MACH_CENTER,	   1, 1, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		list(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	   		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	))

	parent_area_type = (get_area(src)).type

	if(parent_area_type in subtypesof(/area/ruin))
		// figure out which ruin we are on
		while(!(type2parent(parent_area_type) in GLOB.ruin_prototypes))
			parent_area_type = type2parent(parent_area_type)

	else if(parent_area_type in subtypesof(/area/station))
		parent_area_type = /area/station
	else
		parent_area_type = null

/obj/machinery/power/alien_cache/proc/open_cache()
	var/cache_turf = get_turf(src)
	for(var/i in 1 to 5)
		cache_turf = get_step(cache_turf, NORTH)
	new /obj/item/salvage/ruin/nanotrasen/alien(cache_turf)
	update_icon()

/obj/machinery/power/alien_cache/update_icon()
	. = ..()
	if(total_energy >= DECYPHER_ENERGY)
		icon_state = "decyphered"


/obj/machinery/power/alien_cach/connect_to_network()
	. = ..()
	if(.)
		update_icon()

/obj/machinery/power/alien_cache/process()
	if(powernet && total_energy < DECYPHER_ENERGY)
		consuming = get_surplus()
		consume_direct_power(consuming)
		// power consumed in Watts and a tick is 2 seconds, so 1 Watt tick is 2 Joules.
		total_energy += 2 * consuming
		// Chance for causing a supermatter event rises in proportion to total energy. between 1/10 and 1/5 minutes, increasing with decyphering progress.
		if(prob((1 / 300) + (total_energy / ( 300 * DECYPHER_ENERGY))))
			for(var/obj/super_maybe in GLOB.poi_list)
				if(((get_area(super_maybe)).type in typesof(parent_area_type)) && (super_maybe.type in typesof(/obj/machinery/atmospherics/supermatter_crystal)))
					var/obj/machinery/atmospherics/supermatter_crystal/supermatter = super_maybe
					if(!supermatter.event_active)
						supermatter.radio.autosay("<span class='reallybig'>Interdimensional interference detected</span>",name, supermatter.damage_channel)
						// alpha and sierra tier probability increases with power consumption
						var/list/events = list(/datum/supermatter_event/delta_tier = 40,
								/datum/supermatter_event/charlie_tier = 40,
								/datum/supermatter_event/bravo_tier = 15,
								/datum/supermatter_event/alpha_tier = 5 * (consuming / (5 MW)),
								/datum/supermatter_event/sierra_tier = 1 * (consuming / (1 MW)),
								)

						var/datum/supermatter_event/event = pick(subtypesof(pickweight(events)))
						supermatter.run_event(event)
						supermatter.make_next_event_time()
						break
		if(total_energy >= DECYPHER_ENERGY)
			open_cache()
