-- Persistent Data
local multiRefObjects = {
{};{};
} -- multiRefObjects
multiRefObjects[1]["massEmpty"] = 8000;
multiRefObjects[1]["riverCrossing"] = false;
multiRefObjects[1]["maxSlopeAngle"] = 0.46999999880791;
multiRefObjects[1]["Kmax"] = 0.050000000745058;
multiRefObjects[1]["RCS"] = 5;
multiRefObjects[1]["box"] = {
	["min"] = {
		["y"] = -0.094844691455364;
		["x"] = -4.5354399681091;
		["z"] = -1.8130934238434;
	};
	["max"] = {
		["y"] = 3.5838124752045;
		["x"] = 4.4813804626465;
		["z"] = 1.8655642271042;
	};
};
multiRefObjects[1]["speedMax"] = 20.833299636841;
multiRefObjects[1]["life"] = 2;
multiRefObjects[1]["attributes"] = {
	["Ground Units Non Airdefence"] = true;
	["Vehicles"] = true;
	["NonArmoredUnits"] = true;
	["Trucks"] = true;
	["Ground vehicles"] = true;
	["NonAndLightArmoredUnits"] = true;
	["Unarmed vehicles"] = true;
	["All"] = true;
	["Datalink"] = true;
	["Ground Units"] = true;
};
multiRefObjects[1]["category"] = 2;
multiRefObjects[1]["speedMaxOffRoad"] = 20.833299636841;
multiRefObjects[1]["_origin"] = "";
multiRefObjects[1]["typeName"] = "M 818";
multiRefObjects[1]["displayName"] = "Truck M939 Heavy";
multiRefObjects[2]["massEmpty"] = 8700;
multiRefObjects[2]["riverCrossing"] = false;
multiRefObjects[2]["maxSlopeAngle"] = 0.61000001430511;
multiRefObjects[2]["Kmax"] = 0.050000000745058;
multiRefObjects[2]["RCS"] = 5;
multiRefObjects[2]["box"] = {
	["min"] = {
		["y"] = 0.0047516031190753;
		["x"] = -2.9863131046295;
		["z"] = -1.3823875188828;
	};
	["max"] = {
		["y"] = 1.7728828191757;
		["x"] = 2.957328081131;
		["z"] = 1.3121749162674;
	};
};
multiRefObjects[2]["speedMax"] = 16.666700363159;
multiRefObjects[2]["life"] = 4;
multiRefObjects[2]["attributes"] = {
	["Ground Units Non Airdefence"] = true;
	["Vehicles"] = true;
	["Armored vehicles"] = true;
	["AntiAir Armed Vehicles"] = true;
	["LightArmoredUnits"] = true;
	["NonAndLightArmoredUnits"] = true;
	["Ground vehicles"] = true;
	["Armed vehicles"] = true;
	["ATGM"] = true;
	["Infantry carriers"] = true;
	["Armed ground units"] = true;
	["All"] = true;
	["Ground Units"] = true;
	["APC"] = true;
};
multiRefObjects[2]["category"] = 2;
multiRefObjects[2]["speedMaxOffRoad"] = 16.666700363159;
multiRefObjects[2]["_origin"] = "";
multiRefObjects[2]["typeName"] = "BTR_D";
multiRefObjects[2]["displayName"] = "APC BTR-RD";
local obj1 = {
	["Ground-1-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16858625;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 634;
		};
		["groupUnitNames"] = {
			[1] = "Ground-1-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "317";
		["groupName"] = "Ground-1";
		["desc"] = multiRefObjects[2];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 16.814652330511;
			["x"] = -221038.49999139;
			["z"] = 566747.50003031;
		};
		["name"] = "Ground-1-1";
		["sensors"] = {
			[0] = {
				[1] = {
					["type"] = 0;
					["typeName"] = "TKN-3B day";
					["opticType"] = 0;
				};
				[2] = {
					["type"] = 0;
					["typeName"] = "TKN-3B night";
					["opticType"] = 2;
				};
			};
		};
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
	["RED-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16833281;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 656;
		};
		["groupUnitNames"] = {
			[1] = "RED-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "309";
		["groupName"] = "RED-1";
		["desc"] = multiRefObjects[1];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 13.240942550707;
			["x"] = -281607.25;
			["z"] = 647086.9375;
		};
		["name"] = "RED-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 7;
	};
	["RED-5-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16834305;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 680;
		};
		["groupUnitNames"] = {
			[1] = "RED-5-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "313";
		["groupName"] = "RED-5";
		["desc"] = multiRefObjects[1];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 45.011047912645;
			["x"] = -284986.9375;
			["z"] = 684288.375;
		};
		["name"] = "RED-5-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 7;
	};
	["RED-4-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16834049;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 563;
		};
		["groupUnitNames"] = {
			[1] = "RED-4-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "312";
		["groupName"] = "RED-4";
		["desc"] = multiRefObjects[1];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 30.011033634064;
			["x"] = -164638.34375;
			["z"] = 462210.90625;
		};
		["name"] = "RED-4-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 7;
	};
	["RED-2-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16833537;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 654;
		};
		["groupUnitNames"] = {
			[1] = "RED-2-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "310";
		["groupName"] = "RED-2";
		["desc"] = multiRefObjects[1];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 10.045037818956;
			["x"] = -355893.5625;
			["z"] = 617352.625;
		};
		["name"] = "RED-2-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 7;
	};
	["BLUE-3-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16858369;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 781;
		};
		["groupUnitNames"] = {
			[1] = "BLUE-3-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "316";
		["groupName"] = "BLUE-3";
		["desc"] = multiRefObjects[1];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 154.6667025088;
			["x"] = -83575.734374111;
			["z"] = 834646.81249986;
		};
		["name"] = "BLUE-3-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
	["RED-3-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16833793;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 655;
		};
		["groupUnitNames"] = {
			[1] = "RED-3-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "311";
		["groupName"] = "RED-3";
		["desc"] = multiRefObjects[1];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 18.011017395067;
			["x"] = -317782.21875;
			["z"] = 635758.75;
		};
		["name"] = "RED-3-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 7;
	};
	["BLUE-2-2"] = {
		["isAlive"] = true;
		["ObjectID"] = 16857857;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 732;
		};
		["groupUnitNames"] = {
			[1] = "BLUE-2-1";
			[2] = "BLUE-2-2";
			[3] = "BLUE-2-3";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "319";
		["groupName"] = "BLUE-2";
		["desc"] = multiRefObjects[1];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 430.01143701177;
			["x"] = -125081.5625;
			["z"] = 760541.25;
		};
		["name"] = "BLUE-2-2";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
	["BLUE-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16857345;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 779;
		};
		["groupUnitNames"] = {
			[1] = "BLUE-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "314";
		["groupName"] = "BLUE-1";
		["desc"] = multiRefObjects[1];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 524.82656152348;
			["x"] = -148710.53125;
			["z"] = 843838.125;
		};
		["name"] = "BLUE-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
	["Ground-2-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16840961;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 634;
		};
		["groupUnitNames"] = {
			[1] = "Ground-2-1";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "318";
		["groupName"] = "Ground-2";
		["desc"] = multiRefObjects[2];
		["coalition"] = 1;
		["postition"] = {
			["y"] = 16.166197453232;
			["x"] = -221516.25000827;
			["z"] = 566626.49999328;
		};
		["name"] = "Ground-2-1";
		["sensors"] = {
			[0] = {
				[1] = {
					["type"] = 0;
					["typeName"] = "TKN-3B day";
					["opticType"] = 0;
				};
				[2] = {
					["type"] = 0;
					["typeName"] = "TKN-3B night";
					["opticType"] = 2;
				};
			};
		};
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 81;
	};
	["BLUE-2-1"] = {
		["isAlive"] = true;
		["ObjectID"] = 16857601;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 732;
		};
		["groupUnitNames"] = {
			[1] = "BLUE-2-1";
			[2] = "BLUE-2-2";
			[3] = "BLUE-2-3";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "315";
		["groupName"] = "BLUE-2";
		["desc"] = multiRefObjects[1];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 430.01142132844;
			["x"] = -125041.56249999;
			["z"] = 760541.25;
		};
		["name"] = "BLUE-2-1";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
	["BLUE-2-3"] = {
		["isAlive"] = true;
		["ObjectID"] = 16858113;
		["AETHR"] = {
			["groundUnitID"] = 0;
			["spawned"] = true;
			["divisionID"] = 732;
		};
		["groupUnitNames"] = {
			[1] = "BLUE-2-1";
			[2] = "BLUE-2-2";
			[3] = "BLUE-2-3";
		};
		["category"] = 1;
		["categoryEx"] = 2;
		["callsign"] = "";
		["id"] = "320";
		["groupName"] = "BLUE-2";
		["desc"] = multiRefObjects[1];
		["coalition"] = 2;
		["postition"] = {
			["y"] = 430.01145184602;
			["x"] = -125121.56249999;
			["z"] = 760541.25;
		};
		["name"] = "BLUE-2-3";
		["isEffective"] = true;
		["isActive"] = true;
		["country"] = 80;
	};
}
return obj1
