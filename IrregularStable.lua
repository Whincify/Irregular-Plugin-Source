--[[
                                                            .---.                   
.--.                      __.....__                         |   |                   
|__|                  .-''         '.     .--./)            |   |                   
.--..-,.--. .-,.--.  /     .-''"'-.  `.  /.''\\             |   |          .-,.--.  
|  ||  .-. ||  .-. |/     /________\   \| |  | |            |   |    __    |  .-. | 
|  || |  | || |  | ||                  | \`-' /      _    _ |   | .:--.'.  | |  | | 
|  || |  | || |  | |\    .-------------' /("'`      | '  / ||   |/ |   \ | | |  | | 
|  || |  '- | |  '-  \    '-.____...---. \ '---.   .' | .' ||   |`" __ | | | |  '-  
|__|| |     | |       `.             .'   /'""'.\  /  | /  ||   | .'.''| | | |      
    | |     | |         `''-...... -'    ||     |||   `'.  |'---'/ /   | |_| |      
    |_|     |_|                          \'. __// '   .'|  '/    \ \._,\ '/|_|      
                        .---.             `'---'   `-'  `--'      `--'  `"          
_________   _...._      |   |                   .--.   _..._                        
\        |.'      '-.   |   |            .--./) |__| .'     '.                      
 \        .'```'.    '. |   |           /.''\\  .--..   .-.   .                     
  \      |       \     \|   |          | |  | | |  ||  '   '  |                     
   |     |        |    ||   |   _    _  \`-' /  |  ||  |   |  |                     
   |      \      /    . |   |  | '  / | /("'`   |  ||  |   |  |                     
   |     |\`'-.-'   .'  |   | .' | .' | \ '---. |  ||  |   |  |                     
   |     | '-....-'`    |   | /  | /  |  /'""'.\|__||  |   |  |                     
  .'     '.             '---'|   `'.  | ||     ||   |  |   |  |                     
'-----------'                '   .'|  '/\'. __//    |  |   |  |                     
                              `-'  `--'  `'---'     '--'   '--'                     

Name: Irregular Plugin

Description: A plugin containing various tools I believe are useful in developing, however they are pretty random.

Writer: Whincify

Created: 12/29/2021

Updated: 12/30/2021

]]

--//Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CoreGui = game:GetService("CoreGui")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

--//Datastore

local anchorKey = "anchorSave"
local anchorSave = plugin:GetSetting(anchorKey)
local anchorActive = false

local transparencyKey = "transparencySave"
local transparencySave = plugin:GetSetting(transparencyKey)

local thicknessKey = "thicknessSave"
local thicknessSave = plugin:GetSetting(thicknessKey)

--//Plugin

local DevVersion = false
local Toolbar
local ToolbarButton

if (DevVersion) then
	Toolbar = plugin:CreateToolbar("Whincify's DEV Plugins")
	ToolbarButton = Toolbar:CreateButton("Irregular Plugin DEV", "Contains various tools useful for developing.","rbxassetid://4458901886")
else
	Toolbar = plugin:CreateToolbar("Whincify's Plugins")
	ToolbarButton = Toolbar:CreateButton("Irregular Plugin", "Contains various tools useful for developing.","rbxassetid://4458901886")
end

ToolbarButton.ClickableWhenViewportHidden = true

local Plugin = plugin:CreateDockWidgetPluginGui(
	"Irregular Plugin",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		false,
		false,
		170,
		185,
		165,
		185
	)                         
)

Plugin.Title = "Irregular Plugin"
Plugin.Name = "Irregular Plugin"

--//UI

local MainGui = script.IrregularGui:Clone()
MainGui.Parent = Plugin

local MainFrame = MainGui.Tools
local TitleBar = MainFrame.TitleBar
local OutputBar = MainFrame.OutputBar
local FooterBar = MainFrame.FooterBar

local AutoAnchor = MainFrame.AutoAnchor
local CameraToPart = MainFrame["Camera-To-Part"]
local DirectoryNumberer = MainFrame["Directory Numberer"]
local GhostModel = MainFrame["Ghost Model"]
local ModelWeld = MainFrame["Model Weld"]
local TextureTransfer = MainFrame["Texture Transfer"]
local CustomSelection = MainFrame["Custom Selection"]
local ScriptRemover = MainFrame["Script Remover"]
local GameOrganizer = MainFrame["Game Organizer"]
local UnionColorer = MainFrame["Union Colorer"]
local Output = MainFrame.Output.ScrollingFrame
local SampleText = Output.SampleText

--//Variables

local Red = Color3.fromRGB(220, 52, 52)
local Orange = Color3.fromRGB(255, 162, 32)
local Grey = Color3.fromRGB(204, 204, 204)

--//Initialize

function updateOrder(exempt)
	for _, child in pairs(Output:GetChildren()) do
		if ((child.Name == "outputMessage") and (child ~= exempt)) then
			child.LayoutOrder = child.LayoutOrder + 1
		end
	end
end

function createOutput(func,message,color)
	if ((func) and (message)) then
		func = string.upper(func)
		message = tostring(message)
		local newMessage = SampleText:Clone()
		updateOrder(newMessage)
		newMessage.Name = "outputMessage"
		newMessage.Text = "["..func.."] "..message
		newMessage.TextColor3 = color or Grey
		newMessage.Visible = true
		newMessage.Parent = Output
	end
end

if (anchorSave) then
	anchorActive = true
	AutoAnchor.Container.CheckBox.CheckImage.Visible = true
	createOutput("Auto Anchor","Auto Anchor has been automatically enabled from save.")
elseif (not anchorSave) then
	anchorActive = false
end

ToolbarButton.Click:Connect(function()
	Plugin.Enabled = not Plugin.Enabled
	if (Plugin.Enabled) then
		MainGui.Visible = true
	elseif (not Plugin.Enabled) then
		MainGui.Visible = false
	end
end)

--//Functionality

function clearOutput()
	local count = #Output:GetChildren() - 3
	if (count < 0) then
		count = 0
	end
	for _, child in pairs(Output:GetChildren()) do
		if (child.Name == "outputMessage") then
			child:Destroy()
		end
	end
	local successMessage = SampleText:Clone()
	local messagesText = "message"
	if (count > 1) then
		messagesText = "messages"
	end
	successMessage.Text = "Cleared "..count.." "..messagesText.." from output. (auto-deleting in 5 seconds)"
	if (count == 0) then
		successMessage.Text = "There are no messages to clear. (auto-deleting in 5 seconds)"
	end
	successMessage.TextColor3 = Grey
	successMessage.Visible = true
	successMessage.Parent = Output
	local timer = 5
	repeat
		wait(1)
		timer = timer - 1
		if (count == 0) then
			successMessage.Text = "There are no messages to clear. (auto-deleting in "..timer.." seconds)"
		elseif (count > 0) then
			successMessage.Text = "Cleared "..count.." "..messagesText.." from output. (auto-deleting in "..timer.." seconds)"
		end
	until (timer == 0)
	successMessage:Destroy()
end

function createWaypoint(waypoint)
	if (waypoint) then
		waypoint = tostring(waypoint)
		ChangeHistoryService:SetWaypoint(waypoint)
	end
end

function anchor(part)
	part.Anchored = true
	createWaypoint('Anchored new instance "'..part.Name..'".')
end

function autoAnchor()
	if (not anchorActive) then
		anchorActive = true
		AutoAnchor.Container.CheckBox.CheckImage.Visible = true
		createOutput("Auto Anchor","Auto Anchor is now enabled. All new parts will be anchored automatically.")
		plugin:SetSetting(anchorKey, true)
	elseif (anchorActive) then
		anchorActive = false
		AutoAnchor.Container.CheckBox.CheckImage.Visible = false
		createOutput("Auto Anchor","Auto Anchor has been disabled. All new parts will need anchored manually.")
		plugin:SetSetting(anchorKey, false)
	end
end

function cameraPart()
	local success, err = pcall(function()
		local part = Instance.new("Part",workspace)
		part.Name = "CameraPosition"
		part.CFrame = workspace.Camera.CFrame
	end)
	if success then
		createWaypoint("Camera To Part","Created camera part at"..tostring(workspace.Camera.CFrame))
		createOutput("Camera To Part","Succesfully created a camera part.")
	else
		createOutput("Camera To Part","Something went wrong, please try again.",Red)
	end
end

function numberer()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects == 1 then
			for i, object in pairs(selectedObjects) do
				if (object:GetChildren()) and (#object:GetChildren() > 0) then
					local LastNumber = 0
					for _, child in pairs(object:GetChildren()) do
						child.Name = tostring(LastNumber+1)
						LastNumber = LastNumber + 1
					end
					createOutput("Directory Numberer","Numbered "..tostring(#object:GetChildren()).." children of directory "..object.Name)
					createWaypoint("Directory Numberer","Numbered "..tostring(#object:GetChildren()).." children of directory "..object.Name)
				elseif (#object:GetChildren() == 0) then
					createOutput("Directory Numberer","Directory must have children to number.",Orange)
				end
			end
		elseif #selectedObjects == 0 then
			createOutput("Directory Numberer","Please select a directory.",Orange)
		elseif #selectedObjects > 1 then
			createOutput("Directory Numberer","Please select only one directory at a time.",Orange)
		end
	end)
	if not success and err then
		createOutput("Directory Numberer","Directory Numberer encountered the following error: "..err,Red)
	end
end

function ghostCreate()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects == 1 then
			for i, object in pairs(selectedObjects) do
				if (object:IsA("Model")) then
					if (object:GetChildren()) and (#object:GetChildren() > 0) and (object:IsA("Model")) then
						for _, child in pairs(object:GetDescendants()) do
							if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
								child.CanCollide = false
								child.Transparency = 1
							end
						end
						createOutput("Ghost Model","Ghosted "..tostring(#object:GetChildren()).." children of "..object.Name..".")
						createWaypoint("Ghost Model","Ghosted "..tostring(#object:GetChildren()).." children of "..object.Name..".")
					elseif (#object:GetChildren() == 0) then
						createOutput("Ghost Model","Model must have children to ghost.",Orange)
					end
				else
					createOutput("Ghost Model","Ghost Model only works with model instances.",Orange)
				end
			end
		elseif #selectedObjects == 0 then
			createOutput("Ghost Model","Please select a model.",Orange)
		elseif #selectedObjects > 1 then
			createOutput("Ghost Model","Please select only one model at a time.",Orange)
		end
	end)
	if not success and err then
		createOutput("Ghost Model","Ghost Model encountered the following error: "..err,Red)
	end
end

function ghostRemove()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects == 1 then
			for i, object in pairs(selectedObjects) do
				if (object:IsA("Model")) then
					if (object:GetChildren()) and (#object:GetChildren() > 0) and (object:IsA("Model")) then
						for _, child in pairs(object:GetDescendants()) do
							if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
								child.CanCollide = true
								child.Transparency = 0
							end
						end
						createOutput("Ghost Model","Ghosted "..tostring(#object:GetChildren()).." children of "..object.Name..".")
						createWaypoint("Ghost Model","Ghosted "..tostring(#object:GetChildren()).." children of "..object.Name..".")
					elseif (#object:GetChildren() == 0) then
						createOutput("Ghost Model","Model must have children to ghost.",Orange)
					end
				else
					createOutput("Ghost Model","Ghost Model only works with model instances.",Orange)
				end
			end
		elseif #selectedObjects == 0 then
			createOutput("Ghost Model","Please select a model.",Orange)
		elseif #selectedObjects > 1 then
			createOutput("Ghost Model","Please select only one model at a time.",Orange)
		end
	end)
	if not success and err then
		createOutput("Ghost Model","Ghost Model encountered the following error: "..err,Red)
	end
end

function weld()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects == 1 then
			for i, object in pairs(selectedObjects) do
				if object:IsA("Model") then
					if not object.PrimaryPart then
						createOutput("Model Weld","Model Weld requires the model to have a primary part.",Orange)
					elseif object.PrimaryPart then
						local PrimaryPart = object.PrimaryPart
						for i, existingweld in pairs(PrimaryPart:GetChildren()) do
							if existingweld:IsA("WeldConstraint") or existingweld:IsA("Weld") then
								existingweld:Destroy()
							end
						end
						local WeldsCreated = 0
						for i, part in pairs(object:GetDescendants()) do
							if part:IsA("Part") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") or part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
								local Weld = Instance.new("WeldConstraint",PrimaryPart)
								Weld.Part0 = part
								Weld.Part1 = PrimaryPart
								WeldsCreated = WeldsCreated + 1
								part.Anchored = false
							end
						end
						PrimaryPart.Anchored = true
						createOutput("Model Weld","Successfully created "..tostring(WeldsCreated).." WeldConstraints for "..object.Name)
						createWaypoint("Created "..tostring(WeldsCreated).." WeldConstraints for "..object.Name)
					end
				else
					createOutput("Model Weld","Model Weld only works with model instances.",Orange)
				end
			end
		elseif #selectedObjects == 0 then
			createOutput("Model Weld","Please select a model.",Orange)
		elseif #selectedObjects > 1 then
			createOutput("Model Weld","Please select only one model at a time.",Orange)
		end
	end)
	if not success and err then
		createOutput("Model Weld","Model Weld encountered the following error: "..err,Red)
	end
end

function transfer()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects == 2 then
			local hasTexture
			local needsTexture
			for _, object in pairs(selectedObjects) do
				if ((object:FindFirstChildOfClass("Decal")) or (object:FindFirstChildOfClass("Texture"))) then
					if (not hasTexture) then
						hasTexture = object
					elseif (hasTexture) then
						createOutput("Texture Transfer","Both of the selected instances already have a texture or decal.",Orange)
					end
				else
					if (not needsTexture) then
						needsTexture = object
					elseif (needsTexture) then
						createOutput("Texture Transfer","Neither of the selected instances have textures or decals.",Orange)
					end
				end
			end
			if (hasTexture) and (needsTexture) then
				local decalText = "decal"
				local textureText = "texture"
				local countDecal = 0
				local countTexture = 0
				for _, child in pairs(hasTexture:GetChildren()) do
					if ((child:IsA("Decal")) or (child:IsA("Texture"))) then
						child:Clone().Parent = needsTexture
						if (child.ClassName == "Decal") then
							countDecal = countDecal + 1
						elseif (child.ClassName == "Texture") then
							countTexture = countTexture + 1
						end
					end
				end
				if ((countDecal > 1) or (countDecal == 0)) then
					decalText = "decals"
				end
				if ((countTexture > 1) or (countTexture == 0)) then
					textureText = "textures"
				end
				createOutput("Texture Transfer","Successfully transfered "..countTexture.." "..textureText.." and "..countDecal.." "..decalText.." from "..hasTexture.Name.." to "..needsTexture.Name..".")
				createWaypoint("Successfully transfered "..countTexture.." "..textureText.." and "..countDecal.." "..decalText.." from "..hasTexture.Name.." to "..needsTexture.Name..".")
			else
				createOutput("Texture Transfer","Transfer failed, please read the previous outputs and try again.",Orange)
			end
		else
			createOutput("Texture Transfer","Please only select 2 instances.",Orange)
		end
	end)
	if not success and err then
		createOutput("Texture Transfer","Texture Transfer encountered the following error: "..err,Red)
	end
end

CoreGui:WaitForChild("DraggerUI").ChildAdded:Connect(function(child)
	if ((child.Name == "HoverBox") or (child:IsA("SelectionBox"))) then
		child.Transparency = tonumber(CustomSelection.Container.TransparencyBox.Text) or 0
		child.LineThickness = tonumber(CustomSelection.Container.ThicknessBox.Text) or 0.15
	end
end)

function updateSelection()
	local Transparency = tonumber(CustomSelection.Container.TransparencyBox.Text) or 0
	local Thickness = tonumber(CustomSelection.Container.ThicknessBox.Text) or 0.15

	CoreGui:WaitForChild("MaterialFlipBox").Transparency = Transparency
	CoreGui:WaitForChild("MaterialFlipBox").LineThickness = Thickness

	createOutput("Custom Selection","Selection box settings have been updated to the following: Transparency: "..Transparency..", Thickness: "..Thickness)
end

function removeScripts()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects > 0 then
			local scriptsRemoved = 0
			for i, object in pairs(selectedObjects) do
				for _, child in pairs(object:GetChildren()) do
					if ((child:IsA("Script")) or (child:IsA("ModuleScript")) or (child:IsA("LocalScript"))) then
						scriptsRemoved = scriptsRemoved + 1
						child:Destroy()
					end
				end
			end
			if (scriptsRemoved == 0) then
				local instanceText = "instance"
				if (#selectedObjects > 1) then
					instanceText = "instances"
				end
				createOutput("Script Remover","Searched "..#selectedObjects.." "..instanceText.." and found 0 scripts to remove.")
			elseif (scriptsRemoved > 0) then
				local scriptsText = "script"
				if (scriptsRemoved > 1) then
					scriptsText = "scripts"
				end
				createOutput("Script Remover","Removed "..scriptsRemoved.." "..scriptsText.." from "..#selectedObjects.." instances.")
				createWaypoint("Script Remover","Removed "..scriptsRemoved.." "..scriptsText.." from "..#selectedObjects.." instances.")
			end
		elseif #selectedObjects == 0 then
			createOutput("Script Remover","Please select instances to check and remove scripts from.",Orange)
		end
	end)
	if not success and err then
		createOutput("Script Remover","Script Remover encountered the following error: "..err,Red)
	end
end

local PartsFolder = "Part Folder"
local MeshsFolder = "Mesh Folder"
local ScriptsFolder = "Script Folder"
local LocalScriptsFolder = "LocalScript Folder"
local ModuleScriptsFolder = "ModuleScript Folder"
local UnionsFolder = "Union Folder"

function organize()
	local assetsOrganized = 0
	for _, child in pairs(workspace:GetChildren(),ReplicatedStorage:GetChildren(),ServerScriptService:GetChildren()) do
		if (child:IsA("Part")) and (child.Name == "Part") then
			if (not workspace:FindFirstChild(PartsFolder)) then
				Instance.new("Folder",workspace).Name = PartsFolder
			end
			child.Parent = workspace[PartsFolder]
			assetsOrganized = assetsOrganized + 1
		elseif (child:IsA("MeshPart")) and (child.Name == "MeshPart") then
			if (not workspace:FindFirstChild(MeshsFolder)) then
				Instance.new("Folder",workspace).Name = MeshsFolder
			end
			child.Parent = workspace[MeshsFolder]
			assetsOrganized = assetsOrganized + 1
		elseif (child:IsA("Script")) and (child.Name == "Script") then
			if (not ServerScriptService:FindFirstChild(ScriptsFolder)) then
				Instance.new("Folder",ServerScriptService).Name = ScriptsFolder
			end
			child.Parent = ServerScriptService[ScriptsFolder]
			assetsOrganized = assetsOrganized + 1
		elseif (child:IsA("LocalScript")) and (child.Name == "LocalScript") then
			if (not workspace:FindFirstChild(LocalScriptsFolder)) then
				Instance.new("Folder",workspace).Name = LocalScriptsFolder
			end
			child.Parent = workspace[LocalScriptsFolder]
			assetsOrganized = assetsOrganized + 1
		elseif (child:IsA("ModuleScript")) and (child.Name == "ModuleScript") then
			if (not ReplicatedStorage:FindFirstChild(ModuleScriptsFolder)) then
				Instance.new("Folder",ReplicatedStorage).Name = ModuleScriptsFolder
			end
			child.Parent = ReplicatedStorage[ModuleScriptsFolder]
			assetsOrganized = assetsOrganized + 1
		elseif (child:IsA("UnionOperation")) and ((child.Name == "UnionOperation") or (child.Name == "Union")) then
			if (not workspace:FindFirstChild(UnionsFolder)) then
				Instance.new("Folder",workspace).Name = UnionsFolder
			end
			child.Parent = workspace[UnionsFolder]
			assetsOrganized = assetsOrganized + 1
		end
	end
	if (assetsOrganized > 0) then
		local assetsText = "asset"
		if (assetsOrganized > 1) then
			assetsText = "assets"
		end
		createOutput("Game Organizer",assetsText.." instances were organized.",Orange)
	elseif (assetsOrganized == 0) then
		createOutput("Game Organizer","There were no instances found to organize.",Orange)
	end
end

function colorUnion()
	local selectedObjects = Selection:Get()
	local success, err = pcall(function()
		if #selectedObjects > 0 then
			local unionsColored = 0
			local excludedParts = 0
			local coloredPart
			for i, object in pairs(selectedObjects) do
				if (object:IsA("Part")) then
					coloredPart = object
				end
			end
			if (coloredPart) then
				local unionText = "union"
				if ((#selectedObjects - 1) > 1) then
					unionText = "unions"
				end
				for _, selected in pairs(selectedObjects) do
					if ((selected:IsA("UnionOperation")) and (selected ~= coloredPart)) then
						selected.UsePartColor = true
						selected.Color = coloredPart.Color
						unionsColored = unionsColored + 1
					elseif ((not selected:IsA("UnionOperation")) and (selected ~= coloredPart)) then
						excludedParts = excludedParts + 1
					end
				end
				if (excludedParts > 0) then
					createOutput("Union Colorer","Recolored "..unionsColored.." "..unionText..". "..excludedParts.." instances were also selected but weren't unions.")
					createWaypoint("Union Colorer","Recolored "..unionsColored.." "..unionText..". "..excludedParts.." instances were also selected but weren't unions.")
				else
					createOutput("Union Colorer","Recolored "..unionsColored.." "..unionText..".")
					createWaypoint("Union Colorer","Recolored "..unionsColored.." "..unionText..".")
				end
			elseif (not coloredPart) then
				createOutput("Union Colorer","Please include a part instance in selection to copy color from.",Orange)
			end
		elseif #selectedObjects == 0 then
			createOutput("Union Colorer","Please select at least one union to color, as well as a part to copy the color of.",Orange)
		end
	end)
	if not success and err then
		createOutput("Union Colorer","Union Colorer encountered the following error: "..err,Red)
	end
end

AutoAnchor.Container.CheckBox.MouseButton1Click:Connect(function()
	autoAnchor()
end)

CameraToPart.Container.TextButton.MouseButton1Click:Connect(function()
	cameraPart()
end)

DirectoryNumberer.Container.TextButton.MouseButton1Click:Connect(function()
	numberer()
end)

GhostModel.Container.CreateButton.MouseButton1Click:Connect(function()
	ghostCreate()
end)

GhostModel.Container.RemoveButton.MouseButton1Click:Connect(function()
	ghostRemove()
end)

ModelWeld.Container.TextButton.MouseButton1Click:Connect(function()
	weld()
end)

TextureTransfer.Container.TextButton.MouseButton1Click:Connect(function()
	transfer()
end)

if ((transparencySave) or (thicknessSave)) then
	createOutput("Custom Selection","Selection settings have been automatically updated from save.")
end

local oldTransparency = 0

if (transparencySave) then
	CustomSelection.Container.TransparencyBox.Text = transparencySave
end

CustomSelection.Container.TransparencyBox.MouseEnter:Connect(function()
	CustomSelection.Container.TransparencyBox.Text = ""
end)

CustomSelection.Container.TransparencyBox.MouseLeave:Connect(function()
	if (not tonumber(CustomSelection.Container.TransparencyBox.Text)) then
		CustomSelection.Container.TransparencyBox.Text = oldTransparency
	end
end)

CustomSelection.Container.TransparencyBox:GetPropertyChangedSignal("Text"):Connect(function(transparency)
	transparency = CustomSelection.Container.TransparencyBox.Text
	if ((tonumber(transparency) == oldTransparency) or (transparency == "") or (not transparency)) then
		return
	end
	if (tonumber(transparency)) then
		oldTransparency = transparency
		plugin:SetSetting(transparencyKey, transparency)
		updateSelection()
	else
		CustomSelection.Container.TransparencyBox.Text = oldTransparency
		createOutput("Custom Selection",'Attempted to set transparency value to '..typeof(transparency)..', and the only accepted type is "number".',Orange)
	end
end)

local oldThickness = 0.15

if (thicknessSave) then
	CustomSelection.Container.ThicknessBox.Text = thicknessSave
end

CustomSelection.Container.ThicknessBox.MouseEnter:Connect(function()
	CustomSelection.Container.ThicknessBox.Text = ""
end)

CustomSelection.Container.ThicknessBox.MouseLeave:Connect(function()
	if (not tonumber(CustomSelection.Container.ThicknessBox.Text)) then
		CustomSelection.Container.ThicknessBox.Text = oldThickness
	end
end)

CustomSelection.Container.ThicknessBox:GetPropertyChangedSignal("Text"):Connect(function(thickness)
	thickness = CustomSelection.Container.ThicknessBox.Text
	if ((tonumber(thickness) == oldThickness) or (thickness == "") or (not thickness)) then
		return
	end
	if (tonumber(thickness)) then
		oldThickness = thickness
		plugin:SetSetting(thicknessKey, thickness)
		updateSelection()
	else
		CustomSelection.Container.ThicknessBox.Text = oldThickness
		createOutput("Custom Selection",'Attempted to set thickness value to '..typeof(thickness)..', and the only accepted type is "number".',Orange)
	end
end)

CustomSelection.Container.TextButton.MouseButton1Click:Connect(function()
	CustomSelection.Container.ThicknessBox.Text = 0.15
	CustomSelection.Container.TransparencyBox.Text = 0
end)

ScriptRemover.Container.TextButton.MouseButton1Click:Connect(function()
	removeScripts()
end)

GameOrganizer.Container.TextButton.MouseButton1Click:Connect(function()
	organize()
end)

UnionColorer.Container.TextButton.MouseButton1Click:Connect(function()
	colorUnion()
end)

OutputBar.TextButton.MouseButton1Click:Connect(function()
	clearOutput()
end)

workspace.ChildAdded:Connect(function(child)
	if ((anchorActive) and (child:IsA("Part") or child:IsA("WedgePart") or child:IsA("CornerWedgePart") or child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("UnionOperation"))) then
		if (not anchorActive) then
			return
		elseif (anchorActive) then
			anchor(child)
		end
	end
end)
