// ID

/obj/item/card/id/engineer_trainee
	name = "Engineer Trainee ID"
	desc = "An identification card for an engineer trainee"
	icon_state = "engineering"
	access = list(ACCESS_ENGINEER_TRAINEE, ACCESS_CE, ACCESS_MINERAL_STOREROOM, ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
	untrackable = TRUE

//outfit

/datum/outfit/engineer_trainee
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	back = /obj/item/mod/control/pre_equipped/advanced/trainee
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
	description = "Experiment with power production and atmospherics"
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper"
	flavour_text = "You are an engineer trainee"
	assignedrole = "Engineer Trainee"
	outfit = /datum/outfit/engineer_trainee

	del_types = list() // Necessary to prevent del_types from removing radio!

	allow_species_pick = TRUE
	skin_tone = 255


// Modsuits

/obj/item/mod/control/pre_equipped/advanced/trainee
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

// Camera Console
/obj/item/circuitboard/camera/engineering/enginner_training
	build_path = /obj/machinery/computer/security/engineering/engineer_training

/obj/item/circuitboard/camera/engineering/enginner_training/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/machinery/computer/security/engineering/engineer_training
	name = "engineer training camera monitor"
	network = list("Engineer Training Power Alarms","Engineer Training Atmos Alarms","Engineer Training Fire Alarms")
	circuit = /obj/item/circuitboard/camera/engineering/enginner_training
