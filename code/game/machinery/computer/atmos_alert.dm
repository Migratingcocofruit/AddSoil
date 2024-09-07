/obj/machinery/computer/atmos_alert
	name = "atmospheric alert computer"
	desc = "Used to access the station's atmospheric sensors."
	circuit = /obj/item/circuitboard/atmos_alert
	icon_keyboard = "atmos_key"
	icon_screen = "alert:0"
	light_color = LIGHT_COLOR_CYAN
	// List of alarms and their state in areas. This is sent to TGUI
	var/list/alarm_cache
	var/parent_area_type = null

/obj/machinery/computer/atmos_alert/Initialize(mapload)
	. = ..()
	alarm_cache = list()
	alarm_cache["minor"] = list()
	alarm_cache["priority"] = list()

	parent_area_type = (get_area(src)).type

	if(parent_area_type in subtypesof(/area/ruin))
		// figure out which ruin we are on
		while(!(type2parent(parent_area_type) in GLOB.ruin_prototypes))
			parent_area_type = type2parent(parent_area_type)

	else if(parent_area_type in subtypesof(/area/station))
		parent_area_type = /area/station
	else
		parent_area_type = null


/obj/machinery/computer/atmos_alert/process()
	// This is relatively cheap because the areas list is pretty small
	for(var/obj/machinery/alarm/AirAlarm as anything in GLOB.air_alarms)
		if(!((get_area(AirAlarm)).type in typesof(parent_area_type)) || AirAlarm.z != z)
			continue // Not an area we monitor, or outside our z-level
		if(!AirAlarm.report_danger_level)
			continue
		switch(AirAlarm.alarm_area.atmosalm)
			if(ATMOS_ALARM_DANGER)
				alarm_cache["priority"] |= AirAlarm.alarm_area.name
				alarm_cache["minor"] -= AirAlarm.alarm_area.name
			if(ATMOS_ALARM_WARNING)
				alarm_cache["priority"] -= AirAlarm.alarm_area.name
				alarm_cache["minor"] |= AirAlarm.alarm_area.name
			else
				alarm_cache["priority"] -= AirAlarm.alarm_area.name
				alarm_cache["minor"] -= AirAlarm.alarm_area.name

	update_icon()

/obj/machinery/computer/atmos_alert/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/atmos_alert/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosAlertConsole", name)
		ui.open()

/obj/machinery/computer/atmos_alert/ui_data(mob/user)
	return alarm_cache

/obj/machinery/computer/atmos_alert/update_icon_state()
	if(!length(alarm_cache)) // This happens if were mid init
		icon_screen = "alert:0"
		return ..()


	if(length(alarm_cache["priority"]))
		icon_screen = "alert:2"
	else if(length(alarm_cache["minor"]))
		icon_screen = "alert:1"
	else
		icon_screen = "alert:0"
	..()
