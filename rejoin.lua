-- Script đặt trong ServerScriptService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ClientCheckEvent = Instance.new("RemoteEvent", ReplicatedStorage)
ClientCheckEvent.Name = "ClientCheckEvent"

-- Đường dẫn đến file để lưu thông tin (Cần thay đường dẫn đúng)
local FILE_PATH = "C:\\path\\to\\roblox_info.json"

-- Function để xác định loại client dựa trên một số logic (giả sử chúng ta có một biến môi trường hoặc một file cấu hình để kiểm tra)
local function getClientType()
    -- Giả sử bạn có một file cấu hình để xác định loại client
    local clientTypeFile = "C:\\path\\to\\client_type.txt"
    local file = io.open(clientTypeFile, "r")
    if file then
        local clientType = file:read("*a")
        file:close()
        return clientType:match("^%s*(.-)%s*$")  -- Loại bỏ khoảng trắng đầu và cuối
    end
    return "unknown"
end

-- Function để xử lý thông tin từ client
local function onClientInfoReceived(player, clientInfo)
    local data = {
        player = clientInfo.Name,
        userId = clientInfo.UserId,
        clientType = clientInfo.ClientType,
        platform = clientInfo.Platform,
        timestamp = os.time()
    }

    local jsonData = HttpService:JSONEncode(data)
    
    -- Ghi thông tin vào file
    local file = io.open(FILE_PATH, "w")
    if file then
        file:write(jsonData)
        file:close()
    end
end

-- Kết nối RemoteEvent với function xử lý
ClientCheckEvent.OnServerEvent:Connect(onClientInfoReceived)

-- LocalScript phần gửi thông tin từ client
local function sendClientInfo()
    local player = game.Players.LocalPlayer

    -- Xác định loại client hiện tại
    local clientType = getClientType()

    local clientInfo = {
        Name = player.Name,
        UserId = player.UserId,
        ClientType = clientType,
        Platform = game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC"
    }
    ClientCheckEvent:FireServer(clientInfo)

    -- Tạo và hiển thị GUI
    local PlayerGui = player:WaitForChild("PlayerGui")

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
    frame.Parent = screenGui

    -- Tạo một TextLabel để hiển thị chữ "Mizuhara vision 0.3"
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Mizuhara vision 0.3"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame
end

-- Gọi function khi player vào game và cứ mỗi 3 phút
game.Players.PlayerAdded:Connect(function(player)
    sendClientInfo()
    while true do
        wait(180)  -- 3 phút
        sendClientInfo()
    end
end)
