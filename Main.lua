local getsynassetfromurl = loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/RePendelum/main/getsynassetfromurl.lua"))()
local Scripts = {
	["NAMEHERE"] = {
		["Link"] = "rawlinkhere",
		["Image"] = getsynassetfromurl("https://cdn.discordapp.com/attachments/308098766987329536/959809672372711484/unknown.png"),
		["HatID"] = "id1,id2,etc."
	},
}

local GUI = game:GetObjects("rbxassetid://9260677580")[1]--script.Parent
local MainFrame = GUI.Frame
local Elements = MainFrame.Elements

local Sine = 0
local Toggle = true
local Selected = ""
local setclipboard = setclipboard or print

local function reanimate()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/newnetlessreanimate.lua"))()
	task.wait()
end

MainFrame.Inset.Activated:Connect(function()
	if MainFrame.AbsolutePosition.X < 30 then
		if Toggle then
			game:GetService("TweenService"):Create(MainFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position = UDim2.new(0,-252,0,MainFrame.AbsolutePosition.Y)}):Play()
			MainFrame.Inset.Text = ">"
		else
			game:GetService("TweenService"):Create(MainFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position = UDim2.new(0,0,0,MainFrame.AbsolutePosition.Y)}):Play()
			MainFrame.Inset.Text = "<"
		end
		Toggle = not Toggle
	end
end)

Elements.Reanimate.Activated:Connect(reanimate)
Elements.CopyHats.Activated:Connect(function()
	if Selected and Scripts[Selected] then
		setclipboard(tostring(Scripts[Selected]["HatID"]))
	end
end)
Elements.CopyCredits.Activated:Connect(function()
	setclipboard[[Original Developer - https://discord.id/?prefill=801256997261017100
Remake Main Developer - https://discord.id/?prefill=806621844291584001
Convert Developers - https://discord.id/?prefill=786897804664635400,https://discord.id/?prefill=307781359244541953
getsynassetfromurl function - https://discord.id/?prefill=649302696473395200]]
end)

game:GetService("RunService").RenderStepped:Connect(function()
	Sine += 1; Elements.Pendelum.Rotation = math.cos(Sine/30)*30
end)

spawn(function()
	local dragToggle,dragInput,dragStart,startPos
	local dragSpeed = 0
	local function updateInput(input)
		local Delta = input.Position - dragStart -- 
		if startPos.X.Offset + Delta.X < 30 then
			MainFrame.Position = UDim2.new(0, 0, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			MainFrame.Inset.Visible = true
		else
			MainFrame.Position = UDim2.new(0, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			MainFrame.Inset.Visible = false
		end
	end
	MainFrame.Drag.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)	
		end
	end)
	MainFrame.Drag.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end)

for i,v in pairs(Scripts) do
	local NewClone = Elements.Scroll.Example:Clone()
	NewClone.Visible = true
	NewClone.Name = i
	NewClone.Text = i
	NewClone.Activated:Connect(function()
		if Selected == i then
			reanimate()
			loadstring(game:HttpGet(v["Link"]))()
			Selected = ""
			Elements.Preview.Image = ""
		else
			Selected = i
			Elements.Preview.Image = v["Image"]
		end
	end)
	NewClone.Parent = Elements.Scroll
end

task.spawn(function()
	local function randomString()
		local length = math.random(10,20)
		local array = {}
		for i = 1, length do
			array[i] = string.char(math.random(32, 126))
		end
		return table.concat(array)
	end
	Elements.Pendelum.Pendelum.ZIndex = 3
	GUI.Name = randomString()
	if syn then
		syn.protect_gui(GUI)
		GUI.Parent = game:GetService("CoreGui")
	elseif get_hidden_gui or gethui then
		local hiddenUI = get_hidden_gui or gethui
		GUI.Parent = hiddenUI()
	elseif game:GetService("CoreGui"):FindFirstChild('RobloxGui') then
		GUI.Parent = game:GetService("CoreGui").RobloxGui
	else
		GUI.Parent = game:GetService("CoreGui")
	end
end)
