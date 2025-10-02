-- Persistent Data
local multiRefObjects = {
{};{};{};
} -- multiRefObjects
multiRefObjects[2]["life"] = 40;
multiRefObjects[2]["attributes"] = {
	["Buildings"] = true;
};
multiRefObjects[2]["_origin"] = "";
multiRefObjects[2]["category"] = 4;
multiRefObjects[2]["typeName"] = "PAR_APPARATNAYA_20";
multiRefObjects[2]["displayName"] = "";
multiRefObjects[1]["life"] = 90;
multiRefObjects[1]["attributes"] = {
	["Buildings"] = true;
};
multiRefObjects[1]["_origin"] = "";
multiRefObjects[1]["category"] = 4;
multiRefObjects[1]["typeName"] = "PAR_GSM";
multiRefObjects[1]["displayName"] = "";
multiRefObjects[3]["life"] = 20;
multiRefObjects[3]["attributes"] = {
	["Buildings"] = true;
};
multiRefObjects[3]["_origin"] = "";
multiRefObjects[3]["category"] = 4;
multiRefObjects[3]["typeName"] = "PAR_AGREGATNAYA";
multiRefObjects[3]["displayName"] = "";
local obj1 = {
	[712310784] = {
		["id"] = 712310784;
		["position"] = {
			["y"] = 60.598526000977;
			["x"] = 101877.2890625;
			["z"] = 450556.5;
		};
		["desc"] = multiRefObjects[3];
	};
	[384794624] = {
		["id"] = 384794624;
		["position"] = {
			["y"] = 65.05696105957;
			["x"] = 95501.28125;
			["z"] = 462884.59375;
		};
		["desc"] = multiRefObjects[2];
	};
	[235831297] = {
		["id"] = 235831297;
		["position"] = {
			["y"] = 65.609786987305;
			["x"] = 95521.484375;
			["z"] = 462871.09375;
		};
		["desc"] = multiRefObjects[1];
	};
	[384827392] = {
		["id"] = 384827392;
		["position"] = {
			["y"] = 60.508731842041;
			["x"] = 101857.0859375;
			["z"] = 450564;
		};
		["desc"] = multiRefObjects[2];
	};
	[712245248] = {
		["id"] = 712245248;
		["position"] = {
			["y"] = 65.581207275391;
			["x"] = 95521.484375;
			["z"] = 462877.09375;
		};
		["desc"] = multiRefObjects[3];
	};
	[235864065] = {
		["id"] = 235864065;
		["position"] = {
			["y"] = 60.562564849854;
			["x"] = 101877.2890625;
			["z"] = 450550.5;
		};
		["desc"] = multiRefObjects[1];
	};
}
return obj1
