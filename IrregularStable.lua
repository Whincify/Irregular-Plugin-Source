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

Description: A plugin containing various tools I believe are useful in developing, however they are pretty random. (If you are reading this enjoy my OCD code.)

Writer: Whincify

Created: 12/29/2021

Updated: 12/29/2021

]]

--//Services

local ServerScriptService = game:GetService("ServerScriptService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

--//Datastore

local anchorKey = "anchorSave"
local anchorSave = plugin:GetSetting(anchorKey)
local anchorActive = false

--//Plugin

local Toolbar = plugin:CreateToolbar("Whincify's Plugins")
local ToolbarButton = Toolbar:CreateButton("Irregular Plugin", "Contains various tools useful for developing.","rbxassetid://4458901886")

ToolbarButton.ClickableWhenViewportHidden = true

local Plugin = plugin:CreateDockWidgetPluginGui(
	"Irregular Plugin",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float, -- Window will be initialized in a floating state.
		false,                        -- Window will be initially enabled.
		false,                       -- Don't override the saved enabled/dock state.
		170,                         -- Width of the floating window.
		185,                         -- Height of the floating window.
		165,                          -- Minimum Width
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
	successMessage.Text = "Cleared "..count.." messages from output. (auto-deleting in 5 seconds)"
	successMessage.TextColor3 = Grey
	successMessage.Visible = true
	successMessage.Parent = Output
	local timer = 5
	repeat
		wait(1)
		timer = timer - 1
		successMessage.Text = "Cleared "..count.." messages from output. (auto-deleting in "..timer.." seconds)"
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
		if #selectedObjects > 0 then
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
				end
			end
		else
			createOutput("Model Weld","Please select a model.",Orange)
		end
	end)
	if not success and err then
		createOutput("Model Weld","Model Weld encountered the following error: "..err,Red)
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
