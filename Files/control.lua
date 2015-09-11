game.on_init(function()
	firstruntimer = 120
	firstrun = true
end)

game.on_load(function()
	drawshowmenubutton()
end)

-- GLOBAL
tf1="";tf2="";tf3="";tf4="";tf5=""; -- save text field variables on menu minimize
--maxzoomlevel = 2 -- default max zoomlevel
extensionindex = 1 -- default extension
gridsizeindex = 2 -- default gridsize index
gridsizearray = {256, 1024, 2048} -- screenshot size in pixel
gridpixelarray = {8,32,64} -- ingame units per screenshot, 32 pixels/unit

foldernamesize = "Map" -- default map name
foldernameresolution = gridsizearray[gridsizeindex]

extrazoomin=false
extrazoomout = false

showalt = false

-- ON TICK
counter = 0
game.on_event(defines.events.on_tick, function(event)

	-- DRAW MENU ON INIT
	if(firstrun) then
		drawshowmenubutton()
	end

	-- UPDATE PLAYER POSITION
	if(counter>=30 and game.players[1].gui.left.factoriomaps ~= nil) then
		if(game.players[1].gui.left.factoriomaps.menu_ver2 ~= nil) then
			local pos = game.players[1].position
			game.players[1].gui.left.factoriomaps.menu_ver2.menuplayerxy.playerxy.caption = math.ceil(pos.x) .. "," .. math.ceil(pos.y)

		end
		counter = 0
	end
	counter = counter + 1
end)

help = false
-- ON GUI CLICK
game.on_event(defines.events.on_gui_click, function(event)

	-- BUTTON SHOW MENU
	if(event.element.name=="showmenu") then
		if(game.players[event.player_index].gui.top.showmenu.caption=="Show Menu") then
			drawgui(event.player_index)
			setvalues(event.player_index)
			game.players[event.player_index].gui.top.showmenu.caption="Hide Menu"
		else
			savevalues(event.player_index)
			game.players[event.player_index].gui.left.factoriomaps.destroy()
			game.players[event.player_index].gui.top.showmenu.caption="Show Menu"
		end
	end

	-- BUTTON SET DAYTIME
	if(event.element.name == "setdaytime") then
		currentdaytime = game.daytime
		game.daytime = 0
	end
	-- BUTTON RESET DAYTIME
	if(event.element.name == "resetdaytime") then
		if(currentdaytime ~= nil) then
			game.daytime = currentdaytime
		end
	end

	-- TOGGLE ADVANCED MODE
	if(event.element.name == "advancedbutton") then
		if (advanced == true) then
			advanced = false
			game.players[event.player_index].gui.left.factoriomaps.menu_ver2.destroy()
		else
			advanced = true
		end
		draw=true
	end

	-- TOGGLE HELP MODE
	if(event.element.name == "helpbutton") then
		if(help == true)then
			help = false
		else
			help = true
		end
		draw=true
	end

	-- tp BUTTON TELEPORT
	if(event.element.name=="teleport1") then
		local x = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextX.text
		local y = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextY.text
		if(x~="" and y ~= "") then
			game.players[event.player_index].teleport{x,y}
		end
	end
	if(event.element.name=="teleport2") then
		local x = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextX.text
		local y = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextY.text
		if(x~="" and y ~= "") then
			game.players[event.player_index].teleport{x,y}
		end
	end
	-- pp BUTTON: USE PLAYER COORDINATES IN TEXTFIELD
	if(event.element.name=="useplayerposition1") then
		txtTopLeftX.text = math.ceil(game.players[event.player_index].position.x)
		txtTopLeftY.text = math.ceil(game.players[event.player_index].position.y)
	end
	if(event.element.name=="useplayerposition2") then
		txtBottomRightX.text = math.ceil(game.players[event.player_index].position.x)
		txtBottomRightY.text = math.ceil(game.players[event.player_index].position.y)
	end

	-- SHOW ALT INFO BUTTON
	if(event.element.name == "showalt") then
		showalt = true
	end
	-- MAX SIZE BUTTON
	if(event.element.name == "maxdiscovered") then
		local minx = 100000		-- set initial value to something big
		local miny = 100000
		local maxx = -100000
		local maxy = -100000

		for coord in game.players[event.player_index].surface.get_chunks() do
			if(game.players[event.player_index].force.is_chunk_charted(game.players[event.player_index].surface,{coord.x,coord.y})) then -- if explored by player
				if(coord.x<minx) then	-- check if this chunk is outside the current outer limit
					minx = coord.x
				end
				if(coord.y<miny) then
					miny = coord.y
				end
				if(coord.x>maxx) then
					maxx = coord.x
				end
				if(coord.y>maxy) then
					maxy = coord.y
				end
			end

		end
		txtTopLeftX.text = minx*32 -- convert to coordinates (chunk is 32x32)
		txtTopLeftY.text = miny*32
		txtBottomRightX.text = maxx*32
		txtBottomRightY.text = maxy*32


		foldernamesize =  "Map" .. "("..(-1*minx	 + maxx) .. "," .. (-1*miny + maxy) .. ")"
        updatefilename()
	end

	-- CROP BASE BUTTON
	if(event.element.name == "cropbase") then
		cropbase(event.player_index)
	end

	-- EXTRA ZOOM BUTTONS
	if(event.element.name == "maxzoomcheckbox1") then
		if(event.element.state == true) then
			extrazoomin = true
		else
			extrazoomin = false
		end
	end
	if(event.element.name == "maxzoomcheckbox2") then
		if(event.element.state == true) then
			extrazoomout = true
		else
			extrazoomout = false
		end
	end

	-- GRIDSIZE CHECKBOXES TICKED -- RADIO BUTTON SIMULATION ;)
	if(event.element.name == "gridsizecheckbox1") then
		if(event.element.state==true) then
			gridsizeindex = 1
			radiogridsize2.state = false
			radiogridsize3.state = false
			updatefilename()
		else
			radiogridsize1.state = true
		end
	elseif (event.element.name == "gridsizecheckbox2") then
		if(event.element.state==true) then
			gridsizeindex = 2
			radiogridsize1.state = false
			radiogridsize3.state = false
			updatefilename()
		else
			radiogridsize2.state = true
		end
	elseif (event.element.name == "gridsizecheckbox3") then
		if(event.element.state==true) then
			gridsizeindex = 3
			radiogridsize1.state = false
			radiogridsize2.state = false
			updatefilename()
		else
			radiogridsize3.state = true
		end
	end

		-- EXTENSION CHECKBOXES TICKED -- RADIO BUTTON SIMULATION ;)
	if(event.element.name == "extensioncheckbox1") then
		if(event.element.state==true) then
			extensionindex = 1
			radioextension2.state = false
			radioextension3.state = false
		else
			radioextension1.state = true
		end
	elseif (event.element.name == "extensioncheckbox2") then
		if(event.element.state==true) then
			extensionindex = 2
			radioextension1.state = false
			radioextension3.state = false
		else
			radioextension2.state = true
		end
	elseif (event.element.name == "extensioncheckbox3") then
		if(event.element.state==true) then
			extensionindex = 3
			radioextension1.state = false
			radioextension2.state = false
		else
			radioextension3.state = true
		end
	end

	-- BUTTON GENERATE MAPS/INDEX.HTML PRESSED
	if(event.element.name == "generate") then

		if(txtTopLeftX.text == "" or txtBottomRightX.text == "") then
			cropbase(event.player_index)
		end
		if(txtTopLeftX.text ~= "" and txtBottomRightX.text ~= "" and checkinput(event.player_index)) then
			--local minX = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextX.text
			--local minY = game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextY.text
			local deltaX = math.abs(game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextX.text) + math.abs(game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextX.text)
			local deltaY = math.abs(game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextY.text) + math.abs(game.players[event.player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextY.text)
			generatescreenshots(event.player_index, deltaX, deltaY)
			game.players[event.player_index].gui.left.factoriomaps.menu_ver1.generatewarning.caption = "Screenshots created"
			generateindex()
			game.players[event.player_index].gui.left.factoriomaps.menu_ver1.generatewarning2.caption = "Index.html created. Check your script-output folder to see the result!"
		end
	end

	if(draw == true) then
		drawgui(event.player_index)
		draw = false
	end
end)

function cropbase(player_index)
	-- code copied from Max size, to shrink the initial area quite a bit, before searching for max builded area
	local minx = 10000
	local miny = 10000
	local maxx = -10000
	local maxy = -10000

	for coord in game.players[player_index].surface.get_chunks() do -- first find max explored area, to shrink the area to search for player-built items a bit
		if(game.forces.player.is_chunk_charted(game.players[player_index].surface,{coord.x,coord.y})) then -- if explored by player

			if(coord.x<minx) then	-- check if outside current outer limit
				minx = coord.x
			end
			if(coord.y<miny) then
				miny = coord.y
			end
			if(coord.x>maxx) then
				maxx = coord.x
			end
			if(coord.y>maxy) then
				maxy = coord.y
			end
		end

	end

	local limitminx = minx*32
	local limitminy = miny*32
	local limitmaxx = maxx*32
	local limitmaxy = maxy*32

	-- now start searching for anything built by the player, and find the max coordinates
	local minx = 10000
	local miny = 10000
	local maxx = -10000
	local maxy = -10000
	local step = 10

	for y=limitminy,limitmaxy,step do
		for x =limitminx,limitmaxx,step do
--			for _,b in pairs(game.players[player_index].surface.find_entities_filtered{area = {{x-step/2, y-step/2}, {x+step/2, y+step/2}}, name="train-stop"}) do
--					game.players[player_index].print(b.prototype.name)
--			end


			for _,v in pairs(game.players[player_index].surface.find_entities{{x-step/2, y-step/2}, {x+step/2, y+step/2}}) do

				if(v.force.name == "player" and v.name ~= "player") then -- if owner = player, and it's not the player himself

					if(x>maxx) then
						maxx = x
					end
					if(x<minx) then
						minx = x
					end
					if(y>maxy) then
						maxy = y
					end
					if(y<miny) then
						miny = y
					end
				break
				end
			end
		end
	end
	if(minx ~= 10000 and miny ~= 10000 and maxx ~= -10000 and maxy ~= -10000) then
		txtTopLeftX.text = minx-15 -- 15 = arbitrairy number, to get the screenshot edge just outside of the base,
		txtTopLeftY.text = miny-15 -- instead of right on the outer walls
		txtBottomRightX.text = maxx+15
		txtBottomRightY.text = maxy+15

		--if(math.ceil(-1*minx/32 + maxx/32) >50 or math.ceil(-1*miny/32 + maxy/32)>50)


		foldernamesize = "Map" .. "(".. math.ceil(-1*minx/32 + maxx/32) .. "," .. math.ceil(-1*miny/32 + maxy/32) .. ")"
		updatefilename()
	else
		game.players[player_index].print("Either you haven't built anything yet, or there is something very wrong ;)")
	end
end

function updatefilename()
	foldernameresolution = gridsizearray[gridsizeindex] -- look up grid size
	txtFolderName.text = foldernamesize .. foldernameresolution -- change folder name
end

function checkinput(player_index)
	-- check if coordinates entered make a valid rectangle

	if( tonumber(txtTopLeftX.text) < tonumber(txtBottomRightX.text) and tonumber(txtTopLeftY.text) < tonumber(txtBottomRightY.text))then
		return true
	else
		game.players[player_index].print("Coordinates input error, top right has to be smaller than bottom left")
		return false
	end

end

function drawshowmenubutton()
	-- draw initial menu button
	for k,_ in ipairs(game.players) do
		if(game.players[k].gui.top.showmenu == nil) then
			game.players[k].gui.top.add({type="button", name="showmenu", caption="Show Menu"})
		end
	end


end

function setvalues(player_index)
	-- save values on hide menu
	if(ui.menu_ver2) then
		game.players[player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextX.text = tf1
		game.players[player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextY.text = tf2
		game.players[player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextX.text = tf3
		game.players[player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextY.text = tf4
		game.players[player_index].gui.left.factoriomaps.menu_ver1.menu4.foldername.text = tf5
	end
end

function savevalues(player_index)
	-- load values on show menu
	if(game.players[player_index].gui.left.factoriomaps) then
		if(game.players[player_index].gui.left.factoriomaps.menu_ver2) then
			tf1 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextX.text
			tf2 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu1.toplefttextY.text
			tf3 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextX.text
			tf4 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu2.bottomrighttextY.text
		end
		tf5 = game.players[player_index].gui.left.factoriomaps.menu_ver1.menu4.foldername.text
	end

end

function toLatLng(res, point)
	if(point.y < (res/2)) then
		lat = -90 +(math.atan2(point.y,res)*180/math.pi)
		if(lat > 84.5) then
			lat = 84.5
		end
	else
		local y = res - point.y
		--game.players[player_index].print (res .. " ** " .. point.y..",".. y)
		lat = -90 + (math.atan2(y,res)*180/math.pi)
		if(lat < -84.5) then
			lat = -84.5
		end
	end
	lng = -180 + (point.x/res)*360
	return {lat = lat, lng = lng}
end

function generatescreenshots(player_index)

	if(txtFolderName.text == "") then
		game.players[player_index].print("Please check foldername, it can't be empty")
		return
	end

	playerposition = game.players[player_index].position
	ingameresolution = 0 -- default

	local squaresize = gridpixelarray[gridsizeindex]
	local ingametotalwidth = (-1*txtTopLeftX.text+txtBottomRightX.text)
	local ingametotalheight = (-1*txtTopLeftY.text+txtBottomRightY.text)
	local numberofhorizontalscreenshots = math.ceil(ingametotalwidth/squaresize)
	local numberofverticalscreenshots =  math.ceil(ingametotalheight/squaresize)
	local zooming = 1 -- counter for measuring zoom, 1/1, 1/2,1/4,1/8 etc



	-- delete folder (if it already exists)
	game.remove_path("FactorioMaps/".. txtFolderName.text)

	-- calculate min/max zoom levels
	--
	minzoom = 0 -- lvl 0 is always 256x256, the resolution in which google maps calculates positions
	maxzoom=0 -- default

	local resolutionarray = {8, 16,32,64,128,256,512,1024,2048,4096,8192} -- resolution for each zoom level, lvl 0 is always 8x8 (256x256 pixels)

	local maxcounter = 0 -- in google maps, max zoom out level is 0, so start with 0
	for _,res in pairs(resolutionarray) do
		if(ingametotalwidth < res and ingametotalheight < res) then
			maxzoom = maxcounter
			ingameresolution = res
			center = toLatLng(res, {x=ingametotalwidth/2, y=ingametotalheight/2})
			break
		end
		maxcounter = maxcounter + 1
	end

	local latlng = toLatLng(ingameresolution,{x=ingametotalwidth,y=ingametotalheight})
	linesarray =
	{
		{lat = 84.5, lng = -179}, -- start top left
		{lat = 84.5, lng = -50}, -- lng = latlng.lng/2}, -- intermediate point, so the line won't "flip"
		{lat = 84.5, lng = latlng.lng},
		{lat = latlng.lat, lng = latlng.lng},
		{lat = latlng.lat, lng =  -50},
		{lat = latlng.lat, lng = -179},
		{lat = 84.5, lng = -179} -- start top left
	}
	if gridsizeindex == 1 then
		minzoom = 0
	elseif gridsizeindex == 2 then
		minzoom = 2
	elseif gridsizeindex == 3 then
		minzoom = 3
	end

	if(extrazoomin == false) then -- if (no max level zoom in), skip this step
		maxzoom = maxzoom - 1
		zooming = zooming / 2 -- startzoom
		numberofhorizontalscreenshots = math.ceil(numberofhorizontalscreenshots/2)
		numberofverticalscreenshots = math.ceil(numberofverticalscreenshots/2)
	elseif(z==minzoom and extrazoomout == false) then -- if (no extra zoom out), skip this step
		-- debug: if minzoom < smallest zoomlevel possible, skip the step before the minzoom level
		minzoom = minzoom + 1
	end

	--debug: fails for very small maps where maxzoom < minzoom
	for z=maxzoom,minzoom,-1 do  -- max and min zoomlevels
		for y=0,numberofverticalscreenshots-1 do


			for x=0,numberofhorizontalscreenshots-1 do
				if((extensionindex==2 and z==maxzoom) or extensionindex==3) then
					extension = "png"
				else
					extension = "jpg"
				end
				local positiontext = {txtTopLeftX.text + (1/(2*zooming))*squaresize + x*(1/zooming)*squaresize, txtTopLeftY.text + (1/(2*zooming))*squaresize + y*(1/zooming)*squaresize}
				local resolutiontext = {gridsizearray[gridsizeindex],gridsizearray[gridsizeindex]}
				local pathtext = "FactorioMaps/".. txtFolderName.text .. "/Images/".. z .."_".. x .."_".. y ..".".. extension
				game.take_screenshot{position=positiontext, resolution=resolutiontext ,zoom=zooming, path= pathtext, show_entity_info=showalt}
			end
		end

		zooming = zooming/2
		if gridsizeindex == 1 and zooming < 1/256 then
			game.players[player_index].print("max level zoom break")
			minzoom = z
			break
		elseif gridsizeindex == 2 and zooming < 1/64 then
			game.players[player_index].print("max level zoom break")
			minzoom = z
			break
		elseif gridsizeindex == 3 and zooming < 1/32 then
			game.players[player_index].print("max level zoom break")
			minzoom = z
			break
		end

		numberofhorizontalscreenshots = math.ceil(numberofhorizontalscreenshots/2)
		numberofverticalscreenshots = math.ceil(numberofverticalscreenshots/2)
	end

end
