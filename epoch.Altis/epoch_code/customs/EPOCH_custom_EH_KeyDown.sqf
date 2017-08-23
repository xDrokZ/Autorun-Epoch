/*
	Author: Aaron Clark - EpochMod.com

    Contributors: [Ignatz] He-Man

	Description:
	Custom A3 Epoch KeyUp Eventhandler

    Licence:
    Arma Public License Share Alike (APL-SA) - https://www.bistudio.com/community/licenses/arma-public-license-share-alike

    Github:
    https://github.com/EpochModTeam/Epoch/tree/release/Sources/epoch_code/custom/EPOCH_custom_EH_KeyDown.sqf
*/
params ["_display","_dikCode","_shift","_ctrl","_alt"];
_handled = false;


/////////////// SimpleAutorun by ShadowRanger24/He-Man/xDrokZ ////////////////
 
if (vehicle player == player) then {
       
    if (_dikCode == 0x0B) then { 	// Button 0
   
        if (isNil "AR_active") then {AR_active = false; 1234 cutText ["","PLAIN",0];};
			if (AR_active) exitWith {AR_active = false; 1234 cutText ["","PLAIN",0]; _handled = true;};

			if (!isNull objectParent player) exitWith {};
			if (surfaceIsWater (getPos player)) exitWith {};
			if ((damage player) >= 0.5) exitWith {hint "Too much injured for Autorun!";};
			
			 
			_mapAngle = [getPos player, getDir player] call BIS_fnc_terrainGradAngle;
			if ((_mapAngle <= -25) || (_mapAngle >= 20))  exitWith {hint "To steep for Autorun!";};
			
			private["_legsHit","_canRun","_allHitPointsDamage","_index"];
			_legsHit = (vehicle player) getHitPointDamage "HitLegs";
			_abdHit = (vehicle player) getHitPointDamage "HitAbdomen";
			_diaphragmHit = (vehicle player) getHitPointDamage "HitDiaphragm";
			_injured = if (_legsHit > 0.5 || _abdHit > 0.5 || _diaphragmHit > 0.5) then {true} else {false};
			if (_injured) exitWith {hint "Too much injured for Autorun!";};

			AR_active = true;
			
			if (AR_active) then {
            _pic = "addons\texture\runner.paa";
            [
            '<img align=''left'' size=''1.75'' shadow=''1'' image='+(str(_pic))+' />',
            0.93715 * safezoneW + safezoneX,
            0.22963 * safezoneH + safezoneY,
            99999,
            0,
            0,
            1234
            ] spawn bis_fnc_dynamicText;
            };
			
			AR_weapon = currentWeapon player;
			AR_animation = switch (true) do {
				case (AR_weapon isEqualTo ""): {"AmovPercMevaSnonWnonDf"};
				case (AR_weapon isEqualTo (primaryWeapon player)): {"AmovPercMevaSlowWrflDf"};
				case (AR_weapon isEqualTo (secondaryWeapon player)): {"AmovPercMevaSlowWrflDf"};
				case (AR_weapon isEqualTo (handgunWeapon player)): {"AmovPercMevaSlowWpstDf"};
			};

			player playMoveNow AR_animation;

			player addEventHandler ["AnimChanged", {
			
				_mapAngle = [getPos player, getDir player] call BIS_fnc_terrainGradAngle;
				if ((!AR_active) || {!((currentWeapon player) isEqualTo AR_weapon)} || {!isNull objectParent player} || {surfaceIsWater (getPos player)} || {_mapAngle >= 20} || {_mapAngle <= -25}) exitWith {
					player removeEventHandler ["AnimChanged", _thisEventHandler];

					AR_weapon = currentWeapon player;
					AR_animation = switch (true) do {
						case (AR_weapon isEqualTo ""): {"AmovPercMstpSnonWnonDnon"};
						case (AR_weapon isEqualTo (primaryWeapon player)): {"AmovPercMstpSlowWrflDnon"};
						case (AR_weapon isEqualTo (secondaryWeapon player)): {"AmovPercMevaSlowWlnrDf"};
						case (AR_weapon isEqualTo (handgunWeapon player)): {"AmovPercMstpSlowWpstDnon"};
					};

					player playMoveNow AR_animation;

					AR_active = false;
					1234 cutText ["","PLAIN",0];
					AR_weapon = nil;
					AR_animation = nil;
				};

				player playMoveNow AR_animation;
			}];

			_handled = true;
		};
		
		if (_dikCode in [0x11,0x1E,0x1F,0x20,0x2D,0x2E,0x15,0x2C]) then 		// abort on pressing w,a,s,d,y,x,c,z
				{
					AR_active = false;
					1234 cutText ["","PLAIN",0];
				};	
		
		
    };
 
    ///////////// End Autorun /////////////

if (_handled) exitwith {_handled};


_handled
