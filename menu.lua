--[[
---------------------------------------------------
LUXART VEHICLE CONTROL (FOR FIVEM)
---------------------------------------------------
Last revision: DECEMBER 26 2020 (VERS. 3.2.0)
Coded by Lt.Caine
ELS Clicks by Faction
Additonal Modification by TrevorBarns
---------------------------------------------------
FILE: menu.lua
PURPOSE: Handle RageUI menu stuff
---------------------------------------------------
]]

RMenu.Add('lvc', 'main', RageUI.CreateMenu("Luxart Vehicle Control", "Main Menu"))
RMenu.Add('lvc', 'maintone', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "Main Tone Selection Menu"))
RMenu.Add('lvc', 'tkdsettings', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "Takedown Settings"))
RMenu.Add('lvc', 'hudsettings', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "HUD Settings"))
RMenu.Add('lvc', 'audiosettings', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "Audio Settings"))
RMenu.Add('lvc', 'saveload', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "Storage Management"))
RMenu.Add('lvc', 'about', RageUI.CreateSubMenu(RMenu:Get('lvc', 'main'),"Luxart Vehicle Control", "About Luxart Vehicle Control"))
RMenu:Get('lvc', 'main'):SetTotalItemsPerPage(12)
RMenu:Get('lvc', 'audiosettings'):SetTotalItemsPerPage(12)
RMenu:Get('lvc', 'main'):DisplayGlare(false)
RMenu:Get('lvc', 'saveload'):DisplayGlare(false)
RMenu:Get('lvc', 'maintone'):DisplayGlare(false)
RMenu:Get('lvc', 'hudsettings'):DisplayGlare(false)
RMenu:Get('lvc', 'audiosettings'):DisplayGlare(false)
RMenu:Get('lvc', 'tkdsettings'):DisplayGlare(false)
RMenu:Get('lvc', 'about'):DisplayGlare(false)

main_tone_settings = nil
main_tone_choices = { 'Cycle & Button', 'Cycle Only', 'Button Only', 'Disabled' } 
settings_init = false

--Strings for Save/Load confirmation, not ideal but it works. 
local ok_to_disable  = true
local confirm_s_msg
local confirm_l_msg
local confirm_fr_msg
local confirm_s_desc
local confirm_l_desc
local confirm_fr_desc
local profile_s_op = 75
local profile_l_op = 75
local github_index = 1
local hazard_state = false
local button_sfx_scheme_id = 1
local sl_btn_debug_msg = ""

Keys.Register(open_menu_key, open_menu_key, 'LVC: Open Menu', function()
	if not key_lock and player_is_emerg_driver and UpdateOnscreenKeyboard() ~= 0 then
		if tone_PMANU_id == nil then
			tone_PMANU_id = GetTone(veh, 2)
		elseif not IsApprovedTone(veh, tone_PMANU_id) then
			tone_PMANU_id = GetTone(veh, 2)			
		end
		if tone_SMANU_id == nil then
			tone_SMANU_id = GetTone(veh, 3)
		elseif not IsApprovedTone(veh, tone_SMANU_id) then
			tone_SMANU_id = GetTone(veh, 3)			
		end
		if tone_AUX_id == nil then
			tone_AUX_id = GetTone(veh, 3)
		elseif not IsApprovedTone(veh, tone_AUX_id) then
			tone_AUX_id = GetTone(veh, 3)			
		end
		RageUI.Visible(RMenu:Get('lvc', 'main'), not RageUI.Visible(RMenu:Get('lvc', 'main')))
	end
end)

--Returns table of all approved tones
function GetApprovedTonesList()
	local list = { } 
	local pending_tone = 0
	for i, _ in ipairs(tone_table) do
		if i ~= 1 then
			pending_tone = GetTone(veh,i)
			if IsApprovedTone(veh, pending_tone) and i <= GetToneCount(veh) then
				table.insert(list, { Name = tone_table[pending_tone], Value = pending_tone })
			end
		end
	end
	return list
end

--Returns table of all tones with settings value
function GetTonesList()
	local veh_name = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
	local temp_tone_array = nil
	local list = { } 

	--Reset debug message that shows vehicle gameName.
	sl_btn_debug_msg = ""

 	if VEHICLES[veh_name] ~= nil then						--Does profile exist as outlined in vehicle.meta
		temp_tone_array = VEHICLES[veh_name]
	elseif VEHICLES[string.lower(veh_name)] ~= nil then		--What if we lowercase it, is it a case issue?
		temp_tone_array = VEHICLES[string.lower(veh_name)]
	elseif VEHICLES[string.upper(veh_name)] ~= nil then		--What if we uppercase it, is it a case issue? 
		temp_tone_array = VEHICLES[string.upper(veh_name)]	
	else
		temp_tone_array = VEHICLES['DEFAULT']
		sl_btn_debug_msg = " Using ~b~DEFAULT~s~ profile for \"~b~" .. veh_name .. "~s~\"."
	end
	
	for _, tone in ipairs(temp_tone_array) do
		if tone ~= 1 then
			table.insert(list, {tone,1})
		end
	end
	
	return list
end

--Find index at which a given siren tone is at.
function GetToneIndex(tone_id)
	for i, tone in ipairs(tone_list) do
		if tone_id == tone.Value then
			return i
		end
	end
end

--Find index at which a given siren tone is at.
function GetIndex(item, tbl)
	for i, j in ipairs(tbl) do
		if item == j then
			return i
		end
	end
end

--Returns true if any menu is open
function IsMenuOpen()
	return RageUI.Visible(RMenu:Get('lvc', 'main')) or 
	RageUI.Visible(RMenu:Get('lvc', 'maintone')) or 
	RageUI.Visible(RMenu:Get('lvc', 'saveload')) or 
	RageUI.Visible(RMenu:Get('lvc', 'tkdsettings')) or 
	RageUI.Visible(RMenu:Get('lvc', 'audiosettings')) or 
	RageUI.Visible(RMenu:Get('lvc', 'hudsettings')) or 
	RageUI.Visible(RMenu:Get('lvc', 'about'))
end

--Ensure not all sirens are disabled / button only
function SetCheckVariable() 
	ok_to_disable = false
	local count = 0
	for i, siren in ipairs(main_tone_settings) do
		if siren[2] < 3 then
			count = count + 1
		end
	end
	if count > 1 then
		ok_to_disable = true
	end
end


--Loads settings and builds first table states, also updates tone_list every second for vehicle changes
Citizen.CreateThread(function()
    while true do
		if not settings_init and player_is_emerg_driver then
			main_tone_settings = GetTonesList()
			settings_init = true
		end

		tone_list = GetApprovedTonesList()
		Citizen.Wait(1000)
	end
end)

--Handle user input to cancel confirmation message for SAVE/LOAD
Citizen.CreateThread(function()
	while true do 
		while not RageUI.Settings.Controls.Back.Enabled do
			for Index = 1, #RageUI.Settings.Controls.Back.Keys do
				if IsDisabledControlJustPressed(RageUI.Settings.Controls.Back.Keys[Index][1], RageUI.Settings.Controls.Back.Keys[Index][2]) then
					confirm_s_msg = nil
					confirm_s_desc = nil
					profile_s_op = 75
					confirm_l_msg = nil
					confirm_l_desc = nil
					profile_l_op = 75
					confirm_r_msg = nil
					confirm_fr_msg = nil
					Citizen.Wait(10)
					RageUI.Settings.Controls.Back.Enabled = true
					break
				end
			end
			Citizen.Wait(0)
		end
		Citizen.Wait(100)
	end
end)
--Handle Disabling Controls while menu open
Citizen.CreateThread(function()
	while true do 
		while IsMenuOpen() do
			DisableControlAction(0, 27, true) 
			DisableControlAction(0, 99, true) 
			DisableControlAction(0, 172, true) 
			DisableControlAction(0, 173, true) 
			DisableControlAction(0, 174, true) 
			DisableControlAction(0, 175, true) 
			Citizen.Wait(0)
		end
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
    while true do
		--Main Menu Visible
	    RageUI.IsVisible(RMenu:Get('lvc', 'main'), function()
			RageUI.Separator("Siren Settings")
			RageUI.Button('Main Siren Settings', "Change which/how each available primary tone is used.", {RightLabel = "→→→"}, true, {
			  onSelected = function()

			  end,
			}, RMenu:Get('lvc', 'maintone'))
			if custom_manual_tones_master_switch then
				--PMT List
				RageUI.List('Primary Manual Tone', tone_list, GetToneIndex(tone_PMANU_id), "Change your primary manual tone. Key: R", {}, true, {
				  onListChange = function(Index, Item)
					tone_PMANU_id = Item.Value;
				  end,
				  onSelected = function()
					proposed_name = KeyboardInput("Enter new tone name for " .. siren_string_lookup[tone_PMANU_id] .. ":", tone_table[tone_PMANU_id], 15)
					if proposed_name ~= nil then
						ChangeToneString(tone_PMANU_id, proposed_name)
					end
				  end,
				})
				--SMT List
				RageUI.List('Secondary Manual Tone', tone_list, GetToneIndex(tone_SMANU_id), "Change your secondary manual tone. Key: E+R", {}, true, {
				  onListChange = function(Index, Item)
					tone_SMANU_id = Item.Value;
				  end,
				  onSelected = function()
					proposed_name = KeyboardInput("Enter new tone name for " .. siren_string_lookup[tone_SMANU_id] .. ":", tone_table[tone_SMANU_id], 15)
					if proposed_name ~= nil then
						ChangeToneString(tone_SMANU_id, proposed_name)
					end
				  end,
				})
			end
			if custom_aux_tones_master_switch then
				--AST List
				RageUI.List('Auxiliary Siren Tone', tone_list, GetToneIndex(tone_AUX_id), "Change your auxiliary/dual siren tone. Key: ↑", {}, true, {
				  onListChange = function(Index, Item)
					tone_AUX_id = Item.Value;
				  end,
				  onSelected = function()
					proposed_name = KeyboardInput("Enter new tone name for " .. siren_string_lookup[tone_AUX_id] .. ":", tone_table[tone_AUX_id], 15)
					if proposed_name ~= nil then
						ChangeToneString(tone_AUX_id, proposed_name)
					end
				  end,
				})
			end
			RageUI.Checkbox('Siren Park Kill', "Toggles whether your sirens turn off automatically when you exit your vehicle. ", park_kill, {}, {
			  onSelected = function(Index)
				  park_kill = Index
			  end
			})
			--Begin HUD Settings
			RageUI.Separator("Other Settings")
			RageUI.Button('Takedown Settings', "Open takedown lights menu.", {RightLabel = "→→→"}, true, {
			  onSelected = function()
			  end,
			}, RMenu:Get('lvc', 'tkdsettings'))	
			RageUI.Button('HUD Settings', "Open HUD settings menu.", {RightLabel = "→→→"}, true, {
			  onSelected = function()
			  end,
			}, RMenu:Get('lvc', 'hudsettings'))					
			RageUI.Button('Audio Settings', "Open audio settings menu.", {RightLabel = "→→→"}, true, {
			  onSelected = function()
			  end,
			}, RMenu:Get('lvc', 'audiosettings'))			
			RageUI.Separator("Miscellaneous")	
			RageUI.Button('Storage Management', "Save / Load LVC profiles.", {RightLabel = "→→→"}, true, {
			  onSelected = function()
			  end,
			}, RMenu:Get('lvc', 'saveload'))			
			RageUI.Button('More Information', "Learn more about Luxart Vehicle Control.", {RightLabel = "→→→"}, true, {
			  onSelected = function()
			  end,
			}, RMenu:Get('lvc', 'about'))
        end)
		---------------------------------------------------------------------
		----------------------------MAIN TONE MENU---------------------------
		---------------------------------------------------------------------	
	    RageUI.IsVisible(RMenu:Get('lvc', 'maintone'), function()
			RageUI.Checkbox('Airhorn Interrupt Mode', "Toggles whether the airhorn interupts main siren.", tone_airhorn_intrp, {}, {
            onSelected = function(Index)				
                tone_airhorn_intrp = Index
            end	
			})
			RageUI.Checkbox('Reset to Standby', "When enabled, the primary siren will reset to 1st siren. When disabled, the last played tone will resume.", tone_main_reset_standby, {}, {
            onSelected = function(Index)
				tone_main_reset_standby = Index
            end
            })
			for i, siren in pairs(main_tone_settings) do
				RageUI.List(tone_table[siren[1]], main_tone_choices, siren[2], "Change how is activated.\nCycle: play as you cycle through sirens.\nButton: play when associated registered key is pressed.", {}, IsApprovedTone(veh, siren[1]), {
					onListChange = function(Index, Item)
						if Index < 3 or ok_to_disable then
							siren[2] = Index;
						else
							ShowNotification("~y~~h~Info:~h~ ~s~Luxart Vehicle Control\nAction prohibited, cannot disable all sirens.") 
						end
						SetCheckVariable()
					end,
					onSelected = function()
						proposed_name = KeyboardInput("Enter new tone name for " .. siren_string_lookup[siren[1]] .. ":", tone_table[siren[1]], 15)
						if proposed_name ~= nil then
						ChangeToneString(siren[1], proposed_name)
						end
					end,
				})
			end
        end)	
		---------------------------------------------------------------------
		-------------------------OTHER SETTINGS MENU-------------------------
		---------------------------------------------------------------------
		--TKD SETTINGS
		RageUI.IsVisible(RMenu:Get('lvc', 'tkdsettings'), function()
			RageUI.Checkbox('Takedowns', "Takedown masterswitch, toggle takedown functionality.", tkd_masterswitch, {}, {
            onSelected = function(Index)
				tkd_masterswitch = Index
            end
            })				
			RageUI.Checkbox('Set Highbeams', "Determines weather takedowns will auto toggle high-beams.", tkd_set_highbeams, {Enabled = tkd_masterswitch}, {
            onSelected = function(Index)
				tkd_set_highbeams = Index
            end
            })	
			RageUI.List('Position', {"1", "2", "3", "4"}, tkd_scheme, "Select predefined positions of light source.", {}, true, {
			  onListChange = function(Index, Item)
				tkd_scheme = Index
			  end,
			})
			RageUI.Slider('Intensity', tkd_intensity, 150, 15, "Set brightness/intensity of takedowns.", false, {}, tkd_masterswitch, {
			  onSliderChange = function(Index)
				tkd_intensity = Index
			  end,	  
			})					
			RageUI.Slider('Radius', tkd_radius, 90, 9, "Set width of takedowns.", false, {}, tkd_masterswitch, {
			  onSliderChange = function(Index)
				tkd_radius = Index
			  end,	  
			})			
			RageUI.Slider('Distance', tkd_distance, 250, 25, "Set the max distance the takedown can travel.", false, {}, tkd_masterswitch, {
			  onSliderChange = function(Index)
				tkd_distance = Index
			  end,	  
			})				
			RageUI.Slider('Falloff', tkd_falloff, 2000, 200, "Set how fast light \"falls off\" or appears dim.", false, {}, tkd_masterswitch, {
			  onSliderChange = function(Index)
				tkd_falloff = Index
			  end,	  
			})	
        end)
		--HUD SETTINGS
	    RageUI.IsVisible(RMenu:Get('lvc', 'hudsettings'), function()
			RageUI.Checkbox('Visible', "Toggles whether the LVC HUD is on screen.", show_HUD, {}, {
			  onSelected = function(Index)
				  show_HUD = Index
				  
			  end
			})
			RageUI.Button('Move Mode', "Move HUD position on screen.", {}, show_HUD, {
			  onSelected = function()
					TogMoveMode()
				end,
			  });
			RageUI.Slider('Background Opacity', hud_bgd_opacity, 255, 20, "Change opacity of of the HUD background rectangle.", false, {}, show_HUD, {
			  onSliderChange = function(Index)
				--Stupid way to check if a KVP was found.
				if Index == 0 then
					Index = 1
				end
				hud_bgd_opacity = Index
			  end,
			})
			RageUI.Slider('Button Opacity', hud_button_off_opacity, 255, 20, "Change opacity of inactive HUD buttons.", false, {}, show_HUD, {
			  onSliderChange = function(Index)
				--Stupid way to check if a KVP was found.
				if Index == 0 then
					Index = 1
				end
				hud_button_off_opacity = Index 
			  end,
			})
        end)	    
		--AUDIO SETTINGS MENU
		RageUI.IsVisible(RMenu:Get('lvc', 'audiosettings'), function()
			RageUI.List("Sirenbox SFX Scheme", button_sfx_scheme_choices, button_sfx_scheme_id, "Change what SFX to use for siren box clicks.", {}, true, {
			  onListChange = function(Index, Item)
				button_sfx_scheme_id = Index
				button_sfx_scheme = button_sfx_scheme_choices[button_sfx_scheme_id]
			  end,				
			})
			RageUI.Checkbox('Manual Button Clicks', "When enabled, your manual tone button (default: R) will activate the upgrade SFX.", manu_button_SFX, {}, {
            onSelected = function(Index)
				manu_button_SFX = Index
            end
            })			
			RageUI.Checkbox('Airhorn Button Clicks', "When enabled, your airhorn button (default: E) will activate the upgrade SFX.", airhorn_button_SFX, {}, {
			  onSelected = function(Index)
				airhorn_button_SFX = Index
            end
            })
			RageUI.List('Activity Reminder', {"Off", "1/2", "1", "2", "5", "10"}, activity_reminder_index, ("Recieve reminder tone that your lights are on. Options are in minutes. Timer (sec): %1.0f"):format((last_activity_timer / 1000) or 0), {}, true, {
			  onListChange = function(Index, Item)
				activity_reminder_index = Index
				SetActivityTimer()
			  end,
			})			
			RageUI.Slider('On Volume', (on_volume*100), 100, 2, "Set volume of light slider / button. Plays when lights are turned ~g~on~s~. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				on_volume = (Index / 100)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", button_sfx_scheme .. "/" .. "On", on_volume)
			  end,
			})			
			RageUI.Slider('Off Volume', (off_volume*100), 100, 2, "Set volume of light slider / button. Plays when lights are turned ~r~off~s~. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				off_volume = (Index/100)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", button_sfx_scheme .. "/" .. "Off", off_volume)
			  end,
			})			
			RageUI.Slider('Upgrade Volume', (upgrade_volume*100), 100, 2, "Set volume of siren button. Plays when siren is turned ~g~on~s~. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				upgrade_volume = (Index/100)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", button_sfx_scheme .. "/" .. "Upgrade", upgrade_volume)
			  end,			  
			})			
			RageUI.Slider('Downgrade Volume', (downgrade_volume*100), 100, 2, "Set volume of siren button. Plays when siren is turned ~r~off~s~. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				downgrade_volume = (Index/100)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", button_sfx_scheme .. "/" .. "Downgrade", downgrade_volume)
			  end,			  
			})	
			RageUI.Slider('Activity Reminder Volume', (activity_reminder_volume*500), 100, 2, "Set volume of activity reminder tone. Plays when lights are ~g~on~s~, siren is ~r~off~s~, and timer is has finished. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				activity_reminder_volume = (Index/500)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", button_sfx_scheme .. "/" .. "Reminder", activity_reminder_volume)
			  end,			  
			})				
			RageUI.Slider('Hazards Volume', (hazards_volume*100), 100, 2, "Set volume of hazards button. Plays when hazards are toggled. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				hazards_volume = (Index/100)
			  end,
			  onSelected = function(Index, Item)
				if hazard_state then
					TriggerEvent("lvc:audio", "Hazards_On", hazards_volume)
				else
					TriggerEvent("lvc:audio", "Hazards_Off", hazards_volume)
				end
				hazard_state = not hazard_state
			  end,			  
			})
			RageUI.Slider('Lock Volume', (lock_volume*100), 100, 2, "Set volume of lock notification sound. Plays when siren box lockout is toggled. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				lock_volume = (Index/100)			
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", "Key_Lock", lock_volume)
			  end,			  
			})					
			RageUI.Slider('Lock Reminder Volume', (lock_reminder_volume*100), 100, 2, "Set volume of lock reminder sound. Plays when locked out keys are pressed repeatedly. Press Enter to play the sound.", true, {}, true, {
			  onSliderChange = function(Index)
				lock_reminder_volume = (Index/100)
			  end,
			  onSelected = function(Index, Item)
				TriggerEvent("lvc:audio", "Locked_Press", lock_reminder_volume)
			  end,			  
			})			
        end)
		---------------------------------------------------------------------
		----------------------------SAVE LOAD MENU---------------------------
		---------------------------------------------------------------------
	    RageUI.IsVisible(RMenu:Get('lvc', 'saveload'), function()
			RageUI.Button('Save Settings', confirm_s_desc or "Save LVC settings." .. sl_btn_debug_msg, {RightLabel = confirm_s_msg or "(".. GetVehicleProfileName() .. ")", RightLabelOpacity = profile_s_op}, true, {
				onSelected = function()
					if confirm_s_msg == "Are you sure?" then
						SaveSettings()
						confirm_s_msg = nil
						confirm_s_desc = nil
						profile_s_op = 75
					else 
						RageUI.Settings.Controls.Back.Enabled = false 
						profile_s_op = 255
						confirm_s_msg = "Are you sure?" 
						confirm_s_desc = "~r~This will override any exisiting save data for this vehicle profile ("..GetVehicleProfileName()..")."
						confirm_l_msg = nil
						profile_l_op = 75
						confirm_r_msg = nil
						confirm_fr_msg = nil
					end
				end,
			})			
			RageUI.Button('Load Settings', confirm_l_desc or "Load LVC settings." .. sl_btn_debug_msg, {RightLabel = confirm_l_msg or "(".. GetVehicleProfileName() .. ")", RightLabelOpacity = profile_l_op}, true, {
			  onSelected = function()
				if confirm_l_msg == "Are you sure?" then
					LoadSettings()
					confirm_l_msg = nil
					confirm_l_desc = nil
					profile_l_op = 75
				else 
					RageUI.Settings.Controls.Back.Enabled = false 
					profile_l_op = 255
					confirm_l_msg = "Are you sure?" 
					confirm_l_desc = "~r~This will override any unsaved settings."
					confirm_s_msg = nil
					profile_s_op = 75
					confirm_r_msg = nil
					confirm_fr_msg = nil

				end
			  end,
			})			
			RageUI.Separator("Advanced Settings")
			RageUI.Button('Reset Settings', "~r~Reset LVC to it's default state, preserves existing saves. Will override any unsaved settings.", {RightLabel = confirm_r_msg}, true, {
			  onSelected = function()
				if confirm_r_msg == "Are you sure?" then
					ResetSettings()
					confirm_r_msg = nil
				else 
					RageUI.Settings.Controls.Back.Enabled = false 
					confirm_r_msg = "Are you sure?" 
					confirm_l_msg = nil
					profile_l_op = 75
					confirm_s_msg = nil
					profile_s_op = 75
					confirm_fr_msg = nil
				end
			  end,
			})			
			RageUI.Button('Factory Reset', "~r~Permanently delete any saves, resetting LVC to its default state.", {RightLabel = confirm_fr_msg}, true, {
			  onSelected = function()
				if confirm_fr_msg == "Are you sure?" then
					RageUI.CloseAll()
					Citizen.Wait(100)
					ExecuteCommand('lvcfactoryreset')
					confirm_fr_msg = nil
				else 
					RageUI.Settings.Controls.Back.Enabled = false 
					confirm_fr_msg = "Are you sure?" 
					confirm_l_msg = nil
					profile_l_op = 75
					confirm_s_msg = nil
					profile_s_op = 75
					confirm_r_msg = nil
				end
			  end,
			})
        end)	
		---------------------------------------------------------------------
		------------------------------ABOUT MENU-----------------------------
		---------------------------------------------------------------------
	    RageUI.IsVisible(RMenu:Get('lvc', 'about'), function()
			if curr_version ~= nil then
				--print(repo_version, curr_version, IsNewerVersion(repo_version, curr_version))
				if IsNewerVersion(repo_version, curr_version) then
					RageUI.Button('Current Version', "This server is running " .. curr_version, { RightLabel = "~o~~h~" .. curr_version or "unknown" }, true, {
					  onSelected = function()
					  end,
					  });	
					RageUI.Button('Latest Version', "The latest update is " .. repo_version .. ". Contact a server developer.", {RightLabel = repo_version or "unknown"}, true, {
						onSelected = function()
					end,
					});
				else
					RageUI.Button('Current Version', "This server is running " .. curr_version .. ", the latest version.", { RightLabel = curr_version or "unknown" }, true, {
					  onSelected = function()
					  end,
					  });			
				end
			end
			RageUI.List('Launch GitHub Page', {"Main Repository", "Siren Repository", "File Bug Report"}, github_index, "View the project and more info on GitHub.", {}, true, {
			  onListChange = function(Index, Item)
				github_index = Index
			  end,
			  onSelected = function()
				if github_index == 1 then
					TriggerServerEvent('lvc_OpenLink_s', "https://github.com/TrevorBarns/luxart-vehicle-control")
				elseif github_index	== 2 then
					TriggerServerEvent('lvc_OpenLink_s', "https://github.com/TrevorBarns/luxart-vehicle-control-extras")			
				else
					TriggerServerEvent('lvc_OpenLink_s', "https://github.com/TrevorBarns/luxart-vehicle-control/issues/new")			
				end
			  end,
			})
			RageUI.Button('Developer\'s Discord', "Join my discord for support, future updates, and other resources.", {}, true, {
				onSelected = function()
				TriggerServerEvent('lvc_OpenLink_s', "https://discord.gg/HGBp3un")
			end,
			});	
			RageUI.Button('About / Credits', "Originally designed and created by ~b~Lt. Caine~s~. ELS SoundFX by ~b~Faction~s~. Version 3 expansion by ~b~Trevor Barns~s~.\n\nSpecial thanks to Lt. Cornelius, bakerxgooty, MrLucky8, xotikorukx, the RageUI team, and everyone else who helped beta test, this would not have been possible without you all!", {}, true, {
				onSelected = function()
			end,
			});
			  
        end)
        Citizen.Wait(1)
	end
end)
