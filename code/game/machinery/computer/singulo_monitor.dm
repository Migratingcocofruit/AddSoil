/obj/machinery/computer/singulo_monitor
	name = "singularity monitoring console"
	desc = "Used to monitor singularities."
	icon_keyboard = "power_key"
	icon_screen = "smmon_0"
	circuit = /obj/item/circuitboard/singulo_monitor
	light_color = LIGHT_COLOR_YELLOW
	/// Cache-list of all singularities
	var/list/singularities
	/// Last energy level of the singularity so we know if it went up or down between cycles
	var/last_energy
	/// Last size of the singularity so we know if it went up or down between cycles
	var/last_size
	/// Reference to the active singularity
	var/obj/singularity/active
	/// Channel to send warning through to the engineers
	var/warning_channel = "Engineering"
	/// Channel to send breach containment alert
	var/breach_channel = "Common"
	/// Radio for sending announcements
	var/obj/item/radio/singu_radio
	/// List of field generators containing the singulo
	var/list/field_gens

/obj/machinery/computer/singulo_monitor/Initialize(mapload)
	. = ..()
	singu_radio = new(src)
	singu_radio.listening = FALSE
	singu_radio.follow_target = src
	singu_radio.config(list("[warning_channel]" = 0, "[breach_channel]" = 0))


/obj/machinery/computer/singulo_monitor/Destroy()
	active = null
	qdel(singu_radio)
	return ..()

/obj/machinery/computer/singulo_monitor/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/singulo_monitor/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/singulo_monitor/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/singulo_monitor/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SingularityMonitor", name)
		ui.open()

/obj/machinery/computer/singulo_monitor/ui_data(mob/user)
	var/list/data = list()

	if(istype(active))
		var/turf/T = get_turf(active)
		// If we somehow dissipate during this proc, handle it somewhat
		if(!T)
			active = null
			refresh()
			return

		data["active"] = TRUE
		data["singulo_stage"] = (active.current_size + 1) / 2
		data["singulo_potential_stage"] = (active.allowed_size + 1) / 2
		data["singulo_energy"] = active.energy

		switch(active.allowed_size)
			if(STAGE_ONE)
				data["singulo_high"] = STAGE_TWO_THRESHOLD
				data["singulo_low"] = 0
			if(STAGE_TWO)
				data["singulo_high"] = STAGE_THREE_THRESHOLD
				data["singulo_low"] = STAGE_TWO_THRESHOLD
			if(STAGE_THREE)
				data["singulo_high"] = STAGE_FOUR_THRESHOLD
				data["singulo_low"] = STAGE_THREE_THRESHOLD
			if(STAGE_FOUR)
				data["singulo_high"] = STAGE_FIVE_THRESHOLD
				data["singulo_low"] = STAGE_FOUR_THRESHOLD
			else
				data["singulo_high"] = STAGE_SIX_THRESHOLD
				data["singulo_low"] = STAGE_FIVE_THRESHOLD

		var/list/generators = list()
		var/index = 1
		for(var/obj/machinery/field/generator/generator in field_gens)
			generators.Add(list(list(
				"charge" = generator.power,
				"gen_index" = index++
			)))
		data["generators"] = generators

	else
		var/list/singulos = list()
		for(var/I in singularities)
			var/obj/singularity/S = I
			var/area/A = get_area(S)
			if(!A)
				continue

			singulos.Add(list(list(
				"area_name" = A.name,
				"energy" = S.energy,
				"stage" = (S.current_size + 1) / 2,
				"singularity_id" = S.singulo_id
			)))

		data["active"] = FALSE
		data["singularities"] = singulos

	return data

/**
  * Supermatter List Refresher
  *
  * This proc loops through the list of supermatters in the atmos SS and adds them to this console's cache list
  */
/obj/machinery/computer/singulo_monitor/proc/refresh()
	singularities = list()
	var/turf/T = get_turf(ui_host()) // Get the UI host incase this ever turned into a singularity monitoring module for AIs to use or something
	if(!T)
		return
	for(var/obj/singularity/S in GLOB.singularities)
		// not within coverage, not on a tile.
		if(!(is_station_level(S.z) || is_mining_level(S.z) || atoms_share_level(S, T) || !issimulatedturf(S.loc) || istype(active)))
			continue
		singularities.Add(S)

	if(!(active in singularities))
		active = null

/obj/machinery/computer/singulo_monitor/proc/send_alerts()
	// Breach alerts
	if(active.current_size > (last_size + 2) || active.current_size >= STAGE_FIVE)// We should only see a singulo grow 2 stages at once when breaching containment.
		singu_radio.autosay("<b>Warning: The singularity in [get_area(active)] has exceeded containment field limits!</b>", name, breach_channel)
	for(var/obj/machinery/field/generator/gen in field_gens)
		if(!gen || (gen.active < 2))
			singu_radio.autosay("<b>Warning: The containment field of the singularity in [get_area(active)] has been disabled!</b>", name, breach_channel)
			return

	if(active.energy > last_energy)// We only want to give warnings while the situation is getting worse.
		if(active.energy >= (STAGE_FIVE_THRESHOLD - 100))
			singu_radio.autosay("<b>Warning: The singularity in [get_area(active)] approaching an uncontainable level!</b>", name, warning_channel)
			return
		var/warning_threshold
		// The field can contain energy of up to 1 stage above the current one.
		switch(active.current_size)
			if(STAGE_ONE)
				warning_threshold = STAGE_THREE_THRESHOLD
			if(STAGE_TWO)
				warning_threshold = STAGE_FOUR_THRESHOLD
			else
				warning_threshold = 0
		// Stage 5 and above is not containable regardless, so we don't care about them in this case.
		if(warning_threshold && (active.energy >= (warning_threshold - 100)))
			singu_radio.autosay("<b>Warning: The singularity in [get_area(active)] is nearing containment field limits!</b>", name, warning_channel)
			return




/obj/machinery/computer/singulo_monitor/process()
	if(stat & (NOPOWER|BROKEN))
		return FALSE
	if(active)
		if(last_energy != active.energy)
			send_alerts()
			last_size = active.current_size
			last_energy = active.energy
			icon_screen = "singumon_[last_energy]"
			update_icon()

	return TRUE

/obj/machinery/computer/singulo_monitor/ui_act(action, params)
	if(..())
		return

	if(stat & (BROKEN|NOPOWER))
		return

	. = TRUE

	switch(action)
		if("refresh")
			refresh()

		if("view")
			var/newuid = text2num(params["view"])
			for(var/obj/singularity/S in singularities)
				if(S.singulo_id == newuid)
					active = S
					if(active)
						field_gens = active.find_field_gens()
					break

		if("back")
			active = null
