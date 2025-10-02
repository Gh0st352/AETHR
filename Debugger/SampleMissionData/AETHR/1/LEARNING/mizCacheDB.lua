-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
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
	["ZONEMGR_HeliPatrol-1"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAS";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 452.9328;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995394.6808969;
					["x"] = -214659.00298379;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAS";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Helicopters";
											[2] = "Ground Units";
											[3] = "Light armed ships";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 31;
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
												["name"] = 7;
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
												["name"] = 32;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 159;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 452.9328;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "default";
				["skill"] = "Excellent";
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["TN_IDM_LB"] = "2";
					["OwnshipCallSign"] = "G-2";
					["AIDisabled"] = false;
					["PltNVG"] = true;
					["TrackAirTargets"] = true;
					["CpgNVG"] = true;
				};
				["type"] = "AH-64D_BLK_II";
				["unitId"] = 283;
				["psi"] = 0;
				["y"] = 995394.6808969;
				["x"] = -214659.00298379;
				["name"] = "ZONEMGR_HeliPatrol-1-1";
				["payload"] = {
					["pylons"] = {
						[1] = {
							["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}";
						};
						[2] = {
							["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}";
						};
						[4] = {
							["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}";
						};
						[3] = {
							["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}";
						};
					};
					["fuel"] = 1140;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 30;
					["gun"] = 100;
				};
				["onboard_num"] = "031";
				["callsign"] = {
					[1] = 9;
					[2] = 1;
					["name"] = "ArmyAir11";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["datalinks"] = {
					["IDM"] = {
						["settings"] = {
							["presets"] = {
								[7] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 7";
									["callSign"] = "PRE 7";
									["autoAcknowledgment"] = true;
								};
								[1] = {
									["primaryFreq"] = 1;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 1";
									["callSign"] = "PRE 1";
									["autoAcknowledgment"] = true;
								};
								[2] = {
									["primaryFreq"] = 2;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 2";
									["callSign"] = "PRE 2";
									["autoAcknowledgment"] = true;
								};
								[4] = {
									["primaryFreq"] = 4;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 4";
									["callSign"] = "PRE 4";
									["autoAcknowledgment"] = true;
								};
								[8] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 8";
									["callSign"] = "PRE 8";
									["autoAcknowledgment"] = true;
								};
								[9] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = false;
									["presetName"] = "PRESET 9";
									["callSign"] = "PRE 9";
									["autoAcknowledgment"] = true;
								};
								[5] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 5";
									["callSign"] = "PRE 5";
									["autoAcknowledgment"] = true;
								};
								[10] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = false;
									["presetName"] = "PRESET10";
									["callSign"] = "PRE10";
									["autoAcknowledgment"] = true;
								};
								[3] = {
									["primaryFreq"] = 3;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 3";
									["callSign"] = "PRE 3";
									["autoAcknowledgment"] = true;
								};
								[6] = {
									["primaryFreq"] = 0;
									["NoAcknowledgmentRetries"] = 2;
									["LB_Net"] = true;
									["presetName"] = "PRESET 6";
									["callSign"] = "PRE 6";
									["autoAcknowledgment"] = true;
								};
							};
						};
						["network"] = {
							["presets"] = {
								[7] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[1] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[2] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[4] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[8] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[9] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[5] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[10] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[3] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
								[6] = {
									["members"] = {
										[1] = {
											["PRI_value"] = true;
											["TM_value"] = true;
											["missionUnitId"] = 283;
										};
									};
								};
							};
						};
					};
				};
			};
		};
		["y"] = 995394.6808969;
		["x"] = -214659.00298379;
		["name"] = "ZONEMGR_HeliPatrol-1";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 225;
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
	["CUSTOM_STEALTHBOMBER"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Ground Attack";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 10000;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["properties"] = {
						["addopt"] = {
						};
					};
					["y"] = 981662.21407734;
					["x"] = -206832.98715087;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 215.83333333333;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[7] = {
									["number"] = 7;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
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
											["id"] = "Option";
											["params"] = {
												["value"] = 1;
												["name"] = 1;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 1;
												["name"] = 3;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 15;
											};
										};
									};
								};
								[8] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 8;
									["params"] = {
										["action"] = {
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = true;
											};
										};
									};
								};
								[9] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 9;
									["params"] = {
										["action"] = {
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["variantIndex"] = 2;
												["value"] = 131074;
												["name"] = 5;
												["formationIndex"] = 2;
											};
										};
									};
								};
								[6] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 6;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 165;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 10000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "usaf standard";
				["skill"] = "Excellent";
				["speed"] = 215.83333333333;
				["AddPropAircraft"] = {
					["VoiceCallsignLabel"] = "DE";
					["VoiceCallsignNumber"] = "11";
					["STN_L16"] = "00641";
				};
				["type"] = "B-1B";
				["unitId"] = 289;
				["psi"] = -0.077966633831506;
				["y"] = 981662.21407734;
				["x"] = -206832.98715087;
				["name"] = "CUSTOM_STEALTHBOMBER";
				["payload"] = {
					["pylons"] = {
						[2] = {
							["CLSID"] = "GBU-31*8";
							["settings"] = {
								["NFP_VIS_DrawArgNo_56"] = 0.5;
								["arm_delay_ctrl_FMU139CB_LD"] = 4;
								["function_delay_ctrl_FMU139CB_LD"] = 0;
								["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL";
								["NFP_fuze_type_tail"] = "FMU139CB_LD";
								["NFP_fuze_type_nose"] = "EMPTY_NOSE";
								["NFP_PRESVER"] = 1;
							};
						};
					};
					["fuel"] = 88450;
					["flare"] = 48;
					["chaff"] = 480;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 5;
					[2] = 1;
					["name"] = "Dodge11";
					[3] = 1;
				};
				["heading"] = -0.032651707933472;
				["onboard_num"] = "016";
			};
		};
		["y"] = 981662.21407734;
		["x"] = -206832.98715087;
		["name"] = "CUSTOM_STEALTHBOMBER";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
	};
	["ZONEMGR_HeliPatrol-8"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "Transport";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 483.36483324719;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995509.71255926;
					["x"] = -214735.67242339;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
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
												["value"] = true;
												["name"] = 32;
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
												["name"] = 7;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 161;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 483.36483324719;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Italy 15B Stormo S.A.R -Soccorso";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["ExhaustScreen"] = true;
					["GunnersAISkill"] = 90;
				};
				["type"] = "UH-1H";
				["unitId"] = 285;
				["psi"] = 0;
				["y"] = 995509.71255926;
				["x"] = -214735.67242339;
				["name"] = "ZONEMGR_HeliPatrol-8-1";
				["payload"] = {
					["pylons"] = {
						[1] = {
							["CLSID"] = "M134_L";
						};
						[6] = {
							["CLSID"] = "M134_R";
						};
						[4] = {
							["CLSID"] = "M134_SIDE_R";
						};
						[3] = {
							["CLSID"] = "M134_SIDE_L";
						};
					};
					["fuel"] = 473;
					["flare"] = 60;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 11;
					[2] = 1;
					["name"] = "Cargo11";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "033";
			};
		};
		["y"] = 995509.71255926;
		["x"] = -214735.67242339;
		["name"] = "ZONEMGR_HeliPatrol-8";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["TEMPLATE_SAM_RDR"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 130;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 238;
				["skill"] = "High";
				["y"] = 982157.640955;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-6";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206359.76851571;
			};
			[2] = {
				["type"] = "Tor 9A331";
				["unitId"] = 234;
				["skill"] = "High";
				["y"] = 982168.95955684;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-2";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206313.73953488;
			};
			[3] = {
				["type"] = "Osa 9A33 ln";
				["unitId"] = 235;
				["skill"] = "High";
				["y"] = 982111.86349865;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-3";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206337.88588548;
			};
			[1] = {
				["type"] = "Tor 9A331";
				["unitId"] = 233;
				["skill"] = "High";
				["y"] = 982134.75222683;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-1";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206309.21209415;
			};
			[4] = {
				["type"] = "Osa 9A33 ln";
				["unitId"] = 236;
				["skill"] = "High";
				["y"] = 982183.04492803;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-4";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206348.70143836;
			};
			[5] = {
				["type"] = "M 818";
				["unitId"] = 237;
				["skill"] = "High";
				["y"] = 982132.23698197;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_RDR-5";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206357.25327086;
			};
		};
		["y"] = 982134.75222683;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_SAM_RDR";
		["x"] = -206309.21209415;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 770;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 982134.75222683;
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
					["x"] = -206309.21209415;
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
	["RED-5"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 189;
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
				["unitId"] = 313;
				["skill"] = "Random";
				["y"] = 684288.38797728;
				["coldAtStart"] = false;
				["name"] = "RED-5-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -284986.92858389;
			};
		};
		["y"] = 684288.38797728;
		["uncontrollable"] = false;
		["name"] = "RED-5";
		["x"] = -284986.92858389;
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
					["y"] = 684288.38797728;
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
					["x"] = -284986.92858389;
				};
			};
			["routeRelativeTOT"] = false;
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
	["CUSTOM_BOMBER"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Ground Attack";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 13700;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["properties"] = {
						["addopt"] = {
						};
					};
					["y"] = 981551.60108099;
					["x"] = -206827.59850511;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 369.48611111111;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[7] = {
									["number"] = 7;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
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
											["id"] = "Option";
											["params"] = {
												["value"] = 1;
												["name"] = 1;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 1;
												["name"] = 3;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 15;
											};
										};
									};
								};
								[8] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 8;
									["params"] = {
										["action"] = {
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[9] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 9;
									["params"] = {
										["action"] = {
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["variantIndex"] = 2;
												["value"] = 131074;
												["name"] = 5;
												["formationIndex"] = 2;
											};
										};
									};
								};
								[6] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 6;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 134;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 13700;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "usaf standard";
				["skill"] = "Excellent";
				["speed"] = 369.48611111111;
				["AddPropAircraft"] = {
					["VoiceCallsignLabel"] = "UI";
					["VoiceCallsignNumber"] = "11";
					["STN_L16"] = "00573";
				};
				["type"] = "B-1B";
				["unitId"] = 251;
				["psi"] = -0.077966633831506;
				["y"] = 981551.60108099;
				["x"] = -206827.59850511;
				["name"] = "CUSTOM_BOMBER-1";
				["payload"] = {
					["pylons"] = {
						[2] = {
							["CLSID"] = "CBU97*10";
						};
					};
					["fuel"] = 88450;
					["flare"] = 48;
					["chaff"] = 480;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 3;
					[2] = 1;
					["name"] = "Uzi11";
					[3] = 1;
				};
				["heading"] = -0.032651707933472;
				["onboard_num"] = "013";
			};
		};
		["y"] = 981551.60108099;
		["x"] = -206827.59850511;
		["name"] = "CUSTOM_BOMBER";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["CUSTOM_TANKER_DROGUE"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Refueling";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 9144;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["y"] = 981616.19127988;
					["x"] = -206914.88098209;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
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
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "ActivateBeacon";
											["params"] = {
												["frequency"] = 962000000;
												["type"] = 4;
												["AA"] = false;
												["callsign"] = "TKR";
												["channel"] = 1;
												["modeChannel"] = "X";
												["bearing"] = true;
												["system"] = 4;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "Tanker";
									["enabled"] = true;
									["params"] = {
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
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
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 167;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 9144;
				["type"] = "KC135MPRS";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = -0.077966633831506;
				["livery_id"] = "100th arw";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 2;
					[2] = 1;
					["name"] = "Arco11";
					[3] = 1;
				};
				["y"] = 981616.19127988;
				["x"] = -206914.88098209;
				["name"] = "CUSTOM_TANKER_DROGUE";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = 90700;
					["flare"] = 60;
					["chaff"] = 120;
					["gun"] = 100;
				};
				["speed"] = 220.97222222222;
				["heading"] = -0.032651707933472;
				["onboard_num"] = "018";
				["unitId"] = 291;
			};
		};
		["y"] = 981616.19127988;
		["x"] = -206914.88098209;
		["name"] = "CUSTOM_TANKER_DROGUE";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["BLUE-2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 191;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M 818";
				["unitId"] = 315;
				["skill"] = "Random";
				["y"] = 760541.27999043;
				["coldAtStart"] = false;
				["name"] = "BLUE-2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -125041.56012833;
			};
			[2] = {
				["type"] = "M 818";
				["unitId"] = 319;
				["skill"] = "Random";
				["y"] = 760541.27999043;
				["coldAtStart"] = false;
				["name"] = "BLUE-2-2";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -125081.56012833;
			};
			[3] = {
				["type"] = "M 818";
				["unitId"] = 320;
				["skill"] = "Random";
				["y"] = 760541.27999043;
				["coldAtStart"] = false;
				["name"] = "BLUE-2-3";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -125121.56012833;
			};
		};
		["y"] = 760541.27999043;
		["uncontrollable"] = false;
		["name"] = "BLUE-2";
		["x"] = -125041.56012833;
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
					["y"] = 760541.27999043;
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
					["x"] = -125041.56012833;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["ZONEMGR_HeliPatrol-3"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAS";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 482.95693489008;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995518.30527283;
					["x"] = -214655.11573368;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAS";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Helicopters";
											[2] = "Ground Units";
											[3] = "Light armed ships";
										};
										["priority"] = 0;
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
												["name"] = 32;
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
												["name"] = 7;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 154;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 482.95693489008;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "georgian air force";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["SimplifiedAI"] = false;
					["OperatorNVG"] = true;
					["ExhaustScreen"] = true;
					["PilotNVG"] = true;
					["GunnersAISkill"] = 90;
					["R60equipment"] = true;
					["TrackAirTargets"] = true;
				};
				["type"] = "Mi-24P";
				["unitId"] = 278;
				["psi"] = 0;
				["y"] = 995518.30527283;
				["x"] = -214655.11573368;
				["name"] = "ZONEMGR_HeliPatrol-3-1";
				["payload"] = {
					["pylons"] = {
						[1] = {
							["CLSID"] = "{2x9M220_Ataka_V}";
						};
						[2] = {
							["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}";
						};
						[6] = {
							["CLSID"] = "{2x9M220_Ataka_V}";
						};
						[5] = {
							["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}";
						};
					};
					["fuel"] = 1701;
					["flare"] = 192;
					["ammo_type"] = 1;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 9;
					[2] = 1;
					["name"] = "Heavy11";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "026";
			};
		};
		["y"] = 995518.30527283;
		["x"] = -214655.11573368;
		["name"] = "ZONEMGR_HeliPatrol-3";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 127.5;
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
	["CUSTOM_TANKER_BOOM"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Refueling";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 9144;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["y"] = 981550.54376165;
					["x"] = -206914.88098209;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 156.73611111111;
					["ETA_locked"] = true;
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
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "ActivateBeacon";
											["params"] = {
												["frequency"] = 962000000;
												["type"] = 4;
												["AA"] = false;
												["callsign"] = "TKR";
												["channel"] = 1;
												["modeChannel"] = "X";
												["bearing"] = true;
												["system"] = 4;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "Tanker";
									["enabled"] = true;
									["params"] = {
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
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
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 166;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 9144;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "TurAF Standard";
				["skill"] = "Excellent";
				["speed"] = 156.73611111111;
				["AddPropAircraft"] = {
					["STN_L16"] = "00642";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "TO";
				};
				["type"] = "KC-135";
				["unitId"] = 290;
				["psi"] = -0.077966633831506;
				["y"] = 981550.54376165;
				["x"] = -206914.88098209;
				["name"] = "CUSTOM_TANKER_BOOM";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = 90700;
					["flare"] = 0;
					["chaff"] = 0;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Texaco11";
					[3] = 1;
				};
				["heading"] = -0.032651707933472;
				["onboard_num"] = "017";
			};
		};
		["y"] = 981550.54376165;
		["x"] = -206914.88098209;
		["name"] = "CUSTOM_TANKER_BOOM";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
	};
	["AA"] = {
		["dynSpawnTemplate"] = false;
		["modulation"] = 0;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 2;
			["typeKey"] = "plane";
			["countryName"] = "USA";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2687;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 910746.10049523;
					["x"] = -61825.542015402;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 179.86111111111;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 6;
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
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4;
												["name"] = 18;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
				[2] = {
					["alt"] = 2122.0176;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 911785.87076051;
					["x"] = -50438.680287101;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 179.86111111111;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 164.84712203955;
				};
				[4] = {
					["alt"] = 9144;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 915797.97936757;
					["x"] = -27034.71341259;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 367.05785659947;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 169.59101817524;
				};
				[3] = {
					["alt"] = 2748;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 914237.71490927;
					["x"] = -38625.249388539;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 179.86111111111;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 219.44758217268;
				};
			};
		};
		["groupId"] = 163;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2687;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "vfa-37";
				["skill"] = "Client";
				["speed"] = 179.86111111111;
				["AddPropAircraft"] = {
					["HelmetMountedDevice"] = 1;
					["VoiceCallsignLabel"] = "SD";
					["OuterBoard"] = 0;
					["InnerBoard"] = 0;
					["STN_L16"] = "00637";
					["VoiceCallsignNumber"] = "11";
				};
				["type"] = "FA-18C_hornet";
				["Radio"] = {
					[1] = {
						["channels"] = {
							[1] = 305;
							[2] = 264;
							[4] = 256;
							[8] = 257;
							[16] = 261;
							[17] = 267;
							[9] = 255;
							[18] = 251;
							[5] = 254;
							[10] = 262;
							[20] = 266;
							[11] = 259;
							[3] = 265;
							[6] = 250;
							[12] = 268;
							[13] = 269;
							[7] = 270;
							[14] = 260;
							[19] = 253;
							[15] = 263;
						};
						["modulations"] = {
							[1] = 0;
							[2] = 0;
							[4] = 0;
							[8] = 0;
							[16] = 0;
							[17] = 0;
							[9] = 0;
							[18] = 0;
							[5] = 0;
							[10] = 0;
							[20] = 0;
							[11] = 0;
							[3] = 0;
							[6] = 0;
							[12] = 0;
							[13] = 0;
							[7] = 0;
							[14] = 0;
							[19] = 0;
							[15] = 0;
						};
						["channelsNames"] = {
						};
					};
					[2] = {
						["channels"] = {
							[1] = 305;
							[2] = 264;
							[4] = 256;
							[8] = 257;
							[16] = 261;
							[17] = 267;
							[9] = 255;
							[18] = 251;
							[5] = 254;
							[10] = 262;
							[20] = 266;
							[11] = 259;
							[3] = 265;
							[6] = 250;
							[12] = 268;
							[13] = 269;
							[7] = 270;
							[14] = 260;
							[19] = 253;
							[15] = 263;
						};
						["modulations"] = {
							[1] = 0;
							[2] = 0;
							[4] = 0;
							[8] = 0;
							[16] = 0;
							[17] = 0;
							[9] = 0;
							[18] = 0;
							[5] = 0;
							[10] = 0;
							[20] = 0;
							[11] = 0;
							[3] = 0;
							[6] = 0;
							[12] = 0;
							[13] = 0;
							[7] = 0;
							[14] = 0;
							[19] = 0;
							[15] = 0;
						};
						["channelsNames"] = {
						};
					};
				};
				["unitId"] = 287;
				["psi"] = -0.091060624262185;
				["y"] = 910746.10049523;
				["x"] = -61825.542015402;
				["name"] = "Aerial-2-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[10] = {
							["CLSID"] = "{INV-SMOKE-RED}";
						};
						[1] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[4] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[9] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
					};
					["fuel"] = 4900;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "011";
				["callsign"] = {
					[1] = 2;
					[2] = 1;
					["name"] = "Springfield11";
					[3] = 1;
				};
				["heading"] = 0.091060624262185;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["FF1_Channel"] = 2;
							["FF2_Channel"] = 3;
							["transmitPower"] = 0;
							["AIC_Channel"] = 1;
							["VOCA_Channel"] = 4;
							["VOCB_Channel"] = 5;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 287;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 910746.10049523;
		["x"] = -61825.542015402;
		["name"] = "AA";
		["communication"] = true;
		["start_time"] = 0;
		["uncontrollable"] = false;
		["frequency"] = 305;
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
	["Test1-13"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 182;
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
				["unitId"] = 306;
				["skill"] = "Random";
				["y"] = 861734.86171626;
				["coldAtStart"] = false;
				["name"] = "Test1-13-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396545.69956924;
			};
		};
		["y"] = 861734.86171626;
		["uncontrollable"] = false;
		["name"] = "Test1-13";
		["x"] = -396545.69956924;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861734.86171626;
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
					["x"] = -396545.69956924;
				};
			};
			["routeRelativeTOT"] = false;
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
	["CUSTOM_StrikeTransport"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Ground Attack";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 772;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["y"] = 981918.94113995;
					["x"] = -206696.34883304;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
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
												["name"] = 7;
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
												["name"] = 1;
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
												["value"] = false;
												["name"] = 6;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["variantIndex"] = 1;
												["zInverse"] = 0;
												["name"] = 5;
												["formationIndex"] = 9;
												["value"] = 589825;
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
								[5] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4294967295;
												["name"] = 10;
											};
										};
									};
								};
								[7] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 7;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 124;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 772;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Italy 15B Stormo S.A.R -Soccorso";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["ExhaustScreen"] = true;
					["GunnersAISkill"] = 90;
				};
				["type"] = "UH-1H";
				["unitId"] = 203;
				["psi"] = 0;
				["y"] = 981918.94113995;
				["x"] = -206696.34883304;
				["name"] = "CUSTOM_StrikeTransport-1";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = "631";
					["flare"] = 60;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Enfield11";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "010";
			};
			[2] = {
				["alt"] = 772;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Italy 15B Stormo S.A.R -Soccorso";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["ExhaustScreen"] = true;
					["GunnersAISkill"] = 90;
				};
				["type"] = "UH-1H";
				["unitId"] = 204;
				["psi"] = 0;
				["y"] = 981958.94113995;
				["x"] = -206736.34883304;
				["name"] = "CUSTOM_StrikeTransport-2";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = "631";
					["flare"] = 60;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Enfield12";
					[3] = 2;
				};
				["heading"] = 0;
				["onboard_num"] = "011";
			};
		};
		["y"] = 981918.94113995;
		["x"] = -206696.34883304;
		["name"] = "CUSTOM_StrikeTransport";
		["communication"] = true;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["TEMPLATE_TankCompany"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 129;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 232;
				["skill"] = "High";
				["y"] = 981584.34879899;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-6";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206353.18286753;
			};
			[2] = {
				["type"] = "M-1 Abrams";
				["unitId"] = 228;
				["skill"] = "High";
				["y"] = 981593.99317343;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-2";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206316.70197291;
			};
			[3] = {
				["type"] = "M-113";
				["unitId"] = 229;
				["skill"] = "High";
				["y"] = 981585.08261008;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-3";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206331.48302504;
			};
			[1] = {
				["type"] = "M-1 Abrams";
				["unitId"] = 227;
				["skill"] = "High";
				["y"] = 981575.33340549;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206316.17782212;
			};
			[4] = {
				["type"] = "M1045 HMMWV TOW";
				["unitId"] = 230;
				["skill"] = "High";
				["y"] = 981595.56562578;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-4";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206347.20754859;
			};
			[5] = {
				["type"] = "M1043 HMMWV Armament";
				["unitId"] = 231;
				["skill"] = "High";
				["y"] = 981571.87401031;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_TankCompany-5";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206347.31237874;
			};
		};
		["y"] = 981575.33340549;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_TankCompany";
		["x"] = -206316.17782212;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 772;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981575.33340549;
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
												["groupId"] = 24;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206316.17782212;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["Ground-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 17;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 566747.52934261;
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
												["value"] = 4;
												["name"] = 0;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -221038.49585886;
				};
			};
		};
		["groupId"] = 193;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR_D";
				["unitId"] = 317;
				["skill"] = "Average";
				["y"] = 566747.52934261;
				["coldAtStart"] = false;
				["name"] = "Ground-1-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -221038.49585886;
			};
		};
		["y"] = 566747.52934261;
		["uncontrollable"] = false;
		["name"] = "Ground-1";
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["x"] = -221038.49585886;
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
	["TEMPLATE_SAM_IR"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 128;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 226;
				["skill"] = "High";
				["y"] = 982020.49051143;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-6";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206349.91600322;
			};
			[2] = {
				["type"] = "Strela-10M3";
				["unitId"] = 222;
				["skill"] = "High";
				["y"] = 982022.96210942;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-2";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206315.72556434;
			};
			[3] = {
				["type"] = "2S6 Tunguska";
				["unitId"] = 223;
				["skill"] = "High";
				["y"] = 981985.08108942;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-3";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206332.87204144;
			};
			[1] = {
				["type"] = "Strela-10M3";
				["unitId"] = 221;
				["skill"] = "High";
				["y"] = 982001.54159349;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-1";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206315.51959784;
			};
			[4] = {
				["type"] = "2S6 Tunguska";
				["unitId"] = 224;
				["skill"] = "High";
				["y"] = 982034.08430038;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-4";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206336.73414726;
			};
			[5] = {
				["type"] = "M 818";
				["unitId"] = 225;
				["skill"] = "High";
				["y"] = 982002.15949299;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_SAM_IR-5";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206348.68020422;
			};
		};
		["y"] = 982001.54159349;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_SAM_IR";
		["x"] = -206315.51959784;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 770;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 982001.54159349;
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
					["x"] = -206315.51959784;
				};
			};
			["routeRelativeTOT"] = true;
		};
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
	["ZONEMGR_HeliPatrol-5"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "AFAC";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 483.36483324719;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995634.30690601;
					["x"] = -214664.78253645;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "FAC";
									["number"] = 1;
									["params"] = {
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 28;
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
												["name"] = 7;
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
												["name"] = 32;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 156;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 483.36483324719;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "default";
				["skill"] = "Excellent";
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["MMS removal"] = false;
					["Remove doors"] = true;
					["PDU"] = false;
					["ALQ144"] = false;
					["Rapid Deployment Gear"] = false;
					["tacNet"] = 1;
				};
				["type"] = "OH58D";
				["unitId"] = 280;
				["psi"] = 0;
				["y"] = 995634.30690601;
				["x"] = -214664.78253645;
				["name"] = "ZONEMGR_HeliPatrol-5-1";
				["payload"] = {
					["pylons"] = {
						[1] = {
							["CLSID"] = "OH58D_FIM_92_L";
						};
						[5] = {
							["CLSID"] = "OH58D_FIM_92_R";
						};
					};
					["fuel"] = 333.69;
					["flare"] = 30;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Anvil11";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "028";
			};
		};
		["y"] = 995634.30690601;
		["x"] = -214664.78253645;
		["name"] = "ZONEMGR_HeliPatrol-5";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 116;
	};
	["TEMPLATE_IFV_Company"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 133;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 250;
				["skill"] = "High";
				["y"] = 981669.51766632;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-6";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206353.00378831;
			};
			[2] = {
				["type"] = "Marder";
				["unitId"] = 246;
				["skill"] = "High";
				["y"] = 981681.47505024;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-2";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206316.68266877;
			};
			[3] = {
				["type"] = "M1126 Stryker ICV";
				["unitId"] = 247;
				["skill"] = "High";
				["y"] = 981670.25147741;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-3";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206331.30394582;
			};
			[1] = {
				["type"] = "M-2 Bradley";
				["unitId"] = 245;
				["skill"] = "High";
				["y"] = 981660.50227282;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206315.99874291;
			};
			[4] = {
				["type"] = "LAV-25";
				["unitId"] = 248;
				["skill"] = "High";
				["y"] = 981682.95201074;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-4";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206344.83179826;
			};
			[5] = {
				["type"] = "MCV-80";
				["unitId"] = 249;
				["skill"] = "High";
				["y"] = 981657.58304218;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_IFV_Company-5";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206342.5729175;
			};
		};
		["y"] = 981660.50227282;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_IFV_Company";
		["x"] = -206315.99874291;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 771;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981660.50227282;
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
												["groupId"] = 25;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206315.99874291;
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
	["TEST_CUSTOM_STEALTHBOMBER-1"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = false;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Ground Attack";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 15240;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["properties"] = {
						["addopt"] = {
						};
					};
					["y"] = 901291.39447504;
					["x"] = -363958.14300777;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 369.4;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["number"] = 6;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
											};
										};
									};
								};
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 1;
												["name"] = 3;
											};
										};
									};
								};
								[8] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 8;
									["params"] = {
										["action"] = {
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 15;
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
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 1;
											};
										};
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["number"] = 5;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
								[7] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 7;
									["params"] = {
										["action"] = {
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = true;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
				[2] = {
					["alt"] = 15240;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["properties"] = {
						["addopt"] = {
						};
					};
					["y"] = 884276.03376981;
					["x"] = -380520.62339004;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 369.4;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = false;
									["id"] = "Bombing";
									["enabled"] = true;
									["params"] = {
										["direction"] = 0;
										["attackQtyLimit"] = false;
										["attackQty"] = 1;
										["expend"] = "One";
										["altitude"] = 15240;
										["directionEnabled"] = false;
										["x"] = -396546.52710361;
										["y"] = 861736.12139809;
										["altitudeEnabled"] = false;
										["weaponType"] = 14;
										["groupAttack"] = false;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "Bombing";
									["number"] = 2;
									["params"] = {
										["direction"] = 0;
										["attackQtyLimit"] = false;
										["attackQty"] = 1;
										["expend"] = "One";
										["y"] = 861582.04321687;
										["directionEnabled"] = false;
										["groupAttack"] = false;
										["altitude"] = 15240;
										["altitudeEnabled"] = false;
										["weaponType"] = 14;
										["x"] = -396499.30452478;
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = false;
									["id"] = "Bombing";
									["enabled"] = true;
									["params"] = {
										["groupAttack"] = false;
										["attackQtyLimit"] = false;
										["attackQty"] = 1;
										["expend"] = "One";
										["altitude"] = 15240;
										["directionEnabled"] = false;
										["x"] = -396581.87382844;
										["y"] = 861657.15531071;
										["altitudeEnabled"] = false;
										["weaponType"] = 14;
										["direction"] = 0;
									};
								};
							};
						};
					};
					["ETA"] = 64.280667600399;
				};
			};
			["routeRelativeTOT"] = false;
		};
		["groupId"] = 184;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 15240;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "usaf standard";
				["skill"] = "Excellent";
				["speed"] = 369.4;
				["AddPropAircraft"] = {
					["STN_L16"] = "00664";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "FD";
				};
				["type"] = "B-1B";
				["unitId"] = 308;
				["psi"] = 2.3427078320323;
				["y"] = 901291.39447504;
				["x"] = -363958.14300777;
				["name"] = "TEST_CUSTOM_STEALTHBOMBER-1-1";
				["payload"] = {
					["pylons"] = {
						[2] = {
							["CLSID"] = "GBU-31*8";
							["settings"] = {
								["arm_delay_ctrl_FMU139CB_LD"] = 4;
								["NFP_VIS_DrawArgNo_56"] = 0.5;
								["function_delay_ctrl_FMU139CB_LD"] = 0;
								["NFP_PRESID"] = "MDRN_B_A_PGM_TWINWELL";
								["NFP_fuze_type_tail"] = "FMU139CB_LD";
								["NFP_fuze_type_nose"] = "EMPTY_NOSE";
								["NFP_PRESVER"] = 1;
							};
						};
					};
					["fuel"] = 88450;
					["flare"] = 48;
					["chaff"] = 480;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 6;
					[2] = 1;
					["name"] = "Ford11";
					[3] = 1;
				};
				["heading"] = -2.3427078320323;
				["onboard_num"] = "020";
			};
		};
		["y"] = 901291.39447504;
		["x"] = -363958.14300777;
		["name"] = "TEST_CUSTOM_STEALTHBOMBER-1";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["ZONEMGR_CAP-7"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995108.27633525;
					["x"] = -214285.56321066;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 169.58333333333;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 145;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "J-11A";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "usaf 65th aggressor sqn 'desert' (fictional)";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 8;
					[2] = 1;
					["name"] = "Pontiac11";
					[3] = 1;
				};
				["y"] = 995108.27633525;
				["x"] = -214285.56321066;
				["name"] = "ZONEMGR_CAP-7-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[1] = {
							["CLSID"] = "{RKL609_L}";
						};
						[2] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[4] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[8] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[9] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[5] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[10] = {
							["CLSID"] = "{RKL609_R}";
						};
						[3] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[6] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
					};
					["fuel"] = 9400;
					["flare"] = 96;
					["chaff"] = 96;
					["gun"] = 100;
				};
				["speed"] = 169.58333333333;
				["heading"] = 0;
				["onboard_num"] = "017";
				["unitId"] = 269;
			};
		};
		["y"] = 995108.27633525;
		["x"] = -214285.56321066;
		["name"] = "ZONEMGR_CAP-7";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 127.5;
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
	["ZONEMGR_CAP-16"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994895.02376856;
					["x"] = -214660.60699297;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 153;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "proto 06";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
				};
				["type"] = "JF-17";
				["unitId"] = 277;
				["psi"] = 0;
				["y"] = 994895.02376856;
				["x"] = -214660.60699297;
				["name"] = "ZONEMGR_CAP-16-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[2] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[3] = {
							["CLSID"] = "DIS_TANK800";
						};
						[1] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[4] = {
							["CLSID"] = "DIS_SPJ_POD";
						};
						[5] = {
							["CLSID"] = "DIS_TANK800";
						};
						[7] = {
							["CLSID"] = "DIS_PL-5EII";
						};
					};
					["fuel"] = 2325;
					["flare"] = 32;
					["chaff"] = 36;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 8;
					[2] = 2;
					["name"] = "Pontiac21";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "025";
			};
		};
		["y"] = 994895.02376856;
		["x"] = -214660.60699297;
		["name"] = "ZONEMGR_CAP-16";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 243;
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
	["AA-1"] = {
		["dynSpawnTemplate"] = false;
		["modulation"] = 0;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 7620;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 915484.32051799;
					["x"] = -18115.462305399;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 256.94444444444;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 6;
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
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4;
												["name"] = 18;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
				[2] = {
					["alt"] = 7620;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 921051.72904474;
					["x"] = -14206.430786618;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 256.94444444444;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "Orbit";
									["number"] = 1;
									["params"] = {
										["speedEdited"] = true;
										["pattern"] = "Circle";
										["speed"] = 256.94444444444;
										["altitudeEdited"] = true;
										["altitude"] = 7620;
									};
								};
							};
						};
					};
					["ETA"] = 26.475326582983;
				};
			};
		};
		["groupId"] = 164;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 7620;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "vfa-37";
				["skill"] = "Average";
				["speed"] = 256.94444444444;
				["AddPropAircraft"] = {
					["HelmetMountedDevice"] = 1;
					["VoiceCallsignLabel"] = "UI";
					["OuterBoard"] = 0;
					["InnerBoard"] = 0;
					["STN_L16"] = "00640";
					["VoiceCallsignNumber"] = "11";
				};
				["type"] = "FA-18C_hornet";
				["unitId"] = 288;
				["psi"] = -0.95864382984992;
				["y"] = 915484.32051799;
				["x"] = -18115.462305399;
				["name"] = "AA-1-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[10] = {
							["CLSID"] = "{INV-SMOKE-RED}";
						};
						[1] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[4] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[9] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
					};
					["fuel"] = 4900;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "012";
				["callsign"] = {
					[1] = 3;
					[2] = 1;
					["name"] = "Uzi11";
					[3] = 1;
				};
				["heading"] = 0.95864382984992;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["FF1_Channel"] = 2;
							["FF2_Channel"] = 3;
							["transmitPower"] = 0;
							["AIC_Channel"] = 1;
							["VOCA_Channel"] = 4;
							["VOCB_Channel"] = 5;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 288;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 915484.32051799;
		["x"] = -18115.462305399;
		["name"] = "AA-1";
		["communication"] = true;
		["start_time"] = 0;
		["uncontrollable"] = false;
		["frequency"] = 305;
	};
	["ZONEMGR_CAP-6"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994880.12325912;
					["x"] = -214297.40085161;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 152;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "proto 06";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
				};
				["type"] = "JF-17";
				["unitId"] = 276;
				["psi"] = 0;
				["y"] = 994880.12325912;
				["x"] = -214297.40085161;
				["name"] = "ZONEMGR_CAP-6-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[2] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[3] = {
							["CLSID"] = "DIS_TANK800";
						};
						[1] = {
							["CLSID"] = "DIS_PL-5EII";
						};
						[4] = {
							["CLSID"] = "DIS_SPJ_POD";
						};
						[5] = {
							["CLSID"] = "DIS_TANK800";
						};
						[7] = {
							["CLSID"] = "DIS_PL-5EII";
						};
					};
					["fuel"] = 2325;
					["flare"] = 32;
					["chaff"] = 36;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 7;
					[2] = 2;
					["name"] = "Chevy21";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "024";
			};
		};
		["y"] = 994880.12325912;
		["x"] = -214297.40085161;
		["name"] = "ZONEMGR_CAP-6";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 243;
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
	["ZONEMGR_CAP-5"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994695.94149916;
					["x"] = -214308.4517572;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 251.80555555556;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 150;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "idf ra'am, 69 hammer sqn";
				["skill"] = "Excellent";
				["speed"] = 251.80555555556;
				["AddPropAircraft"] = {
					["IFF_M2_CODE"] = "auto";
					["InitAirborneTime"] = 0;
					["Sta8LaserCode"] = 688;
					["LCFTLaserCode"] = 688;
					["Sta5LaserCode"] = 688;
					["Sta2LaserCode"] = 688;
					["RCFTLaserCode"] = 688;
					["MountNVG"] = false;
				};
				["type"] = "F-15ESE";
				["unitId"] = 274;
				["psi"] = 0;
				["y"] = 994695.94149916;
				["x"] = -214308.4517572;
				["name"] = "ZONEMGR_CAP-5-1";
				["payload"] = {
					["pylons"] = {
						[13] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[1] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[2] = {
							["CLSID"] = "{F15E_EXTTANK}";
						};
						[15] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[5] = {
							["CLSID"] = "{AIM-7H}";
						};
						[10] = {
							["CLSID"] = "{AIM-7H}";
						};
						[3] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[6] = {
							["CLSID"] = "{AIM-7H}";
						};
						[14] = {
							["CLSID"] = "{F15E_EXTTANK}";
						};
						[11] = {
							["CLSID"] = "{AIM-7H}";
						};
					};
					["fuel"] = 10246;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 120;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 5;
					[2] = 2;
					["name"] = "Dodge21";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "022";
			};
		};
		["y"] = 994695.94149916;
		["x"] = -214308.4517572;
		["name"] = "ZONEMGR_CAP-5";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 243;
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
	["Test1-12"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 181;
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
				["unitId"] = 305;
				["skill"] = "Random";
				["y"] = 861512.12542515;
				["coldAtStart"] = false;
				["name"] = "Test1-12-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396555.71324845;
			};
		};
		["y"] = 861512.12542515;
		["uncontrollable"] = false;
		["name"] = "Test1-12";
		["x"] = -396555.71324845;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2654182795;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861512.12542515;
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
					["x"] = -396555.71324845;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1-9"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 178;
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
				["unitId"] = 302;
				["skill"] = "Random";
				["y"] = 861578.42873984;
				["coldAtStart"] = false;
				["name"] = "Test1-9-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396725.57602609;
			};
		};
		["y"] = 861578.42873984;
		["uncontrollable"] = false;
		["name"] = "Test1-9";
		["x"] = -396725.57602609;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2637092935;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861578.42873984;
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
					["x"] = -396725.57602609;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 169;
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
				["unitId"] = 293;
				["skill"] = "Random";
				["y"] = 861550.58549824;
				["coldAtStart"] = false;
				["name"] = "Test1-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396667.30845534;
			};
		};
		["y"] = 861550.58549824;
		["uncontrollable"] = false;
		["name"] = "Test1";
		["x"] = -396667.30845534;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861550.58549824;
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
					["x"] = -396667.30845534;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 170;
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
				["unitId"] = 294;
				["skill"] = "Random";
				["y"] = 861596.30455236;
				["coldAtStart"] = false;
				["name"] = "Test1-1-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396611.98800385;
			};
		};
		["y"] = 861596.30455236;
		["uncontrollable"] = false;
		["name"] = "Test1-1";
		["x"] = -396611.98800385;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861596.30455236;
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
					["x"] = -396611.98800385;
				};
			};
			["routeRelativeTOT"] = false;
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
	["ZONEMGR_CAP-11"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994865.25864972;
					["x"] = -214491.93798619;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 147;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "MiG-29G";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "luftwaffe gray-1";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 2;
					[2] = 2;
					["name"] = "Springfield21";
					[3] = 1;
				};
				["y"] = 994865.25864972;
				["x"] = -214491.93798619;
				["name"] = "ZONEMGR_CAP-11-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[2] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[3] = {
							["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}";
						};
						[1] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[4] = {
							["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}";
						};
						[5] = {
							["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}";
						};
						[7] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
					};
					["fuel"] = "3376";
					["flare"] = 30;
					["chaff"] = 30;
					["gun"] = 100;
				};
				["speed"] = 220.97222222222;
				["heading"] = 0;
				["onboard_num"] = "019";
				["unitId"] = 271;
			};
		};
		["y"] = 994865.25864972;
		["x"] = -214491.93798619;
		["name"] = "ZONEMGR_CAP-11";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["ZONEMGR_CAP-9"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995447.40307979;
					["x"] = -214282.66631081;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 146;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "MiG-21Bis";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "afghanistan (1)";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 1;
					[2] = 2;
					["name"] = "Enfield21";
					[3] = 1;
				};
				["y"] = 995447.40307979;
				["x"] = -214282.66631081;
				["name"] = "ZONEMGR_CAP-9-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{SPRD}";
						};
						[2] = {
							["CLSID"] = "{R-3R}";
						};
						[3] = {
							["CLSID"] = "{PTB_490C_MIG21}";
						};
						[1] = {
							["CLSID"] = "{R-60M 2L}";
						};
						[4] = {
							["CLSID"] = "{R-3R}";
						};
						[5] = {
							["CLSID"] = "{R-60M 2R}";
						};
						[7] = {
							["CLSID"] = "{MIG21_SMOKE_WHITE}";
						};
					};
					["fuel"] = 2280;
					["flare"] = 40;
					["ammo_type"] = 1;
					["chaff"] = 18;
					["gun"] = 100;
				};
				["speed"] = 220.97222222222;
				["heading"] = 0;
				["onboard_num"] = "018";
				["unitId"] = 270;
			};
		};
		["y"] = 995447.40307979;
		["x"] = -214282.66631081;
		["name"] = "ZONEMGR_CAP-9";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["TEMPLATE_EWR"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 125;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "55G6 EWR";
				["unitId"] = 205;
				["skill"] = "High";
				["y"] = 982324.87650306;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_EWR-1";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -206318.540862;
			};
			[2] = {
				["type"] = "SA-18 Igla manpad";
				["unitId"] = 206;
				["skill"] = "High";
				["y"] = 982283.99938201;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_EWR-2";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -206346.53889011;
			};
			[4] = {
				["type"] = "M 818";
				["unitId"] = 208;
				["skill"] = "High";
				["y"] = 982341.95530021;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_EWR-4";
				["playerCanDrive"] = false;
				["heading"] = 0.61086523819802;
				["x"] = -206359.9779436;
			};
			[3] = {
				["type"] = "SA-18 Igla comm";
				["unitId"] = 207;
				["skill"] = "High";
				["y"] = 982286.77214173;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_EWR-3";
				["playerCanDrive"] = false;
				["heading"] = 0.05235987755983;
				["x"] = -206350.45969089;
			};
		};
		["y"] = 982324.87650306;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_EWR";
		["x"] = -206318.540862;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 769;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 982324.87650306;
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
					["x"] = -206318.540862;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["ZONEMGR_CAP-2"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994920.64324631;
					["x"] = -214072.69910446;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["enabled"] = true;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["number"] = 5;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 144;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Damned - General";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
					["STN_L16"] = "00614";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "CY";
				};
				["type"] = "F-16C_50";
				["unitId"] = 268;
				["psi"] = 0;
				["y"] = 994920.64324631;
				["x"] = -214072.69910446;
				["name"] = "ZONEMGR_CAP-2-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[1] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[2] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[4] = {
							["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}";
						};
						[8] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[9] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[5] = {
							["CLSID"] = "ALQ_184";
						};
						[3] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[6] = {
							["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}";
						};
					};
					["fuel"] = 3249;
					["flare"] = 60;
					["ammo_type"] = 5;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "016";
				["callsign"] = {
					[1] = 7;
					[2] = 1;
					["name"] = "Chevy11";
					[3] = 1;
				};
				["heading"] = 0;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["flightLead"] = true;
							["transmitPower"] = 3;
							["specialChannel"] = 1;
							["fighterChannel"] = 1;
							["missionChannel"] = 1;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 268;
									["TDOA"] = true;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 994920.64324631;
		["x"] = -214072.69910446;
		["name"] = "ZONEMGR_CAP-2";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 305;
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
	["ZONEMGR_CAP-1"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994724.98922287;
					["x"] = -214063.62561415;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 179.86111111111;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["enabled"] = true;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["number"] = 5;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 142;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Damned - General";
				["skill"] = "Excellent";
				["speed"] = 179.86111111111;
				["AddPropAircraft"] = {
					["STN_L16"] = "00612";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "DE";
				};
				["type"] = "FA-18C_hornet";
				["unitId"] = 266;
				["psi"] = 0;
				["y"] = 994724.98922287;
				["x"] = -214063.62561415;
				["name"] = "ZONEMGR_CAP-1-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{LAU-115 - AIM-7P}";
						};
						[1] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[2] = {
							["CLSID"] = "<CLEAN>";
						};
						[4] = {
							["CLSID"] = "{AIM-7P}";
						};
						[8] = {
							["CLSID"] = "<CLEAN>";
						};
						[9] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[5] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[10] = {
							["CLSID"] = "{INV-SMOKE-RED}";
						};
						[3] = {
							["CLSID"] = "{LAU-115 - AIM-7P}";
						};
						[6] = {
							["CLSID"] = "{AIM-7P}";
						};
					};
					["fuel"] = 4900;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "014";
				["callsign"] = {
					[1] = 5;
					[2] = 1;
					["name"] = "Dodge11";
					[3] = 1;
				};
				["heading"] = 0;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["FF1_Channel"] = 2;
							["FF2_Channel"] = 3;
							["transmitPower"] = 0;
							["AIC_Channel"] = 1;
							["VOCA_Channel"] = 4;
							["VOCB_Channel"] = 5;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 266;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 994724.98922287;
		["x"] = -214063.62561415;
		["name"] = "ZONEMGR_CAP-1";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 305;
	};
	["TEMPLATE_Strike"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 132;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[2] = {
				["type"] = "Soldier M249";
				["unitId"] = 241;
				["skill"] = "High";
				["y"] = 981582.16045107;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Strike-2";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -206440.33363266;
			};
			[3] = {
				["type"] = "Soldier RPG";
				["unitId"] = 242;
				["skill"] = "High";
				["y"] = 981578.73187964;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Strike-3";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -206440.6764898;
			};
			[1] = {
				["type"] = "Soldier M4";
				["unitId"] = 240;
				["skill"] = "Excellent";
				["y"] = 981580.43441212;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Strike-1";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -206438.73217363;
			};
			[4] = {
				["type"] = "Soldier RPG";
				["unitId"] = 243;
				["skill"] = "High";
				["y"] = 981578.33187964;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Strike-4";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -206443.01934695;
			};
			[5] = {
				["type"] = "Soldier RPG";
				["unitId"] = 244;
				["skill"] = "High";
				["y"] = 981582.64616536;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Strike-5";
				["playerCanDrive"] = false;
				["heading"] = 0;
				["x"] = -206442.53363266;
			};
		};
		["y"] = 981580.43441212;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_Strike";
		["x"] = -206438.73217363;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 772;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981580.43441212;
					["formation_template"] = "";
					["speed_locked"] = true;
					["ETA_locked"] = true;
					["speed"] = 0;
					["action"] = "Vee";
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["number"] = 1;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
									["number"] = 2;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
					["x"] = -206438.73217363;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["ZONEMGR_CAP-4"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995469.50489098;
					["x"] = -214039.54638767;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
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
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 151;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "106th sqn (8th airbase)";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
					["VoiceCallsignLabel"] = "FD";
					["VoiceCallsignNumber"] = "21";
					["STN_L16"] = "00623";
				};
				["type"] = "F-15C";
				["unitId"] = 275;
				["psi"] = 0;
				["y"] = 995469.50489098;
				["x"] = -214039.54638767;
				["name"] = "ZONEMGR_CAP-4-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}";
						};
						[1] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[2] = {
							["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}";
						};
						[4] = {
							["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}";
						};
						[8] = {
							["CLSID"] = "{AIM-7H}";
						};
						[9] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[5] = {
							["CLSID"] = "{AIM-7H}";
						};
						[10] = {
							["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}";
						};
						[3] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
						[6] = {
							["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}";
						};
						[11] = {
							["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}";
						};
					};
					["fuel"] = "6103";
					["flare"] = 60;
					["chaff"] = 120;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 6;
					[2] = 2;
					["name"] = "Ford21";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "023";
			};
		};
		["y"] = 995469.50489098;
		["x"] = -214039.54638767;
		["name"] = "ZONEMGR_CAP-4";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
	};
	["ZONEMGR_CAP-10"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994695.07653292;
					["x"] = -214489.84719462;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 139;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "MiG-29A";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "Air Force Standard";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 2;
					[2] = 1;
					["name"] = "Springfield11";
					[3] = 1;
				};
				["y"] = 994695.07653292;
				["x"] = -214489.84719462;
				["name"] = "ZONEMGR_CAP-10-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[2] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[3] = {
							["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}";
						};
						[1] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[4] = {
							["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}";
						};
						[5] = {
							["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}";
						};
						[7] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
					};
					["fuel"] = "3376";
					["flare"] = 30;
					["chaff"] = 30;
					["gun"] = 100;
				};
				["speed"] = 220.97222222222;
				["heading"] = 0;
				["onboard_num"] = "011";
				["unitId"] = 263;
			};
		};
		["y"] = 994695.07653292;
		["x"] = -214489.84719462;
		["name"] = "ZONEMGR_CAP-10";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
	};
	["ZONEMGR_CAP-8"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995270.58859023;
					["x"] = -214286.34994601;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 251.80555555556;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 138;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "2003 tigermeet";
				["skill"] = "Excellent";
				["speed"] = 251.80555555556;
				["AddPropAircraft"] = {
					["ReadyALCM"] = true;
					["GunBurst"] = 1;
					["InitHotDrift"] = 0;
					["ForceINSRules"] = false;
					["RocketBurst"] = 6;
					["LoadNVGCase"] = false;
					["DisableVTBExport"] = false;
					["LaserCode100"] = 6;
					["LaserCode1"] = 8;
					["IFF_M2_CODE"] = "auto";
					["ReadyQRA"] = false;
					["WpBullseye"] = 0;
					["LaserCode10"] = 8;
					["EnableTAF"] = true;
				};
				["type"] = "M-2000C";
				["unitId"] = 262;
				["psi"] = 0;
				["y"] = 995270.58859023;
				["x"] = -214286.34994601;
				["name"] = "ZONEMGR_CAP-8-1";
				["payload"] = {
					["pylons"] = {
						[2] = {
							["CLSID"] = "{Matra_S530D}";
						};
						[8] = {
							["CLSID"] = "{Matra_S530D}";
						};
						[10] = {
							["CLSID"] = "{Eclair}";
						};
						[1] = {
							["CLSID"] = "{MMagicII}";
						};
						[9] = {
							["CLSID"] = "{MMagicII}";
						};
						[5] = {
							["CLSID"] = "{M2KC_RPL_522}";
						};
					};
					["fuel"] = 3165;
					["flare"] = 64;
					["ammo_type"] = 1;
					["chaff"] = 234;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Enfield11";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "010";
			};
		};
		["y"] = 995270.58859023;
		["x"] = -214286.34994601;
		["name"] = "ZONEMGR_CAP-8";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["ZONEMGR_HeliPatrol-6"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAS";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 483.36483324719;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995391.25704016;
					["x"] = -214738.3323385;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAS";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Helicopters";
											[2] = "Ground Units";
											[3] = "Light armed ships";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 29;
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
												["name"] = 7;
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
												["name"] = 32;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 157;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 483.36483324719;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "cyp air force sand";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["SA342RemoveDoors"] = false;
				};
				["type"] = "SA342L";
				["unitId"] = 281;
				["psi"] = 0;
				["y"] = 995391.25704016;
				["x"] = -214738.3323385;
				["name"] = "ZONEMGR_HeliPatrol-6-1";
				["payload"] = {
					["pylons"] = {
						[1] = {
							["CLSID"] = "{SA342_Mistral_R2}";
						};
						[2] = {
							["CLSID"] = "{SA342_Mistral_L2}";
						};
						[4] = {
							["CLSID"] = "{IR_Deflector}";
						};
					};
					["fuel"] = 416.33;
					["flare"] = 32;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 1;
					[2] = 3;
					["name"] = "Enfield31";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "029";
			};
		};
		["y"] = 995391.25704016;
		["x"] = -214738.3323385;
		["name"] = "ZONEMGR_HeliPatrol-6";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["ZONEMGR_HeliPatrol-7"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAS";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 483.36483324719;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995449.56356429;
					["x"] = -214736.74651258;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAS";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Helicopters";
											[2] = "Ground Units";
											[3] = "Light armed ships";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "EPLRS";
											["params"] = {
												["value"] = true;
												["groupId"] = 30;
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
												["name"] = 7;
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
												["name"] = 32;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 158;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 483.36483324719;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "cyp air force sand";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
				};
				["type"] = "SA342Minigun";
				["unitId"] = 282;
				["psi"] = 0;
				["y"] = 995449.56356429;
				["x"] = -214736.74651258;
				["name"] = "ZONEMGR_HeliPatrol-7-1";
				["payload"] = {
					["pylons"] = {
						[4] = {
							["CLSID"] = "{IR_Deflector}";
						};
					};
					["fuel"] = 416.33;
					["flare"] = 32;
					["ammo_type"] = 1;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 2;
					[2] = 3;
					["name"] = "Springfield31";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "030";
			};
		};
		["y"] = 995449.56356429;
		["x"] = -214736.74651258;
		["name"] = "ZONEMGR_HeliPatrol-7";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
	};
	["Test1-7"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 176;
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
				["unitId"] = 300;
				["skill"] = "Random";
				["y"] = 861678.83090209;
				["coldAtStart"] = false;
				["name"] = "Test1-7-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396637.1716065;
			};
		};
		["y"] = 861678.83090209;
		["uncontrollable"] = false;
		["name"] = "Test1-7";
		["x"] = -396637.1716065;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2616340961;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861678.83090209;
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
					["x"] = -396637.1716065;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1-4"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 173;
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
				["unitId"] = 297;
				["skill"] = "Random";
				["y"] = 861538.64675102;
				["coldAtStart"] = false;
				["name"] = "Test1-4-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396624.85813377;
			};
		};
		["y"] = 861538.64675102;
		["uncontrollable"] = false;
		["name"] = "Test1-4";
		["x"] = -396624.85813377;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2646858569;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861538.64675102;
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
					["x"] = -396624.85813377;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["RED-4"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 188;
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
				["unitId"] = 312;
				["skill"] = "Random";
				["y"] = 462210.90058401;
				["coldAtStart"] = false;
				["name"] = "RED-4-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -164638.34374338;
			};
		};
		["y"] = 462210.90058401;
		["uncontrollable"] = false;
		["name"] = "RED-4";
		["x"] = -164638.34374338;
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
					["y"] = 462210.90058401;
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
					["x"] = -164638.34374338;
				};
			};
			["routeRelativeTOT"] = false;
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
	["RED-3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 187;
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
				["unitId"] = 311;
				["skill"] = "Random";
				["y"] = 635758.73250808;
				["coldAtStart"] = false;
				["name"] = "RED-3-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -317782.23148808;
			};
		};
		["y"] = 635758.73250808;
		["uncontrollable"] = false;
		["name"] = "RED-3";
		["x"] = -317782.23148808;
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
					["y"] = 635758.73250808;
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
					["x"] = -317782.23148808;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["RED-2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 186;
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
				["unitId"] = 310;
				["skill"] = "Random";
				["y"] = 617352.59594871;
				["coldAtStart"] = false;
				["name"] = "RED-2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -355893.57109092;
			};
		};
		["y"] = 617352.59594871;
		["uncontrollable"] = false;
		["name"] = "RED-2";
		["x"] = -355893.57109092;
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
					["y"] = 617352.59594871;
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
					["x"] = -355893.57109092;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1-3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 172;
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
				["unitId"] = 296;
				["skill"] = "Random";
				["y"] = 861610.0158125;
				["coldAtStart"] = false;
				["name"] = "Test1-3-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396671.97476695;
			};
		};
		["y"] = 861610.0158125;
		["uncontrollable"] = false;
		["name"] = "Test1-3";
		["x"] = -396671.97476695;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861610.0158125;
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
					["x"] = -396671.97476695;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["RED-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 185;
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
				["unitId"] = 309;
				["skill"] = "Random";
				["y"] = 647086.94635695;
				["coldAtStart"] = false;
				["name"] = "RED-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -281607.24635888;
			};
		};
		["y"] = 647086.94635695;
		["uncontrollable"] = false;
		["name"] = "RED-1";
		["x"] = -281607.24635888;
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
					["y"] = 647086.94635695;
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
					["x"] = -281607.24635888;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["Test1-2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 171;
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
				["unitId"] = 295;
				["skill"] = "Random";
				["y"] = 861580.87938471;
				["coldAtStart"] = false;
				["name"] = "Test1-2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396636.83966285;
			};
		};
		["y"] = 861580.87938471;
		["uncontrollable"] = false;
		["name"] = "Test1-2";
		["x"] = -396636.83966285;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861580.87938471;
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
					["x"] = -396636.83966285;
				};
			};
			["routeRelativeTOT"] = false;
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
	["Test1-14"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 183;
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
				["unitId"] = 307;
				["skill"] = "Random";
				["y"] = 861581.86648778;
				["coldAtStart"] = false;
				["name"] = "Test1-14-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396498.6229372;
			};
		};
		["y"] = 861581.86648778;
		["uncontrollable"] = false;
		["name"] = "Test1-14";
		["x"] = -396498.6229372;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2638313639;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861581.86648778;
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
					["x"] = -396498.6229372;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["ZONEMGR_CAP-15"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 994705.70009339;
					["x"] = -214644.14950734;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 169.58333333333;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 149;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "Su-33";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "279th kiap 1st squad navy";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 4;
					[2] = 2;
					["name"] = "Colt21";
					[3] = 1;
				};
				["y"] = 994705.70009339;
				["x"] = -214644.14950734;
				["name"] = "ZONEMGR_CAP-15-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[2] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[12] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[3] = {
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}";
						};
						[1] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[10] = {
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}";
						};
						[11] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[7] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
					};
					["fuel"] = 4750;
					["flare"] = 48;
					["chaff"] = 48;
					["gun"] = 100;
				};
				["speed"] = 169.58333333333;
				["heading"] = 0;
				["onboard_num"] = "021";
				["unitId"] = 273;
			};
		};
		["y"] = 994705.70009339;
		["x"] = -214644.14950734;
		["name"] = "ZONEMGR_CAP-15";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["Ground-2"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 16;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 566626.49874464;
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
												["value"] = 4;
												["name"] = 0;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -221516.24821928;
				};
			};
		};
		["groupId"] = 194;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Red";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "BTR_D";
				["unitId"] = 318;
				["skill"] = "Average";
				["y"] = 566626.49874464;
				["coldAtStart"] = false;
				["name"] = "Ground-2-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -221516.24821928;
			};
		};
		["y"] = 566626.49874464;
		["uncontrollable"] = false;
		["name"] = "Ground-2";
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["x"] = -221516.24821928;
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
	["CUSTOM_CAP"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 10668;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 981520.7388714;
					["x"] = -207164.27715508;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 274.64484702976;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 6;
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
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[8] = {
									["number"] = 8;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["variantIndex"] = 1;
												["value"] = 393217;
												["name"] = 5;
												["formationIndex"] = 6;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4;
												["name"] = 18;
											};
										};
									};
								};
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[5] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 5;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[7] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 7;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4;
												["name"] = 18;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 136;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 10668;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "vfa-37";
				["skill"] = "Average";
				["speed"] = 274.64484702976;
				["AddPropAircraft"] = {
					["STN_L16"] = "00603";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "CT";
				};
				["type"] = "FA-18C_hornet";
				["unitId"] = 259;
				["psi"] = -1.5813164076074;
				["y"] = 981520.7388714;
				["x"] = -207164.27715508;
				["name"] = "CUSTOM_CAP-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[1] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[2] = {
							["CLSID"] = "LAU-115_2*LAU-127_AIM-120C";
						};
						[4] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[8] = {
							["CLSID"] = "LAU-115_2*LAU-127_AIM-120C";
						};
						[9] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[5] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[3] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[6] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
					};
					["fuel"] = 4900;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "014";
				["callsign"] = {
					[1] = 4;
					[2] = 1;
					["name"] = "Colt11";
					[3] = 1;
				};
				["heading"] = 1.5813164076074;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["FF1_Channel"] = 2;
							["FF2_Channel"] = 3;
							["transmitPower"] = 0;
							["VOCB_Channel"] = 5;
							["VOCA_Channel"] = 4;
							["AIC_Channel"] = 1;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 259;
								};
								[2] = {
									["missionUnitId"] = 260;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
			[2] = {
				["alt"] = 10668;
				["alt_type"] = "BARO";
				["livery_id"] = "vfa-37";
				["skill"] = "Average";
				["speed"] = 274.64484702976;
				["AddPropAircraft"] = {
					["STN_L16"] = "00604";
					["VoiceCallsignNumber"] = "12";
					["VoiceCallsignLabel"] = "CT";
				};
				["type"] = "FA-18C_hornet";
				["unitId"] = 260;
				["psi"] = -1.5813164076074;
				["y"] = 981560.7388714;
				["x"] = -207204.27715508;
				["name"] = "CUSTOM_CAP-2";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[1] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[2] = {
							["CLSID"] = "LAU-115_2*LAU-127_AIM-120C";
						};
						[4] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
						[8] = {
							["CLSID"] = "LAU-115_2*LAU-127_AIM-120C";
						};
						[9] = {
							["CLSID"] = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}";
						};
						[5] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[3] = {
							["CLSID"] = "{FPU_8A_FUEL_TANK}";
						};
						[6] = {
							["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}";
						};
					};
					["fuel"] = 4900;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "015";
				["callsign"] = {
					[1] = 4;
					[2] = 1;
					["name"] = "Colt12";
					[3] = 2;
				};
				["heading"] = 1.5813164076074;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["FF1_Channel"] = 2;
							["FF2_Channel"] = 3;
							["transmitPower"] = 0;
							["VOCB_Channel"] = 5;
							["VOCA_Channel"] = 4;
							["AIC_Channel"] = 1;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["missionUnitId"] = 259;
								};
								[2] = {
									["missionUnitId"] = 260;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 981520.7388714;
		["x"] = -207164.27715508;
		["name"] = "CUSTOM_CAP";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 305;
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
	["Test1-8"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 177;
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
				["unitId"] = 301;
				["skill"] = "Random";
				["y"] = 861661.78147831;
				["coldAtStart"] = false;
				["name"] = "Test1-8-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396698.42324008;
			};
		};
		["y"] = 861661.78147831;
		["uncontrollable"] = false;
		["name"] = "Test1-8";
		["x"] = -396698.42324008;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2620003074;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861661.78147831;
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
					["x"] = -396698.42324008;
				};
			};
			["routeRelativeTOT"] = false;
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
	["Test1-6"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 175;
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
				["unitId"] = 299;
				["skill"] = "Random";
				["y"] = 861657.5313397;
				["coldAtStart"] = false;
				["name"] = "Test1-6-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396581.49779945;
			};
		};
		["y"] = 861657.5313397;
		["uncontrollable"] = false;
		["name"] = "Test1-6";
		["x"] = -396581.49779945;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1502;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861657.5313397;
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
					["x"] = -396581.49779945;
				};
			};
			["routeRelativeTOT"] = false;
		};
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
	["Test1-5"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 174;
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
				["unitId"] = 298;
				["skill"] = "Random";
				["y"] = 861583.79615103;
				["coldAtStart"] = false;
				["name"] = "Test1-5-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396569.28964146;
			};
		};
		["y"] = 861583.79615103;
		["uncontrollable"] = false;
		["name"] = "Test1-5";
		["x"] = -396569.28964146;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2637092935;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861583.79615103;
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
					["x"] = -396569.28964146;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["BLUE-1"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 190;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M 818";
				["unitId"] = 314;
				["skill"] = "Random";
				["y"] = 843838.13370679;
				["coldAtStart"] = false;
				["name"] = "BLUE-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -148710.53102084;
			};
		};
		["y"] = 843838.13370679;
		["uncontrollable"] = false;
		["name"] = "BLUE-1";
		["x"] = -148710.53102084;
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
					["y"] = 843838.13370679;
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
					["x"] = -148710.53102084;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["ZONEMGR_HeliPatrol-4"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "Transport";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 483.0830946842;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995576.30608942;
					["x"] = -214659.41209047;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
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
												["value"] = true;
												["name"] = 32;
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
												["name"] = 7;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 155;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 483.0830946842;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "Russia_VVS_Standard";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["ExhaustScreen"] = true;
					["CargoHalfdoor"] = true;
					["GunnersAISkill"] = 90;
					["AdditionalArmor"] = true;
					["NS430allow"] = true;
				};
				["type"] = "Mi-8MT";
				["unitId"] = 279;
				["psi"] = 0;
				["y"] = 995576.30608942;
				["x"] = -214659.41209047;
				["name"] = "ZONEMGR_HeliPatrol-4-1";
				["payload"] = {
					["pylons"] = {
						[5] = {
							["CLSID"] = "GUV_YakB_GSHP";
						};
						[2] = {
							["CLSID"] = "GUV_YakB_GSHP";
						};
						[7] = {
							["CLSID"] = "KORD_12_7";
						};
						[8] = {
							["CLSID"] = "PKT_7_62";
						};
					};
					["fuel"] = "1929";
					["flare"] = 128;
					["chaff"] = 0;
					["gun"] = 100;
					["restricted"] = {
					};
				};
				["callsign"] = {
					[1] = 10;
					[2] = 1;
					["name"] = "Trash11";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "027";
			};
		};
		["y"] = 995576.30608942;
		["x"] = -214659.41209047;
		["name"] = "ZONEMGR_HeliPatrol-4";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 127.5;
	};
	["ZONEMGR_CAP-13"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "Intercept";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995255.85404943;
					["x"] = -214488.94988196;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 277.5;
					["ETA_locked"] = true;
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
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 148;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "MiG-31";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "174 GvIAP_Boris Safonov";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 3;
					[2] = 2;
					["name"] = "Uzi21";
					[3] = 1;
				};
				["y"] = 995255.85404943;
				["x"] = -214488.94988196;
				["name"] = "ZONEMGR_CAP-13-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}";
						};
						[2] = {
							["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}";
						};
						[3] = {
							["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}";
						};
						[1] = {
							["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}";
						};
						[4] = {
							["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}";
						};
						[5] = {
							["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}";
						};
					};
					["fuel"] = "15500";
					["flare"] = 0;
					["chaff"] = 0;
					["gun"] = 100;
				};
				["speed"] = 277.5;
				["heading"] = 0;
				["onboard_num"] = "020";
				["unitId"] = 272;
			};
		};
		["y"] = 995255.85404943;
		["x"] = -214488.94988196;
		["name"] = "ZONEMGR_CAP-13";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["BLUE-3"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 192;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[1] = {
				["type"] = "M 818";
				["unitId"] = 316;
				["skill"] = "Random";
				["y"] = 834646.7898486;
				["coldAtStart"] = false;
				["name"] = "BLUE-3-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -83575.737307909;
			};
		};
		["y"] = 834646.7898486;
		["uncontrollable"] = false;
		["name"] = "BLUE-3";
		["x"] = -83575.737307909;
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
					["y"] = 834646.7898486;
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
					["x"] = -83575.737307909;
				};
			};
			["routeRelativeTOT"] = false;
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
	["TEMPLATE_AAA"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 126;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 214;
				["skill"] = "High";
				["y"] = 981861.81053343;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-6";
				["playerCanDrive"] = true;
				["heading"] = 0.13962634015955;
				["x"] = -206344.52030143;
			};
			[2] = {
				["type"] = "Gepard";
				["unitId"] = 210;
				["skill"] = "High";
				["y"] = 981865.11118802;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-2";
				["playerCanDrive"] = true;
				["heading"] = 0.069813170079773;
				["x"] = -206313.41746283;
			};
			[3] = {
				["type"] = "ZSU-23-4 Shilka";
				["unitId"] = 211;
				["skill"] = "High";
				["y"] = 981891.64463241;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-3";
				["playerCanDrive"] = true;
				["heading"] = 0.069813170079773;
				["x"] = -206331.42892069;
			};
			[1] = {
				["type"] = "Gepard";
				["unitId"] = 209;
				["skill"] = "High";
				["y"] = 981879.19492958;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-1";
				["playerCanDrive"] = true;
				["heading"] = 0.034906585039887;
				["x"] = -206314.76740798;
			};
			[4] = {
				["type"] = "ZSU-23-4 Shilka";
				["unitId"] = 212;
				["skill"] = "High";
				["y"] = 981849.69877982;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-4";
				["playerCanDrive"] = true;
				["heading"] = 0.1221730476396;
				["x"] = -206330.18212252;
			};
			[5] = {
				["type"] = "M 818";
				["unitId"] = 213;
				["skill"] = "High";
				["y"] = 981875.8815413;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_AAA-5";
				["playerCanDrive"] = true;
				["heading"] = 0.05235987755983;
				["x"] = -206345.58898557;
			};
		};
		["y"] = 981879.19492958;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_AAA";
		["x"] = -206314.76740798;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 771;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981879.19492958;
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
					["x"] = -206314.76740798;
				};
			};
			["routeRelativeTOT"] = true;
		};
	};
	["Test1-11"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 180;
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
				["unitId"] = 304;
				["skill"] = "Random";
				["y"] = 861474.23781675;
				["coldAtStart"] = false;
				["name"] = "Test1-11-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396634.33003587;
			};
		};
		["y"] = 861474.23781675;
		["uncontrollable"] = false;
		["name"] = "Test1-11";
		["x"] = -396634.33003587;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2660286317;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861474.23781675;
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
					["x"] = -396634.33003587;
				};
			};
			["routeRelativeTOT"] = false;
		};
	};
	["ZONEMGR_CAP-3"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "Intercept";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995233.75223824;
					["x"] = -214050.59729327;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
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
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 143;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "vf-102 diamondbacks";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
				};
				["type"] = "F-14B";
				["unitId"] = 267;
				["psi"] = 0;
				["y"] = 995233.75223824;
				["x"] = -214050.59729327;
				["name"] = "ZONEMGR_CAP-3-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{AIM_54C_Mk60}";
						};
						[1] = {
							["CLSID"] = "{LAU-138 wtip - AIM-9M}";
						};
						[2] = {
							["CLSID"] = "{SHOULDER AIM-7P}";
						};
						[4] = {
							["CLSID"] = "{AIM_54C_Mk60}";
						};
						[8] = {
							["CLSID"] = "{F14-300gal}";
						};
						[9] = {
							["CLSID"] = "{SHOULDER AIM-7P}";
						};
						[5] = {
							["CLSID"] = "{AIM_54C_Mk60}";
						};
						[10] = {
							["CLSID"] = "{LAU-138 wtip - AIM-9M}";
						};
						[3] = {
							["CLSID"] = "{F14-300gal}";
						};
						[6] = {
							["CLSID"] = "{AIM_54C_Mk60}";
						};
					};
					["fuel"] = 7348;
					["flare"] = 60;
					["ammo_type"] = 1;
					["chaff"] = 140;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 6;
					[2] = 1;
					["name"] = "Ford11";
					[3] = 1;
				};
				["heading"] = 0;
				["onboard_num"] = "015";
			};
		};
		["y"] = 995233.75223824;
		["x"] = -214050.59729327;
		["name"] = "ZONEMGR_CAP-3";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["Aerial-1"] = {
		["dynSpawnTemplate"] = false;
		["modulation"] = 0;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 2;
			["typeKey"] = "plane";
			["countryName"] = "USA";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2687;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 829498.97197433;
					["x"] = -355358.93442359;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["number"] = 6;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 4;
												["name"] = 18;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["enabled"] = true;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
								[5] = {
									["number"] = 5;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
				[2] = {
					["alt"] = 2122.0176;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 810284.76453488;
					["x"] = -344156.84991501;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 77.083333333333;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 282.58509979177;
				};
				[4] = {
					["alt"] = 2748;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 795185.78418877;
					["x"] = -337739.78326791;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 227.91900059012;
				};
				[3] = {
					["alt"] = 2748;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 788013.76852437;
					["x"] = -338117.25777656;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = false;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
							};
						};
					};
					["ETA"] = 195.4174388001;
				};
			};
		};
		["groupId"] = 162;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2687;
				["alt_type"] = "BARO";
				["livery_id"] = "default";
				["skill"] = "Client";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
					["HelmetMountedDevice"] = 1;
					["VoiceCallsignLabel"] = "ED";
					["STN_L16"] = "00636";
					["LAU3ROF"] = 0;
					["VoiceCallsignNumber"] = "11";
				};
				["type"] = "F-16C_50";
				["Radio"] = {
					[1] = {
						["channelsNames"] = {
						};
						["modulations"] = {
							[1] = 0;
							[2] = 0;
							[4] = 0;
							[8] = 0;
							[16] = 0;
							[17] = 0;
							[9] = 0;
							[18] = 0;
							[5] = 0;
							[10] = 0;
							[20] = 0;
							[11] = 0;
							[3] = 0;
							[6] = 0;
							[12] = 0;
							[13] = 0;
							[7] = 0;
							[14] = 0;
							[15] = 0;
							[19] = 0;
						};
						["channels"] = {
							[1] = 305;
							[2] = 264;
							[4] = 256;
							[8] = 257;
							[16] = 261;
							[17] = 267;
							[9] = 255;
							[18] = 251;
							[5] = 254;
							[10] = 262;
							[20] = 266;
							[11] = 259;
							[3] = 265;
							[6] = 250;
							[12] = 268;
							[13] = 269;
							[7] = 270;
							[14] = 260;
							[15] = 263;
							[19] = 253;
						};
					};
					[2] = {
						["channelsNames"] = {
						};
						["modulations"] = {
							[1] = 0;
							[2] = 0;
							[4] = 0;
							[8] = 0;
							[16] = 0;
							[17] = 0;
							[9] = 0;
							[18] = 0;
							[5] = 0;
							[10] = 0;
							[20] = 0;
							[11] = 0;
							[3] = 0;
							[6] = 0;
							[12] = 0;
							[13] = 0;
							[7] = 0;
							[14] = 0;
							[15] = 0;
							[19] = 0;
						};
						["channels"] = {
							[1] = 124;
							[2] = 135;
							[4] = 127;
							[8] = 128;
							[16] = 132;
							[17] = 138;
							[9] = 126;
							[18] = 122;
							[5] = 125;
							[10] = 133;
							[20] = 137;
							[11] = 130;
							[3] = 136;
							[6] = 121;
							[12] = 139;
							[13] = 140;
							[7] = 141;
							[14] = 131;
							[15] = 134;
							[19] = 124;
						};
					};
				};
				["unitId"] = 286;
				["psi"] = 1.0429627895852;
				["y"] = 829498.97197433;
				["x"] = -355358.93442359;
				["name"] = "Aerial-1-1";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = 3249;
					["flare"] = 60;
					["ammo_type"] = 5;
					["chaff"] = 60;
					["gun"] = 100;
				};
				["onboard_num"] = "010";
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Enfield11";
					[3] = 1;
				};
				["heading"] = -1.0429627895852;
				["datalinks"] = {
					["Link16"] = {
						["settings"] = {
							["flightLead"] = true;
							["transmitPower"] = 3;
							["specialChannel"] = 1;
							["fighterChannel"] = 1;
							["missionChannel"] = 1;
						};
						["network"] = {
							["teamMembers"] = {
								[1] = {
									["TDOA"] = true;
									["missionUnitId"] = 286;
								};
							};
							["donors"] = {
							};
						};
					};
				};
			};
		};
		["y"] = 829498.97197433;
		["x"] = -355358.93442359;
		["name"] = "Aerial-1";
		["communication"] = true;
		["start_time"] = 0;
		["uncontrollable"] = false;
		["frequency"] = 305;
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
	["Test1-10"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = false;
		["groupId"] = 179;
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
				["unitId"] = 303;
				["skill"] = "Random";
				["y"] = 861476.76365731;
				["coldAtStart"] = false;
				["name"] = "Test1-10-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -396718.94569462;
			};
		};
		["y"] = 861476.76365731;
		["uncontrollable"] = false;
		["name"] = "Test1-10";
		["x"] = -396718.94569462;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 1532.2659065613;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 861476.76365731;
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
					["x"] = -396718.94569462;
				};
			};
			["routeRelativeTOT"] = false;
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
	["ZONEMGR_CAP-12"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995051.68019427;
					["x"] = -214471.7827713;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 140;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "MiG-29S";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "air force standard";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 3;
					[2] = 1;
					["name"] = "Uzi11";
					[3] = 1;
				};
				["y"] = 995051.68019427;
				["x"] = -214471.7827713;
				["name"] = "ZONEMGR_CAP-12-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}";
						};
						[2] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[3] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[1] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[4] = {
							["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}";
						};
						[5] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[7] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
					};
					["fuel"] = "3493";
					["flare"] = 30;
					["chaff"] = 30;
					["gun"] = 100;
				};
				["speed"] = 220.97222222222;
				["heading"] = 0;
				["onboard_num"] = "012";
				["unitId"] = 264;
			};
		};
		["y"] = 995051.68019427;
		["x"] = -214471.7827713;
		["name"] = "ZONEMGR_CAP-12";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
	["TEMPLATE_Supply"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 127;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 220;
				["skill"] = "High";
				["y"] = 982475.74735532;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-6";
				["playerCanDrive"] = true;
				["heading"] = 6.2308254296198;
				["x"] = -206347.07708679;
			};
			[2] = {
				["type"] = "M1043 HMMWV Armament";
				["unitId"] = 216;
				["skill"] = "High";
				["y"] = 982479.6827018;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-2";
				["playerCanDrive"] = true;
				["heading"] = 0.61086523819802;
				["x"] = -206320.69772619;
			};
			[3] = {
				["type"] = "M 818";
				["unitId"] = 217;
				["skill"] = "High";
				["y"] = 982455.27833332;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-3";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206343.34450042;
			};
			[1] = {
				["type"] = "M-2 Bradley";
				["unitId"] = 215;
				["skill"] = "High";
				["y"] = 982458.40888963;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-1";
				["playerCanDrive"] = true;
				["heading"] = 6.1959188445799;
				["x"] = -206318.540862;
			};
			[4] = {
				["type"] = "M 818";
				["unitId"] = 218;
				["skill"] = "High";
				["y"] = 982463.70675415;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-4";
				["playerCanDrive"] = true;
				["heading"] = 0.017453292519943;
				["x"] = -206346.83627476;
			};
			[5] = {
				["type"] = "M 818";
				["unitId"] = 219;
				["skill"] = "High";
				["y"] = 982485.13902424;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Supply-5";
				["playerCanDrive"] = true;
				["heading"] = 6.2133721370998;
				["x"] = -206342.86287638;
			};
		};
		["y"] = 982458.40888963;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_Supply";
		["x"] = -206318.540862;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 769;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 982458.40888963;
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
												["groupId"] = 23;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206318.540862;
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
	["CUSTOM_AWAKS"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "AWACS";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 9144;
					["type"] = "Turning Point";
					["action"] = "Fly Over Point";
					["alt_type"] = "BARO";
					["y"] = 981545.57976112;
					["x"] = -206982.27875528;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 220.97222222222;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[6] = {
									["number"] = 6;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = false;
												["name"] = 6;
											};
										};
									};
								};
								[2] = {
									["number"] = 2;
									["auto"] = true;
									["id"] = "WrappedAction";
									["enabled"] = true;
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
								[3] = {
									["number"] = 3;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = true;
									["id"] = "AWACS";
									["enabled"] = true;
									["params"] = {
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = false;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "SetInvisible";
											["params"] = {
												["value"] = false;
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
											["id"] = "SetImmortal";
											["params"] = {
												["value"] = false;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 168;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 9144;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "nato";
				["skill"] = "Excellent";
				["speed"] = 220.97222222222;
				["AddPropAircraft"] = {
					["STN_L16"] = "00644";
					["VoiceCallsignNumber"] = "11";
					["VoiceCallsignLabel"] = "OD";
				};
				["type"] = "E-3A";
				["unitId"] = 292;
				["psi"] = -0.077966633831506;
				["y"] = 981545.57976112;
				["x"] = -206982.27875528;
				["name"] = "CUSTOM_AWAKS";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = "65000";
					["flare"] = 60;
					["chaff"] = 120;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 1;
					[2] = 1;
					["name"] = "Overlord11";
					[3] = 1;
				};
				["heading"] = -0.032651707933472;
				["onboard_num"] = "019";
			};
		};
		["y"] = 981545.57976112;
		["x"] = -206982.27875528;
		["name"] = "CUSTOM_AWAKS";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["AIRDROP_TRANSPORT"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Blue";
		};
		["radioSet"] = false;
		["task"] = "Transport";
		["uncontrolled"] = false;
		["taskSelected"] = true;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 7315;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 981579.8756315;
					["x"] = -206666.25846626;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 169.44444444444;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[2] = {
									["number"] = 2;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = false;
												["name"] = 6;
											};
										};
									};
								};
								[3] = {
									["number"] = 3;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 7;
											};
										};
									};
								};
								[1] = {
									["number"] = 1;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = 0;
												["name"] = 1;
											};
										};
									};
								};
								[4] = {
									["number"] = 4;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[5] = {
									["number"] = 5;
									["auto"] = false;
									["id"] = "WrappedAction";
									["enabled"] = true;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 26;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 131;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 7315;
				["type"] = "C-130";
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "Air Algerie L-382 White";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 2;
					[2] = 1;
					["name"] = "Springfield11";
					[3] = 1;
				};
				["y"] = 981579.8756315;
				["x"] = -206666.25846626;
				["name"] = "AIRDROP_TRANSPORT-1";
				["payload"] = {
					["pylons"] = {
					};
					["fuel"] = 10415;
					["flare"] = 60;
					["chaff"] = 120;
					["gun"] = 100;
				};
				["speed"] = 169.44444444444;
				["heading"] = 0;
				["onboard_num"] = "012";
				["unitId"] = 239;
			};
		};
		["y"] = 981579.8756315;
		["x"] = -206666.25846626;
		["name"] = "AIRDROP_TRANSPORT";
		["communication"] = false;
		["uncontrollable"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 251;
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
	["ZONEMGR_CAP-14"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "plane";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAP";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 2000;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995415.19271001;
					["x"] = -214472.52057035;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 169.58333333333;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAP";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Air";
										};
										["priority"] = 0;
									};
								};
								[2] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 2;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 17;
											};
										};
									};
								};
								[4] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 4;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["targetTypes"] = {
												};
												["noTargetTypes"] = {
													[1] = "Fighters";
													[2] = "Multirole fighters";
													[4] = "Helicopters";
													[8] = "Tanks";
													[16] = "LR SAM";
													[17] = "Aircraft Carriers";
													[9] = "IFV";
													[18] = "Cruisers";
													[5] = "UAVs";
													[10] = "APC";
													[20] = "Frigates";
													[21] = "Corvettes";
													[11] = "Artillery";
													[22] = "Light armed ships";
													[3] = "Bombers";
													[6] = "Infantry";
													[12] = "Unarmed vehicles";
													[24] = "Submarines";
													[19] = "Destroyers";
													[25] = "Cruise missiles";
													[13] = "AAA";
													[26] = "Antiship Missiles";
													[27] = "AA Missiles";
													[7] = "Fortifications";
													[14] = "SR SAM";
													[28] = "AG Missiles";
													[23] = "Unarmed ships";
													[29] = "SA Missiles";
													[15] = "MR SAM";
												};
												["name"] = 21;
												["value"] = "none;";
											};
										};
									};
								};
								[3] = {
									["enabled"] = true;
									["auto"] = true;
									["id"] = "WrappedAction";
									["number"] = 3;
									["params"] = {
										["action"] = {
											["id"] = "Option";
											["params"] = {
												["value"] = true;
												["name"] = 19;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 141;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 2000;
				["type"] = "Su-27";
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["psi"] = 0;
				["livery_id"] = "Air Force Standard Early";
				["skill"] = "Excellent";
				["callsign"] = {
					[1] = 4;
					[2] = 1;
					["name"] = "Colt11";
					[3] = 1;
				};
				["y"] = 995415.19271001;
				["x"] = -214472.52057035;
				["name"] = "ZONEMGR_CAP-14-1";
				["payload"] = {
					["pylons"] = {
						[7] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[1] = {
							["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}";
						};
						[2] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[4] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[8] = {
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}";
						};
						[9] = {
							["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}";
						};
						[5] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
						[10] = {
							["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}";
						};
						[3] = {
							["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}";
						};
						[6] = {
							["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}";
						};
					};
					["fuel"] = 5590.18;
					["flare"] = 96;
					["chaff"] = 96;
					["gun"] = 100;
				};
				["speed"] = 169.58333333333;
				["heading"] = 0;
				["onboard_num"] = "013";
				["unitId"] = 265;
			};
		};
		["y"] = 995415.19271001;
		["x"] = -214472.52057035;
		["name"] = "ZONEMGR_CAP-14";
		["communication"] = true;
		["uncontrollable"] = false;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 127.5;
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
	["TEMPLATE_Artillery_Company"] = {
		["visible"] = false;
		["taskSelected"] = true;
		["lateActivation"] = true;
		["groupId"] = 135;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 2;
			["countryID"] = 80;
			["typeKey"] = "vehicle";
			["countryName"] = "CJTF Blue";
		};
		["hidden"] = false;
		["units"] = {
			[6] = {
				["type"] = "M 818";
				["unitId"] = 257;
				["skill"] = "High";
				["y"] = 981762.78601589;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-6";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206353.9601709;
			};
			[2] = {
				["type"] = "MLRS";
				["unitId"] = 253;
				["skill"] = "High";
				["y"] = 981783.3713253;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-2";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206318.48041602;
			};
			[3] = {
				["type"] = "MLRS FDDM";
				["unitId"] = 254;
				["skill"] = "High";
				["y"] = 981773.2476521;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-3";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206333.03689847;
			};
			[1] = {
				["type"] = "MLRS";
				["unitId"] = 252;
				["skill"] = "High";
				["y"] = 981762.39854788;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-1";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206317.79649015;
			};
			[4] = {
				["type"] = "M-109";
				["unitId"] = 255;
				["skill"] = "High";
				["y"] = 981792.79084081;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-4";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206333.05622592;
			};
			[5] = {
				["type"] = "M-109";
				["unitId"] = 256;
				["skill"] = "High";
				["y"] = 981753.22847169;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-5";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206332.52027446;
			};
			[7] = {
				["type"] = "M 818";
				["unitId"] = 258;
				["skill"] = "High";
				["y"] = 981781.77194828;
				["coldAtStart"] = false;
				["name"] = "TEMPLATE_Artillery_Company-7";
				["playerCanDrive"] = true;
				["heading"] = 0;
				["x"] = -206354.60595091;
			};
		};
		["y"] = 981762.39854788;
		["uncontrollable"] = false;
		["name"] = "TEMPLATE_Artillery_Company";
		["x"] = -206317.79649015;
		["start_time"] = 0;
		["task"] = "Ground Nothing";
		["route"] = {
			["spans"] = {
			};
			["points"] = {
				[1] = {
					["alt"] = 771;
					["type"] = "Turning Point";
					["ETA"] = 0;
					["alt_type"] = "BARO";
					["y"] = 981762.39854788;
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
												["groupId"] = 26;
											};
										};
									};
								};
							};
						};
					};
					["x"] = -206317.79649015;
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
	["ZONEMGR_HeliPatrol-2"] = {
		["dynSpawnTemplate"] = false;
		["lateActivation"] = true;
		["tasks"] = {
		};
		["AETHR"] = {
			["coalition"] = 1;
			["countryID"] = 81;
			["typeKey"] = "helicopter";
			["countryName"] = "CJTF Red";
		};
		["radioSet"] = false;
		["task"] = "CAS";
		["uncontrolled"] = false;
		["route"] = {
			["points"] = {
				[1] = {
					["alt"] = 482.88445556955;
					["type"] = "Turning Point";
					["action"] = "Turning Point";
					["alt_type"] = "BARO";
					["y"] = 995454.93401027;
					["x"] = -214659.41209047;
					["formation_template"] = "";
					["speed_locked"] = true;
					["speed"] = 46.25;
					["ETA_locked"] = true;
					["task"] = {
						["id"] = "ComboTask";
						["params"] = {
							["tasks"] = {
								[1] = {
									["enabled"] = true;
									["key"] = "CAS";
									["id"] = "EngageTargets";
									["number"] = 1;
									["auto"] = true;
									["params"] = {
										["targetTypes"] = {
											[1] = "Helicopters";
											[2] = "Ground Units";
											[3] = "Light armed ships";
										};
										["priority"] = 0;
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
												["name"] = 32;
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
												["name"] = 7;
											};
										};
									};
								};
							};
						};
					};
					["ETA"] = 0;
				};
			};
			["routeRelativeTOT"] = true;
		};
		["groupId"] = 160;
		["hidden"] = false;
		["units"] = {
			[1] = {
				["alt"] = 482.88445556955;
				["hardpoint_racks"] = true;
				["alt_type"] = "BARO";
				["livery_id"] = "default";
				["skill"] = "Excellent";
				["ropeLength"] = 15;
				["speed"] = 46.25;
				["AddPropAircraft"] = {
					["modification"] = "Ka-50_3";
					["ExhaustScreen"] = true;
				};
				["type"] = "Ka-50_3";
				["unitId"] = 284;
				["psi"] = 0;
				["y"] = 995454.93401027;
				["x"] = -214659.41209047;
				["name"] = "ZONEMGR_HeliPatrol-2-1";
				["payload"] = {
					["pylons"] = {
						[6] = {
							["CLSID"] = "{9S846_2xIGLA}";
						};
						[2] = {
							["CLSID"] = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}";
						};
						[3] = {
							["CLSID"] = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}";
						};
						[1] = {
							["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}";
						};
						[4] = {
							["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}";
						};
						[5] = {
							["CLSID"] = "{9S846_2xIGLA}";
						};
					};
					["fuel"] = 1450;
					["flare"] = 128;
					["chaff"] = 0;
					["gun"] = 100;
				};
				["callsign"] = {
					[1] = 3;
					[2] = 3;
					["name"] = "Uzi31";
					[3] = 1;
				};
				["heading"] = 0.92615334010797;
				["onboard_num"] = "032";
			};
		};
		["y"] = 995454.93401027;
		["x"] = -214659.41209047;
		["name"] = "ZONEMGR_HeliPatrol-2";
		["communication"] = true;
		["start_time"] = 0;
		["modulation"] = 0;
		["frequency"] = 124;
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
}
return obj1
