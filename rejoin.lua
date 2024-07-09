local function reduceLag()
    -- Xóa hiệu ứng và vật cản
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("MeshPart") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("UnionOperation") or obj:IsA("Model") then
            obj:Destroy()
        end
    end

    -- Giảm chất lượng đồ họa
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- Chuyển chế độ đồ họa sang thủ công và đặt mức thấp nhất
    local UserSettings = UserSettings()
    local GameSettings = UserSettings.GameSettings
    GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    GameSettings.GraphicsMode = Enum.GraphicsMode.Manual
end

local function muteSound()
    -- Giảm âm lượng xuống thấp nhất
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
end

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
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundTransparency = 1 -- Đặt trong suốt để chỉ hiển thị hình nền
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    -- Tạo một ImageLabel để làm nền cho menu
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.Position = UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundTransparency = 0 -- Không trong suốt
    imageLabel.Image = "rbxassetid://855088392"
    imageLabel.Parent = frame

    -- Tạo một TextLabel để hiển thị chữ "Mizuhara vision 0.3" với màu sắc cầu vồng
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Mizuhara vision 0.3"
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

-- Gọi function tạo GUI trực tiếp
createGUI()

-- Tự động giảm lag và tắt âm thanh khi script chạy
reduceLag()
muteSound()
