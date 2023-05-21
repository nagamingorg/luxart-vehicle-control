--[[
---------------------------------------------------
LUXART VEHICLE CONTROL V3 (FOR FIVEM)
---------------------------------------------------
Coded by Lt.Caine
ELS Clicks by Faction
Additions by TrevorBarns
---------------------------------------------------
FILE: SIRENS.lua
PURPOSE: Associate specific sirens with specific
vehicles. Siren assignments. 
---------------------------------------------------
SIREN TONE TABLE: 
	ID- Generic Name	(SIREN STRING)									[vehicles.awc name]
	1 - Airhorn 		(SIRENS_AIRHORN)								[AIRHORN_EQD]
	2 - Wail 			(VEHICLES_HORNS_SIREN_1)						[SIREN_PA20A_WAIL]
	3 - Yelp 			(VEHICLES_HORNS_SIREN_2)						[SIREN_2]
	4 - Priority 		(VEHICLES_HORNS_POLICE_WARNING)					[POLICE_WARNING]
	5 - CustomA* 		(RESIDENT_VEHICLES_SIREN_WAIL_01)				[SIREN_WAIL_01]
	6 - CustomB* 		(RESIDENT_VEHICLES_SIREN_WAIL_02)				[SIREN_WAIL_02]
	7 - CustomC* 		(RESIDENT_VEHICLES_SIREN_WAIL_03)				[SIREN_WAIL_03]
	8 - CustomD* 		(RESIDENT_VEHICLES_SIREN_QUICK_01)				[SIREN_QUICK_01]
	9 - CustomE* 		(RESIDENT_VEHICLES_SIREN_QUICK_02)				[SIREN_QUICK_02]
	10 - CustomF* 		(RESIDENT_VEHICLES_SIREN_QUICK_03)				[SIREN_QUICK_03]
	11 - Powercall 		(VEHICLES_HORNS_AMBULANCE_WARNING)				[AMBULANCE_WARNING]
	12 - FireHorn	 	(VEHICLES_HORNS_FIRETRUCK_WARNING)				[FIRE_TRUCK_HORN]
	13 - Firesiren 		(RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01)		[SIREN_FIRETRUCK_WAIL_01]
	14 - Firesiren2 	(RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01)	[SIREN_FIRETRUCK_QUICK_01]
]]
-- CHANGE SIREN NAMES, AUDIONAME, AUDIOREF
--[[SIRENS = {	
	{ Name = 'Airhorn', 		String = 'SIRENS_AIRHORN', 								Ref = 0 }, --1
	{ Name = 'Wail', 			String = 'VEHICLES_HORNS_SIREN_1', 						Ref = 0 }, --2
	{ Name = 'Yelp', 			String = 'VEHICLES_HORNS_SIREN_2', 						Ref = 0 }, --3
	{ Name = 'Priority', 		String = 'VEHICLES_HORNS_POLICE_WARNING', 				Ref = 0 }, --4
	{ Name = 'CustomA', 		String = 'RESIDENT_VEHICLES_SIREN_WAIL_01', 			Ref = 0 }, --5
	{ Name = 'CustomB', 		String = 'RESIDENT_VEHICLES_SIREN_WAIL_02', 			Ref = 0 }, --6
	{ Name = 'CustomC', 		String = 'RESIDENT_VEHICLES_SIREN_WAIL_03', 			Ref = 0 }, --7
	{ Name = 'CustomD', 		String = 'RESIDENT_VEHICLES_SIREN_QUICK_01', 			Ref = 0 }, --8
	{ Name = 'CustomE',		String = 'RESIDENT_VEHICLES_SIREN_QUICK_02',			Ref = 0 }, --9
	{ Name = 'CustomF',		String = 'RESIDENT_VEHICLES_SIREN_QUICK_03', 			Ref = 0 }, --10
	{ Name = 'Powercall', 	String = 'VEHICLES_HORNS_AMBULANCE_WARNING', 			Ref = 0 }, --11
	{ Name = 'Fire Horn', 	String = 'VEHICLES_HORNS_FIRETRUCK_WARNING', 			Ref = 0 }, --12
	{ Name = 'Fire Yelp', 	String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01', 	Ref = 0 }, --13
	{ Name = 'Fire Wail', 	String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01', 	Ref = 0 }, --14
}]]--

RequestScriptAudioBank('DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCSO_NEW', false)
RequestScriptAudioBank('DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCSO_OLD', false)
RequestScriptAudioBank('DLC_SERVERSIDEAUDIO\\OISS_SSA_VEHAUD_BCFD_NEW', false)

SIRENS = {	
--[[1]]   { Name = 'Airhorn',       String = 'SIRENS_AIRHORN',                              Ref = 0 },
--[[2]]   { Name = 'Wail',          String = 'VEHICLES_HORNS_SIREN_1',                      Ref = 0 },
--[[3]]   { Name = 'Yelp',          String = 'VEHICLES_HORNS_SIREN_2',                      Ref = 0 },
--[[4]]   { Name = 'Priority',      String = 'VEHICLES_HORNS_POLICE_WARNING',               Ref = 0 },
--[[5]]   { Name = 'CustomA',  	    String = 'RESIDENT_VEHICLES_SIREN_WAIL_01',             Ref = 0 },
--[[6]]   { Name = 'CustomB',       String = 'RESIDENT_VEHICLES_SIREN_WAIL_02',             Ref = 0 },
--[[7]]   { Name = 'CustomA',       String = 'RESIDENT_VEHICLES_SIREN_WAIL_03',             Ref = 0 },
--[[8]]   { Name = 'CustomA',       String = 'RESIDENT_VEHICLES_SIREN_QUICK_01',            Ref = 0 },
--[[9]]   { Name = 'CustomA',       String = 'RESIDENT_VEHICLES_SIREN_QUICK_02',            Ref = 0 },
--[[10]]  { Name = 'CustomA',       String = 'RESIDENT_VEHICLES_SIREN_QUICK_03',            Ref = 0 },
--[[11]]  { Name = 'CustomA',       String = 'VEHICLES_HORNS_AMBULANCE_WARNING',            Ref = 0 },
--[[12]]  { Name = 'FireHorn',      String = 'VEHICLES_HORNS_FIRETRUCK_WARNING',            Ref = 0 },
--[[13]]  { Name = 'Fire Yelp',     String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01',   Ref = 0 },
--[[14]]  { Name = 'Fire Yelp',     String = 'RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01',  Ref = 0 },
-- START OF SAS --
--[[15]]  { Name = 'Airhorn',         String = 'OISS_SSA_VEHAUD_BCSO_NEW_HORN',             Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET'},
--[[16]]  { Name = 'Wail',         String = 'OISS_SSA_VEHAUD_BCSO_NEW_SIREN_ADAM',       Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET'},
--[[17]]  { Name = 'Yelp',         String = 'OISS_SSA_VEHAUD_BCSO_NEW_SIREN_BOY',        Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET'},
--[[18]]  { Name = 'Priority',        String = 'OISS_SSA_VEHAUD_BCSO_NEW_SIREN_CHARLES',    Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET'},
--[[19]]  { Name = 'Sweep',        String = 'OISS_SSA_VEHAUD_BCSO_NEW_SIREN_DAVID',      Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET'},
--[[20]]  { Name = 'Ultra hi-lo',  String = 'OISS_SSA_VEHAUD_BCSO_NEW_SIREN_EDWARD',     Ref = 'OISS_SSA_VEHAUD_BCSO_NEW_SOUNDSET',   Option = 3},
--[[21]]  { Name = 'Airhorn',         String = 'OISS_SSA_VEHAUD_BCSO_OLD_HORN',             Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET'},
--[[22]]  { Name = 'Wail',         String = 'OISS_SSA_VEHAUD_BCSO_OLD_SIREN_ADAM',       Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET'},
--[[23]]  { Name = 'Yelp',         String = 'OISS_SSA_VEHAUD_BCSO_OLD_SIREN_BOY',        Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET'},
--[[24]]  { Name = 'Priority',        String = 'OISS_SSA_VEHAUD_BCSO_OLD_SIREN_CHARLES',    Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET'},
--[[25]]  { Name = 'Sweep',        String = 'OISS_SSA_VEHAUD_BCSO_OLD_SIREN_DAVID',      Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET'},
--[[26]]  { Name = 'Ultra hi-lo',  String = 'OISS_SSA_VEHAUD_BCSO_OLD_SIREN_EDWARD',     Ref = 'OISS_SSA_VEHAUD_BCSO_OLD_SOUNDSET',   Option = 3},
--[[27]]  { Name = 'Fire horn',        String = 'OISS_SSA_VEHAUD_BCFD_NEW_HORN',             Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
--[[28]]  { Name = 'Powercall',        String = 'OISS_SSA_VEHAUD_BCFD_NEW_SIREN_ADAM',       Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
--[[29]]  { Name = 'Q-Coast',          String = 'OISS_SSA_VEHAUD_BCFD_NEW_SIREN_BOY',        Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
--[[30]]  { Name = 'Q-High',           String = 'OISS_SSA_VEHAUD_BCFD_NEW_SIREN_CHARLES',    Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
--[[31]]  { Name = 'Q-Mid',            String = 'OISS_SSA_VEHAUD_BCFD_NEW_SIREN_DAVID',      Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
--[[32]]  { Name = 'Q-Mid 2',           String = 'OISS_SSA_VEHAUD_BCFD_NEW_SIREN_EDWARD',     Ref = 'OISS_SSA_VEHAUD_BCFD_NEW_SOUNDSET'},
}

--ASSIGN SIRENS TO VEHICLES
SIREN_ASSIGNMENTS = {
	--['<gameName>'] = {tones},
	['DEFAULT'] = { 15, 16, 17, 18, 19, 20 },
	-- LAW ENFORCEMENT --
	['18tahoew'] = { 15, 16, 17, 18, 19, 20 },
	['18burbanw'] = { 15, 16, 17, 18, 19, 20 },
	['18chargerw'] = { 15, 16, 17, 18, 19, 20 },
	['14chargerw'] = { 15, 16, 17, 18, 19, 20 },
	['16fpiuw'] = { 15, 16, 17, 18, 19, 20 },
	['18taurusw'] = { 15, 16, 17, 18, 19, 20 },
	['18f150w'] = { 15, 16, 17, 18, 19, 20 },
  ['f150'] = { 15, 16, 17, 18, 19, 20 },
	['13capricew'] = { 15, 16, 17, 18, 19, 20 },
	['11cvpiw'] = { 21, 22, 23, 24, 25, 26 },
	['06tahoew'] = { 21, 22, 23, 24, 25, 26 },
	['bearcat'] = { 15, 16, 17, 18, 19, 20 },
	['gwsilv'] = { 15, 16, 17, 18, 19, 20 },
	['gwboat'] = { 1, 5, 8 },
	-- FIRE & RESCUE --
	['20ramambo'] = { 1, 5, 8, 11 },
	['tahoepov'] = { 1, 5, 8, 4 },
	['arroweng'] = { 27, 28, 29, 30, 31, 32 },
	['arrowladder'] = { 27, 28, 29, 30, 31, 32 },
	['arrowrescue'] = { 27, 28, 29, 30, 31, 32 },
	['squad1'] = { 12, 5, 8, 4 },
	['ram20pov'] = { 1, 5, 8, 4 },
}