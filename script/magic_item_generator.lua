--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: no max line length
-- luacheck: globals aSpecialMaterials aMeleeWeaponAbilities aRangedWeaponAbilities aAmmunitionAbilities aArmorAbilities aShieldAbilities aItemSize
-- luacheck: globals aDamageDice aPositionDamage aAltDamageDice1 aAltDamageDice2 aAltDamageDice3 aWeightMultiplier generateMagicItem
-- luacheck: globals ItemManager.isArmor ItemManager.isShield ItemManager.isWeapon addRangedEffect addAmmoEffect cleanAbility getAbilities getAbilityList
-- luacheck: globals getItemType

aSpecialMaterials = {
	['Adamantine'] = {
		sStringName = 'adamantine',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 48, PRPG Core Rulebook pg. 154</p><p>Mined from rocks that fell from the heavens, this ultrahard metal adds to the quality of a weapon or suit of armor. Weapons fashioned from adamantine have a natural ability to bypass hardness when sundering weapons or attacking objects, ignoring hardness less than 20. Armor made from adamantine grants its wearer damage reduction of 1/— if it’s light armor, 2/— if it’s medium armor, and 3/— if it’s heavy armor. Adamantine is so costly that weapons and armor made from it are always of masterwork quality; the masterwork cost is included in the prices given below. Thus, adamantine weapons and ammunition have a +1 enhancement bonus on attack rolls, and the armor check penalty of adamantine armor is lessened by 1 compared to ordinary armor of its type. Items without metal parts cannot be made from adamantine. An arrow could be made of adamantine, but a quarterstaff could not.</p>',
	},
	['Alchemical silver'] = {
		sStringName = 'silver',
		bMeleeWeapon = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 48, PRPG Core Rulebook pg. 155</p><p>A complex process involving metallurgy and alchemy can bond silver to a weapon made of steel so that it bypasses the damage reduction of creatures such as lycanthropes.</p><p>On a successful attack with a silvered slashing or piercing weapon, the wielder takes a –1 penalty on the damage roll (with a minimum of 1 point of damage). The alchemical silvering process can’t be applied to nonmetal items, and it doesn’t work on rare metals such as adamantine, cold iron, and mithral.</p>',
	},
	['Angelskin'] = {
		sStringName = 'angelskin',
		bLightArmor = true,
		bMediumArmor = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 48</p><p>The preserved skin of an angel retains a portion of celestial grace and can be crafted into leather, hide, or studded leather armor. Angelskin radiates a moderate good aura that masks malign auras. Any evil aura radiated by the wearer is reduced in strength by 10 Hit Dice. Auras reduced below 1 Hit Die can’t be detected by means such as detect evil; the creature doesn’t detect as evil, though this has no effect on other aspects of the creature’s alignment. For example, a weak chaotic creature wearing angelskin armor detects as chaotic, but not evil.</p><p>Spells and supernatural abilities that have special effects when cast on or used against creatures with evil alignments (even beneficial effects) have a 20% chance of treating an evil wearer as neutral instead. Ongoing effects such as smite evil make this roll the first time they are used against the creature; if the effect treats the target as neutral, it does so for the remainder of the effect’s duration. If the ongoing effect applies to an area and the wearer leaves that area, the percentage chance should be rolled again. Permanent magic items such as holy weapons always treat the wearer as evil. Armor constructed from angelskin is always of masterwork quality.</p>',
	},
	['Blood crystal'] = {
		sStringName = 'blood crystal',
		bMeleeWeapon = true,
		bAmmunition = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 48</p><p>Mysterious radiation deep below the surface of the earth warps once-ordinary quartz into bloodcraving stone. If an attack with a piercing or slashing blood crystal weapon hits a target suffering from a bleed effect, the creature takes 1 additional point of damage from the attack as the blood crystal drains blood from the wound. This applies even if the creature was taking bleed damage before the attack with the blood crystal weapon. This does not increase the amount of the bleed effect.</p><p>Unfed blood crystal has a pale pink hue, darkening toward deep crimson as it becomes saturated with blood. Piercing or slashing weapons composed entirely or partially of metal can be made from blood crystal. Unworked blood crystal has a value of 500 gp per pound. Weapons made with blood crystal have one-half the normal hit points. Armor and shields cannot be made of blood crystal, as they would feed on the wearer’s own wounds.</p>',
	},
	['Cold iron'] = {
		sStringName = 'cold iron',
		bMeleeWeapon = true,
		bAmmunition = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 49, PRPG Core Rulebook pg. 154</p><p>This iron, mined deep underground and known for its effectiveness against demons and fey creatures, is forged at a lower temperature to preserve its delicate properties. Weapons made of cold iron cost twice as much to make as their normal counterparts. Also, adding any magical enhancements to a cold iron weapon increases its price by 2,000 gp. This increase is applied the first time the item is enhanced, not once per ability added.</p><p>Items without metal parts cannot be made from cold iron. An arrow could be made of cold iron, but a quarterstaff could not. A double weapon with one cold iron half costs 50% more than normal.</p>',
	},
	['Darkleaf cloth'] = {
		sStringName = 'darkleaf cloth',
		bLightArmor = true,
		bMediumArmor = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 49, Advanced Race Guide pg. 27</p><p>Darkleaf cloth is a special form of flexible material made by weaving together leaves and thin strips of bark from darkwood trees, then treating the resulting fabric with special alchemical processes. The resulting material is tough as cured hide but much lighter, making it an excellent material from which to create armor. Spell failure chances for armors made from darkleaf cloth decrease by 10% (to a minimum of 5%), maximum Dexterity bonuses increase by 2, and armor check penalties decrease by 3 (to a minimum of 0).</p><p> An item made from darkleaf cloth weighs half as much as the same item made from leather, furs, or hides. Items not primarily constructed of leather, fur, or hide are not meaningfully affected by being partially made of darkleaf cloth. As such, padded armor, leather armor, studded leather armor, and hide armor can be made out of darkleaf cloth (although other types of armor made of leather or hide might be possible). Because darkleaf cloth remains flexible, it cannot be used to construct rigid items such as shields or metal armors. Armors fashioned from darkleaf cloth are always masterwork items; the masterwork cost is included in the listed prices.</p>',
	},
	['Darkwood'] = {
		sStringName = 'darkwood',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 49, PRPG Core Rulebook pg. 154</p><p>This rare magic wood is as hard as normal wood but very light. Any wooden or mostly wooden item (such as a bow or spear) made from darkwood is considered a masterwork item and weighs only half as much as a normal wooden item of that type. Items not normally made of wood or only partially of wood (such as a battleaxe or a mace) either cannot be made from darkwood or do not gain any special benefit from being made of darkwood. The armor check penalty of a darkwood shield is lessened by 2 compared to an ordinary shield of its type. To determine the price of a darkwood item, use the original weight but add 10 gp per pound to the price of a masterwork version of that item.<p>',
	},
	['Dragonhide'] = {
		sStringName = 'dragonhide',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 49, PRPG Core Rulebook pg. 154</p><p>Armorsmiths can work with the hides of dragons to produce armor or shields of masterwork quality. One dragon produces enough hide to make a single suit of masterwork hide armor for a creature one size category smaller than the dragon. By selecting only choice scales and bits of hide, an armorsmith can produce one suit of masterwork banded mail for a creature two sizes smaller, one suit of masterwork half-plate for a creature three sizes smaller, or one masterwork breastplate or suit of full plate for a creature four sizes smaller. In each case, enough hide is available to produce a light or heavy masterwork shield in addition to the armor, provided that the dragon is Large or larger. If the dragonhide comes from a dragon that had immunity to an energy type, the armor is also immune to that energy type, although this does not confer any protection to the wearer. If the armor or shield is later given the ability to protect the wearer against that energy type, the cost to add such protection is reduced by 25%.<p><p>Because dragonhide armor isn’t made of metal, druids can wear it without penalty.</p><p>Dragonhide armor costs twice as much as masterwork armor of that type, but it takes no longer to make than ordinary armor of that type (double all Craft results).</p>',
	},
	['Eel hide'] = {
		sStringName = 'eel hide',
		bLightArmor = true,
		bMediumArmor = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 50</p><p>This supple material offers as much protection as leather, but is more flexible and resistant to electricity. Leather, hide, or studded leather armor can be produced with eel hide. The armor check penalty of such armor is reduced by 1 (to a minimum of 0) and the maximum Dexterity bonus of the armor is increased by 1. Additionally, wearing eel hide grants the wearer electricity resistance 2. Armor crafted from eel hide is always considered masterwork, and the masterwork costs are included in the listed prices.</p>',
	},
	['Elysian bronze'] = {
		sStringName = 'elysian bronze',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 50</p><p>First crafted in the deeps of time by the titans and bestowed as gifts to monster-slaying heroes among the lesser races, Elysian bronze retains the brazen coloration of its namesake but is as hard as steel. A weapon made of Elysian bronze adds a +1 bonus on weapon damage rolls against magical beasts and monstrous humanoids; this damage is multiplied on a critical hit. After a creature uses an Elysian bronze weapon to deal damage to a magical beast or monstrous humanoid, the wielder gains a +1 bonus on attack rolls against that specific creature type (for example, against chimeras, not all magical beasts) for the next 24 hours, or until the weapon deals damage to a different kind of magical beast or monstrous humanoid.</p><p>Armor made of Elysian bronze also protects its wearer against the natural weapons or unarmed strikes of magical beasts and monstrous humanoids, providing damage reduction as if it were adamantine (1/— for light armor, 2/— for medium armor, or 3/— for heavy armor). It does not provide this protection against creatures of other types.</p>',
	},
	['Fire-forged steel'] = {
		sStringName = 'fire forged steel',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 50</p><p>Dwarves stumbled across the secret of crafting fire-forged steel in an effort to make forge-friendly tools. It didn’t take them long to adapt its unique properties to arms and armor. Fire-forged steel channels heat in one direction to protect its wearer or wielder. When it is crafted into armor, heat is channeled away from the wearer, offering some limited protection. Armor crafted from fire-forged steel grants the wearer fire resistance 2.</p><p>Weapons crafted from fire-forged steel similarly channel heat away from the wearer; this does not grant the wielder energy resistance. Instead, the blade absorbs and channels heat to the parts of the weapon that contact enemies. If the weapon is exposed to 10 points or more of fire damage (such as from an opponent’s fireball or by holding it in a campfire for 1 full round), the weapon adds +1d4 points of fire damage to its attacks for the next 2 rounds. If the wielder is wearing fire-forged armor and using a fire-forged weapon, this bonus damage increases to 1d6 points of fire damage and lasts for 4 rounds. This bonus damage does not stack with fire damage from weapon enhancements such as flaming.</p>',
	},
	['Frost-forged steel'] = {
		sStringName = 'frost forged steel',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 50</p><p>This material is the same substance as fire-forged steel with a subtle difference in the alignment of the metal during crafting. Instead of channeling heat away from the wearer, it channels heat toward the wearer. Frost-forged steel works similarly to fire-forged steel, except its effects apply to cold damage rather than fire damage. This means frost-forged steel weapons are less useful than their fire-forged counterparts, as there are few nonmagical sources of cold that can quickly imbue it with enough cold energy to deal bonus damage.</p><p>Armor and weapons made from frost-forged steel are always considered masterwork, and the masterwork costs are included in the listed prices.</p>',
	},
	['Greenwood'] = {
		sStringName = 'greenwood',
		bMeleeWeapon = true,
		bAlwaysMasterwork = true,
		sAddDescription = '<p><b>Source:</b> Ultimate Equipment pg. 50</p><p>The secret of greenwood lies in its harvesting. Each length is taken, with leaves still attached, from a tree animated by a treant and cut with care to avoid the death of the tree. A dryad then speaks to and shapes the wood, coaxing the living green of the leaves into the grain of the wood itself. The resulting wood remains alive as long as it is doused with at least one gallon of water (plus 1 gallon for every 10 pounds of the item’s weight) once per week and allowed to rest for an hour in contact with fertile soil. Any wooden or mostly wooden item (such as a bow or spear) made from greenwood is considered a masterwork item. Items not normally made of wood or only partially of wood (such as a battleaxe or a mace) either cannot be made from greenwood or do not gain any special benefit from being made of greenwood.</p><p> When damp and in contact with fertile soil, living greenwood heals damage to itself at a rate of 1 hit point per hour, even repairing breaks and regrowing missing pieces. If the weapon has the broken condition, it is repaired during the first hour of contact with fertile soil. Greenwood items take only one-quarter damage from fire.</p><p>Greenwood can be altered or enhanced with wood-shaping magic such as ironwood, shape wood, and warp wood. The duration of any such effect on a greenwood item is doubled. To determine the price of a greenwood item, use the original weight but add 50 gp per pound to the price of a masterwork version of that item. Items made from darkwood cannot be made into greenwood.</p>',
	},
	['Griffon mane'] = { sStringName = 'griffon mane', bLightArmor = true, sAddDescription = '' },
	['Living steel'] = {
		sStringName = 'living steel',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		sAddDescription = '',
	},
	['Mithral'] = {
		sStringName = 'mithral',
		bLightArmor = true,
		bMediumArmor = true,
		bHeavyArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bRangedWeapon = true,
		bAmmunition = true,
		bAlwaysMasterwork = true,
		sAddDescription = '',
	},
	['Viridium'] = { sStringName = 'viridium', bMeleeWeapon = true, bAmmunition = true, sAddDescription = '' },
	['Whipwood'] = { sStringName = 'whipwood', bMeleeWeapon = true, bAmmunition = true, sAddDescription = '' },
	['Wyroot'] = { sStringName = 'wyroot', bMeleeWeapon = true, sAddDescription = '' },
	['Bone'] = {
		sStringName = 'bone',
		bLightArmor = true,
		bMediumArmor = true,
		bMeleeWeapon = true,
		bFragile = true,
		sAddDescription = '',
	},
	['Bronze'] = {
		sStringName = 'bronze',
		bLightArmor = true,
		bMediumArmor = true,
		bShield = true,
		bMeleeWeapon = true,
		bAmmunition = true,
		bFragile = true,
		sAddDescription = '',
	},
	['Gold'] = {
		sStringName = 'gold',
		bLightArmor = true,
		bMediumArmor = true,
		bMeleeWeapon = true,
		bFragile = true,
		sAddDescription = '',
	},
	['Obsidian'] = {
		sStringName = 'obsidian',
		bMeleeWeapon = true,
		bAmmunition = true,
		bFragile = true,
		sAddDescription = '',
	},
	['Stone'] = {
		sStringName = 'stone',
		bMeleeWeapon = true,
		bAmmunition = true,
		bFragile = true,
		sAddDescription = '',
	},
}

aMeleeWeaponAbilities = {
	['Advancing'] = {
		sStringName = 'advancing',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Allying'] = {
		sStringName = 'allying',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Anarchic'] = {
		sStringName = 'anarchic',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Axiomatic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: chaotic; IFT: ALIGN(lawful); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(lawful); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Anchoring'] = {
		sStringName = 'anchoring',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Axiomatic'] = {
		sStringName = 'axiomatic',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Anarchic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: lawful; IFT: ALIGN(chaotic); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(chaotic); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Bane'] = {
		sStringName = 'bane',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		aEffects = {},
		sSubSelectionLabel = 'Bane Type',
		aSubSelection = {
			['Aberations'] = {
				sStringName = 'aberations',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(aberation); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Animals'] = {
				sStringName = 'animals',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(animal); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Constructs'] = {
				sStringName = 'constructs',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(construct); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Dragons'] = {
				sStringName = 'dragons',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(dragon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Fey'] = {
				sStringName = 'fey',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(fey); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Humanoids'] = {
				sStringName = 'humanoid',
				sSubSubSelectionLabel = 'Humanoid Type',
				aEffects = {},
				aSubSubSelection = {
					['Dwarf'] = {
						sStringName = 'dwarf',
						aEffects = {
							{ sEffect = 'IFT: TYPE(dwarf); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Elf'] = {
						sStringName = 'elf',
						aEffects = { { sEffect = 'IFT: TYPE(elf); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Gnoll'] = {
						sStringName = 'gnoll',
						aEffects = {
							{ sEffect = 'IFT: TYPE(gnoll); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Gnome'] = {
						sStringName = 'gnome',
						aEffects = {
							{ sEffect = 'IFT: TYPE(gnome); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Goblinoid'] = {
						sStringName = 'goblinoid',
						aEffects = {
							{ sEffect = 'IFT: TYPE(goblinoid); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Halfling'] = {
						sStringName = 'halfling',
						aEffects = {
							{ sEffect = 'IFT: TYPE(halfling); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Human'] = {
						sStringName = 'human',
						aEffects = {
							{ sEffect = 'IFT: TYPE(human); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Orc'] = {
						sStringName = 'orc',
						aEffects = { { sEffect = 'IFT: TYPE(orc); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Reptilian'] = {
						sStringName = 'reptilian',
						aEffects = {
							{ sEffect = 'IFT: TYPE(reptilian); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
				},
			},
			['Magical Beasts'] = {
				sStringName = 'magical beasts',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{ sEffect = 'IFT: TYPE(magical beast); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
				},
			},
			['Monstrous Humanoids'] = {
				sStringName = 'monstrous humanoid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{ sEffect = 'IFT: TYPE(monstrous humanoid); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
				},
			},
			['Oozes'] = {
				sStringName = 'oozes',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(ooze); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Outsiders'] = {
				sStringName = 'outsiders',
				aEffect = {},
				sSubSubSelectionLabel = 'Outsider Type',
				aSubSubSelection = {
					['Air'] = {
						sStringName = 'air',
						aEffects = { { sEffect = 'IFT: TYPE(air); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Angel'] = {
						sStringName = 'angel',
						aEffects = {
							{ sEffect = 'IFT: TYPE(angel); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Archon'] = {
						sStringName = 'archon',
						aEffects = {
							{ sEffect = 'IFT: TYPE(archon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Demon'] = {
						sStringName = 'demon',
						aEffects = {
							{ sEffect = 'IFT: TYPE(demon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Devil'] = {
						sStringName = 'devil',
						aEffects = {
							{ sEffect = 'IFT: TYPE(devil); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Earth'] = {
						sStringName = 'earth',
						aEffects = {
							{ sEffect = 'IFT: TYPE(earth); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Fire'] = {
						sStringName = 'fire',
						aEffects = { { sEffect = 'IFT: TYPE(fire); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Native'] = {
						sStringName = 'native',
						aEffects = {
							{ sEffect = 'IFT: TYPE(native); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Water'] = {
						sStringName = 'water',
						aEffects = {
							{ sEffect = 'IFT: TYPE(water); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
				},
			},
			['Plants'] = {
				sStringName = 'plants',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(plant); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Undead'] = {
				sStringName = 'undead',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(undead); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Vermin'] = {
				sStringName = 'vermin',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(vermin); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
		},
	},
	['Benevolent'] = {
		sStringName = 'benevolent',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Brilliant energy'] = {
		sStringName = 'brilliant energy',
		iBonus = 4,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 16,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Called'] = {
		sStringName = 'called',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Conductive'] = {
		sStringName = 'conductive',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Corrosive'] = {
		sStringName = 'corrosive',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Corrosive burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Corrosive burst'] = {
		sStringName = 'corrosive burst',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'moderate evocation',
		aExclusions = { 'Corrosive' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Countering'] = {
		sStringName = 'countering',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Courageous'] = {
		sStringName = 'courageous',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 3,
		sAura = 'faint enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Cruel'] = {
		sStringName = 'cruel',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Cunning'] = {
		sStringName = 'cunning',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 6,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dancing'] = {
		sStringName = 'dancing',
		iBonus = 4,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 15,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Deadly'] = {
		sStringName = 'deadly',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Defending'] = {
		sStringName = 'defending',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Defiant'] = {
		sStringName = 'defiant',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dispelling'] = {
		sStringName = 'dispelling',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'strong abjuration',
		aExclusions = { 'Dispelling burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dispelling burst'] = {
		sStringName = 'dispelling burst',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong abjuration',
		aExclusions = { 'Dispelling' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Disruption'] = {
		sStringName = 'disruption',
		iBonus = 2,
		iCost = 0,
		bBludgeoning = true,
		iCL = 14,
		sAura = 'strong conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dueling'] = {
		sStringName = 'dueling',
		iBonus = 5,
		iCost = 14000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Flaming'] = {
		sStringName = 'flaming',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Flaming burst', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Flaming burst'] = {
		sStringName = 'flaming burst',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = { 'Flaming', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Frost'] = {
		sStringName = 'frost',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = { 'Icy burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Furious'] = {
		sStringName = 'furious',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF: CUSTOM(rage); ATK: 2; DMG: 2', nActionOnly = 1, nCritical = 0 } },
	},
	['Furyborn'] = {
		sStringName = 'furyborn',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Ghost touch'] = {
		sStringName = 'ghost touch',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMGTYPE: ghost touch', nActionOnly = 1, bAERequired = true, nCritical = 0 } },
	},
	['Glamered'] = {
		sStringName = 'glamered',
		iBonus = 1,
		iCost = 4000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate illusion',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Glorious'] = {
		sStringName = 'glorious',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Grayflame'] = {
		sStringName = 'grayflame',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 6,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Grounding'] = {
		sStringName = 'grounding',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IFT: TYPE(air); DMG: 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Guardian'] = {
		sStringName = 'guardian',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Heartseeker'] = {
		sStringName = 'heartseeker',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Holy'] = {
		sStringName = 'holy',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Unholy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: good; IFT: ALIGN(evil); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(evil); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Huntsman'] = {
		sStringName = 'huntsman',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Icy burst'] = {
		sStringName = 'icy burst',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Frost' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Igniting'] = {
		sStringName = 'igniting',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = { 'Flaming', 'Flaming burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMGO: 1d6 fire', nActionOnly = 1, nCritical = 0 } },
	},
	['Impact'] = {
		sStringName = 'impact',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		iCL = 9,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Impervious'] = {
		sStringName = 'impervious',
		iBonus = 1,
		iCost = 3000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Invigorating'] = {
		sStringName = 'invigorating',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Jurist'] = {
		sStringName = 'jurist',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 4,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Keen'] = {
		sStringName = 'keen',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'KEEN', nActionOnly = 1, bAERequired = true, nCritical = 0 } },
	},
	['Ki focus'] = {
		sStringName = 'ki focus',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Ki intensifying'] = {
		sStringName = 'ki intensifying',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Lifesurge'] = {
		sStringName = 'lifesurge',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Limning'] = {
		sStringName = 'limning',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Menacing'] = {
		sStringName = 'menacing',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate illusion',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Merciful'] = {
		sStringName = 'merciful',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMGTYPE: nonlethal; DMG: 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Mighty cleaving'] = {
		sStringName = 'mighty cleaving',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mimetic'] = {
		sStringName = 'mimetic',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Negating'] = {
		sStringName = 'negating',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Neutralizing'] = {
		sStringName = 'neutralizing',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IFT: TYPE(earth); 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Nullifying'] = {
		sStringName = 'nullifying',
		iBonus = 3,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Ominous'] = {
		sStringName = 'ominous',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Phase locking'] = {
		sStringName = 'phase locking',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Planar'] = {
		sStringName = 'planar',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Quenching'] = {
		sStringName = 'quenching',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IFT: TYPE(fire); 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Repositioning'] = {
		sStringName = 'repositioning',
		iBonus = 3,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Seaborne'] = {
		sStringName = 'seaborne',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Shock'] = {
		sStringName = 'shock',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = { 'Shocking burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Shocking burst'] = {
		sStringName = 'shocking burst',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Shock' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Speed'] = {
		sStringName = 'speed',
		iBonus = 3,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spell storing'] = {
		sStringName = 'spell storing',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 13,
		sAura = 'strong divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spellstealing'] = {
		sStringName = 'spellstealing',
		iBonus = 3,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong evocation and varies',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Stalking'] = {
		sStringName = 'stalking',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Thawing'] = {
		sStringName = 'thawing',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Throwing'] = {
		sStringName = 'throwing',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Thundering'] = {
		sStringName = 'thundering',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Transformative'] = {
		sStringName = 'transformative',
		iBonus = 0,
		iCost = 10000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Unholy'] = {
		sStringName = 'unholy',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Holy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: evil; IFT: ALIGN(good); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(good); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Valiant'] = {
		sStringName = 'valiant',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 5,
		sAura = 'faint divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IFT: CUSTOM(challenge target); DMG: 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Vicious'] = {
		sStringName = 'vicious',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Vorpal'] = {
		sStringName = 'vorpal',
		iBonus = 5,
		iCost = 0,
		bSlashing = true,
		iCL = 18,
		sAura = 'strong necromancy and transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Wounding'] = {
		sStringName = 'wounding',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'NIFT: CUSTOM(immune, critical); DMGO: 1', nActionOnly = 1, bAERequired = true, nCritical = 0 },
		},
	},
	['Disjoining'] = {
		sStringName = 'disjoining',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Harvesting'] = {
		sStringName = 'harvesting',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mythic bane'] = {
		sStringName = 'mythic bane',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IFT: TYPE(mythic); ATK: 2; DMG: 2d6', nActionOnly = 1, bAERequired = true, nCritical = 0 },
		},
	},
	['Potent'] = {
		sStringName = 'potent',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Sacrosanct'] = {
		sStringName = 'sacrosanct',
		iBonus = 2,
		iCost = 5000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
}

aRangedWeaponAbilities = {
	['Adaptive'] = {
		sStringName = 'adaptive',
		iBonus = 1,
		iCost = 1000,
		bBow = true,
		iCL = 1,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Impervious'] = {
		sStringName = 'impervious',
		iBonus = 1,
		iCost = 3000,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Glamered'] = {
		sStringName = 'glamered',
		iBonus = 1,
		iCost = 4000,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Allying'] = {
		sStringName = 'allying',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Bane'] = {
		sStringName = 'bane',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = 'Bane Type',
		aSubSelection = {
			['Aberations'] = {
				sStringName = 'aberations',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(aberation); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Animals'] = {
				sStringName = 'animals',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(animal); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Constructs'] = {
				sStringName = 'constructs',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(construct); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Dragons'] = {
				sStringName = 'dragons',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(dragon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Fey'] = {
				sStringName = 'fey',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(fey); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Humanoids'] = {
				sStringName = 'humanoid',
				sSubSubSelectionLabel = 'Humanoid Type',
				aEffects = {},
				aSubSubSelection = {
					['Dwarf'] = {
						sStringName = 'dwarf',
						aEffects = {
							{ sEffect = 'IFT: TYPE(dwarf); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Elf'] = {
						sStringName = 'elf',
						aEffects = { { sEffect = 'IFT: TYPE(elf); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Gnoll'] = {
						sStringName = 'gnoll',
						aEffects = {
							{ sEffect = 'IFT: TYPE(gnoll); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Gnome'] = {
						sStringName = 'gnome',
						aEffects = {
							{ sEffect = 'IFT: TYPE(gnome); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Goblinoid'] = {
						sStringName = 'goblinoid',
						aEffects = {
							{ sEffect = 'IFT: TYPE(goblinoid); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Halfling'] = {
						sStringName = 'halfling',
						aEffects = {
							{ sEffect = 'IFT: TYPE(halfling); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Human'] = {
						sStringName = 'human',
						aEffects = {
							{ sEffect = 'IFT: TYPE(human); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Orc'] = {
						sStringName = 'orc',
						aEffects = { { sEffect = 'IFT: TYPE(orc); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Reptilian'] = {
						sStringName = 'reptilian',
						aEffects = {
							{ sEffect = 'IFT: TYPE(reptilian); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
				},
			},
			['Magical Beasts'] = {
				sStringName = 'magical beasts',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{ sEffect = 'IFT: TYPE(magical beast); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
				},
			},
			['Monstrous Humanoids'] = {
				sStringName = 'monstrous humanoid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{ sEffect = 'IFT: TYPE(monstrous humanoid); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
				},
			},
			['Oozes'] = {
				sStringName = 'oozes',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(ooze); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Outsiders'] = {
				sStringName = 'outsiders',
				aEffect = {},
				sSubSubSelectionLabel = 'Outsider Type',
				aSubSubSelection = {
					['Air'] = {
						sStringName = 'air',
						aEffects = { { sEffect = 'IFT: TYPE(air); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Angel'] = {
						sStringName = 'angel',
						aEffects = {
							{ sEffect = 'IFT: TYPE(angel); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Archon'] = {
						sStringName = 'archon',
						aEffects = {
							{ sEffect = 'IFT: TYPE(archon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Demon'] = {
						sStringName = 'demon',
						aEffects = {
							{ sEffect = 'IFT: TYPE(demon); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Devil'] = {
						sStringName = 'devil',
						aEffects = {
							{ sEffect = 'IFT: TYPE(devil); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Earth'] = {
						sStringName = 'earth',
						aEffects = {
							{ sEffect = 'IFT: TYPE(earth); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Fire'] = {
						sStringName = 'fire',
						aEffects = { { sEffect = 'IFT: TYPE(fire); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
					},
					['Native'] = {
						sStringName = 'native',
						aEffects = {
							{ sEffect = 'IFT: TYPE(native); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
					['Water'] = {
						sStringName = 'water',
						aEffects = {
							{ sEffect = 'IFT: TYPE(water); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 },
						},
					},
				},
			},
			['Plants'] = {
				sStringName = 'plants',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(plant); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Undead'] = {
				sStringName = 'undead',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(undead); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
			['Vermin'] = {
				sStringName = 'vermin',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'IFT: TYPE(vermin); ATK: 2; DMG: 2d6', nActionOnly = 1, nCritical = 0 } },
			},
		},
	},
	['Called'] = {
		sStringName = 'called',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Conductive'] = {
		sStringName = 'conductive',
		iBonus = 1,
		iCost = 0,
		iCL = 16,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Conserving'] = {
		sStringName = 'conserving',
		iBonus = 1,
		iCost = 0,
		bFirearm = true,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Corrosive'] = {
		sStringName = 'corrosive',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Cruel'] = {
		sStringName = 'cruel',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Cunning'] = {
		sStringName = 'cunning',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Distance'] = {
		sStringName = 'distance',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Flaming'] = {
		sStringName = 'flaming',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = { 'Flaming burst', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Frost'] = {
		sStringName = 'frost',
		iBonus = 1,
		iCost = 0,
		iCL = 6,
		sAura = 'moderate divination',
		aExclusions = { 'Icy burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Huntsman'] = {
		sStringName = 'huntsman',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'moderate enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Jurist'] = {
		sStringName = 'jurist',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Limning'] = {
		sStringName = 'limning',
		iBonus = 1,
		iCost = 0,
		iCL = 6,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Lucky'] = {
		sStringName = 'lucky',
		iBonus = 1,
		iCost = 0,
		bFirearm = true,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Merciful'] = {
		sStringName = 'merciful',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMGTYPE: nonlethal; DMG: 1d6', nActionOnly = 1, nCritical = 0 } },
	},
	['Planar'] = {
		sStringName = 'planar',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Reliable'] = {
		sStringName = 'reliable',
		iBonus = 1,
		iCost = 0,
		bFirearm = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Returning'] = {
		sStringName = 'returning',
		iBonus = 1,
		iCost = 0,
		bThrown = true,
		iCL = 10,
		sAura = 'moderate illusion',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Seeking'] = {
		sStringName = 'seeking',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Shock'] = {
		sStringName = 'shock',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate divination',
		aExclusions = { 'Shocking burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Thundering'] = {
		sStringName = 'thundering',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d8 sonic, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Anarchic'] = {
		sStringName = 'anarchic',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = { 'Axiomatic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: chaotic; IFT: ALIGN(lawful); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(lawful); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Anchoring'] = {
		sStringName = 'anchoring',
		iBonus = 2,
		iCost = 0,
		bFirearm = true,
		bThrown = true,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Axiomatic'] = {
		sStringName = 'axiomatic',
		iBonus = 2,
		iCost = 0,
		iCL = 4,
		sAura = 'faint transmutation',
		aExclusions = { 'Anarchic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: lawful; IFT: ALIGN(chaotic); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(chaotic); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Corrosive burst'] = {
		sStringName = 'corrosive burst',
		iBonus = 2,
		iCost = 0,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = { 'Corrosive' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 acid, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Designating, lesser'] = {
		sStringName = 'lesser designating',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Endless ammunition'] = {
		sStringName = 'endless ammunition',
		iBonus = 2,
		iCost = 0,
		bBow = true,
		bCrossbow = true,
		iCL = 8,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Flaming burst'] = {
		sStringName = 'flaming burst',
		iBonus = 2,
		iCost = 0,
		iCL = 5,
		sAura = 'faint conjuration',
		aExclusions = { 'Flaming', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 fire, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Holy'] = {
		sStringName = 'holy',
		iBonus = 2,
		iCost = 0,
		iCL = 11,
		sAura = 'moderate abjuration',
		aExclusions = { 'Unholy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: good; IFT: ALIGN(evil); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(evil); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Icy burst'] = {
		sStringName = 'icy burst',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = { 'Frost' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 cold, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Igniting'] = {
		sStringName = 'igniting',
		iBonus = 2,
		iCost = 0,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = { 'Flaming', 'Flaming burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DMGO: 1d6 fire', nActionOnly = 1, nCritical = 0 } },
	},
	['Phase locking'] = {
		sStringName = 'phase locking',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Shocking burst'] = {
		sStringName = 'shocking burst',
		iBonus = 2,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate transmutation',
		aExclusions = { 'Shock' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMG: 1d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 2 },
			{ sEffect = 'DMG: 2d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 3 },
			{ sEffect = 'DMG: 3d10 electricity, critical', nActionOnly = 1, bAERequired = true, nCritical = 4 },
		},
	},
	['Stalking'] = {
		sStringName = 'stalking',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Unholy'] = {
		sStringName = 'unholy',
		iBonus = 2,
		iCost = 0,
		iCL = 11,
		sAura = 'moderate abjuration',
		aExclusions = { 'Holy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: evil; IFT: ALIGN(good); DMG: 2d6', nActionOnly = 1, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(good); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Lucky, greater'] = {
		sStringName = 'greater lucky',
		iBonus = 3,
		iCost = 0,
		bFirearm = true,
		iCL = 12,
		sAura = 'strong divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Reliable, greater'] = {
		sStringName = 'greater reliable',
		iBonus = 3,
		iCost = 0,
		bFirearm = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Speed'] = {
		sStringName = 'speed',
		iBonus = 3,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Brilliant energy'] = {
		sStringName = 'brilliant energy',
		iBonus = 4,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Designating, greater'] = {
		sStringName = 'greater designating',
		iBonus = 4,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Nimble shot'] = {
		sStringName = 'nimble shot',
		iBonus = 4,
		iCost = 0,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Second chance'] = {
		sStringName = 'second chance',
		iBonus = 4,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Disjoining'] = {
		sStringName = 'disjoining',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Harvesting'] = {
		sStringName = 'harvesting',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mythic bane'] = {
		sStringName = 'mythic bane',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IFT: TYPE(mythic); ATK: 2; DMG: 2d6', nActionOnly = 1, bAERequired = true, nCritical = 0 },
		},
	},
	['Potent'] = {
		sStringName = 'potent',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Sacrosanct'] = {
		sStringName = 'sacrosanct',
		iBonus = 2,
		iCost = 5000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
}

aAmmunitionAbilities = {
	['Anarchic'] = {
		sStringName = 'anarchic',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Axiomatic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); DMGTYPE: chaotic; IFT: ALIGN(lawful); DMG: 2d6',
				nActionOnly = 1,
				nCritical = 0,
			},
			{ sEffect = 'IF: ALIGN(lawful); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Axiomatic'] = {
		sStringName = 'axiomatic',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Anarchic' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); DMGTYPE: lawful; IFT: ALIGN(chaotic); DMG: 2d6',
				nActionOnly = 0,
				nCritical = 0,
			},
			{ sEffect = 'IF: ALIGN(chaotic); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Bane'] = {
		sStringName = 'bane',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = 'Bane Type',
		aSubSelection = {
			['Aberations'] = {
				sStringName = 'aberations',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(aberation); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Animals'] = {
				sStringName = 'animals',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(animal); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Constructs'] = {
				sStringName = 'constructs',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(construct); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Dragons'] = {
				sStringName = 'dragons',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(dragon); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Fey'] = {
				sStringName = 'fey',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(fey); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Humanoids'] = {
				sStringName = 'humanoid',
				sSubSubSelectionLabel = 'Humanoid Type',
				aEffects = {},
				aSubSubSelection = {
					['Dwarf'] = {
						sStringName = 'dwarf',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(dwarf); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Elf'] = {
						sStringName = 'elf',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(elf); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Gnoll'] = {
						sStringName = 'gnoll',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(gnoll); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Gnome'] = {
						sStringName = 'gnome',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(gnome); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Goblinoid'] = {
						sStringName = 'goblinoid',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(goblinoid); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Halfling'] = {
						sStringName = 'halfling',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(halfling); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Human'] = {
						sStringName = 'human',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(human); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Orc'] = {
						sStringName = 'orc',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(orc); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Reptilian'] = {
						sStringName = 'reptilian',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(reptilian); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
				},
			},
			['Magical Beasts'] = {
				sStringName = 'magical beasts',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(magical beast); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Monstrous Humanoids'] = {
				sStringName = 'monstrous humanoid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(monstrous humanoid); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Oozes'] = {
				sStringName = 'oozes',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(ooze); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Outsiders'] = {
				sStringName = 'outsiders',
				aEffect = {},
				sSubSubSelectionLabel = 'Outsider Type',
				aSubSubSelection = {
					['Air'] = {
						sStringName = 'air',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(air); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Angel'] = {
						sStringName = 'angel',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(angel); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Archon'] = {
						sStringName = 'archon',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(archon); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Demon'] = {
						sStringName = 'demon',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(demon); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Devil'] = {
						sStringName = 'devil',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(devil); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Earth'] = {
						sStringName = 'earth',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(earth); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Fire'] = {
						sStringName = 'fire',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(fire); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Native'] = {
						sStringName = 'native',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(native); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
					['Water'] = {
						sStringName = 'water',
						aEffects = {
							{
								sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(water); ATK: 2; DMG: 2d6',
								nActionOnly = 0,
								nCritical = 0,
							},
						},
					},
				},
			},
			['Plants'] = {
				sStringName = 'plants',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(plant); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Undead'] = {
				sStringName = 'undead',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(undead); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
			['Vermin'] = {
				sStringName = 'vermin',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {
					{
						sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(vermin); ATK: 2; DMG: 2d6',
						nActionOnly = 0,
						nCritical = 0,
					},
				},
			},
		},
	},
	['Brilliant energy'] = {
		sStringName = 'brilliant energy',
		iBonus = 4,
		iCost = 0,
		iCL = 16,
		sAura = 'strong transmutation ',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Conductive'] = {
		sStringName = 'conductive',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Corrosive'] = {
		sStringName = 'corrosive',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Corrosive burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Corrosive burst'] = {
		sStringName = 'corrosive burst',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'moderate evocation',
		aExclusions = { 'Corrosive' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 acid', nActionOnly = 0, nCritical = 0 },
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit2); DMG: 1d10 acid, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 2d10 acid, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 3d10 acid, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Cruel'] = {
		sStringName = 'cruel',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Cunning'] = {
		sStringName = 'cunning',
		iBonus = 1,
		iCost = 0,
		iCL = 6,
		sAura = 'moderate divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Designating, greater'] = {
		sStringName = 'greater designating',
		iBonus = 4,
		iCost = 0,
		iCL = 12,
		sAura = 'moderate enchantment',
		aExclusions = { 'Designating, lesser' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Designating, lesser'] = {
		sStringName = 'lesser designating',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate enchantment',
		aExclusions = { 'Designating, greater' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dry load'] = {
		sStringName = 'dry load',
		iBonus = 1,
		iCost = 1500,
		iCL = 3,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Flaming'] = {
		sStringName = 'flaming',
		iBonus = 1,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Flaming burst', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 fire', nActionOnly = 0, nCritical = 0 } },
	},
	['Flaming burst'] = {
		sStringName = 'flaming burst',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = { 'Flaming', 'Igniting' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 fire', nActionOnly = 0, nCritical = 0 },
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit2); DMG: 1d10 fire, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 2d10 fire, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit4); DMG: 3d10 fire, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Frost'] = {
		sStringName = 'frost',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = { 'Icy burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 cold', nActionOnly = 0, nCritical = 0 } },
	},
	['Ghost touch'] = {
		sStringName = 'ghost touch',
		iBonus = 1,
		iCost = 0,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); DMGTYPE: ghost touch',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Holy'] = {
		sStringName = 'holy',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Unholy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); DMGTYPE: good; IFT: ALIGN(evil); DMG: 2d6',
				nActionOnly = 0,
				nCritical = 0,
			},
			{ sEffect = 'IF: ALIGN(evil); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Icy burst'] = {
		sStringName = 'icy burst',
		iBonus = 2,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Frost' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 cold', nActionOnly = 0, nCritical = 0 },
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit2); DMG: 1d10 cold, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 2d10 cold, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit4); DMG: 3d10 cold, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Igniting'] = {
		sStringName = 'igniting',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = { 'Flaming', 'Flaming burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 fire', nActionOnly = 0, nCritical = 0 },
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG0: 1d6 fire', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Limning'] = {
		sStringName = 'limning',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Merciful'] = {
		sStringName = 'merciful',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMGTYPE: nonlethal; DMG: 1d6', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Phase locking'] = {
		sStringName = 'phase locking',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Planar'] = {
		sStringName = 'planar',
		iBonus = 1,
		iCost = 0,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Seeking'] = {
		sStringName = 'seeking',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'strong divination',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Shock'] = {
		sStringName = 'shock',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = { 'Shocking burst' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 electricity', nActionOnly = 0, nCritical = 0 } },
	},
	['Shocking burst'] = {
		sStringName = 'shocking burst',
		iBonus = 2,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate evocation',
		aExclusions = { 'Shock' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: CUSTOM(%s Attack); DMG: 1d6 electricity', nActionOnly = 0, nCritical = 0 },
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit2); DMG: 1d10 electricity, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 2d10 electricity, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit4); DMG: 3d10 electricity, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Thundering'] = {
		sStringName = 'thundering',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit2); DMG: 1d8 sonic, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit3); DMG: 2d8 sonic, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
			{
				sEffect = 'IF: CUSTOM(%s Attack); IF: CUSTOM(Crit4); DMG: 3d8 sonic, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Unholy'] = {
		sStringName = 'unholy',
		iBonus = 2,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = { 'Holy' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'DMGTYPE: evil; IFT: ALIGN(good); DMG: 2d6', nActionOnly = 0, nCritical = 0 },
			{ sEffect = 'IF: ALIGN(good); NLVL 1', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Disjoining'] = {
		sStringName = 'disjoining',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 7,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Harvesting'] = {
		sStringName = 'harvesting',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 9,
		sAura = 'moderate necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mythic bane'] = {
		sStringName = 'mythic bane',
		iBonus = 1,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'IF: CUSTOM(%s Attack); IFT: TYPE(mythic); ATK: 2; DMG: 2d6',
				nActionOnly = 1,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Potent'] = {
		sStringName = 'potent',
		iBonus = 2,
		iCost = 0,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 12,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Sacrosanct'] = {
		sStringName = 'sacrosanct',
		iBonus = 2,
		iCost = 5000,
		bSlashing = true,
		bPiercing = true,
		bBludgeoning = true,
		iCL = 8,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
}

aArmorAbilities = {
	['Adhesive'] = {
		sStringName = 'adhesive',
		iBonus = 3,
		iCost = 7000,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Balanced'] = {
		sStringName = 'balanced',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Benevolent'] = {
		sStringName = 'benevolent',
		iBonus = 1,
		iCost = 2000,
		iCL = 5,
		sAura = 'faint enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Bitter'] = {
		sStringName = 'bitter',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Bolstering'] = {
		sStringName = 'bolstering',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint enchantment',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Brawling'] = {
		sStringName = 'brawling',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Champion'] = {
		sStringName = 'champion',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: ALIGN(good); IFT: CUSTOM(challenge, smite); AC: 2', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Creeping'] = {
		sStringName = 'creeping',
		iBonus = 2,
		iCost = 5000,
		iCL = 7,
		sAura = 'moderate illusion and transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Dastard'] = {
		sStringName = 'dastard',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'IF: ALIGN(evil); IFT: CUSTOM(challenge, smite); AC: 2', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Deathless'] = {
		sStringName = 'deathless',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'RESIST: 10 negative; RESIST: 10 positive', nActionOnly = 0, nCritical = 0 },
			{
				sEffect = 'Fortification, FORTIF: 25 negative; FORTIF: 25 positive',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Defiant'] = {
		sStringName = 'defiant',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = 'Type',
		aSubSelection = {
			['Aberations'] = {
				sStringName = 'aberations',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {},
			},
			['Animals'] = { sStringName = 'animals', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Constructs'] = {
				sStringName = 'constructs',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {},
			},
			['Dragons'] = { sStringName = 'dragons', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Fey'] = { sStringName = 'fey', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Humanoids'] = {
				sStringName = 'humanoid',
				sSubSubSelectionLabel = 'Humanoid Type',
				aEffects = {},
				aSubSubSelection = {
					['Dwarf'] = { sStringName = 'dwarf', aEffects = {} },
					['Elf'] = { sStringName = 'elf', aEffects = {} },
					['Gnoll'] = { sStringName = 'gnoll', aEffects = {} },
					['Gnome'] = { sStringName = 'gnome', aEffects = {} },
					['Goblinoid'] = { sStringName = 'goblinoid', aEffects = {} },
					['Halfling'] = { sStringName = 'halfling', aEffects = {} },
					['Human'] = { sStringName = 'human', aEffects = {} },
					['Orc'] = { sStringName = 'orc', aEffects = {} },
					['Reptilian'] = { sStringName = 'reptilian', aEffects = {} },
				},
			},
			['Magical Beasts'] = {
				sStringName = 'magical beasts',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {},
			},
			['Monstrous Humanoids'] = {
				sStringName = 'monstrous humanoid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = {},
			},
			['Oozes'] = { sStringName = 'oozes', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Outsiders'] = {
				sStringName = 'outsiders',
				aEffect = {},
				sSubSubSelectionLabel = 'Outsider Type',
				aSubSubSelection = {
					['Air'] = { sStringName = 'air', aEffects = {} },
					['Angel'] = { sStringName = 'angel', aEffects = {} },
					['Archon'] = { sStringName = 'archon', aEffects = {} },
					['Demon'] = { sStringName = 'demon', aEffects = {} },
					['Devil'] = { sStringName = 'devil', aEffects = {} },
					['Earth'] = { sStringName = 'earth', aEffects = {} },
					['Fire'] = { sStringName = 'fire', aEffects = {} },
					['Native'] = { sStringName = 'native', aEffects = {} },
					['Water'] = { sStringName = 'water', aEffects = {} },
				},
			},
			['Plants'] = { sStringName = 'plants', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Undead'] = { sStringName = 'undead', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
			['Vermin'] = { sStringName = 'vermin', sSubSubSelectionLabel = '', aSubSubSelection = {}, aEffects = {} },
		},
		aEffects = {},
	},
	['Delving'] = {
		sStringName = 'delving',
		iBonus = 3,
		iCost = 10000,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Determination'] = {
		sStringName = 'determination',
		iBonus = 5,
		iCost = 30000,
		iCL = 10,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Energy resistance'] = {
		sStringName = 'energy resistance',
		iBonus = 4,
		iCost = 18000,
		iCL = 3,
		sAura = 'faint abjuration',
		aExclusions = { 'Energy resistance, greater', 'Energy resistance, improved' },
		sSubSelectionLabel = 'Type',
		aSubSelection = {
			['Acid'] = {
				sStringName = 'acid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 10 acid', nActionOnly = 0, nCritical = 0 } },
			},
			['Cold'] = {
				sStringName = 'cold',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 10 cold', nActionOnly = 0, nCritical = 0 } },
			},
			['Electricity'] = {
				sStringName = 'electricity',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 10 electricity', nActionOnly = 0, nCritical = 0 } },
			},
			['Fire'] = {
				sStringName = 'fire',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 10 fire', nActionOnly = 0, nCritical = 0 } },
			},
			['Sonic'] = {
				sStringName = 'sonic',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 10 sonic', nActionOnly = 0, nCritical = 0 } },
			},
		},
		aEffects = {},
	},
	['Energy resistance, greater'] = {
		sStringName = 'greater energy resistance',
		iBonus = 5,
		iCost = 66000,
		iCL = 11,
		sAura = 'moderate abjuration',
		aExclusions = { 'Energy resistance', 'Energy resistance, improved' },
		sSubSelectionLabel = 'Type',
		aSubSelection = {
			['Acid'] = {
				sStringName = 'acid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 30 acid', nActionOnly = 0, nCritical = 0 } },
			},
			['Cold'] = {
				sStringName = 'cold',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 30 cold', nActionOnly = 0, nCritical = 0 } },
			},
			['Electricity'] = {
				sStringName = 'electricity',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 30 electricity', nActionOnly = 0, nCritical = 0 } },
			},
			['Fire'] = {
				sStringName = 'fire',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 30 fire', nActionOnly = 0, nCritical = 0 } },
			},
			['Sonic'] = {
				sStringName = 'sonic',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 30 sonic', nActionOnly = 0, nCritical = 0 } },
			},
		},
		aEffects = {},
	},
	['Energy resistance, improved'] = {
		sStringName = 'improved energy resistance',
		iBonus = 5,
		iCost = 42000,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = { 'Energy resistance', 'Energy resistance, greater' },
		sSubSelectionLabel = '',
		aSubSelection = {
			['Acid'] = {
				sStringName = 'acid',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 20 acid', nActionOnly = 0, nCritical = 0 } },
			},
			['Cold'] = {
				sStringName = 'cold',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 20 cold', nActionOnly = 0, nCritical = 0 } },
			},
			['Electricity'] = {
				sStringName = 'electricity',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 20 electricity', nActionOnly = 0, nCritical = 0 } },
			},
			['Fire'] = {
				sStringName = 'fire',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 20 fire', nActionOnly = 0, nCritical = 0 } },
			},
			['Sonic'] = {
				sStringName = 'sonic',
				sSubSubSelectionLabel = '',
				aSubSubSelection = {},
				aEffects = { { sEffect = 'RESIST: 20 sonic', nActionOnly = 0, nCritical = 0 } },
			},
		},
		aEffects = {},
	},
	['Etherealness'] = {
		sStringName = 'etherealness',
		iBonus = 5,
		iCost = 49000,
		iCL = 13,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Expeditious'] = {
		sStringName = 'expeditious',
		iBonus = 2,
		iCost = 4000,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Fortification (heavy)'] = {
		sStringName = 'heavy fortification',
		iBonus = 5,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (light)', 'Fortification (moderate)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 75 precision; FORTIF: 75, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Fortification (light)'] = {
		sStringName = 'light fortification',
		iBonus = 1,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (heavy)', 'Fortification (moderate)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 25 precision; FORTIF: 25, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Fortification (moderate)'] = {
		sStringName = 'moderate fortification',
		iBonus = 3,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (heavy)', 'Fortification (light)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 50 precision; FORTIF: 50, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Ghost touch'] = {
		sStringName = 'ghost touch',
		iBonus = 3,
		iCost = 0,
		iCL = 15,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'Incorporeal', nActionOnly = 0, nCritical = 0 } },
	},
	['Glamered'] = {
		sStringName = 'glamered',
		iBonus = 2,
		iCost = 2700,
		iCL = 10,
		sAura = 'moderate illusion',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Grinding'] = {
		sStringName = 'grinding',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Harmonizing'] = {
		sStringName = 'harmonizing',
		iBonus = 4,
		iCost = 15000,
		iCL = 7,
		sAura = 'moderate illusion',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{ sEffect = 'SKILL: 5 compotence perform; SKILL: -5 stealth; VULN: sonic', nActionOnly = 0, nCritical = 0 },
		},
	},
	['Hosteling'] = {
		sStringName = 'hosteling',
		iBonus = 3,
		iCost = 7500,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Impervious'] = {
		sStringName = 'impervious',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Invulnerability'] = {
		sStringName = 'invulnerability',
		iBonus = 3,
		iCost = 0,
		iCL = 18,
		sAura = 'strong varies',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'DR: 5 magic', nActionOnly = 0, nCritical = 0 } },
	},
	['Jousting'] = {
		sStringName = 'jousting',
		iBonus = 2,
		iCost = 3750,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 5 compotence ride', nActionOnly = 0, nCritical = 0 } },
	},
	['Martyring'] = {
		sStringName = 'martyring',
		iBonus = 4,
		iCost = 18000,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mirrored'] = {
		sStringName = 'mirrored',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Poison-resistant'] = {
		sStringName = 'poison resistant',
		iBonus = 1,
		iCost = 2250,
		iCL = 7,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Putrid'] = {
		sStringName = 'putrid',
		iBonus = 3,
		iCost = 10000,
		iCL = 5,
		sAura = 'faint conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Radiant'] = {
		sStringName = 'radiant',
		iBonus = 3,
		iCost = 7500,
		iCL = 6,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Rallying'] = {
		sStringName = 'rallying',
		iBonus = 2,
		iCost = 5000,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Righteous'] = {
		sStringName = 'righteous',
		iBonus = 5,
		iCost = 27000,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = { 'Unrighteous' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF ALIGN(evil); NLVL 1', nActionOnly = 0, nCritical = 0 } },
	},
	['Shadow'] = {
		sStringName = 'shadow',
		iBonus = 2,
		iCost = 3750,
		iCL = 5,
		sAura = 'faint illusion',
		aExclusions = { 'Shadow, greater', 'Shadow, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 5 compotence stealth', nActionOnly = 0, nCritical = 0 } },
	},
	['Shadow, greater'] = {
		sStringName = 'greater shadow',
		iBonus = 5,
		iCost = 33750,
		iCL = 15,
		sAura = 'strong illusion',
		aExclusions = { 'Shadow', 'Shadow, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 15 compotence stealth', nActionOnly = 0, nCritical = 0 } },
	},
	['Shadow, improved'] = {
		sStringName = 'improved shadow',
		iBonus = 4,
		iCost = 15000,
		iCL = 10,
		sAura = 'moderate illusion',
		aExclusions = { 'Shadow', 'Shadow, greater' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 10 compotence stealth', nActionOnly = 0, nCritical = 0 } },
	},
	['Slick'] = {
		sStringName = 'slick',
		iBonus = 2,
		iCost = 3750,
		iCL = 4,
		sAura = 'faint conjuration',
		aExclusions = { 'Slick, greater', 'Slick, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 5 compotence escape artist', nActionOnly = 0, nCritical = 0 } },
	},
	['Slick, greater'] = {
		sStringName = 'slick greater',
		iBonus = 5,
		iCost = 33750,
		iCL = 15,
		sAura = 'strong conjuration',
		aExclusions = { 'Slick', 'Slick, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 15 compotence escape artist', nActionOnly = 0, nCritical = 0 } },
	},
	['Slick, improved'] = {
		sStringName = 'slick improved',
		iBonus = 4,
		iCost = 15000,
		iCL = 10,
		sAura = 'moderate conjuration',
		aExclusions = { 'Slick', 'Slick, greater' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SKILL: 10 compotence escape artist', nActionOnly = 0, nCritical = 0 } },
	},
	['Spell resistance (13)'] = {
		sStringName = 'spell resistance (13)',
		iBonus = 2,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (15)', 'Spell resistance (17)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SR: 13', nActionOnly = 0, bAERequired = true, nCritical = 0 } },
	},
	['Spell resistance (15)'] = {
		sStringName = 'spell resistance (15)',
		iBonus = 3,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (17)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SR: 15', nActionOnly = 0, bAERequired = true, nCritical = 0 } },
	},
	['Spell resistance (17)'] = {
		sStringName = 'spell resistance (17)',
		iBonus = 4,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (15)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SR: 17', nActionOnly = 0, bAERequired = true, nCritical = 0 } },
	},
	['Spell resistance (19)'] = {
		sStringName = 'spell resistance (19)',
		iBonus = 5,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (15)', 'Spell resistance (17)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'SR: 19', nActionOnly = 0, bAERequired = true, nCritical = 0 } },
	},
	['Spell storing'] = {
		sStringName = 'spell storing',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'strong evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Stanching'] = {
		sStringName = 'stanching',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Titanic'] = {
		sStringName = 'titanic',
		iBonus = 3,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Unbound'] = {
		sStringName = 'unbound',
		iBonus = 5,
		iCost = 27000,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF ALIGN(lawful); NLVL 1', nActionOnly = 0, nCritical = 0 } },
	},
	['Undead controlling'] = {
		sStringName = 'undead controlling',
		iBonus = 5,
		iCost = 49000,
		iCL = 13,
		sAura = 'strong necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Unrighteous'] = {
		sStringName = 'unrighteous',
		iBonus = 5,
		iCost = 27000,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = { 'Righteous' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF ALIGN(good); NLVL 1', nActionOnly = 0, nCritical = 0 } },
	},
	['Vigilant'] = {
		sStringName = 'vigilant',
		iBonus = 5,
		iCost = 27000,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'IF ALIGN(chaotic); NLVL 1', nActionOnly = 0, nCritical = 0 } },
	},
	['Warding'] = {
		sStringName = 'warding',
		iBonus = 1,
		iCost = 0,
		iCL = 12,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Wild'] = {
		sStringName = 'wild',
		iBonus = 3,
		iCost = 0,
		iCL = 9,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Denying'] = {
		sStringName = 'denying',
		iBonus = 4,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Resonating'] = {
		sStringName = 'resonating',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Burdenless'] = {
		sStringName = 'burdenless',
		iBonus = 0,
		iCost = 4000,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
}

aShieldAbilities = {
	['Animated'] = {
		sStringName = 'animated',
		iBonus = 2,
		iCost = 0,
		iCL = 12,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Arrow catching'] = {
		sStringName = 'arrow catching',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'AC: 1 deflection ranged', nActionOnly = 0, nCritical = 0 } },
	},
	['Arrow deflection'] = {
		sStringName = 'arrow deflection',
		iBonus = 2,
		iCost = 0,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Bashing'] = {
		sStringName = 'bashing',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Blinding'] = {
		sStringName = 'blinding',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Clangorous'] = {
		sStringName = 'clangorous',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Defiant'] = {
		sStringName = 'defiant',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Determination'] = {
		sStringName = 'determination',
		iBonus = 5,
		iCost = 30000,
		iCL = 10,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Energy resistance'] = {
		sStringName = 'energy resistance',
		iBonus = 4,
		iCost = 18000,
		iCL = 3,
		sAura = 'faint abjuration',
		aExclusions = { 'Energy resistance, greater', 'Energy resistance, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Energy resistance, greater'] = {
		sStringName = 'greater energy resistance',
		iBonus = 5,
		iCost = 66000,
		iCL = 11,
		sAura = 'moderate abjuration',
		aExclusions = { 'Energy resistance', 'Energy resistance, improved' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Energy resistance, improved'] = {
		sStringName = 'improved energy resistance',
		iBonus = 5,
		iCost = 42000,
		iCL = 7,
		sAura = 'moderate abjuration',
		aExclusions = { 'Energy resistance', 'Energy resistance, greater' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Fortification (heavy)'] = {
		sStringName = 'heavy fortification',
		iBonus = 5,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (light)', 'Fortification (moderate)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 75 precision; FORTIF: 75, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Fortification (light)'] = {
		sStringName = 'light fortification',
		iBonus = 1,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (heavy)', 'Fortification (moderate)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 25 precision; FORTIF: 25, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Fortification (moderate)'] = {
		sStringName = 'moderate fortification',
		iBonus = 3,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = { 'Fortification (heavy)', 'Fortification (light)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {
			{
				sEffect = 'FORTIF: 50 precision; FORTIF: 50, critical',
				nActionOnly = 0,
				bAERequired = true,
				nCritical = 0,
			},
		},
	},
	['Ghost touch'] = {
		sStringName = 'ghost touch',
		iBonus = 3,
		iCost = 0,
		iCL = 15,
		sAura = 'strong transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = { { sEffect = 'Incorporeal', nActionOnly = 0, nCritical = 0 } },
	},
	['Grinding'] = {
		sStringName = 'grinding',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Hosteling'] = {
		sStringName = 'hosteling',
		iBonus = 3,
		iCost = 7500,
		iCL = 9,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Impervious'] = {
		sStringName = 'impervious',
		iBonus = 1,
		iCost = 0,
		iCL = 7,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Merging'] = {
		sStringName = 'merging',
		iBonus = 2,
		iCost = 0,
		iCL = 10,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Mirrored'] = {
		sStringName = 'mirrored',
		iBonus = 1,
		iCost = 0,
		iCL = 8,
		sAura = 'moderate abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Poison-resistant'] = {
		sStringName = 'poison resistant',
		iBonus = 1,
		iCost = 2250,
		iCL = 7,
		sAura = 'moderate conjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Radiant'] = {
		sStringName = 'radiant',
		iBonus = 3,
		iCost = 7500,
		iCL = 6,
		sAura = 'moderate evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Rallying'] = {
		sStringName = 'rallying',
		iBonus = 2,
		iCost = 5000,
		iCL = 5,
		sAura = 'faint abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Ramming'] = {
		sStringName = 'ramming',
		iBonus = 1,
		iCost = 0,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Reflecting'] = {
		sStringName = 'reflecting',
		iBonus = 5,
		iCost = 0,
		iCL = 14,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spell resistance (13)'] = {
		sStringName = 'spell resistance 13 ',
		iBonus = 2,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (15)', 'Spell resistance (17)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spell resistance (15)'] = {
		sStringName = 'spell resistance (15)',
		iBonus = 3,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (17)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spell resistance (17)'] = {
		sStringName = 'spell resistance (17)',
		iBonus = 4,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (15)', 'Spell resistance (19)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Spell resistance (19)'] = {
		sStringName = 'spell resistance (19)',
		iBonus = 5,
		iCost = 0,
		iCL = 15,
		sAura = 'strong abjuration',
		aExclusions = { 'Spell resistance (13)', 'Spell resistance (15)', 'Spell resistance (17)' },
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Undead controlling'] = {
		sStringName = 'undead controlling',
		iBonus = 5,
		iCost = 49000,
		iCL = 13,
		sAura = 'strong necromancy',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Wild'] = {
		sStringName = 'wild',
		iBonus = 3,
		iCost = 0,
		iCL = 9,
		sAura = 'moderate transmutation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Wyrmsbreath'] = {
		sStringName = 'wyrmsbreath',
		iBonus = 2,
		iCost = 5000,
		iCL = 5,
		sAura = 'faint evocation',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
	['Deflecting'] = {
		sStringName = 'deflecting',
		iBonus = 3,
		iCost = 0,
		iCL = 13,
		sAura = 'strong abjuration',
		aExclusions = {},
		sSubSelectionLabel = '',
		aSubSelection = {},
		aEffects = {},
	},
}
aItemSize = {
	['fine'] = { iPosition = 1 },
	['diminuative'] = { iPosition = 2 },
	['tiny'] = { iPosition = 3 },
	['small'] = { iPosition = 4 },
	['medium'] = { iPosition = 5 },
	['large'] = { iPosition = 6 },
	['huge'] = { iPosition = 7 },
	['gargantuan'] = { iPosition = 8 },
	['colossal'] = { iPosition = 9 },
}

aDamageDice = {
	['0'] = { iPosition = 0 },
	['1'] = { iPosition = 1 },
	['1d2'] = { iPosition = 2 },
	['1d3'] = { iPosition = 3 },
	['1d4'] = { iPosition = 4 },
	['1d6'] = { iPosition = 5 },
	['1d8'] = { iPosition = 6 },
	['1d10'] = { iPosition = 7 },
	['2d6'] = { iPosition = 8 },
	['2d8'] = { iPosition = 9 },
	['3d6'] = { iPosition = 10 },
	['3d8'] = { iPosition = 11 },
	['4d6'] = { iPosition = 12 },
	['4d8'] = { iPosition = 13 },
	['6d6'] = { iPosition = 14 },
	['6d8'] = { iPosition = 15 },
	['8d6'] = { iPosition = 16 },
	['8d8'] = { iPosition = 17 },
	['12d6'] = { iPosition = 18 },
	['12d8'] = { iPosition = 19 },
	['16d6'] = { iPosition = 20 },
}

aPositionDamage = {
	[0] = { sDamage = '0' },
	{ sDamage = '1' },
	{ sDamage = '1d2' },
	{ sDamage = '1d3' },
	{ sDamage = '1d4' },
	[5] = { sDamage = '1d6' },
	[6] = { sDamage = '1d8', sAltDamage1 = '2d4' },
	[7] = { sDamage = '1d10' },
	[8] = { sDamage = '2d6', sAltDamage1 = '3d4', sAltDamage2 = '1d12' },
	[9] = { sDamage = '2d8', sAltDamage1 = '4d4' },
	[10] = { sDamage = '3d6', sAltDamage1 = '5d4' },
	[11] = { sDamage = '3d8', sAltDamage1 = '6d4' },
	[12] = { sDamage = '4d6', sAltDamage1 = '6d4', sAltDamage2 = '2d12' },
	[13] = { sDamage = '4d8', sAltDamage1 = '8d4' },
	[14] = { sDamage = '6d6', sAltDamage1 = '9d4', sAltDamage2 = '3d12' },
	[15] = { sDamage = '6d8', sAltDamage1 = '12d4' },
	[16] = { sDamage = '8d6', sAltDamage1 = '12d4', sAltDamage2 = '4d12' },
	[17] = { sDamage = '8d8', sAltDamage1 = '16d4' },
	[18] = { sDamage = '12d6', sAltDamage1 = '18d4', sAltDamage2 = '6d12' },
	[19] = { sDamage = '12d8', sAltDamage1 = '24d4' },
	[20] = { sDamage = '16d6', sAltDamage1 = '24d4', sAltDamage2 = '8d12' },
}

aAltDamageDice1 = {
	['2d4'] = { sDamage = '1d8' },
	['3d4'] = { sDamage = '2d6' },
	['4d4'] = { sDamage = '2d8' },
	['5d4'] = { sDamage = '3d6' },
	['6d4'] = { sDamage = '3d8' },
	['7d4'] = { sDamage = '4d6' },
	['8d4'] = { sDamage = '4d8' },
	['9d4'] = { sDamage = '6d6' },
	['12d4'] = { sDamage = '6d8' },
	['16d4'] = { sDamage = '8d8' },
	['18d4'] = { sDamage = '12d6' },
	['24d4'] = { sDamage = '12d8' },
}

aAltDamageDice2 = {
	['1d12'] = { sDamage = '2d6' },
	['2d12'] = { sDamage = '4d6' },
	['3d12'] = { sDamage = '6d6' },
	['4d12'] = { sDamage = '8d6' },
	['6d12'] = { sDamage = '12d6' },
	['8d12'] = { sDamage = '16d6' },
}

aAltDamageDice3 = { ['2d10'] = { sDown = '2d8', sUp = '4d8' } }

aWeightMultiplier = {
	['fine'] = { nMultiplier = 0.1 },
	['diminuative'] = { nMultiplier = 0.1 },
	['tiny'] = { nMultiplier = 0.1 },
	['small'] = { nMultiplier = 0.5 },
	['medium'] = { nMultiplier = 1 },
	['large'] = { nMultiplier = 2 },
	['huge'] = { nMultiplier = 5 },
	['gargantuan'] = { nMultiplier = 8 },
	['colossal'] = { nMultiplier = 12 },
}

local nMaxTotalBonus = 10 -- must have no more than 10 bonus points

local function addProperty(sItemProperties, sProperty)
	local sNewItemProperties = ''
	if sItemProperties == '' then
		sNewItemProperties = sProperty
	elseif sItemProperties:match(sProperty) then
		sNewItemProperties = sItemProperties
	else
		sNewItemProperties = sItemProperties .. ', ' .. sProperty
	end
	return sNewItemProperties
end

local function getDamageBySize(sDamage, sOriginalSize, sItemSize)
	local iSizeDifference = aItemSize[sItemSize:lower()].iPosition - aItemSize[sOriginalSize:lower()].iPosition
	if iSizeDifference == 0 then return sDamage end

	return changeDamageBySizeDifference(sDamage, iSizeDifference)
end

function getAbilityBonusAndCost(sSpecialAbility, sType, sSubType)
	local tAbilities
	if sSubType == 'melee' then
		tAbilities = aMeleeWeaponAbilities[sSpecialAbility]
	elseif sSubType == 'ranged' then
		tAbilities = aRangedWeaponAbilities[sSpecialAbility]
	elseif sType == 'armor' then
		tAbilities = aArmorAbilities[sSpecialAbility]
	elseif sType == 'shield' then
		tAbilities = aShieldAbilities[sSpecialAbility]
	elseif sType == 'ammunition' then
		tAbilities = aAmmunitionAbilities[sSpecialAbility]
	end

	local iBonus = tAbilities.iBonus or 0
	local iBonusCost = 0
	local iExtraCost = tAbilities.iCost or 0
	local sAbilityName = tAbilities.sStringName or ''
	local iCL = tAbilities.iCL or 0
	local sAura = tAbilities.sAura or ''

	if iExtraCost == 0 then iBonusCost = iBonus end

	return iBonus, iBonusCost, iExtraCost, sAbilityName, iCL, sAura
end

function generateMagicItem(nodeItem)
	if not nodeItem then return false end
	local sEnhancementBonus = DB.getValue(nodeItem, 'combobox_bonus', '')
	local sSpecialMaterial = DB.getValue(nodeItem, 'combobox_material', '')
	local sItemSize = DB.getValue(nodeItem, 'combobox_item_size', '')
	local sType, sSubType = getItemType(nodeItem)
	if notifyMissingTypeData(sType, sSubType) then return end

	local aAbilities = getAbilities(nodeItem, sType, sSubType)

	local _, bMaterial, nErrorCode, aConflicts = checkComboboxes(sType, sSubType, nil, sSpecialMaterial, aAbilities)
	if nErrorCode == 1 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_4'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 2 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_5'), aConflicts.sAbility1, aConflicts.sAbility2),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 3 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_6'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local sItemName, iItemCost, iItemWeight, sFullSubType, sItemProperties, iArmorPenalty, iArmorMaxDex, iArmorSpellFailure, iSpeed30, iSpeed20, iRange, sDamageType, sDamage, sOriginalSize =
		getItemData(nodeItem)
	local sNewDamage = sDamage

	if ItemManager.isWeapon(nodeItem) or ItemManager.isShield(nodeItem) then sNewDamage = getDamageBySize(sDamage, sOriginalSize, sItemSize) end

	local iEnchancementBonus = getEnhancementBonus(sEnhancementBonus)
	local iEffectiveBonus = iEnchancementBonus
	local iCostBonus = iEnchancementBonus
	local iExtraCost = 0
	local iTotalAbilityBonus = 0

	if (iEnchancementBonus == 0) and (next(aAbilities) ~= nil) then
		Comm.addChatMessage({
			text = Interface.getString('magic_item_gen_error_1'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local aCL, aAura = {}, {}
	for _, aAbility in ipairs(aAbilities) do
		local iAbilityBonus, iAbilityCostBonus, iAbilityExtraCost, sAbilityName, iCL, sAura =
			getAbilityBonusAndCost(aAbility.sAbility, sType, sSubType)
		iEffectiveBonus = iEffectiveBonus + iAbilityBonus
		iTotalAbilityBonus = iTotalAbilityBonus + iAbilityBonus
		iCostBonus = iCostBonus + iAbilityCostBonus
		iExtraCost = iExtraCost + iAbilityExtraCost
		sDamageType, iRange = getSpecialAbilityData(aAbility.sAbility, sDamageType, iRange)
		local sFullSpecialAbility = aAbility.sAbility
		if aAbility.sSubAbility ~= Interface.getString('itemnone') then
			sFullSpecialAbility = sFullSpecialAbility .. '(' .. aAbility.sSubAbility
			if aAbility.sSubSubAbility ~= Interface.getString('itemnone') then
				sFullSpecialAbility = sFullSpecialAbility .. '(' .. aAbility.sSubSubAbility .. ')'
			end
			sFullSpecialAbility = sFullSpecialAbility .. ')'
		end
		sItemProperties = addProperty(sItemProperties, sFullSpecialAbility)
		table.insert(aCL, iCL)
		table.insert(aAura, sAura)
	end

	if iEffectiveBonus == iTotalAbilityBonus and iTotalAbilityBonus ~= 0 then
		Comm.addChatMessage({
			text = Interface.getString('magic_item_gen_error_7'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	if iEffectiveBonus > nMaxTotalBonus then
		Comm.addChatMessage({
			text = Interface.getString('magic_item_gen_error_2'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local iMaterialCost, iNewWeight, iNewArmorPenalty, iNewArmorMaxDex, iNewArmorSpellFailure, iNewSpeed30, iNewSpeed20, bMasterworkMaterial, bFragileMaterial, sItemProperties, sDamageType, sAddDescription =
		getMaterialData(
			sSpecialMaterial,
			iEnchancementBonus,
			sType,
			sSubType,
			sFullSubType,
			iItemWeight,
			iArmorPenalty,
			iArmorMaxDex,
			iArmorSpellFailure,
			iSpeed30,
			iSpeed20,
			iItemCost,
			sItemProperties,
			sDamageType
		)

	local iNewWeight = getWeightBySize(iNewWeight, sOriginalSize, sItemSize)

	local iMasterworkCost = 0
	if not bMasterworkMaterial or (not sEnhancementBonus == Interface.getString('itemnone')) then
		iMasterworkCost = getMasterworkPrice(sType, sItemProperties)
	end
	if bMasterworkMaterial or sEnhancementBonus ~= Interface.getString('itemnone') then
		sItemProperties = addProperty(sItemProperties, 'masterwork')
		iNewArmorPenalty = iNewArmorPenalty + 1
		if iNewArmorPenalty > 0 then iNewArmorPenalty = 0 end
	end

	if bFragileMaterial then sItemProperties = addProperty(sItemProperties, 'fragile') end

	local iEnhancementCost = getEnchancementCost(iCostBonus, sType)
	local iTotalCost = iMaterialCost + iMasterworkCost + iEnhancementCost + iExtraCost

	local sItemNewName =
		getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)

	local iNewBonus = 0
	if iEnchancementBonus > 0 then
		iNewBonus = iEnchancementBonus
		sDamageType = addProperty(sDamageType, 'magic')
		if DataCommon.isPFRPG() and (ItemManager.isWeapon(nodeItem) or sType == 'ammunition') then
			sDamageType = getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
		end
	end
	local sNewNonIdentifiedName = 'Unidentified ' .. sItemName:lower()

	local iCL = 3 * iNewBonus
	for _, iCL1 in pairs(aCL) do
		iCL = math.max(iCL, iCL1)
	end

	local sAura = ''
	for _, sAura1 in pairs(aAura) do
		sAura = addProperty(sAura, sAura1)
	end
	for _, aAbility in pairs(aAbilities) do
		if aAbility.sAbility == 'Impact' then
			sNewDamage = changeDamageBySizeDifference(sNewDamage, 1)
			break
		elseif aAbility.sAbility == 'Bashing' then
			sNewDamage = changeDamageBySizeDifference(sNewDamage, 2)
			break
		end
	end

	local sItemDescription = DB.getValue(nodeItem, 'description', '')
	if sAddDescription ~= '' then sItemDescription = sItemDescription .. '<h>' .. sSpecialMaterial .. '</h>' .. sAddDescription end

	-- Update fields in DB
	DB.setValue(nodeItem, 'aura', 'string', sAura)
	DB.setValue(nodeItem, 'bonus', 'number', iNewBonus)
	DB.setValue(nodeItem, 'cl', 'number', iCL)
	DB.setValue(nodeItem, 'cost', 'string', tostring(iTotalCost) .. ' gp')
	DB.setValue(nodeItem, 'description', 'formattedtext', sItemDescription)
	DB.setValue(nodeItem, 'isidentified', 'number', 0)
	DB.setValue(nodeItem, 'locked', 'number', 1)
	DB.setValue(nodeItem, 'name', 'string', StringManager.capitalize(sItemNewName))
	DB.setValue(nodeItem, 'nonid_name', 'string', StringManager.capitalize(sNewNonIdentifiedName))
	DB.setValue(nodeItem, 'properties', 'string', sItemProperties)
	DB.setValue(nodeItem, 'weight', 'number', iNewWeight)
	DB.setValue(nodeItem, 'damage', 'string', sNewDamage)
	DB.setValue(nodeItem, 'substance', 'string', sSpecialMaterial)
	DB.setValue(nodeItem, 'size', 'string', sItemSize)

	if ItemManager.isWeapon(nodeItem) or sType == 'ammunition' then
		DB.setValue(nodeItem, 'damagetype', 'string', sDamageType)
		DB.setValue(nodeItem, 'range', 'number', iRange)
	end

	if ItemManager.isArmor(nodeItem) or ItemManager.isShield(nodeItem) then
		DB.setValue(nodeItem, 'checkpenalty', 'number', iNewArmorPenalty)
		DB.setValue(nodeItem, 'maxstatbonus', 'number', iNewArmorMaxDex)
		DB.setValue(nodeItem, 'speed20', 'number', iNewSpeed20)
		DB.setValue(nodeItem, 'speed30', 'number', iNewSpeed30)
		DB.setValue(nodeItem, 'spellfailure', 'number', iNewArmorSpellFailure)
	end
	for _, aAbility in pairs(aAbilities) do
		addEffectsForAbility(nodeItem, sType, sSubType, aAbility.sAbility, aAbility.sSubAbility, aAbility.sSubSubAbility)
	end
	if ItemManager.isWeapon(nodeItem) and (sSubType == 'ranged' or sSubType == 'firearm') then addRangedEffect(nodeItem) end
	if sType == 'ammunition' then addAmmoEffect(nodeItem) end
	Comm.addChatMessage({ text = 'Generated ' .. sItemNewName, secret = true, icon = 'ct_faction_friend' }) -- ]]

	return true
end

function getAbilities(nodeItem, sType, sSubType)
	if not nodeItem then return end
	local aAbilities = {}
	for _, nodeAbility in pairs(DB.getChildren(nodeItem, 'abilitieslist')) do
		local aAbility = {}
		aAbility.sAbility = DB.getValue(nodeAbility, 'combobox_ability')
		aAbility.sSubAbility = DB.getValue(nodeAbility, 'combobox_ability_sub_select')
		aAbility.sSubSubAbility = DB.getValue(nodeAbility, 'combobox_ability_sub_sub_select')
		aAbility = cleanAbility(aAbility, sType, sSubType)
		if next(aAbility) ~= nil then table.insert(aAbilities, aAbility) end
	end
	return aAbilities
end

function cleanAbility(aAbility, sType, sSubType)
	local aNewAbility = {}
	local aAbilityList = getAbilityList(sType, sSubType)

	if aAbility.sAbility == Interface.getString('itemnone') then return aNewAbility end
	aNewAbility.sAbility = aAbility.sAbility

	if next(aAbilityList[aAbility.sAbility].aSubSelection) == nil then
		aNewAbility.sSubAbility = Interface.getString('itemnone')
		aNewAbility.sSubSubAbility = Interface.getString('itemnone')
	else
		aNewAbility.sSubAbility = aAbility.sSubAbility
		if
			aAbility.sSubAbility ~= Interface.getString('itemnone')
			and next(aAbilityList[aAbility.sAbility].aSubSelection[aAbility.sSubAbility].aSubSubSelection) == nil
		then
			aNewAbility.sSubSubAbility = Interface.getString('itemnone')
		else
			aNewAbility.sSubSubAbility = aAbility.sSubSubAbility
		end
	end
	return aNewAbility
end

function getAbilityList(sType, sSubType)
	if sType == 'weapon' then
		if sSubType == 'melee' then
			return aMeleeWeaponAbilities
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			return aRangedWeaponAbilities
		end
	elseif sType == 'ammunition' then
		return aAmmunitionAbilities
	elseif sType == 'armor' then
		return aArmorAbilities
	elseif sType == 'shield' then
		return aShieldAbilities
	end
end

function getItemType(nodeItem)
	local sItemType = ''
	local sItemSubType = ''
	local sType = string.lower(DB.getChild(nodeItem, 'type').getValue() or '')
	local sSubType = string.lower(DB.getChild(nodeItem, 'subtype').getValue() or '')
	if sType == 'weapon' then
		sItemType = 'weapon'
	elseif sType == 'armor' then
		if sSubType:match('shield') then
			sItemType = 'shield'
		else
			sItemType = 'armor'
		end
	end

	if sSubType:match('ammunition') or sType == 'ammo' or sSubType == 'ammo' then sItemType = 'ammunition' end

	if sType == 'weapon' then
		if sSubType:match('melee') then
			sItemSubType = 'melee'
		elseif sSubType:match('ranged') then
			sItemSubType = 'ranged'
		elseif sSubType:match('firearm') then
			sItemSubType = 'firearm'
		else
			sItemSubType = ''
		end
	elseif sType == 'armor' then
		if sSubType:match('light') then
			sItemSubType = 'light'
		elseif sSubType:match('medium') then
			sItemSubType = 'medium'
		elseif sSubType:match('heavy') then
			sItemSubType = 'heavy'
		end
	end
	return sItemType, sItemSubType
end

function checkComboboxes(sType, sSubType, sBonus, sMaterial, aAbilities)
	local bBonus = checkSelection(sBonus)
	local bMaterial = checkSelection(sMaterial)
	local aConflicts = {}

	for key1, aAbility1 in ipairs(aAbilities) do
		for key2, aAbility2 in ipairs(aAbilities) do
			if key1 ~= key2 then
				local nError = checkForAbilitySelectionError(sType, sSubType, aAbility1, aAbility2)
				if nError > 0 then
					aConflicts.sAbility1 = aAbility1.sAbility
					aConflicts.sAbility2 = aAbility2.sAbility
					return bBonus, bMaterial, nError, aConflicts
				end
			end
		end
		local aAbilityList = getAbilityList(sType, sSubType)
		if next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil and aAbility1.sSubAbility == Interface.getString('itemnone') then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		elseif
			next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil
			and next(aAbilityList[aAbility1.sAbility].aSubSelection[aAbility1.sSubAbility].aSubSubSelection) ~= nil
			and aAbility1.sSubSubAbility == Interface.getString('itemnone')
		then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		end
	end
	return bBonus, bMaterial, 0
end

function checkForAbilitySelectionError(sType, sSubType, aAbility1, aAbility2)
	if aAbility1.sAbility == aAbility2.sAbility then
		return 1
	elseif areExclusive(sType, sSubType, aAbility1.sAbility, aAbility2.sAbility) then
		return 2
	end
	return 0
end

function checkSelection(sSelection) return (sSelection ~= Interface.getString('itemnone')) end

function areExclusive(sType, sSubType, sAbility1, sAbility2)
	local aAbilityList = getAbilityList(sType, sSubType)
	return StringManager.contains(aAbilityList[sAbility1].aExclusions, sAbility2)
end

function getEnhancementBonus(sEnhancementBonus)
	local iEnchancementBonus = 0
	if sEnhancementBonus == Interface.getString('bonus_1') then
		iEnchancementBonus = 1
	elseif sEnhancementBonus == Interface.getString('bonus_2') then
		iEnchancementBonus = 2
	elseif sEnhancementBonus == Interface.getString('bonus_3') then
		iEnchancementBonus = 3
	elseif sEnhancementBonus == Interface.getString('bonus_4') then
		iEnchancementBonus = 4
	elseif sEnhancementBonus == Interface.getString('bonus_5') then
		iEnchancementBonus = 5
	end
	return iEnchancementBonus
end

function getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
	local sNewDamageType = sDamageType
	if iEnchancementBonus == 5 then
		sNewDamageType = addProperty(sNewDamageType, 'chaotic')
		sNewDamageType = addProperty(sNewDamageType, 'evil')
		sNewDamageType = addProperty(sNewDamageType, 'good')
		sNewDamageType = addProperty(sNewDamageType, 'lawful')
	end
	if iEnchancementBonus >= 4 then sNewDamageType = addProperty(sNewDamageType, 'adamantine') end
	if iEnchancementBonus >= 3 then
		sNewDamageType = addProperty(sNewDamageType, 'cold iron')
		sNewDamageType = addProperty(sNewDamageType, 'silver')
	end
	if iEnchancementBonus >= 1 then sNewDamageType = addProperty(sNewDamageType, 'magic') end
	return sNewDamageType
end

function getMaterialData(
	sMaterial,
	iEnhancingBonus,
	sType,
	sSubType,
	sFullSubType,
	iWeight,
	iArmorPenalty,
	iArmorMaxDex,
	iArmorSpellFailure,
	iSpeed30,
	iSpeed20,
	iItemBaseCost,
	sProperties,
	sDamageType
)
	local iMaterialCost = iItemBaseCost
	local iNewWeight = iWeight
	local iNewArmorPenalty = iArmorPenalty
	local iNewArmorMaxDex = iArmorMaxDex
	local iNewArmorSpellFailure = iArmorSpellFailure
	local iNewSpeed30 = iSpeed30
	local iNewSpeed20 = iSpeed20
	local sNewProperties = sProperties
	local sNewDamageType = sDamageType
	local sAddDescription = ''

	if aSpecialMaterials[sMaterial] and aSpecialMaterials[sMaterial].sAddDescription then
		sAddDescription = aSpecialMaterials[sMaterial].sAddDescription
	end

	if sMaterial == Interface.getString('adamantine') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 5000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 10000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 15000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 60
		end
		sNewProperties = addProperty(sNewProperties, 'adamantine')
		sNewDamageType = addProperty(sNewDamageType, 'adamantine')
	elseif sMaterial == Interface.getString('alchemical_silver') then
		if sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 2
		else
			if sFullSubType:lower():match('light') then
				iMaterialCost = iMaterialCost + 20
			elseif sFullSubType:lower():match('one-handed') then
				iMaterialCost = iMaterialCost + 90
			elseif sFullSubType:lower():match('two-handed') then
				iMaterialCost = iMaterialCost + 180
			elseif sProperties:lower():match('double') then
				iMaterialCost = iMaterialCost + 180
			end
		end
		sNewDamageType = addProperty(sNewDamageType, 'silver')
	elseif sMaterial == Interface.getString('angelskin') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2000
		end
	elseif sMaterial == Interface.getString('blood_crystal') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 1500
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 30
		end
	elseif sMaterial == Interface.getString('cold_iron') then
		iMaterialCost = 2 * iMaterialCost
		if iEnhancingBonus > 0 then iMaterialCost = iMaterialCost + 2000 end
		sNewDamageType = addProperty(sNewDamageType, 'cold iron')
	elseif sMaterial == Interface.getString('darkleaf_cloth') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 750
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1500
		else
			iMaterialCost = iMaterialCost + 375 * iWeight
		end
		iNewArmorPenalty = iArmorPenalty + 3
		iNewArmorMaxDex = iNewArmorMaxDex + 2
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
		if iNewArmorSpellFailure < 5 then iNewArmorSpellFailure = 5 end
	elseif sMaterial == Interface.getString('darkwood') then
		if sType == 'shield' then iNewArmorPenalty = iNewArmorPenalty + 2 end
		iMaterialCost = iWeight * 10 + getMasterworkPrice(sType, sProperties)
		iNewWeight = iNewWeight / 2
	elseif sMaterial == Interface.getString('dragonhide') then
		iMaterialCost = 2 * getMasterworkPrice(sType, sProperties)
	elseif sMaterial == Interface.getString('eel_hide') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1200
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1800
		end
		iNewArmorPenalty = iArmorPenalty + 1
		iNewArmorMaxDex = iNewArmorMaxDex + 1
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
	elseif sMaterial == Interface.getString('elysian_bronze') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 1000
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 20
		end
	elseif sMaterial == Interface.getString('fire_forged_steel') or sMaterial == Interface.getString('frost_forged_steel') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2500
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 600
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 15
		end
	elseif sMaterial == Interface.getString('greenwood') then
		iMaterialCost = iWeight * 50 + getMasterworkPrice(sType, sProperties)
	elseif sMaterial == Interface.getString('griffon_mane') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 200
		else
			iMaterialCost = iMaterialCost + iWeight * 50
		end
	elseif sMaterial == Interface.getString('living_steel') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 500
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 1500
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 500
		elseif sType == 'shield' then
			iMaterialCost = iMaterialCost + 100
		elseif sType == 'ammunition' then
			iMaterialCost = 10
		else
			iMaterialCost = iMaterialCost + 250 * iWeight
		end
	elseif sMaterial == Interface.getString('mithral') then
		sNewDamageType = addProperty(sNewDamageType, 'silver')
		iNewWeight = iNewWeight / 2
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 4000
			iNewSpeed30 = 30
			iNewSpeed20 = 20
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 9000
			iNewSpeed30 = 20
			iNewSpeed20 = 15
		elseif sType == 'shield' then
			iMaterialCost = iMaterialCost + 1000
		else
			iMaterialCost = iMaterialCost + 500 * iWeight
		end
		iNewArmorPenalty = iArmorPenalty + 3
		if iNewArmorMaxDex > 0 then iNewArmorMaxDex = iNewArmorMaxDex + 2 end
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
		if iNewArmorSpellFailure < 0 then iNewArmorSpellFailure = 0 end
	elseif sMaterial == Interface.getString('viridium') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 200
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 20
		end
	elseif sMaterial == Interface.getString('whipwood') then
		iMaterialCost = iMaterialCost + 500
	elseif sMaterial == Interface.getString('wyroot') then
		iMaterialCost = iMaterialCost + 1000
	elseif sMaterial == Interface.getString('bone') then
		iMaterialCost = iItemBaseCost / 2
		-- elseif sMaterial == Interface.getString("bronze") then
	elseif sMaterial == Interface.getString('gold') then
		iNewArmorPenalty = iNewArmorPenalty - 2
		iNewWeight = iNewWeight * 1.5
		iMaterialCost = 10 * iMaterialCost
	elseif sMaterial == Interface.getString('obsidian') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iNewWeight / 2
	elseif sMaterial == Interface.getString('stone') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iNewWeight / 4
	end

	if aSpecialMaterials[sMaterial] and aSpecialMaterials[sMaterial].bAlwaysMasterwork and sType == 'armor' and iNewArmorPenalty == iArmorPenalty then
		iNewArmorPenalty = iArmorPenalty + 1
	end
	if iNewArmorPenalty > 0 then iNewArmorPenalty = 0 end

	local bAlwaysMasterwork = false
	if aSpecialMaterials[sMaterial] and aSpecialMaterials[sMaterial].bAlwaysMasterwork then
		bAlwaysMasterwork = aSpecialMaterials[sMaterial].bAlwaysMasterwork
	end

	local bFragile = false
	if aSpecialMaterials[sMaterial] and aSpecialMaterials[sMaterial].bFragile then bFragile = aSpecialMaterials[sMaterial].bFragile end

	return iMaterialCost,
		iNewWeight,
		iNewArmorPenalty,
		iNewArmorMaxDex,
		iNewArmorSpellFailure,
		iNewSpeed30,
		iNewSpeed20,
		bAlwaysMasterwork,
		bFragile,
		sNewProperties,
		sNewDamageType,
		sAddDescription
end

function getMasterworkPrice(sType, sProperties)
	iMasterworkPrice = 0
	local bDoubleProperty = sProperties:lower():match('double')

	if sType == 'armor' or sType == 'shield' then
		iMasterworkPrice = 150
	elseif sType == 'ammunition' then
		iMasterworkPrice = 6
	elseif sType == 'weapon' then
		if bDoubleProperty then
			iMasterworkPrice = 600
		else
			iMasterworkPrice = 300
		end
	end
	return iMasterworkPrice
end

function getItemData(databasenode)
	local dItemName = DB.getChild(databasenode, 'name')
	local dItemProperties = DB.getChild(databasenode, 'properties')
	local dItemWeight = DB.getChild(databasenode, 'weight')
	local dItemCost = DB.getChild(databasenode, 'cost')
	local dSubtype = DB.getChild(databasenode, 'subtype')
	local dArmorPenalty = DB.getChild(databasenode, 'checkpenalty')
	local dArmorMaxDex = DB.getChild(databasenode, 'maxstatbonus')
	local dArmorSpellFailure = DB.getChild(databasenode, 'spellfailure')
	local dSpeed30 = DB.getChild(databasenode, 'speed30')
	local dSpeed20 = DB.getChild(databasenode, 'speed20')
	local dDamageType = DB.getChild(databasenode, 'damagetype')
	local dRange = DB.getChild(databasenode, 'range')
	local dDamage = DB.getChild(databasenode, 'damage')
	local dSize = DB.getChild(databasenode, 'size')

	local sItemName, iItemCost, iItemWeight, sFullSubType, sItemProperties, iArmorPenalty, iArmorMaxDex, iArmorSpellFailure, iSpeed30, iSpeed20, sItemCost, sDamageType, iRange, sDamage, sOriginalSize =
		'', 0, 0, '', '', 0, 0, 0, 0, 0, '', '', 0, '', ''

	if dItemName then sItemName = dItemName.getValue() end
	if dItemProperties then
		sItemProperties = dItemProperties.getValue()
		if sItemProperties == '-' then sItemProperties = '' end
	end
	if dItemWeight then iItemWeight = dItemWeight.getValue() end
	if dItemCost then sItemCost = dItemCost.getValue() end
	if dSubtype then sFullSubType = dSubtype.getValue() end
	if dArmorPenalty then iArmorPenalty = dArmorPenalty.getValue() end
	if dArmorMaxDex then iArmorMaxDex = dArmorMaxDex.getValue() end
	if dArmorSpellFailure then iArmorSpellFailure = dArmorSpellFailure.getValue() end
	if dSpeed30 then iSpeed30 = dSpeed30.getValue() end
	if dSpeed20 then iSpeed20 = dSpeed20.getValue() end
	if dDamageType then sDamageType = dDamageType.getValue() end
	if dRange then iRange = dRange.getValue() end
	if dDamage then sDamage = dDamage.getValue() end
	if dSize then sOriginalSize = dSize.getValue() end
	if not sOriginalSize or sOriginalSize == '' then sOriginalSize = Interface.getString('item_size_medium') end

	local sCoinValue, sCoin = sItemCost:match('^%s*([%d,]+)%s*([^%d]*)$')
	if not sCoinValue then
		sCoin, sCoinValue = sItemCost:match('^%s*([^%d]+)%s*([%d,]+)%s*$')
	end
	if sCoinValue then
		sCoinValue = string.gsub(sCoinValue, ',', '')
		iItemCost = tonumber(sCoinValue) or 0
		sCoin = StringManager.trim(sCoin)
		if sCoin == 'pp' then
			iItemCost = 10 * iItemCost
		elseif sCoin == 'sp' then
			iItemCost = iItemCost / 10
		elseif sCoin == 'cp' then
			iItemCost = iItemCost / 100
		end
	end
	return sItemName,
		iItemCost,
		iItemWeight,
		sFullSubType,
		sItemProperties,
		iArmorPenalty,
		iArmorMaxDex,
		iArmorSpellFailure,
		iSpeed30,
		iSpeed20,
		iRange,
		sDamageType,
		sDamage,
		sOriginalSize
end

function getEnchancementCost(iEnchancementBonus, sType)
	local aBonusPriceArmor = { 0, 1000, 4000, 9000, 16000, 25000, 36000, 49000, 64000, 81000, 100000 }
	local aBonusPriceWeapon = { 0, 2000, 8000, 18000, 32000, 50000, 72000, 98000, 128000, 162000, 200000 }
	local aBonusPriceAmmunition = { 0, 40, 160, 360, 640, 1000, 1440, 1960, 2560, 3240, 4000 }
	local iEnchantmentCost = 0

	if sType == 'weapon' then
		iEnchantmentCost = aBonusPriceWeapon[iEnchancementBonus + 1]
	elseif sType == 'armor' or sType == 'shield' then
		iEnchantmentCost = aBonusPriceArmor[iEnchancementBonus + 1]
	elseif sType == 'ammunition' then
		iEnchantmentCost = aBonusPriceAmmunition[iEnchancementBonus + 1]
	end
	return iEnchantmentCost
end

function figureAbilityName(sAbility, sSubAbility, sSubSubAbility)
	local sAbilityName = ''
	sAbilityName = sAbilityName .. sAbility
	if sSubAbility ~= Interface.getString('itemnone') then
		sAbilityName = sAbilityName .. '(' .. sSubAbility
		if sSubSubAbility ~= Interface.getString('itemnone') then sAbilityName = sAbilityName .. '(' .. sSubSubAbility .. ')' end
		sAbilityName = sAbilityName .. ')'
	end
	sAbilityName = sAbilityName .. ' '
	return sAbilityName
end

function getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)
	local sItemNewName = ''
	if sItemSize:lower() ~= Interface.getString('item_size_medium'):lower() then sItemNewName = sItemNewName .. sItemSize .. ' ' end
	if sEnhancementBonus == Interface.getString('bonus_mwk') and not bMasterworkMaterial then sItemNewName = sItemNewName .. 'masterwork' .. ' ' end
	if iEnchancementBonus > 0 then sItemNewName = sItemNewName .. '+' .. tostring(iEnchancementBonus) .. ' ' end
	if sSpecialMaterial ~= Interface.getString('itemnone') then
		sItemNewName = sItemNewName .. aSpecialMaterials[sSpecialMaterial].sStringName .. ' '
	end

	for _, aAbility in pairs(aAbilities) do
		sItemNewName = sItemNewName .. figureAbilityName(aAbility.sAbility, aAbility.sSubAbility, aAbility.sSubSubAbility)
	end

	sItemNewName = sItemNewName .. sItemName
	sItemNewName = sItemNewName:lower()

	sItemNewName = sItemNewName:gsub('^%l', string.upper)

	return sItemNewName
end

function getSpecialAbilityData(sSpecialAbility, sDamageType, iRange)
	local sNewDamageType = sDamageType:lower()
	local iNewRange = iRange
	if sSpecialAbility == Interface.getString('anarchic') then
		sNewDamageType = addProperty(sNewDamageType, 'chaotic')
	elseif sSpecialAbility == Interface.getString('axiomatic') then
		sNewDamageType = addProperty(sNewDamageType, 'lawful')
	elseif sSpecialAbility == Interface.getString('deadly') then
		sNewDamageType = string.gsub(sNewDamageType, ', nonlethal', '')
		sNewDamageType = string.gsub(sNewDamageType, 'nonlethal', '')
	elseif sSpecialAbility == Interface.getString('distance') then
		iNewRange = 2 * iNewRange
	elseif sSpecialAbility == Interface.getString('holy') then
		sNewDamageType = addProperty(sNewDamageType, 'good')
	elseif sSpecialAbility == Interface.getString('merciful') then
		sNewDamageType = addProperty(sNewDamageType, 'nonlethal')
	elseif sSpecialAbility == Interface.getString('throwing') then
		iNewRange = 10
	elseif sSpecialAbility == Interface.getString('unholy') then
		sNewDamageType = addProperty(sNewDamageType, 'evil')
	end
	return sNewDamageType, iNewRange
end

function changeDamageBySizeDifference(sDamage, iSizeDifference)
	if sDamage == '' or sDamage == nil then return sDamage end
	local aDamage = {}
	local aDamageSplit = StringManager.split(sDamage, '/')

	for kDamage, vDamage in ipairs(aDamageSplit) do
		local diceDamage, nDamage = DiceManager.convertStringToDice(vDamage)
		local nDiceCount = 0
		local sDie = ''
		for _, dice in pairs(diceDamage) do
			if sDie == '' then sDie = dice end
			nDiceCount = nDiceCount + 1
		end
		table.insert(aDamage, { dice = nDiceCount .. sDie, mod = nDamage })
	end

	local aNewDamage = {}
	for _, aDmg in pairs(aDamage) do
		local sNewDamage = aDmg.dice
		local nMod = aDmg.mod
		local iPosition = 0
		local bIsAlt1 = false
		local bIsAlt2 = false
		local bIsAlt3 = false

		if aDamageDice[sNewDamage] ~= nil then
			iPosition = aDamageDice[sNewDamage].iPosition
		elseif aAltDamageDice1[sNewDamage] ~= nil then
			sNewDamage = aAltDamageDice1[sNewDamage].sDamage
			iPosition = aDamageDice[sNewDamage].iPosition
			bIsAlt1 = true
		elseif aAltDamageDice2[sNewDamage] ~= nil then
			sNewDamage = aAltDamageDice2[sNewDamage].sDamage
			iPosition = aDamageDice[sNewDamage].iPosition
			bIsAlt2 = true
		elseif aAltDamageDice3[sNewDamage] ~= nil then
			if iSizeDifference < 0 then
				sNewDamage = aAltDamageDice3[sNewDamage].sDown
				iPosition = aDamageDice[sNewDamage].iPosition
				iSizeDifference = iSizeDifference + 1
			else
				sNewDamage = aAltDamageDice3[sNewDamage].sUp
				iPosition = aDamageDice[sNewDamage].iPosition
				iSizeDifference = iSizeDifference - 1
			end
			bIsAlt3 = true
		end

		local iChange
		for iVar = 1, math.abs(iSizeDifference), 1 do
			if iSizeDifference < 0 then
				iChange = -1
			else
				iChange = 1
			end
			if aDamageDice[sNewDamage].iPosition > aDamageDice['1d6'].iPosition then iChange = iChange * 2 end
			sNewDamage = aPositionDamage[aDamageDice[sNewDamage].iPosition + iChange].sDamage
		end

		if bIsAlt1 then
			if aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage1 ~= nil then
				sNewDamage = aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage1
			end
		end
		if bIsAlt2 then
			if aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage2 ~= nil then
				sNewDamage = aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage2
			end
		end
		if bIsAlt3 then
			if aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage3 ~= nil then
				sNewDamage = aPositionDamage[aDamageDice[sNewDamage].iPosition].sAltDamage3
			end
		end

		table.insert(aNewDamage, { dice = sNewDamage, mod = nMod })
	end

	return getDamageString(aNewDamage)
end

local function mergeDamage(aDamage)
	local sNewDamage = aDamage.dice
	if aDamage.mod > 0 then
		sNewDamage = sNewDamage .. '+' .. aDamage.mod
	elseif aDamage.mod < 0 then
		sNewDamage = sNewDamage .. aDamage.mod
	end
	return sNewDamage
end

function getDamageString(aDamage)
	local sNewDamage = ''
	if aDamage[2] then sNewDamage = mergeDamage(aDamage[2]) end
	if aDamage[1] then
		if sNewDamage ~= '' then sNewDamage = sNewDamage .. '/' end
		sNewDamage = mergeDamage(aDamage[1])
	end
	return sNewDamage
end

local function usingAE() return StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Advanced-Effects') end

function addEffectsForAbility(nodeItem, sType, sSubType, sAbility, sSubAbility, sSubSubAbility)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	local aAbility = {}
	local nCritical = 0
	if ItemManager.isWeapon(nodeItem) then
		if sSubType == 'melee' then
			aAbility = aMeleeWeaponAbilities[sAbility]
			nCritical = getCritical(nodeItem)
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			aAbility = aRangedWeaponAbilities[sAbility]
			nCritical = getCritical(nodeItem)
		end
	elseif sType == 'ammunition' then
		aAbility = aAmmunitionAbilities[sAbility]
	elseif ItemManager.isArmor(nodeItem) then
		aAbility = aArmorAbilities[sAbility]
	elseif ItemManager.isShield(nodeItem) then
		aAbility = aShieldAbilities[sAbility]
	end

	local aEffects = {}
	if aAbility then
		if sSubAbility ~= Interface.getString('itemnone') and next(aAbility.aSubSelection) ~= nil then
			if sSubSubAbility ~= Interface.getString('itemnone') and next(aAbility.aSubSelection[sSubAbility].aSubSubSelection) ~= nil then
				aEffects = aAbility.aSubSelection[sSubAbility].aSubSubSelection[sSubSubAbility].aEffects
			else
				aEffects = aAbility.aSubSelection[sSubAbility].aEffects
			end
		else
			aEffects = aAbility.aEffects
		end
	end
	if next(aEffects) ~= nil then
		for _, aEffect in ipairs(aEffects) do
			if not aEffect.bAERequired or (aEffect.bAERequired and CombatManagerKel) then
				if aEffect.nCritical == 0 or (aEffect.nCritical == nCritical) then
					local sEffect = aEffect.sEffect
					if sType == 'ammunition' and aEffect.sEffect:match('%%s') then sEffect = sEffect:format(getWeaponTypeName(nodeItem)) end
					addEffect(nodeEffectList, sEffect, aEffect.nActionOnly, false)
				end
			end
		end
	end
end

function addEffect(nodeEffectList, sEffect, nActionOnly, bIsLabel)
	if (not nodeEffectList or not sEffect) and sEffect ~= '' then return end
	local nodeEffect = DB.createChild(nodeEffectList)
	if not nodeEffect then return end
	if bIsLabel then DB.setValue(nodeEffect, 'type', 'string', 'label') end
	DB.setValue(nodeEffect, 'effect', 'string', sEffect)
	DB.setValue(nodeEffect, 'actiononly', 'number', nActionOnly)
end

function getCritical(nodeItem)
	if not nodeItem then return 0 end
	local nCritical = 2
	local sCritical = DB.getValue(nodeItem, 'critical')
	if sCritical then
		sCritical = sCritical:match('x%d+')
		if sCritical then nCritical = tonumber(sCritical:match('%d+')) end
	end
	return nCritical
end

function addRangedEffect(nodeItem)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	addEffect(nodeEffectList, getWeaponTypeName(nodeItem) .. ' Attack', 1, true)
	addEffect(nodeEffectList, 'Crit' .. getCritical(nodeItem), 1, true)
end

function addAmmoEffect(nodeItem)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	local nBonus = DB.getValue(nodeItem, 'bonus', 0)
	addEffect(nodeEffectList, 'IF: CUSTOM(' .. getWeaponTypeName(nodeItem) .. ' Attack); ATK: ' .. nBonus .. ' ranged; DMG: ' .. nBonus, 0, false)
end

function getWeaponTypeName(nodeItem)
	if not nodeItem then return '' end
	local sItemName = string.lower(DB.getValue(nodeItem, 'name', ''))
	local sSubType = string.lower(DB.getValue(nodeItem, 'subtype', ''))
	local sType = string.lower(DB.getValue(nodeItem, 'type', ''))
	if sSubType:match('ranged') and sItemName:match('crossbow') then
		return 'Crossbow'
	elseif sSubType:match('ranged') and sItemName:match('bow') then
		return 'Bow'
	elseif sSubType:match('firearm') then
		return 'Firearm'
	elseif sType == 'ammo' or sSubType == 'ammunition' then
		if sItemName:match('arrow') then
			return 'Bow'
		elseif sItemName:match('bolt') then
			return 'Crossbow'
		elseif sItemName:match('bullet') or sItemName:match('cartridge') then
			return 'Firearm'
		end
	end
	return ''
end

function getWeightBySize(iItemWeight, sOriginalSize, sItemSize)
	if sOriginalSize:lower() == sItemSize:lower() then return iItemWeight end
	return iItemWeight / aWeightMultiplier[sOriginalSize:lower()].nMultiplier * aWeightMultiplier[sItemSize:lower()].nMultiplier
end

---	This function returns true if either supplied string is nil or blank.
function notifyMissingTypeData(sType, sSubType)
	local bNotified
	if not sType or sType == '' then
		ChatManager.SystemMessage(string.format(Interface.getString('magic_item_gen_error_8'), 'type'))
		bNotified = true
	end
	if (not sSubType or sSubType == '') and not sType == 'ammunition' then
		ChatManager.SystemMessage(string.format(Interface.getString('magic_item_gen_error_8'), 'subtype'))
		bNotified = true
	end
	return bNotified
end
