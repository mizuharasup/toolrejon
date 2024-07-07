local function createGUI()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- Kiểm tra xem GUI đã tồn tại hay chưa
    if PlayerGui:FindFirstChild("MizuharaVisionGUI") then
        return  
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MizuharaVisionGUI"
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Mizuhara Tool Rejoin Vision 0.3"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame
l
    local function updateRainbowColor()
        local hue = tick() % 10 / 10
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        textLabel.TextColor3 = rainbowColor
    end

    game:GetService("RunService").RenderStepped:Connect(updateRainbowColor)
end

createGUI()

local function sendClientInfo()
    local HttpService = game:GetService("HttpService")
    local player = game.Players.LocalPlayer

    local clientType = "unknown"

    local clientInfo = {
        player = player.Name,
        userId = player.UserId,
        clientType = clientType,
        platform = game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC",
        timestamp = os.time()
    }

    local jsonData = HttpService:JSONEncode(clientInfo)

    local FILE_PATH = "C:\\path\\to\\roblox_info.json"

    local success, err = pcall(function()
        local file = io.open(FILE_PATH, "w")
        if file then
            file:write(jsonData)
            file:close()
        else
            warn("Cannot open file: " .. FILE_PATH)
        end
    end)

    if not success then
        warn("Error writing to file: " .. err)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    sendClientInfo()
    while true do
        wait(180)  -- 3 phút
        sendClientInfo()
    end
end)
