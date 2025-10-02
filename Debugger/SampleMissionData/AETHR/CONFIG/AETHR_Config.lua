-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["Zone"] = {
		["gameBounds"] = {
			["FillAlpha"] = 0.4;
			["LineColors"] = {
				["r"] = 0.1;
				["g"] = 0.1;
				["b"] = 0.1;
			};
			["LineAlpha"] = 0.3;
			["FillColors"] = {
				["r"] = 0.1;
				["g"] = 0.1;
				["b"] = 0.1;
			};
			["getOutOfBounds"] = {
				["snapDistance"] = 0;
				["samplesPerEdge"] = 20;
				["useHoleSinglePolygon"] = false;
			};
			["lineType"] = 0;
		};
		["BorderOffsetThreshold"] = 800;
		["paintColors"] = {
			["CircleColors"] = {
				[0] = {
					["a"] = 0.15;
					["r"] = 0.941;
					["g"] = 0.941;
					["b"] = 0.941;
				};
				[2] = {
					["a"] = 0.15;
					["r"] = 0.941;
					["g"] = 0.941;
					["b"] = 0.941;
				};
				[1] = {
					["a"] = 0.15;
					["r"] = 0.941;
					["g"] = 0.941;
					["b"] = 0.941;
				};
			};
			["LineColors"] = {
				[0] = {
					["r"] = 0;
					["g"] = 0;
					["b"] = 0;
				};
				[2] = {
					["r"] = 0;
					["g"] = 0;
					["b"] = 1;
				};
				[1] = {
					["r"] = 1;
					["g"] = 0;
					["b"] = 0;
				};
			};
			["ArrowColors"] = {
				[0] = {
					["a"] = 0.5;
					["r"] = 0;
					["g"] = 0;
					["b"] = 0;
				};
				[2] = {
					["a"] = 0.5;
					["r"] = 0;
					["g"] = 0;
					["b"] = 1;
				};
				[1] = {
					["a"] = 0.5;
					["r"] = 1;
					["g"] = 0;
					["b"] = 0;
				};
			};
			["FillColors"] = {
				[0] = {
					["r"] = 0;
					["g"] = 0;
					["b"] = 0;
				};
				[2] = {
					["r"] = 0;
					["g"] = 0;
					["b"] = 1;
				};
				[1] = {
					["r"] = 1;
					["g"] = 0;
					["b"] = 0;
				};
			};
			["FillAlpha"] = 0.2;
			["lineType"] = 4;
			["LineAlpha"] = 0.5;
		};
		["ArrowLength"] = 15000;
	};
	["STORAGE"] = {
		["CONFIG_FOLDER"] = "CONFIG";
		["ROOT_FOLDER"] = "AETHR";
		["SUB_FOLDERS"] = {
			["USER_FOLDER"] = "USER";
			["UNITS_FOLDER"] = "UNITS";
			["LEARNING_FOLDER"] = "LEARNING";
			["MAP_FOLDER"] = "MAP";
			["OBJECTS_FOLDER"] = "OBJECTS";
		};
		["PATHS"] = {
			["USER_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\1\\USER";
			["CONFIG_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\CONFIG";
			["LEARNING_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\1\\LEARNING";
			["MAP_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\1\\MAP";
			["OBJECTS_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\1\\OBJECTS";
			["UNITS_FOLDER"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\\\AETHR\\1\\UNITS";
		};
		["FILENAMES"] = {
			["MIZ_ZONES_FILE"] = "mizZones.lua";
			["AIRBASES_FILE"] = "airbases.lua";
			["BASE_OBJECTS_FILE"] = "baseObjects.lua";
			["OBJECTS_FILE"] = "objects.lua";
			["GAME_BOUNDS_FILE"] = "gameBounds.lua";
			["SPAWNER_ATTRIBUTE_DB"] = "spawnerAttributesDB.lua";
			["USER_STORAGE_FILE"] = "userStorage.lua";
			["SPAWNER_TEMPLATE_DB"] = "spawnerTemplateDB.lua";
			["MIZ_CACHE_DB"] = "mizCacheDB.lua";
			["SAVE_DIVS_FILE"] = "saveDivs.lua";
			["SPAWNER_UNIT_CACHE_DB"] = "spawnerUnitInfoCache.lua";
			["SCENERY_OBJECTS_FILE"] = "sceneryObjects.lua";
			["STATIC_OBJECTS_FILE"] = "staticObjects.lua";
			["WORLD_DIVISIONS_FILE"] = "worldDivisions.lua";
			["AETHER_CONFIG_FILE"] = "AETHR_Config.lua";
		};
		["SAVEGAME_DIR"] = "C:\\Users\\Administrator\\Saved Games\\DevServer\\";
	};
	["worldBounds"] = {
		["Iraq"] = {
			["X"] = {
				["min"] = -950000;
				["max"] = 435000;
			};
			["Z"] = {
				["min"] = -500000;
				["max"] = 850000;
			};
		};
		["Normandy"] = {
			["X"] = {
				["min"] = -130000;
				["max"] = 255000;
			};
			["Z"] = {
				["min"] = -230000;
				["max"] = 260000;
			};
		};
		["Syria"] = {
			["X"] = {
				["min"] = -380000;
				["max"] = 291899;
			};
			["Z"] = {
				["min"] = -520000;
				["max"] = 520000;
			};
		};
		["MARIANAS_WWII"] = {
			["X"] = {
				["min"] = -300000;
				["max"] = 1000000;
			};
			["Z"] = {
				["min"] = -1000000;
				["max"] = 500000;
			};
		};
		["GermanyCW"] = {
			["X"] = {
				["min"] = -600000;
				["max"] = 86000;
			};
			["Z"] = {
				["min"] = -1100000;
				["max"] = -300000;
			};
		};
		["MARIANAS_MODERN"] = {
			["X"] = {
				["min"] = -300000;
				["max"] = 1000000;
			};
			["Z"] = {
				["min"] = -800000;
				["max"] = 800000;
			};
		};
		["Caucasus"] = {
			["X"] = {
				["min"] = -600000;
				["max"] = 400000;
			};
			["Z"] = {
				["min"] = -570000;
				["max"] = 1130000;
			};
		};
		["Kola"] = {
			["X"] = {
				["min"] = -315000;
				["max"] = 810000;
			};
			["Z"] = {
				["min"] = -900000;
				["max"] = 860000;
			};
		};
		["NEVADA"] = {
			["X"] = {
				["min"] = 0;
				["max"] = 0;
			};
			["Z"] = {
				["min"] = 0;
				["max"] = 0;
			};
		};
		["SinaiMap"] = {
			["X"] = {
				["min"] = -500000;
				["max"] = 490000;
			};
			["Z"] = {
				["min"] = -280000;
				["max"] = 560000;
			};
		};
		["PersianGulf"] = {
			["X"] = {
				["min"] = -460000;
				["max"] = 800000;
			};
			["Z"] = {
				["min"] = -900000;
				["max"] = 800000;
			};
		};
		["Afghanistan"] = {
			["X"] = {
				["min"] = -1180000;
				["max"] = 535000;
			};
			["Z"] = {
				["min"] = -534000;
				["max"] = 760000;
			};
		};
	};
	["DESCRIPTION"] = {
		[1] = "Autonomous Environment for Theater Realism";
		[2] = "AETHR is a framework designed to enhance the realism and immersion of DCS World missions.";
		[4] = "A high-fidelity simulation layer that weaves in adaptive machine learning decision-making across the whole theater.";
		[3] = "It provides a set of tools and libraries to create dynamic and engaging scenarios.";
	};
	["spawnTemplateSearchString"] = "SPECTRESPAWNERTemplate";
	["MISSION_ID"] = "1";
	["VERSION"] = "0.1.0";
	["THEATER"] = "Caucasus";
	["outTextSettings"] = {
		["airbaseOwnershipChange"] = {
			["clearView"] = false;
			["displayTime"] = 10;
		};
		["zoneOwnershipChange"] = {
			["clearView"] = false;
			["displayTime"] = 10;
		};
	};
	["MIZ_ZONES"] = {
		["BLUESTART"] = {
			[1] = "Zone_ECHO";
		};
		["ALL"] = {
			[6] = "Zone_FOXTROT";
			[2] = "Zone_BRAVO";
			[3] = "Zone_CHARLIE";
			[1] = "Zone_ALPHA";
			[4] = "Zone_DELTA";
			[5] = "Zone_ECHO";
		};
		["REDSTART"] = {
			[1] = "Zone_ALPHA";
			[2] = "Zone_BRAVO";
		};
	};
	["COUNTERS"] = {
		["DYNAMIC_SPAWNERS"] = 1;
		["UNITS"] = 1;
		["OBJECTS"] = 1;
		["GROUPS"] = 1;
		["MARKERS"] = 3532677;
		["STATIC_OBJECTS"] = 1;
		["SCENERY_OBJECTS"] = 1;
	};
	["GITHUB"] = "https://github.com/Gh0st352";
	["DefaultRedCountry"] = 80;
	["AUTHOR"] = "Gh0st352";
	["worldDivisionArea"] = 1862500000;
	["DefaultBlueCountry"] = 81;
	["FLAGS"] = {
		["LEARN_WORLD_OBJECTS"] = true;
		["AETHR_DEBUG_MODE"] = false;
		["AETHR_LEARNING_MODE"] = false;
		["AETHR_FIRST_RUN"] = true;
	};
	["DEBUG_ENABLED"] = true;
}
return obj1
