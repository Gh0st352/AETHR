-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["SPECTRESPAWNERTemplate_2B11"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 63;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "2B11 mortar";
				["unitId"] = 63;
				["skill"] = "Random";
				["y"] = 978965.41333921;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_2B11-1";
				["playerCanDrive"] = false;
				["heading"] = 0.38397243543875;
				["x"] = -207068.37320519;
			};
		};
		["y"] = 978965.41333921;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_2B11";
		["x"] = -207068.37320519;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.52868755908;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978965.41333921;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207068.37320519;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Stryker22"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 37;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1128 Stryker MGS";
				["unitId"] = 37;
				["skill"] = "Random";
				["y"] = 978777.31886929;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Stryker22-1";
				["playerCanDrive"] = true;
				["heading"] = 6.0737457969403;
				["x"] = -206968.09862307;
			};
		};
		["y"] = 978777.31886929;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Stryker22";
		["x"] = -206968.09862307;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 854;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978777.31886929;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 10;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206968.09862307;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_JTAC"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 72;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "JTAC";
				["unitId"] = 72;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["BINO_0"] = true;
					["BINO_2"] = true;
					["BINO_3"] = true;
					["BINO_1"] = true;
				};
				["y"] = 978541.9808285;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_JTAC-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207223.54668236;
			};
		};
		["y"] = 978541.9808285;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_JTAC";
		["x"] = -207223.54668236;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 887.69464431488;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978541.9808285;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 16;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207223.54668236;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Ural375"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 64;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Ural-375";
				["unitId"] = 64;
				["skill"] = "Random";
				["y"] = 978736.66586084;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Ural375-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207306.76151522;
			};
		};
		["y"] = 978736.66586084;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Ural375";
		["x"] = -207306.76151522;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 860;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978736.66586084;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207306.76151522;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_S60"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 99;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "S-60_Type59_Artillery";
				["unitId"] = 134;
				["skill"] = "Random";
				["y"] = 979924.37431314;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_S60-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207438.56492727;
			};
		};
		["y"] = 979924.37431314;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_S60";
		["x"] = -207438.56492727;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 864;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979924.37431314;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207438.56492727;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZU23Closed"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 96;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZU-23 Emplacement Closed";
				["unitId"] = 131;
				["skill"] = "Random";
				["y"] = 979828.25400639;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZU23Closed-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207392.40217295;
			};
		};
		["y"] = 979828.25400639;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZU23Closed";
		["x"] = -207392.40217295;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 894.71106978833;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979828.25400639;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207392.40217295;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leclerc"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 35;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Leclerc";
				["unitId"] = 35;
				["skill"] = "Random";
				["y"] = 978826.94263404;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leclerc-1";
				["playerCanDrive"] = true;
				["heading"] = 5.9166661642608;
				["x"] = -206876.37001985;
			};
		};
		["y"] = 978826.94263404;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leclerc";
		["x"] = -206876.37001985;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.79907057166;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978826.94263404;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206876.37001985;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Sherman"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 31;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M4_Sherman";
				["unitId"] = 31;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["HedgeCutter"] = false;
				};
				["y"] = 978797.4553211;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Sherman-1";
				["playerCanDrive"] = true;
				["heading"] = 3.7873644768277;
				["x"] = -206988.54150893;
			};
		};
		["y"] = 978797.4553211;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Sherman";
		["x"] = -206988.54150893;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 884.18395965186;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978797.4553211;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206988.54150893;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_2S3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 69;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SAU Akatsia";
				["unitId"] = 69;
				["skill"] = "Random";
				["y"] = 979083.75212794;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_2S3-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207070.97059089;
			};
		};
		["y"] = 979083.75212794;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_2S3";
		["x"] = -207070.97059089;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.9418959801;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979083.75212794;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207070.97059089;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BTR80"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 1;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR-80";
				["unitId"] = 1;
				["skill"] = "Random";
				["y"] = 978782.94649509;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BTR80-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206815.76199023;
			};
		};
		["y"] = 978782.94649509;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BTR80";
		["x"] = -206815.76199023;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.41515905493;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978782.94649509;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206815.76199023;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Stinger"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 121;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Soldier stinger";
				["unitId"] = 199;
				["skill"] = "Random";
				["y"] = 979887.85033093;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Stinger-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207466.07544313;
			};
			[2] = {
				["type"] = "Stinger comm";
				["unitId"] = 200;
				["skill"] = "Random";
				["y"] = 979890.444305;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Stinger-2";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207467.52294637;
			};
		};
		["y"] = 979887.85033093;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Stinger";
		["x"] = -207466.07544313;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 895.44288204358;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979887.85033093;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207466.07544313;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leopard2A4T"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 29;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "leopard-2A4_trs";
				["unitId"] = 29;
				["skill"] = "Random";
				["y"] = 978892.46780783;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leopard2A4T-1";
				["playerCanDrive"] = true;
				["heading"] = 2.3911010752322;
				["x"] = -206877.60216731;
			};
		};
		["y"] = 978892.46780783;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leopard2A4T";
		["x"] = -206877.60216731;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 852;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978892.46780783;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206877.60216731;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Merkava"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 2;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Merkava_Mk4";
				["unitId"] = 2;
				["skill"] = "Random";
				["y"] = 978978.97785787;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Merkava-1";
				["playerCanDrive"] = true;
				["heading"] = 5.2708943410229;
				["x"] = -206879.54622176;
			};
		};
		["y"] = 978978.97785787;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Merkava";
		["x"] = -206879.54622176;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.08794925507;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978978.97785787;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206879.54622176;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BMP1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 3;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BMP-1";
				["unitId"] = 3;
				["skill"] = "Random";
				["y"] = 978800.8426293;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BMP1-1";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206842.7466338;
			};
		};
		["y"] = 978800.8426293;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BMP1";
		["x"] = -206842.7466338;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.59435845288;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978800.8426293;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206842.7466338;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BMP2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 17;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BMP-2";
				["unitId"] = 17;
				["skill"] = "Random";
				["y"] = 978826.33285103;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BMP2-1";
				["playerCanDrive"] = true;
				["heading"] = 0.89011791851711;
				["x"] = -206844.83046019;
			};
		};
		["y"] = 978826.33285103;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BMP2";
		["x"] = -206844.83046019;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.13389953781;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978826.33285103;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206844.83046019;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Warrior"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 15;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "MCV-80";
				["unitId"] = 15;
				["skill"] = "Random";
				["y"] = 978983.95839565;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Warrior-1";
				["playerCanDrive"] = true;
				["heading"] = 5.3930673886625;
				["x"] = -206848.88195587;
			};
		};
		["y"] = 978983.95839565;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Warrior";
		["x"] = -206848.88195587;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 881.76061738477;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978983.95839565;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206848.88195587;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Bedford"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 62;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Bedford_MWD";
				["unitId"] = 62;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["Tent"] = 2;
				};
				["y"] = 978541.82463547;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Bedford-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207300.40888156;
			};
		};
		["y"] = 978541.82463547;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Bedford";
		["x"] = -207300.40888156;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 888.80102969861;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978541.82463547;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207300.40888156;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_2S1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 51;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SAU Gvozdika";
				["unitId"] = 51;
				["skill"] = "Random";
				["y"] = 979037.30714299;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_2S1-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207068.90492496;
			};
		};
		["y"] = 979037.30714299;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_2S1";
		["x"] = -207068.90492496;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.75994999738;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979037.30714299;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207068.90492496;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_2S19"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 47;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SAU Msta";
				["unitId"] = 47;
				["skill"] = "Random";
				["y"] = 979062.71415128;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_2S19-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207066.60719581;
			};
		};
		["y"] = 979062.71415128;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_2S19";
		["x"] = -207066.60719581;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.79364143732;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979062.71415128;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207066.60719581;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_PLZ"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 68;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "PLZ05";
				["unitId"] = 68;
				["skill"] = "Random";
				["y"] = 979014.09748637;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_PLZ-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207068.44972579;
			};
		};
		["y"] = 979014.09748637;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_PLZ";
		["x"] = -207068.44972579;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.68011593317;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979014.09748637;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 14;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207068.44972579;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZTZ"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 12;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZTZ96B";
				["unitId"] = 12;
				["skill"] = "Random";
				["y"] = 979123.572567;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZTZ-1";
				["playerCanDrive"] = true;
				["heading"] = 2.1293016874331;
				["x"] = -206881.34078596;
			};
		};
		["y"] = 979123.572567;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZTZ";
		["x"] = -206881.34078596;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 852;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979123.572567;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 4;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206881.34078596;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_PT76"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 16;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "PT_76";
				["unitId"] = 16;
				["skill"] = "Random";
				["y"] = 978775.26562786;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_PT76-1";
				["playerCanDrive"] = false;
				["heading"] = 0.71558499331767;
				["x"] = -206987.7662882;
			};
		};
		["y"] = 978775.26562786;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_PT76";
		["x"] = -206987.7662882;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 884.47027585614;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978775.26562786;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206987.7662882;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_AK74"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 48;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Soldier AK";
				["unitId"] = 48;
				["skill"] = "Random";
				["y"] = 978516.70648;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_AK74-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207225.1980264;
			};
		};
		["y"] = 978516.70648;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_AK74";
		["x"] = -207225.1980264;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 888.20123661835;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978516.70648;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207225.1980264;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_MRL"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 84;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Grad_FDDM";
				["unitId"] = 84;
				["skill"] = "Random";
				["y"] = 978767.69766852;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_MRL-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207064.54034493;
			};
		};
		["y"] = 978767.69766852;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_MRL";
		["x"] = -207064.54034493;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.97418361005;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978767.69766852;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207064.54034493;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_WatchTower"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 81;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "house2arm";
				["unitId"] = 81;
				["skill"] = "Random";
				["y"] = 978811.92536863;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_WatchTower-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207170.47210691;
			};
		};
		["y"] = 978811.92536863;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_WatchTower";
		["x"] = -207170.47210691;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.0568730936;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978811.92536863;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207170.47210691;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_LC_DSHK"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 45;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "tt_DSHK";
				["unitId"] = 45;
				["skill"] = "Random";
				["y"] = 978850.70365763;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_LC_DSHK-1";
				["playerCanDrive"] = true;
				["heading"] = 5.0090949532237;
				["x"] = -206916.38968325;
			};
		};
		["y"] = 978850.70365763;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_LC_DSHK";
		["x"] = -206916.38968325;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.07836772595;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978850.70365763;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206916.38968325;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Hawk"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 88;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[7] = {
				["type"] = "Hawk ln";
				["unitId"] = 94;
				["skill"] = "Random";
				["y"] = 980139.54655203;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-7";
				["playerCanDrive"] = false;
				["heading"] = 6.2482787221397;
				["x"] = -208142.10255603;
			};
			[1] = {
				["type"] = "Hawk sr";
				["unitId"] = 88;
				["skill"] = "Random";
				["y"] = 980241.79688359;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-1";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -208165.33857131;
			};
			[2] = {
				["type"] = "Hawk pcp";
				["unitId"] = 89;
				["skill"] = "Random";
				["y"] = 980163.87214531;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-2";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -208183.5461594;
			};
			[4] = {
				["type"] = "Hawk cwar";
				["unitId"] = 91;
				["skill"] = "Random";
				["y"] = 980172.8816243;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-4";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -208243.90966865;
			};
			[8] = {
				["type"] = "Hawk tr";
				["unitId"] = 95;
				["skill"] = "Random";
				["y"] = 980217.02807137;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-8";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -208116.87601485;
			};
			[9] = {
				["type"] = "Hawk ln";
				["unitId"] = 96;
				["skill"] = "Random";
				["y"] = 980235.94797725;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-9";
				["playerCanDrive"] = false;
				["heading"] = 0.087266462599716;
				["x"] = -208235.80113756;
			};
			[5] = {
				["type"] = "Hawk ln";
				["unitId"] = 92;
				["skill"] = "Random";
				["y"] = 980041.343231;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-5";
				["playerCanDrive"] = false;
				["heading"] = 3.8048177693476;
				["x"] = -208097.05516107;
			};
			[10] = {
				["type"] = "Hawk ln";
				["unitId"] = 97;
				["skill"] = "Random";
				["y"] = 980301.7171739;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-10";
				["playerCanDrive"] = false;
				["heading"] = 0.94247779607694;
				["x"] = -208108.76748376;
			};
			[3] = {
				["type"] = "Hawk tr";
				["unitId"] = 90;
				["skill"] = "Random";
				["y"] = 980350.36836046;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-3";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -208148.40919132;
			};
			[6] = {
				["type"] = "Hawk ln";
				["unitId"] = 93;
				["skill"] = "Random";
				["y"] = 980108.91432345;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-6";
				["playerCanDrive"] = false;
				["heading"] = 5.7072266540215;
				["x"] = -208222.28691907;
			};
			[11] = {
				["type"] = "Hawk ln";
				["unitId"] = 98;
				["skill"] = "Random";
				["y"] = 980380.52073055;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Hawk-11";
				["playerCanDrive"] = false;
				["heading"] = 2.6703537555513;
				["x"] = -208196.51246951;
			};
		};
		["y"] = 980241.79688359;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Hawk";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 383;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980241.79688359;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208165.33857131;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208165.33857131;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_HQ7"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 102;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HQ-7_STR_SP";
				["unitId"] = 137;
				["skill"] = "Random";
				["y"] = 979853.52603243;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HQ7-1";
				["playerCanDrive"] = true;
				["heading"] = 0.48869219055841;
				["x"] = -207762.00218622;
			};
			[2] = {
				["type"] = "HQ-7_LN_SP";
				["unitId"] = 138;
				["skill"] = "Random";
				["y"] = 979903.57339095;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HQ7-2";
				["playerCanDrive"] = false;
				["heading"] = 1.3613568165556;
				["x"] = -207763.09611755;
			};
			[3] = {
				["type"] = "HQ-7_LN_SP";
				["unitId"] = 139;
				["skill"] = "Random";
				["y"] = 979823.853145;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HQ7-3";
				["playerCanDrive"] = false;
				["heading"] = 5.4279739737024;
				["x"] = -207738.89288679;
			};
		};
		["y"] = 979853.52603243;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HQ7";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 900.78291423907;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979853.52603243;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207762.00218622;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207762.00218622;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_Bradley"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 18;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M-2 Bradley";
				["unitId"] = 18;
				["skill"] = "Random";
				["y"] = 978941.03773951;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Bradley-1";
				["playerCanDrive"] = true;
				["heading"] = 0.85521133347722;
				["x"] = -206849.0398139;
			};
		};
		["y"] = 978941.03773951;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Bradley";
		["x"] = -206849.0398139;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.97581832504;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978941.03773951;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 6;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206849.0398139;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_MTLB"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 39;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "MTLB";
				["unitId"] = 39;
				["skill"] = "Random";
				["y"] = 978817.078497;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_MTLB-1";
				["playerCanDrive"] = true;
				["heading"] = 0.85521133347722;
				["x"] = -206813.84012596;
			};
		};
		["y"] = 978817.078497;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_MTLB";
		["x"] = -206813.84012596;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.16591250928;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978817.078497;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206813.84012596;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Flak18"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 110;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "flak18";
				["unitId"] = 162;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["Shield"] = false;
				};
				["y"] = 979892.35785959;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Flak18-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207435.17744791;
			};
		};
		["y"] = 979892.35785959;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Flak18";
		["x"] = -207435.17744791;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 865;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979892.35785959;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207435.17744791;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Bofors"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 93;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "bofors40";
				["unitId"] = 105;
				["skill"] = "Random";
				["y"] = 979903.83385837;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Bofors-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207437.24183346;
			};
		};
		["y"] = 979903.83385837;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Bofors";
		["x"] = -207437.24183346;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 865;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979903.83385837;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207437.24183346;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_HMMWV2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 10;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1045 HMMWV TOW";
				["unitId"] = 10;
				["skill"] = "Random";
				["y"] = 978793.85980712;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HMMWV2-1";
				["playerCanDrive"] = true;
				["heading"] = 0.41887902047864;
				["x"] = -206941.44987541;
			};
		};
		["y"] = 978793.85980712;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HMMWV2";
		["x"] = -206941.44987541;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.6074820246;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978793.85980712;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 3;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206941.44987541;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Blitz"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 60;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Blitz_36-6700A";
				["unitId"] = 60;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["TentedRoof"] = false;
				};
				["y"] = 978698.90202179;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Blitz-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207306.22209273;
			};
		};
		["y"] = 978698.90202179;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Blitz";
		["x"] = -207306.22209273;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.0890081355;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978698.90202179;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207306.22209273;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_KrAZ"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 85;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "KrAZ6322";
				["unitId"] = 85;
				["skill"] = "Random";
				["y"] = 978637.89055712;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_KrAZ-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207302.45942247;
			};
		};
		["y"] = 978637.89055712;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_KrAZ";
		["x"] = -207302.45942247;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 889.02954555212;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978637.89055712;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207302.45942247;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_IglaS"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 95;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SA-18 Igla-S manpad";
				["unitId"] = 129;
				["skill"] = "Random";
				["y"] = 979872.27421785;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_IglaS-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207466.62670534;
			};
			[2] = {
				["type"] = "SA-18 Igla-S comm";
				["unitId"] = 130;
				["skill"] = "Random";
				["y"] = 979875.32338679;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_IglaS-2";
				["playerCanDrive"] = false;
				["heading"] = 0.68067840827779;
				["x"] = -207468.18932533;
			};
		};
		["y"] = 979872.27421785;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_IglaS";
		["x"] = -207466.62670534;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 895.6587025719;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979872.27421785;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207466.62670534;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_RoadOutpost"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 49;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "outpost_road";
				["unitId"] = 49;
				["skill"] = "Random";
				["y"] = 978760.67789434;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_RoadOutpost-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207169.29619221;
			};
		};
		["y"] = 978760.67789434;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_RoadOutpost";
		["x"] = -207169.29619221;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 857;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978760.67789434;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207169.29619221;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZIL135"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 71;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZIL-135";
				["unitId"] = 71;
				["skill"] = "Random";
				["y"] = 978833.77480082;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZIL135-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207304.74781256;
			};
		};
		["y"] = 978833.77480082;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZIL135";
		["x"] = -207304.74781256;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 890.27741056952;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978833.77480082;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207304.74781256;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Challenger"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 22;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Challenger2";
				["unitId"] = 22;
				["skill"] = "Random";
				["y"] = 978782.13463712;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Challenger-1";
				["playerCanDrive"] = true;
				["heading"] = 6.0911990894602;
				["x"] = -206871.66509007;
			};
		};
		["y"] = 978782.13463712;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Challenger";
		["x"] = -206871.66509007;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.176929366;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978782.13463712;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206871.66509007;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leopard2A4"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 7;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "leopard-2A4";
				["unitId"] = 7;
				["skill"] = "Random";
				["y"] = 978866.98213076;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leopard2A4-1";
				["playerCanDrive"] = true;
				["heading"] = 1.3089969389957;
				["x"] = -206876.55140329;
			};
		};
		["y"] = 978866.98213076;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leopard2A4";
		["x"] = -206876.55140329;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.05888725577;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978866.98213076;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206876.55140329;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA6"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 108;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Kub 1S91 str";
				["unitId"] = 157;
				["skill"] = "Random";
				["y"] = 981685.68931077;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA6-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207999.21444268;
			};
			[2] = {
				["type"] = "Kub 2P25 ln";
				["unitId"] = 158;
				["skill"] = "Random";
				["y"] = 981581.07439993;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA6-2";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208011.5648141;
			};
			[4] = {
				["type"] = "Kub 2P25 ln";
				["unitId"] = 160;
				["skill"] = "Random";
				["y"] = 981682.78334102;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA6-4";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -207904.77042594;
			};
			[3] = {
				["type"] = "Kub 2P25 ln";
				["unitId"] = 159;
				["skill"] = "Random";
				["y"] = 981786.67175943;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA6-3";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208009.38533679;
			};
		};
		["y"] = 981685.68931077;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_SA6";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 900.05470306165;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981685.68931077;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207999.21444268;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207999.21444268;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_SA8"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 91;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Osa 9A33 ln";
				["unitId"] = 103;
				["skill"] = "Random";
				["y"] = 980045.76791236;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA8-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207629.90945761;
			};
		};
		["y"] = 980045.76791236;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA8";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 429;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980045.76791236;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207629.90945761;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207629.90945761;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_T59"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 42;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "TYPE-59";
				["unitId"] = 42;
				["skill"] = "Random";
				["y"] = 979101.76865662;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T59-1";
				["playerCanDrive"] = true;
				["heading"] = 2.1293016874331;
				["x"] = -206883.12383263;
			};
		};
		["y"] = 979101.76865662;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T59";
		["x"] = -206883.12383263;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.05651611816;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979101.76865662;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206883.12383263;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Avenger"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 116;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1097 Avenger";
				["unitId"] = 174;
				["skill"] = "Random";
				["y"] = 980396.85828512;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Avenger-1";
				["playerCanDrive"] = true;
				["heading"] = 0.48869219055841;
				["x"] = -207629.53523765;
			};
		};
		["y"] = 980396.85828512;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Avenger";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 891.23621279785;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980396.85828512;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 20;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207629.53523765;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207629.53523765;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_HMMWV"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 14;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1043 HMMWV Armament";
				["unitId"] = 14;
				["skill"] = "Random";
				["y"] = 978831.75570745;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HMMWV-1";
				["playerCanDrive"] = true;
				["heading"] = 4.0317105721069;
				["x"] = -206916.8786626;
			};
		};
		["y"] = 978831.75570745;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HMMWV";
		["x"] = -206916.8786626;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.17571889752;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978831.75570745;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 5;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206916.8786626;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_HL2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 97;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HL_ZU-23";
				["unitId"] = 132;
				["skill"] = "Random";
				["y"] = 979943.11365265;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HL2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207437.12644756;
			};
		};
		["y"] = 979943.11365265;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HL2";
		["x"] = -207437.12644756;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 894.08057599377;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979943.11365265;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207437.12644756;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_T55"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 30;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "T-55";
				["unitId"] = 30;
				["skill"] = "Random";
				["y"] = 978999.20184101;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T55-1";
				["playerCanDrive"] = true;
				["heading"] = 5.8119464091411;
				["x"] = -206879.94165227;
			};
		};
		["y"] = 978999.20184101;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T55";
		["x"] = -206879.94165227;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.87764317804;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978999.20184101;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206879.94165227;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Vulcan"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 122;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Vulcan";
				["unitId"] = 201;
				["skill"] = "Random";
				["y"] = 979867.61010354;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Vulcan-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207483.21720965;
			};
		};
		["y"] = 979867.61010354;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Vulcan";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 866;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979867.61010354;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 22;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207483.21720965;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207483.21720965;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_BTRRD"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 23;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR_D";
				["unitId"] = 23;
				["skill"] = "Random";
				["y"] = 978839.82530744;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BTRRD-1";
				["playerCanDrive"] = true;
				["heading"] = 4.4156830075457;
				["x"] = -206817.54924704;
			};
		};
		["y"] = 978839.82530744;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BTRRD";
		["x"] = -206817.54924704;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.15502695886;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978839.82530744;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206817.54924704;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Barracks"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 57;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "house1arm";
				["unitId"] = 57;
				["skill"] = "Random";
				["y"] = 978519.4321407;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Barracks-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207163.98940911;
			};
		};
		["y"] = 978519.4321407;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_Barracks";
		["x"] = -207163.98940911;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 887.27044955475;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978519.4321407;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207163.98940911;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Pz4"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 40;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Pz_IV_H";
				["unitId"] = 40;
				["skill"] = "Random";
				["y"] = 978820.34033232;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Pz4-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -206988.96530543;
			};
		};
		["y"] = 978820.34033232;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Pz4";
		["x"] = -206988.96530543;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.94360296619;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978820.34033232;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206988.96530543;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leopard2A5"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 5;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Leopard-2A5";
				["unitId"] = 5;
				["skill"] = "Random";
				["y"] = 978912.22232223;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leopard2A5-1";
				["playerCanDrive"] = true;
				["heading"] = 3.2986722862693;
				["x"] = -206879.55856621;
			};
		};
		["y"] = 978912.22232223;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leopard2A5";
		["x"] = -206879.55856621;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.41406042102;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978912.22232223;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206879.55856621;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Chaparral"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 103;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M48 Chaparral";
				["unitId"] = 140;
				["skill"] = "Random";
				["y"] = 980234.36613196;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Chaparral-1";
				["playerCanDrive"] = true;
				["heading"] = 0.48869219055841;
				["x"] = -207641.46572106;
			};
		};
		["y"] = 980234.36613196;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Chaparral";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 430;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980234.36613196;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 6;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 18;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 60;
												["name"] = 8;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207641.46572106;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207641.46572106;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_Mephisto"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 34;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "VAB_Mephisto";
				["unitId"] = 34;
				["skill"] = "Random";
				["y"] = 978831.2667281;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Mephisto-1";
				["playerCanDrive"] = true;
				["heading"] = 2.2689280275926;
				["x"] = -206942.79456864;
			};
		};
		["y"] = 978831.2667281;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Mephisto";
		["x"] = -206942.79456864;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.43420304272;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978831.2667281;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 9;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206942.79456864;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_M4"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 79;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Soldier M4";
				["unitId"] = 79;
				["skill"] = "Random";
				["y"] = 978528.55503944;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M4-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207226.25354988;
			};
		};
		["y"] = 978528.55503944;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M4";
		["x"] = -207226.25354988;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 858;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978528.55503944;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207226.25354988;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_HL"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 61;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HL_B8M1";
				["unitId"] = 61;
				["skill"] = "Random";
				["y"] = 978896.14291888;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HL-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207060.37064582;
			};
		};
		["y"] = 978896.14291888;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HL";
		["x"] = -207060.37064582;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.14294498584;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978896.14291888;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207060.37064582;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SmerchCM"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 59;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Smerch";
				["unitId"] = 59;
				["skill"] = "Random";
				["y"] = 978794.67907492;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SmerchCM-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207064.78721008;
			};
		};
		["y"] = 978794.67907492;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SmerchCM";
		["x"] = -207064.78721008;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.53875836993;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978794.67907492;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207064.78721008;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_RPG"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 73;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Soldier RPG";
				["unitId"] = 73;
				["skill"] = "Random";
				["y"] = 978535.18378601;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_RPG-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207224.54223584;
			};
		};
		["y"] = 978535.18378601;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_RPG";
		["x"] = -207224.54223584;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 887.83874846289;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978535.18378601;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207224.54223584;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Shilka"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 101;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZSU-23-4 Shilka";
				["unitId"] = 136;
				["skill"] = "Random";
				["y"] = 979875.64245141;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Shilka-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207487.05238719;
			};
		};
		["y"] = 979875.64245141;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Shilka";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 896.03443536951;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979875.64245141;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207487.05238719;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207487.05238719;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_Ural4320"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 86;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Ural-4320-31";
				["unitId"] = 86;
				["skill"] = "Random";
				["y"] = 978770.98613413;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Ural4320-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207303.68805791;
			};
		};
		["y"] = 978770.98613413;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Ural4320";
		["x"] = -207303.68805791;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 860;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978770.98613413;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207303.68805791;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA15"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 92;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Tor 9A331";
				["unitId"] = 104;
				["skill"] = "Random";
				["y"] = 979860.8597965;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA15-1";
				["playerCanDrive"] = true;
				["heading"] = 3.1590459461097;
				["x"] = -207629.53523765;
			};
		};
		["y"] = 979860.8597965;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA15";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 898.83161834247;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979860.8597965;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207629.53523765;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207629.53523765;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_Roland"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 90;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Roland Radar";
				["unitId"] = 100;
				["skill"] = "Random";
				["y"] = 980513.97745857;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Roland-1";
				["playerCanDrive"] = false;
				["heading"] = 0.45378560551853;
				["x"] = -207761.73278373;
			};
			[2] = {
				["type"] = "Roland ADS";
				["unitId"] = 101;
				["skill"] = "Random";
				["y"] = 980484.38721407;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Roland-2";
				["playerCanDrive"] = true;
				["heading"] = 5.3756140961425;
				["x"] = -207763.96690888;
			};
			[3] = {
				["type"] = "Roland ADS";
				["unitId"] = 102;
				["skill"] = "Random";
				["y"] = 980525.40339911;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Roland-3";
				["playerCanDrive"] = true;
				["heading"] = 2.7052603405912;
				["x"] = -207797.73527563;
			};
		};
		["y"] = 980513.97745857;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Roland";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 865;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980513.97745857;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207761.73278373;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207761.73278373;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_Chieftain"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 36;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Chieftain_mk3";
				["unitId"] = 36;
				["skill"] = "Random";
				["y"] = 978803.27265978;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Chieftain-1";
				["playerCanDrive"] = true;
				["heading"] = 0.43633231299858;
				["x"] = -206877.39357935;
			};
		};
		["y"] = 978803.27265978;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Chieftain";
		["x"] = -206877.39357935;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.92480311926;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978803.27265978;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206877.39357935;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_M270"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 54;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "MLRS";
				["unitId"] = 54;
				["skill"] = "Random";
				["y"] = 978939.76897262;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M270-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207064.44603717;
			};
		};
		["y"] = 978939.76897262;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M270";
		["x"] = -207064.44603717;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.36962978284;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978939.76897262;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 12;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207064.44603717;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA9"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 115;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Strela-1 9P31";
				["unitId"] = 173;
				["skill"] = "Random";
				["y"] = 980292.87742732;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA9-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207635.93320592;
			};
		};
		["y"] = 980292.87742732;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA9";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 890.85486476025;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980292.87742732;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207635.93320592;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207635.93320592;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_T90"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 9;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "T-90";
				["unitId"] = 9;
				["skill"] = "Random";
				["y"] = 979080.76844611;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T90-1";
				["playerCanDrive"] = true;
				["heading"] = 0.48869219055841;
				["x"] = -206881.5499039;
			};
		};
		["y"] = 979080.76844611;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T90";
		["x"] = -206881.5499039;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 881.96191153137;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979080.76844611;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206881.5499039;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZSU57"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 114;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZSU_57_2";
				["unitId"] = 172;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["Branches"] = false;
				};
				["y"] = 979954.92220021;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZSU57-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207437.25094041;
			};
		};
		["y"] = 979954.92220021;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZSU57";
		["x"] = -207437.25094041;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 893.9069308006;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979954.92220021;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207437.25094041;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_HL_KORD"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 11;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HL_KORD";
				["unitId"] = 11;
				["skill"] = "Random";
				["y"] = 978816.10836796;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HL_KORD-1";
				["playerCanDrive"] = true;
				["heading"] = 3.2986722862693;
				["x"] = -206916.51192809;
			};
		};
		["y"] = 978816.10836796;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HL_KORD";
		["x"] = -206916.51192809;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.24853391174;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978816.10836796;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206916.51192809;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_M939"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 67;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M 818";
				["unitId"] = 67;
				["skill"] = "Random";
				["y"] = 978663.92737119;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M939-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207302.15132926;
			};
		};
		["y"] = 978663.92737119;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M939";
		["x"] = -207302.15132926;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 859;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978663.92737119;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207302.15132926;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA13"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 109;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Strela-10M3";
				["unitId"] = 161;
				["skill"] = "Random";
				["y"] = 979946.87011359;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA13-1";
				["playerCanDrive"] = true;
				["heading"] = 3.1590459461097;
				["x"] = -207636.07310125;
			};
		};
		["y"] = 979946.87011359;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA13";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 413.67125159079;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979946.87011359;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207636.07310125;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207636.07310125;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_T72B"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 28;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "T-72B";
				["unitId"] = 28;
				["skill"] = "Random";
				["y"] = 979017.30016367;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T72B-1";
				["playerCanDrive"] = true;
				["heading"] = 0.43633231299858;
				["x"] = -206880.39782855;
			};
		};
		["y"] = 979017.30016367;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T72B";
		["x"] = -206880.39782855;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 881.90917710364;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979017.30016367;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206880.39782855;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZU232"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 87;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Ural-375 ZU-23 Insurgent";
				["unitId"] = 87;
				["skill"] = "Random";
				["y"] = 979976.23391163;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZU232-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207436.96194578;
			};
		};
		["y"] = 979976.23391163;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZU232";
		["x"] = -207436.96194578;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 893.58307793768;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979976.23391163;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207436.96194578;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BMD1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 27;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BMD-1";
				["unitId"] = 27;
				["skill"] = "Random";
				["y"] = 978777.35344482;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BMD1-1";
				["playerCanDrive"] = true;
				["heading"] = 5.7595865315813;
				["x"] = -206843.57815378;
			};
		};
		["y"] = 978777.35344482;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BMD1";
		["x"] = -206843.57815378;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 853;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978777.35344482;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206843.57815378;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 120;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[7] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 196;
				["skill"] = "Random";
				["y"] = 981532.68323227;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-7";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208624.114086;
			};
			[1] = {
				["type"] = "p-19 s-125 sr";
				["unitId"] = 190;
				["skill"] = "Random";
				["y"] = 981880.55640565;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-1";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208621.18708996;
			};
			[2] = {
				["type"] = "RD_75";
				["unitId"] = 191;
				["skill"] = "Random";
				["y"] = 981691.6182111;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-2";
				["playerCanDrive"] = false;
				["heading"] = 0.5235987755983;
				["x"] = -208604.41140268;
			};
			[4] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 193;
				["skill"] = "Random";
				["y"] = 981675.19930833;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-4";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208465.17910718;
			};
			[8] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 197;
				["skill"] = "Random";
				["y"] = 981801.29648161;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-8";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208546.61686492;
			};
			[9] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 198;
				["skill"] = "Random";
				["y"] = 981800.6397255;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-9";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208624.77084211;
			};
			[5] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 194;
				["skill"] = "Random";
				["y"] = 981669.28850333;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-5";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208705.55184375;
			};
			[3] = {
				["type"] = "SNR_75V";
				["unitId"] = 192;
				["skill"] = "Random";
				["y"] = 981666.66147889;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-3";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208575.5141338;
			};
			[6] = {
				["type"] = "S_75M_Volhov";
				["unitId"] = 195;
				["skill"] = "Random";
				["y"] = 981534.65350061;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA2-6";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -208541.36281604;
			};
		};
		["y"] = 981880.55640565;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA2";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 383;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981880.55640565;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208621.18708996;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208621.18708996;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_LC_KORD"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 6;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "tt_KORD";
				["unitId"] = 6;
				["skill"] = "Random";
				["y"] = 978869.52814109;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_LC_KORD-1";
				["playerCanDrive"] = true;
				["heading"] = 6.1784655520599;
				["x"] = -206917.50374825;
			};
		};
		["y"] = 978869.52814109;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_LC_KORD";
		["x"] = -206917.50374825;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.99743502783;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978869.52814109;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206917.50374825;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SmerchBM21"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 75;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Grad-URAL";
				["unitId"] = 75;
				["skill"] = "Random";
				["y"] = 978871.79625519;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SmerchBM21-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207064.25995922;
			};
		};
		["y"] = 978871.79625519;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SmerchBM21";
		["x"] = -207064.25995922;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.12078920197;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978871.79625519;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207064.25995922;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Rapier"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 106;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "rapier_fsa_blindfire_radar";
				["unitId"] = 153;
				["skill"] = "Random";
				["y"] = 980299.4211906;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Rapier-1";
				["playerCanDrive"] = false;
				["heading"] = 0.45378560551853;
				["x"] = -207772.10167401;
			};
			[2] = {
				["type"] = "rapier_fsa_optical_tracker_unit";
				["unitId"] = 154;
				["skill"] = "Random";
				["y"] = 980279.96581869;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Rapier-2";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -207787.09628385;
			};
			[3] = {
				["type"] = "rapier_fsa_launcher";
				["unitId"] = 155;
				["skill"] = "Random";
				["y"] = 980279.09522673;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Rapier-3";
				["playerCanDrive"] = false;
				["heading"] = 6.2308254296198;
				["x"] = -207770.74432961;
			};
		};
		["y"] = 980299.4211906;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Rapier";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 893.91755092841;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980299.4211906;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207772.10167401;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207772.10167401;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_LC"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 76;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "tt_B8M1";
				["unitId"] = 76;
				["skill"] = "Random";
				["y"] = 978923.47324183;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_LC-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207059.97657214;
			};
		};
		["y"] = 978923.47324183;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_LC";
		["x"] = -207059.97657214;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.91710244601;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978923.47324183;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207059.97657214;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leopard1A3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 26;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Leopard1A3";
				["unitId"] = 26;
				["skill"] = "Random";
				["y"] = 978847.75146135;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leopard1A3-1";
				["playerCanDrive"] = true;
				["heading"] = 0.5235987755983;
				["x"] = -206877.33787228;
			};
		};
		["y"] = 978847.75146135;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leopard1A3";
		["x"] = -206877.33787228;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.70702946399;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978847.75146135;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206877.33787228;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BMP3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 44;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BMP-3";
				["unitId"] = 44;
				["skill"] = "Random";
				["y"] = 978846.63816182;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BMP3-1";
				["playerCanDrive"] = true;
				["heading"] = 5.7770398241012;
				["x"] = -206845.48194993;
			};
		};
		["y"] = 978846.63816182;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BMP3";
		["x"] = -206845.48194993;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.39770298279;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978846.63816182;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206845.48194993;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Nona"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 53;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SAU 2-C9";
				["unitId"] = 53;
				["skill"] = "Random";
				["y"] = 979172.895868;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Nona-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207072.00115436;
			};
		};
		["y"] = 979172.895868;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Nona";
		["x"] = -207072.00115436;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.23486502307;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979172.895868;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207072.00115436;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Outpost"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 55;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "outpost";
				["unitId"] = 55;
				["skill"] = "Random";
				["y"] = 978706.30894785;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Outpost-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207166.11617449;
			};
		};
		["y"] = 978706.30894785;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_Outpost";
		["x"] = -207166.11617449;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.97009525049;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978706.30894785;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207166.11617449;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_LAV25"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 33;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "LAV-25";
				["unitId"] = 33;
				["skill"] = "Random";
				["y"] = 978896.65858774;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_LAV25-1";
				["playerCanDrive"] = true;
				["heading"] = 5.9166661642608;
				["x"] = -206849.45997411;
			};
		};
		["y"] = 978896.65858774;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_LAV25";
		["x"] = -206849.45997411;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.19274672314;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978896.65858774;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206849.45997411;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_EWR-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 123;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "55G6 EWR";
				["unitId"] = 202;
				["skill"] = "Random";
				["y"] = 979300.80324292;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_EWR-1-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207341.1681063;
			};
		};
		["y"] = 979300.80324292;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_EWR-1";
		["x"] = -207341.1681063;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.8591495072;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979300.80324292;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "EWR";
									["number"] = 1;
									["params"] = {
									};
								};
							};
						};
					};
					["x"] = -207341.1681063;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Stryker"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 24;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1126 Stryker ICV";
				["unitId"] = 24;
				["skill"] = "Random";
				["y"] = 978915.38254871;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Stryker-1";
				["playerCanDrive"] = true;
				["heading"] = 1.9547687622336;
				["x"] = -206848.75887082;
			};
		};
		["y"] = 978915.38254871;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Stryker";
		["x"] = -206848.75887082;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 852;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978915.38254871;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 8;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206848.75887082;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Leopard2A6M"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 20;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Leopard-2";
				["unitId"] = 20;
				["skill"] = "Random";
				["y"] = 978933.95239352;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Leopard2A6M-1";
				["playerCanDrive"] = true;
				["heading"] = 3.6651914291881;
				["x"] = -206879.34949679;
			};
		};
		["y"] = 978933.95239352;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Leopard2A6M";
		["x"] = -206879.34949679;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.30584498077;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978933.95239352;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206879.34949679;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Marder"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 41;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Marder";
				["unitId"] = 41;
				["skill"] = "Random";
				["y"] = 978958.81252804;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Marder-1";
				["playerCanDrive"] = true;
				["heading"] = 6.1784655520599;
				["x"] = -206845.39874199;
			};
		};
		["y"] = 978958.81252804;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Marder";
		["x"] = -206845.39874199;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 881.84899637939;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978958.81252804;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206845.39874199;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_FDDM"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 66;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "MLRS FDDM";
				["unitId"] = 66;
				["skill"] = "Random";
				["y"] = 978985.23728646;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_FDDM-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207063.63769966;
			};
		};
		["y"] = 978985.23728646;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_FDDM";
		["x"] = -207063.63769966;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.8369021705;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978985.23728646;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 13;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207063.63769966;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Building"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 74;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "houseA_arm";
				["unitId"] = 74;
				["skill"] = "Random";
				["y"] = 978573.53130586;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Building-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207169.15937366;
			};
		};
		["y"] = 978573.53130586;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_Building";
		["x"] = -207169.15937366;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 857;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978573.53130586;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207169.15937366;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_M249"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 78;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Soldier M249";
				["unitId"] = 78;
				["skill"] = "Random";
				["y"] = 978522.82859022;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M249-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207224.40750294;
			};
		};
		["y"] = 978522.82859022;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M249";
		["x"] = -207224.40750294;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.18715276489;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978522.82859022;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207224.40750294;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_LC2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 100;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "tt_ZU-23";
				["unitId"] = 135;
				["skill"] = "Random";
				["y"] = 979964.86493037;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_LC2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207436.55726156;
			};
		};
		["y"] = 979964.86493037;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_LC2";
		["x"] = -207436.55726156;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 893.74439401697;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979964.86493037;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207436.55726156;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Cobra"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 38;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Cobra";
				["unitId"] = 38;
				["skill"] = "Random";
				["y"] = 978777.26641383;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Cobra-1";
				["playerCanDrive"] = true;
				["heading"] = 2.1293016874331;
				["x"] = -206914.80590819;
			};
		};
		["y"] = 978777.26641383;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Cobra";
		["x"] = -206914.80590819;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.47589009613;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978777.26641383;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206914.80590819;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Linebacker"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 104;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M6 Linebacker";
				["unitId"] = 141;
				["skill"] = "Random";
				["y"] = 980477.97216561;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Linebacker-1";
				["playerCanDrive"] = true;
				["heading"] = 0.48869219055841;
				["x"] = -207625.74920276;
			};
		};
		["y"] = 980477.97216561;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Linebacker";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 427;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980477.97216561;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 6;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 60;
												["name"] = 8;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 19;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207625.74920276;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207625.74920276;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_ZBD"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 19;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZBD04A";
				["unitId"] = 19;
				["skill"] = "Random";
				["y"] = 978863.13974568;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZBD-1";
				["playerCanDrive"] = true;
				["heading"] = 5.7595865315813;
				["x"] = -206816.78950197;
			};
		};
		["y"] = 978863.13974568;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZBD";
		["x"] = -206816.78950197;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.0336889469;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978863.13974568;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 7;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206816.78950197;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_BTRRD2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 21;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR_D";
				["unitId"] = 21;
				["skill"] = "Random";
				["y"] = 978777.72348827;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BTRRD2-1";
				["playerCanDrive"] = true;
				["heading"] = 0.034906585039887;
				["x"] = -206941.81660992;
			};
		};
		["y"] = 978777.72348827;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BTRRD2";
		["x"] = -206941.81660992;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.82800226465;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978777.72348827;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206941.81660992;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 112;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "5p73 s-125 ln";
				["unitId"] = 170;
				["skill"] = "Random";
				["y"] = 981759.06932613;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-6";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208246.87870356;
			};
			[2] = {
				["type"] = "snr s-125 tr";
				["unitId"] = 166;
				["skill"] = "Random";
				["y"] = 981668.81222424;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-2";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208297.58090024;
			};
			[3] = {
				["type"] = "5p73 s-125 ln";
				["unitId"] = 167;
				["skill"] = "Random";
				["y"] = 981571.00373136;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-3";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208244.72116328;
			};
			[1] = {
				["type"] = "p-19 s-125 sr";
				["unitId"] = 165;
				["skill"] = "Random";
				["y"] = 981813.36742328;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-1";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208286.43360877;
			};
			[4] = {
				["type"] = "5p73 s-125 ln";
				["unitId"] = 168;
				["skill"] = "Random";
				["y"] = 981596.17503468;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-4";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208216.31354954;
			};
			[5] = {
				["type"] = "5p73 s-125 ln";
				["unitId"] = 169;
				["skill"] = "Random";
				["y"] = 981733.53843277;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA3-5";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208215.23477939;
			};
		};
		["y"] = 981813.36742328;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA3";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 906.32228745422;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981813.36742328;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208286.43360877;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208286.43360877;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_M113"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 4;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M-113";
				["unitId"] = 4;
				["skill"] = "Random";
				["y"] = 978890.52549504;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M113-1";
				["playerCanDrive"] = true;
				["heading"] = 0.24434609527921;
				["x"] = -206818.52199953;
			};
		};
		["y"] = 978890.52549504;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M113";
		["x"] = -206818.52199953;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.06343437946;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978890.52549504;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 1;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206818.52199953;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_EWR"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 89;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "1L13 EWR";
				["unitId"] = 99;
				["skill"] = "Random";
				["AddPropVehicle"] = {
					["Shield"] = false;
				};
				["y"] = 979347.92816873;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_EWR-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207224.11587124;
			};
		};
		["y"] = 979347.92816873;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_EWR";
		["x"] = -207224.11587124;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 414.37776474847;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979347.92816873;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "EWR";
									["number"] = 1;
									["params"] = {
									};
								};
							};
						};
					};
					["x"] = -207224.11587124;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA5"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 94;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "p-19 s-125 sr";
				["unitId"] = 106;
				["skill"] = "Random";
				["y"] = 981101.46560074;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-1";
				["playerCanDrive"] = false;
				["heading"] = 6.16101225954;
				["x"] = -208293.62964937;
			};
			[2] = {
				["type"] = "RLS_19J6";
				["unitId"] = 107;
				["skill"] = "Random";
				["y"] = 981008.85227729;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-2";
				["playerCanDrive"] = false;
				["heading"] = 3.1066860685499;
				["x"] = -208294.35888814;
			};
			[4] = {
				["type"] = "RPC_5N62V";
				["unitId"] = 109;
				["skill"] = "Random";
				["y"] = 981056.43156804;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-4";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -207939.16356432;
			};
			[8] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 113;
				["skill"] = "Random";
				["y"] = 980712.49215668;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-8";
				["playerCanDrive"] = false;
				["heading"] = 3.8571776469075;
				["x"] = -208226.909613;
			};
			[16] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 121;
				["skill"] = "Random";
				["y"] = 981010.10232018;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-16";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -207894.46946638;
			};
			[17] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 122;
				["skill"] = "Random";
				["y"] = 981099.49051606;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-17";
				["playerCanDrive"] = false;
				["heading"] = 0.80285145591739;
				["x"] = -207892.83431646;
			};
			[9] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 114;
				["skill"] = "Random";
				["y"] = 980795.5293185;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-9";
				["playerCanDrive"] = false;
				["heading"] = 2.775073510671;
				["x"] = -208166.43042725;
			};
			[18] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 123;
				["skill"] = "Random";
				["y"] = 981238.20165283;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-18";
				["playerCanDrive"] = false;
				["heading"] = 4.6949356878647;
				["x"] = -208176.37718109;
			};
			[5] = {
				["type"] = "RPC_5N62V";
				["unitId"] = 110;
				["skill"] = "Random";
				["y"] = 981303.46473931;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-5";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208176.22220782;
			};
			[10] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 115;
				["skill"] = "Random";
				["y"] = 980785.76062396;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-10";
				["playerCanDrive"] = false;
				["heading"] = 1.6929693744345;
				["x"] = -208222.1119861;
			};
			[20] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 125;
				["skill"] = "Random";
				["y"] = 981371.15979572;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-20";
				["playerCanDrive"] = false;
				["heading"] = 1.5184364492351;
				["x"] = -208176.92376846;
			};
			[21] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 126;
				["skill"] = "Random";
				["y"] = 981272.75016428;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-21";
				["playerCanDrive"] = false;
				["heading"] = 3.6651914291881;
				["x"] = -208228.99235653;
			};
			[11] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 116;
				["skill"] = "Random";
				["y"] = 980777.94566834;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-11";
				["playerCanDrive"] = false;
				["heading"] = 0.87266462599716;
				["x"] = -208117.58695458;
			};
			[22] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 127;
				["skill"] = "Random";
				["y"] = 981342.00138641;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-22";
				["playerCanDrive"] = false;
				["heading"] = 2.3212879051525;
				["x"] = -208228.47167065;
			};
			[3] = {
				["type"] = "RPC_5N62V";
				["unitId"] = 108;
				["skill"] = "Random";
				["y"] = 980737.89402074;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-3";
				["playerCanDrive"] = false;
				["heading"] = 5.9515727493007;
				["x"] = -208167.4072967;
			};
			[6] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 111;
				["skill"] = "Random";
				["y"] = 980713.47228441;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-6";
				["playerCanDrive"] = false;
				["heading"] = 5.6199601914217;
				["x"] = -208116.61008512;
			};
			[12] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 117;
				["skill"] = "Random";
				["y"] = 980980.12457156;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-12";
				["playerCanDrive"] = false;
				["heading"] = 4.7996554429844;
				["x"] = -207936.98336442;
			};
			[13] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 118;
				["skill"] = "Random";
				["y"] = 981019.69682627;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-13";
				["playerCanDrive"] = false;
				["heading"] = 4.0317105721069;
				["x"] = -207990.51822318;
			};
			[7] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 112;
				["skill"] = "Random";
				["y"] = 980678.12688856;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-7";
				["playerCanDrive"] = false;
				["heading"] = 4.7822021504645;
				["x"] = -208176.92376846;
			};
			[14] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 119;
				["skill"] = "Random";
				["y"] = 981095.67516623;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-14";
				["playerCanDrive"] = false;
				["heading"] = 2.6529004630314;
				["x"] = -207992.03341189;
			};
			[23] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 128;
				["skill"] = "Random";
				["y"] = 981340.96001465;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-23";
				["playerCanDrive"] = false;
				["heading"] = 0.61086523819802;
				["x"] = -208131.10341096;
			};
			[19] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 124;
				["skill"] = "Random";
				["y"] = 981266.50193372;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-19";
				["playerCanDrive"] = false;
				["heading"] = 5.4279739737024;
				["x"] = -208130.0620392;
			};
			[15] = {
				["type"] = "S-200_Launcher";
				["unitId"] = 120;
				["skill"] = "Random";
				["y"] = 981130.60291885;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA5-15";
				["playerCanDrive"] = false;
				["heading"] = 1.5707963267949;
				["x"] = -207940.53237863;
			};
		};
		["y"] = 981101.46560074;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA5";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 418;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981101.46560074;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208293.62964937;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208293.62964937;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_SmerchBM27"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 65;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Uragan_BM-27";
				["unitId"] = 65;
				["skill"] = "Random";
				["y"] = 978845.07744289;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SmerchBM27-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207065.18129757;
			};
		};
		["y"] = 978845.07744289;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SmerchBM27";
		["x"] = -207065.18129757;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.03985650385;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978845.07744289;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207065.18129757;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_KS19"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 118;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "KS-19";
				["unitId"] = 180;
				["skill"] = "Random";
				["y"] = 979914.53235287;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_KS19-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207437.88862719;
			};
		};
		["y"] = 979914.53235287;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_KS19";
		["x"] = -207437.88862719;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 894.51288843781;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979914.53235287;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207437.88862719;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_CRAM-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 137;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HEMTT_C-RAM_Phalanx";
				["unitId"] = 261;
				["skill"] = "Random";
				["y"] = 979889.59493569;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_CRAM-1-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207485.97144587;
			};
		};
		["y"] = 979889.59493569;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_CRAM-1";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 896.03443536951;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979889.59493569;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 27;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207485.97144587;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207485.97144587;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_M1A2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 8;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M-1 Abrams";
				["unitId"] = 8;
				["skill"] = "Random";
				["y"] = 978956.83608118;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M1A2-1";
				["playerCanDrive"] = true;
				["heading"] = 4.310963252426;
				["x"] = -206879.88686448;
			};
		};
		["y"] = 978956.83608118;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M1A2";
		["x"] = -206879.88686448;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.19939956183;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978956.83608118;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 2;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206879.88686448;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Igla"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 111;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SA-18 Igla manpad";
				["unitId"] = 163;
				["skill"] = "Random";
				["y"] = 979856.12172815;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Igla-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207466.28933844;
			};
			[2] = {
				["type"] = "SA-18 Igla comm";
				["unitId"] = 164;
				["skill"] = "Random";
				["y"] = 979858.40375085;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Igla-2";
				["playerCanDrive"] = false;
				["heading"] = 0.68067840827779;
				["x"] = -207467.61083278;
			};
		};
		["y"] = 979856.12172815;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Igla";
		["x"] = -207466.28933844;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 895.86390297241;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979856.12172815;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207466.28933844;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_ZIL131"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 50;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "S_75_ZIL";
				["unitId"] = 50;
				["skill"] = "Random";
				["y"] = 978515.88917746;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZIL131-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207300.10235772;
			};
		};
		["y"] = 978515.88917746;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZIL131";
		["x"] = -207300.10235772;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 859;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978515.88917746;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207300.10235772;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Dana"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 56;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "SpGH_Dana";
				["unitId"] = 56;
				["skill"] = "Random";
				["y"] = 979104.87867905;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Dana-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207070.45530916;
			};
		};
		["y"] = 979104.87867905;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Dana";
		["x"] = -207070.45530916;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.99676664044;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979104.87867905;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207070.45530916;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Kamaz"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 83;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "KAMAZ Truck";
				["unitId"] = 83;
				["skill"] = "Random";
				["y"] = 978606.63145582;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Kamaz-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207303.05249314;
			};
		};
		["y"] = 978606.63145582;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Kamaz";
		["x"] = -207303.05249314;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 415.15147768039;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978606.63145582;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207303.05249314;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Ural4320T"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 77;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Ural-4320T";
				["unitId"] = 77;
				["skill"] = "Random";
				["y"] = 978807.24659655;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Ural4320T-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207304.009093;
			};
		};
		["y"] = 978807.24659655;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Ural4320T";
		["x"] = -207304.009093;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 890.04083806732;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978807.24659655;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207304.009093;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_HL_DSHK"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 13;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "HL_DSHK";
				["unitId"] = 13;
				["skill"] = "Random";
				["y"] = 978797.89388683;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_HL_DSHK-1";
				["playerCanDrive"] = true;
				["heading"] = 2.6529004630314;
				["x"] = -206916.75641776;
			};
		};
		["y"] = 978797.89388683;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_HL_DSHK";
		["x"] = -206916.75641776;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.3398425968;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978797.89388683;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206916.75641776;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_T72B3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 25;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "T-72B3";
				["unitId"] = 25;
				["skill"] = "Random";
				["y"] = 979038.70434641;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T72B3-1";
				["playerCanDrive"] = false;
				["heading"] = 0.85521133347722;
				["x"] = -206881.44635761;
			};
		};
		["y"] = 979038.70434641;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T72B3";
		["x"] = -206881.44635761;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 881.8309909903;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979038.70434641;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206881.44635761;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SmerchHE"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 80;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Smerch_HE";
				["unitId"] = 80;
				["skill"] = "Random";
				["y"] = 978820.44316164;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SmerchHE-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207065.30249181;
			};
		};
		["y"] = 978820.44316164;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SmerchHE";
		["x"] = -207065.30249181;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 885.05389460382;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978820.44316164;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207065.30249181;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Bunker2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 58;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Bunker";
				["unitId"] = 58;
				["skill"] = "Random";
				["y"] = 978668.21303617;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Bunker2-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207167.78779887;
			};
		};
		["y"] = 978668.21303617;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_Bunker2";
		["x"] = -207167.78779887;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.86072014111;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978668.21303617;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207167.78779887;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Gepard"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 113;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Gepard";
				["unitId"] = 171;
				["skill"] = "Random";
				["y"] = 979856.19600622;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Gepard-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207487.17863609;
			};
		};
		["y"] = 979856.19600622;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Gepard";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 427;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979856.19600622;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207487.17863609;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207487.17863609;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_T155"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 52;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "T155_Firtina";
				["unitId"] = 52;
				["skill"] = "Random";
				["y"] = 979147.73709253;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_T155-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207072.09133523;
			};
		};
		["y"] = 979147.73709253;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_T155";
		["x"] = -207072.09133523;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.15942549451;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979147.73709253;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207072.09133523;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA10"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 105;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[7] = {
				["type"] = "S-300PS 5P85C ln";
				["unitId"] = 148;
				["skill"] = "Random";
				["y"] = 979538.20205342;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-7";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208522.20930648;
			};
			[1] = {
				["type"] = "S-300PS 64H6E sr";
				["unitId"] = 142;
				["skill"] = "Random";
				["y"] = 979637.95785103;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-1";
				["playerCanDrive"] = false;
				["heading"] = 4.6774823953448;
				["x"] = -208583.96289548;
			};
			[2] = {
				["type"] = "S-300PS 40B6MD sr";
				["unitId"] = 143;
				["skill"] = "Random";
				["y"] = 979541.08384978;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-2";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208705.29122081;
			};
			[4] = {
				["type"] = "S-300PS 54K6 cp";
				["unitId"] = 145;
				["skill"] = "Random";
				["y"] = 979650.19003941;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-4";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208668.3213549;
			};
			[8] = {
				["type"] = "S-300PS 5P85D ln";
				["unitId"] = 149;
				["skill"] = "Random";
				["y"] = 979709.70250647;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-8";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208722.42359769;
			};
			[9] = {
				["type"] = "S-300PS 5P85D ln";
				["unitId"] = 150;
				["skill"] = "Random";
				["y"] = 979781.83883019;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-9";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208648.48386588;
			};
			[5] = {
				["type"] = "S-300PS 5P85C ln";
				["unitId"] = 146;
				["skill"] = "Random";
				["y"] = 979731.77580355;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-5";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208617.21482802;
			};
			[10] = {
				["type"] = "S-300PS 5P85D ln";
				["unitId"] = 151;
				["skill"] = "Random";
				["y"] = 979476.16115844;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-10";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208633.15489709;
			};
			[3] = {
				["type"] = "S-300PS 40B6M tr";
				["unitId"] = 144;
				["skill"] = "Random";
				["y"] = 979579.85712378;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-3";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -208481.66861728;
			};
			[6] = {
				["type"] = "S-300PS 5P85C ln";
				["unitId"] = 147;
				["skill"] = "Random";
				["y"] = 979646.27083417;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-6";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208478.26925277;
			};
			[11] = {
				["type"] = "S-300PS 5P85C ln";
				["unitId"] = 152;
				["skill"] = "Random";
				["y"] = 979731.77580355;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA10-11";
				["playerCanDrive"] = false;
				["heading"] = 1.5882496193148;
				["x"] = -208499.64549511;
			};
		};
		["y"] = 979637.95785103;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA10";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 409;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979637.95785103;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208583.96289548;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208583.96289548;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_GAZ"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 82;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "GAZ-66";
				["unitId"] = 82;
				["skill"] = "Random";
				["y"] = 978576.43709443;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_GAZ-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207299.92875438;
			};
		};
		["y"] = 978576.43709443;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_GAZ";
		["x"] = -207299.92875438;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 888.76453063867;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978576.43709443;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207299.92875438;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Bunker1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 46;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "Sandbox";
				["unitId"] = 46;
				["skill"] = "Random";
				["y"] = 978622.21814706;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Bunker1-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -207166.44084302;
			};
		};
		["y"] = 978622.21814706;
		["uncontrollable"] = true;
		["name"] = "SPECTRESPAWNERTemplate_Bunker1";
		["x"] = -207166.44084302;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.67163303796;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978622.21814706;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207166.44084302;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_Stryker2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 43;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M1134 Stryker ATGM";
				["unitId"] = 43;
				["skill"] = "Random";
				["y"] = 978810.48914268;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_Stryker2-1";
				["playerCanDrive"] = true;
				["heading"] = 0.87266462599716;
				["x"] = -206942.66791151;
			};
		};
		["y"] = 978810.48914268;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_Stryker2";
		["x"] = -206942.66791151;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 883.53436183429;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978810.48914268;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 11;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206942.66791151;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA19"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 107;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "2S6 Tunguska";
				["unitId"] = 156;
				["skill"] = "Random";
				["y"] = 980138.98959644;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA19-1";
				["playerCanDrive"] = true;
				["heading"] = 3.1590459461097;
				["x"] = -207631.37715685;
			};
		};
		["y"] = 980138.98959644;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA19";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 893.74048776306;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980138.98959644;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 60;
												["name"] = 8;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207631.37715685;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207631.37715685;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_BTR82A"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 32;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR-82A";
				["unitId"] = 32;
				["skill"] = "Random";
				["y"] = 978870.99411617;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_BTR82A-1";
				["playerCanDrive"] = true;
				["heading"] = 0.68067840827779;
				["x"] = -206846.50387809;
			};
		};
		["y"] = 978870.99411617;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_BTR82A";
		["x"] = -206846.50387809;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 882.28881615515;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 978870.99411617;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -206846.50387809;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_M109"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 70;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M-109";
				["unitId"] = 70;
				["skill"] = "Random";
				["y"] = 979123.97677438;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_M109-1";
				["playerCanDrive"] = true;
				["heading"] = 0.38397243543875;
				["x"] = -207072.2490908;
			};
		};
		["y"] = 979123.97677438;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_M109";
		["x"] = -207072.2490908;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 886.08972327637;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979123.97677438;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 15;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207072.2490908;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_SA11"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 119;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[7] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 187;
				["skill"] = "Random";
				["y"] = 981060.49095186;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-7";
				["playerCanDrive"] = false;
				["heading"] = 5.4279739737024;
				["x"] = -208595.55184929;
			};
			[1] = {
				["type"] = "SA-11 Buk SR 9S18M1";
				["unitId"] = 181;
				["skill"] = "Random";
				["y"] = 980987.72585453;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-1";
				["playerCanDrive"] = false;
				["heading"] = 3.1590459461097;
				["x"] = -208667.02509888;
			};
			[2] = {
				["type"] = "SA-11 Buk CC 9S470M1";
				["unitId"] = 182;
				["skill"] = "Random";
				["y"] = 980988.29369925;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-2";
				["playerCanDrive"] = false;
				["heading"] = 4.7298422729046;
				["x"] = -208621.37120863;
			};
			[4] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 184;
				["skill"] = "Random";
				["y"] = 980862.93643334;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-4";
				["playerCanDrive"] = false;
				["heading"] = 0.83775804095728;
				["x"] = -208584.16735161;
			};
			[8] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 188;
				["skill"] = "Random";
				["y"] = 981102.92365341;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-8";
				["playerCanDrive"] = false;
				["heading"] = 0.90757121103705;
				["x"] = -208603.27589612;
			};
			[9] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 189;
				["skill"] = "Random";
				["y"] = 981074.55415487;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-9";
				["playerCanDrive"] = false;
				["heading"] = 3.5430183815485;
				["x"] = -208631.71437132;
			};
			[5] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 185;
				["skill"] = "Random";
				["y"] = 980824.09520597;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-5";
				["playerCanDrive"] = false;
				["heading"] = 3.7350045992679;
				["x"] = -208615.64213931;
			};
			[3] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 183;
				["skill"] = "Random";
				["y"] = 980835.47970365;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-3";
				["playerCanDrive"] = false;
				["heading"] = 5.7246799465414;
				["x"] = -208582.82799894;
			};
			[6] = {
				["type"] = "SA-11 Buk LN 9A310M1";
				["unitId"] = 186;
				["skill"] = "Random";
				["y"] = 980857.57902267;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_SA11-6";
				["playerCanDrive"] = false;
				["heading"] = 2.8797932657906;
				["x"] = -208613.63311031;
			};
		};
		["y"] = 980987.72585453;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_SA11";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 383;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980987.72585453;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 1;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -208667.02509888;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -208667.02509888;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
	["SPECTRESPAWNERTemplate_ZU23"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 98;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "ZU-23 Emplacement";
				["unitId"] = 133;
				["skill"] = "Random";
				["y"] = 979875.67287785;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_ZU23-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -207437.35872526;
			};
		};
		["y"] = 979875.67287785;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_ZU23";
		["x"] = -207437.35872526;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 895.01240065607;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 979875.67287785;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["x"] = -207437.35872526;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["SPECTRESPAWNERTemplate_NASAMS"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 117;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 7;
			["typeKey"] = "vehicle";
			["countryName"] = "USAF Aggressors";
		};
		["hidden"] = false;
		["units"] = {
			[2] = {
				["type"] = "NASAMS_Command_Post";
				["unitId"] = 176;
				["skill"] = "Random";
				["y"] = 980077.12841531;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_NASAMS-2";
				["playerCanDrive"] = false;
				["heading"] = 1.7104226669544;
				["x"] = -207820.73756795;
			};
			[3] = {
				["type"] = "NASAMS_LN_C";
				["unitId"] = 177;
				["skill"] = "Random";
				["y"] = 980022.20057507;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_NASAMS-3";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -207783.99775428;
			};
			[1] = {
				["type"] = "NASAMS_Radar_MPQ64F1";
				["unitId"] = 175;
				["skill"] = "Random";
				["y"] = 980076.40089424;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_NASAMS-1";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -207792.72800703;
			};
			[4] = {
				["type"] = "NASAMS_LN_C";
				["unitId"] = 178;
				["skill"] = "Random";
				["y"] = 980076.40089424;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_NASAMS-4";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -207740.34649052;
			};
			[5] = {
				["type"] = "NASAMS_LN_C";
				["unitId"] = 179;
				["skill"] = "Random";
				["y"] = 980130.60121341;
				["coldAtStart"] = false;
				["name"] = "SPECTRESPAWNERTemplate_NASAMS-5";
				["playerCanDrive"] = false;
				["heading"] = 0.48869219055841;
				["x"] = -207782.90647269;
			};
		};
		["y"] = 980076.40089424;
		["uncontrollable"] = false;
		["name"] = "SPECTRESPAWNERTemplate_NASAMS";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 897.38746406628;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 980076.40089424;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Off Road";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 0;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 9;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 21;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 20;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 31;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -207792.72800703;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["x"] = -207792.72800703;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["hiddenOnMFD"] = true;
	};
}
return obj1
