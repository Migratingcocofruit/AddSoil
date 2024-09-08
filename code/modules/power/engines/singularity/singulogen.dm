/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "Gravitational Singularity Generator"
	desc = "An odd device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	power_state = NO_POWER_USE
	resistance_flags = FIRE_PROOF
	var/energy = 0
	var/creation_type = /obj/singularity
	var/safe = FALSE

/obj/machinery/the_singularitygen/process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		if(!safe || in_safe_field())
			message_admins("A [creation_type] has been created at [x], [y], [z] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
			investigate_log("A [creation_type] has been created at [x], [y], [z]","singulo")

			var/obj/singularity/S = new creation_type(T, 50)
			transfer_fingerprints_to(S)
			if(src) qdel(src)

/obj/machinery/the_singularitygen/proc/in_safe_field()
	var/turf/T = get_turf(src)
	var/obj/machinery/field/generator/G = null
	var/obj/machinery/field/containment/F = null
	for(var/dir in list(NORTH,SOUTH,EAST,WEST))
		var/right_angle = dir == NORTH || dir == SOUTH ? EAST : NORTH
		for(var/dist in 0 to 9) // checks out to 10 tiles away for an active safe field generator
			T = get_step(T, dir)

			F = locate(/obj/machinery/field/containment) in T
			if(F)
				while(!G)
					T = get_step(T, right_angle)
					G = locate(/obj/machinery/field/generator) in T

			G = locate(/obj/machinery/field/generator) in T
			if(G)
				if(istype(G, /obj/machinery/field/generator/safe))
					var/obj/machinery/field/generator/safe/GS = G
					return (x <= GS.extreme_coords.max_x && x >= GS.extreme_coords.min_x && y <= GS.extreme_coords.max_y && y >= GS.extreme_coords.min_y)
				else
					return FALSE

/obj/machinery/the_singularitygen/wrench_act(mob/living/user, obj/item/wrench/W)
	. = TRUE
	anchored = !anchored
	if(!W.use_tool(src, user, 2 SECONDS, 0, 50))
		return
	if(anchored)
		user.visible_message("[user.name] secures [src] to the floor.", \
			"You secure [src] to the floor.", \
			"You hear a ratchet.")
		src.add_hiddenprint(user)
	else
		user.visible_message("[user.name] unsecures [src] from the floor.", \
			"You unsecure [src.name] from the floor.", \
			"You hear a ratchet.")

/obj/machinery/the_singularitygen/safe
	safe = TRUE
