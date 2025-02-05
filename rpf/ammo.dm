
#define BULLET_DAMAGE		80
#define BULLET_PENETRATION	100
/*--------\
| Bullets |
\--------*/
/*Jones - To make it sane to work with ive set up this file so  you can  search and find what you want.
right underneeeth a casing the bullet projectile should exist not the other way around
 */



//PISTOL AND MAGNUM CATRIDGES/

//9mm/
/obj/item/ammo_casing/bullet/rpf/praetor
	name = "Short, worn brass casing"
	desc = " An Simple short 9x19mm round it is stamped with the letter A"
	projectile_type = /obj/projectile/bullet/rpf
	caliber = "9x19mm"
	icon = 'rpf/bullets_nu.dmi'
	icon_state = "praetor"
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0
	force = 20

/obj/projectile/bullet/rpf
	name = "Pistol bullet"
	desc = " An Simple short 9x19mm round it is stamped with the letter A"
	damage = BULLET_DAMAGE
	damage_type = BRUTE
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/bullet/rpf/praetor
	range = 16
	jitter = 5
	eyeblur = 3
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_SHOT
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	armor_penetration = BULLET_PENETRATION
	speed = 0.3
	accuracy = 30 //Lower accuracy than an arrow.

//40 Super//
/obj/item/ammo_casing/bullet/rpf/invictus
	name = "Short, snub and cracked brass casing.."
	desc = "A simple short 10.2x25mm it is stamped with the letters A and M"
	projectile_type =/obj/projectile/bullet/rpf/invictus
	caliber = "10.2x25mm"
	icon_state = "super"
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0
	force = 20

/obj/projectile/bullet/rpf/invictus
	name = "Magnum bullet"
	desc = "A simple short 10.2x25mm it is stamped with the letters A and M"
	damage = 84
	damage_type = BRUTE
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/bullet/rpf/invictus
	range = 16
	jitter = 5
	eyeblur = 3
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_SHOT
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	armor_penetration = BULLET_PENETRATION
	speed = 0.3
	accuracy = 30 //Lower accuracy than an arrow.

//RIFLE CaTRIDGES//

//6.5/
/obj/item/ammo_casing/bullet/rpf/Centurion
	name = "Short, slightly  grooved brass casing."
	desc = " An short 6.5x53mm round its stamped with the letter A."
	projectile_type = /obj/projectile/bullet/rpf/Centurion
	caliber = "6.5x53mm"
	icon_state = "centurion"
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0
	force = 20

/obj/projectile/bullet/rpf/Centurion
	name = "Rifle bullet"
	desc = " An short 6.5x53mm round its stamped with the letter A."
	damage = 85
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/bullet/rpf/Centurion
	range = 20
	jitter = 5
	eyeblur = 3
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	armor_penetration = BULLET_PENETRATION
	speed = 0.2
	accuracy = 55

//13.2/
/obj/item/ammo_casing/bullet/rpf/Regalis
	name = "Long, exquisitely polished brass casing."
	desc = "A long 13.2x70mm round it is stamped with the letter A"
	projectile_type = /obj/projectile/bullet/rpf/Regalis
	caliber = "13.2x70mm"
	icon_state = "regalis"
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0
	force = 20

/obj/projectile/bullet/rpf/Regalis
	name = "Rifle bullet"
	desc = "A long 13.2x70mm round it is stamped with the letter A"
	damage = 95
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/bullet/rpf/Regalis
	range = 20
	jitter = 5
	eyeblur = 3
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	armor_penetration = BULLET_PENETRATION
	speed = 0.2
	accuracy = 55

#undef BULLET_DAMAGE

#undef BULLET_PENETRATION
