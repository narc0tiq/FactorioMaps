require "defines"
require "gui_style"



function drawgui(player_index)

	if(ui ~= nil) then
		savevalues(player_index)
	end


	if(game.players[player_index].gui.left.factoriomaps ~= nil) then
		game.players[player_index].gui.left.factoriomaps.destroy()
	end
		game.players[player_index].gui.left.add({type="frame", name="factoriomaps", caption="Factorio Maps", direction="horizontal"})

--help = true
advanced = true
		ui = game.players[player_index].gui.left.factoriomaps

		if (ui.menu_ver1 == nil) then
			ui.add({type="frame", name="menu_ver1",direction="vertical"})

			ui.menu_ver1.add({type="flow", name="menu2", direction = "horizontal"})

			ui.menu_ver1.menu2.add({type="label", caption = "Time:"})
			ui.menu_ver1.menu2.add({type="button", name="setdaytime", caption="Midday"})
			ui.menu_ver1.menu2.add({type="button", name="resetdaytime", caption="Reset"})
			ui.menu_ver1.menu2.add({type="label", name="filler", caption="_____________"})
			ui.menu_ver1.menu2.filler.style.font_color = {r=48,g=75, b=74}
			ui.menu_ver1.menu2.add({type="button", name="advancedbutton", caption="Advanced"})

			if(help) then
				ui.menu_ver1.add({type="label", name="help1", caption = "Use Midday to make brightly lit screenshots,"})
				ui.menu_ver1.add({type="label", name="help2", caption = "then set the time to what it was before with Reset."})
				ui.menu_ver1.help1.style.font_color = {r=1}
				ui.menu_ver1.help2.style.font_color = {r=1}
			end

			ui.menu_ver1.add({type="flow", name="menu3", direction = "horizontal"})
			ui.menu_ver1.menu3.add({type="checkbox", name="maxzoomcheckbox1",state = false, caption = "Maximum zoom in"})
			ui.menu_ver1.menu3.add({type="checkbox", name="maxzoomcheckbox2",state = false, caption = "Maximum zoom out (experimental)"})
			checkboxmaxzoom1 = game.players[player_index].gui.left.factoriomaps.menu_ver1.menu3.maxzoomcheckbox1
			checkboxmaxzoom2 = ui.menu_ver1.menu3.maxzoomcheckbox2

			if(help) then
				ui.menu_ver1.add({type="label", name="help3", caption = "Max zoom in makes you zoom in one extra level."})
				ui.menu_ver1.add({type="label", name="help4", caption = "Max zoom out makes you zoom out one extra level."})
				ui.menu_ver1.add({type="label", name="help5", caption = "Extra zoom out may cause weird screen shots."})
				ui.menu_ver1.help3.style.font_color = {r=1}
				ui.menu_ver1.help4.style.font_color = {r=1}
				ui.menu_ver1.help5.style.font_color = {r=1}
			end
			ui.menu_ver1.add({type="flow", name="menu3a", direction = "horizontal"})
			ui.menu_ver1.menu3a.add({type="checkbox", name="showalt",state=showalt, caption = "Show entity (Alt) info"})
			if(help) then
				ui.menu_ver1.add({type="label", name="help3a", caption = "Alt info shows the function of an assembly building."})
				ui.menu_ver1.help3a.style.font_color = {r=1}
			end
			ui.menu_ver1.add({type="flow", name="menu4", direction = "horizontal"})
			ui.menu_ver1.menu4.add({type="label", name="foldernamelabel", caption = "Folder Name:"})
			ui.menu_ver1.menu4.add({type="textfield", name="foldername"})
			txtFolderName = ui.menu_ver1.menu4.foldername
			ui.menu_ver1.menu4.add({type="button", name="generate", caption="Generate images"})

			if(help) then
				ui.menu_ver1.add({type="label", name="help6", caption = "Press the Generate button to start making the map."})
				ui.menu_ver1.add({type="label", name="help7", caption = "The program will generate a folder name for you"})
				ui.menu_ver1.help6.style.font_color = {r=1}
				ui.menu_ver1.help7.style.font_color = {r=1}
			end


			ui.menu_ver1.add({type="label", name="generatewarning"})
			ui.menu_ver1.add({type="label", name="generatewarning2"})


			if warning then
				ui.menu_ver1.generatewarning.style.font_color = {r=1,b=0, g=0}
				ui.menu_ver1.generatewarning.caption="Warning: On bigger maps, Factorio Maps can take up to 10 minutes and 5 GB of disk space!"
				ui.menu_ver1.generatewarning2.caption="The game will freeze until everything is generated."
			end

			if help then


			end
		end


	--if(ui.menu_ver2 == nil and advanced) then

		ui.add({type="frame", name="menu_ver2", direction="vertical"})

		ui.menu_ver2.add({type="flow", name="menu1", direction = "horizontal"})

		ui.menu_ver2.menu1.add({type="label", name="topleftlabel", caption = "Top left x/y:"})
		ui.menu_ver2.menu1.add({type="textfield", name="toplefttextX", caption=""})
		ui.menu_ver2.menu1.add({type="textfield", name="toplefttextY", caption=""})
		txtTopLeftX = ui.menu_ver2.menu1.toplefttextX
		txtTopLeftY = ui.menu_ver2.menu1.toplefttextY
		ui.menu_ver2.menu1.add({type="button", name="teleport1", caption="tp"})
		ui.menu_ver2.menu1.add({type="button", name="useplayerposition1", caption="pp"})

		ui.menu_ver2.add({type="flow", name="menu2", direction = "horizontal"})
		ui.menu_ver2.menu2.add({type="label", name="bottomrightlabel", caption = "Bottom right x/y:"})
		ui.menu_ver2.menu2.add({type="textfield", name="bottomrighttextX", caption=""})
		ui.menu_ver2.menu2.add({type="textfield", name="bottomrighttextY", caption=""})
		txtBottomRightX = ui.menu_ver2.menu2.bottomrighttextX
		txtBottomRightY = ui.menu_ver2.menu2.bottomrighttextY
		ui.menu_ver2.menu2.add({type="button", name="teleport2", caption="tp"})
		ui.menu_ver2.menu2.add({type="button", name="useplayerposition2", caption="pp"})

		ui.menu_ver2.add({type="flow", name="menu3", direction = "horizontal"})
		ui.menu_ver2.menu3.add({type="button", name="maxdiscovered", caption="Max Size"})
		ui.menu_ver2.menu3.add({type="button", name="cropbase", caption="Crop to Base"})

		ui.menu_ver2.add({type="flow", name="menu3a", direction = "horizontal"})
		ui.menu_ver2.menu3a.add({type="label", caption = "Grid size:"})
		ui.menu_ver2.menu3a.add({type="checkbox", name="gridsizecheckbox1",state = (gridsizeindex==1 and "true" or "false"), caption = "256x256"})
		ui.menu_ver2.menu3a.add({type="checkbox", name="gridsizecheckbox2",state = (gridsizeindex==2 and "true" or "false"), caption = "1024x1024"})
		ui.menu_ver2.menu3a.add({type="checkbox", name="gridsizecheckbox3",state = (gridsizeindex==3 and "true" or "false"), caption = "2048x2048"})
		radiogridsize1 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu3a.gridsizecheckbox1
		radiogridsize2 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu3a.gridsizecheckbox2
		radiogridsize3 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu3a.gridsizecheckbox3
		if(help) then
			ui.menu_ver2.add({type="label", name="help8", caption = "For some people 1024 was lagging, try 256. Use 2048 at own risk."})
			ui.menu_ver2.help8.style.font_color = {r=1}
		end
		ui.menu_ver2.add({type="flow", name="menu4", direction = "horizontal"})
		ui.menu_ver2.menu4.add({type="label", caption = "Ext:"})
		ui.menu_ver2.menu4.add({type="checkbox", name="extensioncheckbox1",state = (extensionindex==1 and "true" or "false"), caption = ".jpg"})
		ui.menu_ver2.menu4.add({type="checkbox", name="extensioncheckbox2",state = (extensionindex==2 and "true" or "false"), caption = ".png (only max zoom in)"})
		ui.menu_ver2.menu4.add({type="checkbox", name="extensioncheckbox3",state = (extensionindex==3 and "true" or "false"), caption = ".png (all)"})
		if(help) then
			ui.menu_ver2.add({type="label", name="help9", caption = "Png gives better quality screenshots, but is (much) bigger in filesize."})
			ui.menu_ver2.help9.style.font_color = {r=1}
		end

		radioextension1 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu4.extensioncheckbox1
		radioextension2 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu4.extensioncheckbox2
		radioextension3 = game.players[player_index].gui.left.factoriomaps.menu_ver2.menu4.extensioncheckbox3

		ui.menu_ver2.add({type="flow", name="menuplayerxy", direction = "horizontal"})
		ui.menu_ver2.menuplayerxy.add({type="button", name="helpbutton", caption = "Help"})
		ui.menu_ver2.menuplayerxy.add({type="label", name="playerxylabel", caption = "Player x/y:"})
		ui.menu_ver2.menuplayerxy.add({type="label", name="playerxy", caption = "0,0"})
	--end
setvalues(player_index)

end
