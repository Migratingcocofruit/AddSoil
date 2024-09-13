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
	back = /obj/item/mod/control/pre_equipped/engineer/trainee
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

/obj/item/mod/control/pre_equipped/engineer/trainee
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

/obj/machinery/power/alien_cache
	name = "Alien Technology Cache"
	icon = 'icons/obj/machines/alien_cache.dmi'
	icon_state = "alien_cache"
	base_icon_state = "alien_cache"
	power_state = NO_POWER_USE
	density = TRUE
	interact_offline = TRUE
	luminosity = 1

/obj/machinery/power/alien_cache/Initialize(mapload)
	. = ..()
	if(!powernet)
		connect_to_network()

	AddComponent(/datum/component/multitile, 1, list(
		list(1, 1, 1, 1, 1, 1,1,		   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,1,		   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,1	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,1	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,1	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,1	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1, MACH_CENTER, 1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
		list(1, 1, 1, 1, 1, 1,0	,	   1, 1, 1, 1, 1, 1),
	))

/obj/machinery/power/bluespace_tap/connect_to_network()
	. = ..()
	if(.)
		update_icon()
