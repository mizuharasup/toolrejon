-- Function để tạo và hiển thị GUI với màu sắc cầu vồng và khả năng kéo thả
local function createGUI()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- Kiểm tra xem GUI đã tồn tại hay chưa
    if PlayerGui:FindFirstChild("MizuharaVisionGUI") then
        return  -- Nếu GUI đã tồn tại, thoát function
    end

    -- Tạo một ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MizuharaVisionGUI"
    screenGui.Parent = PlayerGui

    -- Tạo một Frame để chứa các thành phần GUI khác
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    -- Tạo một TextLabel để hiển thị chữ "Mizuhara vision 0.3" với màu sắc cầu vồng
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Mizuhara Tool Rejoin vision 0.3"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame

    -- Function để tạo màu sắc cầu vồng cho TextLabel
    local function updateRainbowColor()
        local hue = tick() % 10 / 10
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        textLabel.TextColor3 = rainbowColor
    end

    -- Vòng lặp để cập nhật màu sắc cầu vồng mỗi frame
    game:GetService("RunService").RenderStepped:Connect(updateRainbowColor)
end

-- Gọi function tạo GUI trực tiếp vì Parent là PlayerGui không cần exploit protection
createGUI()

-- Phần gửi thông tin từ client
local function sendClientInfo()
    local HttpService = game:GetService("HttpService")
    local player = game.Players.LocalPlayer

    -- Xác định loại client hiện tại
    local clientType = "unknown"  -- Có thể thay thế bằng logic xác định loại client nếu cần

    local clientInfo = {
        player = player.Name,
        userId = player.UserId,
        clientType = clientType,
        platform = game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC",
        timestamp = os.time()
    }

    local jsonData = HttpService:JSONEncode(clientInfo)

    -- Đường dẫn đến file để lưu thông tin (Cần thay đường dẫn đúng)
    local FILE_PATH = "C:\\path\\to\\roblox_info.json"

    -- Ghi thông tin vào file
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

-- Gọi function khi player vào game và cứ mỗi 3 phút
game.Players.PlayerAdded:Connect(function(player)
    sendClientInfo()
    while true do
        wait(180)  -- 3 phút
        sendClientInfo()
    end
end)
