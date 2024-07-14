local DataStoreService = game:GetService("DataStoreService")
local lagReductionStore = DataStoreService:GetDataStore("LagReductionSettings")

local function reduceLag()
    -- Ẩn hiệu ứng và vật cản
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("MeshPart") then
            obj.Transparency = 1
            obj.Enabled = false
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
            obj.Transparency = 1
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("UnionOperation") or obj:IsA("Model") then
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1
                end
            end
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

local function restoreSettings()
    -- Khôi phục lại các cài đặt ban đầu của game (cần được tùy chỉnh phù hợp với cài đặt mặc định của game)
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

    -- Khôi phục chế độ đồ họa tự động
    local UserSettings = UserSettings()
    local GameSettings = UserSettings.GameSettings
    GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
    GameSettings.GraphicsMode = Enum.GraphicsMode.Automatic

    -- Hiển thị lại các đối tượng đã ẩn
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("MeshPart") then
            obj.Transparency = 0
            obj.Enabled = true
        elseif obj:IsA("BasePart") then
            obj.Transparency = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0
        elseif obj:IsA("UnionOperation") or obj:IsA("Model") then
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0
                end
            end
        end
    end
end

local function muteSound()
    -- Giảm âm lượng xuống thấp nhất
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
end

local function unmuteSound()
    -- Khôi phục âm lượng
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 1
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
    textLabel.Size = UDim2.new(1, 0, 0.2, 0)
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

    -- Tạo một nút để bật chế độ giảm lag
    local enableButton = Instance.new("TextButton")
    enableButton.Size = UDim2.new(0, 200, 0, 50)
    enableButton.Position = UDim2.new(0.5, -100, 0.4, -25)
    enableButton.Text = "Enable Lag Reduction"
    enableButton.Parent = frame

    -- Tạo một nút để tắt chế độ giảm lag
    local disableButton = Instance.new("TextButton")
    disableButton.Size = UDim2.new(0, 200, 0, 50)
    disableButton.Position = UDim2.new(0.5, -100, 0.7, -25)
    disableButton.Text = "Disable Lag Reduction"
    disableButton.Parent = frame

    local function saveLagReductionSetting(isEnabled)
        local success, errorMessage = pcall(function()
            lagReductionStore:SetAsync(tostring(player.UserId), isEnabled)
        end)
        if not success then
            warn("Failed to save lag reduction setting: " .. errorMessage)
        end
    end

    local function loadLagReductionSetting()
        local success, isEnabled = pcall(function()
            return lagReductionStore:GetAsync(tostring(player.UserId))
        end)
        if success then
            return isEnabled
        else
            warn("Failed to load lag reduction setting")
            return false
        end
    end

    local function toggleLagReduction(isEnabled)
        if isEnabled then
            reduceLag()
            muteSound()
            enableButton.Visible = false
            disableButton.Visible = true
        else
            restoreSettings()
            unmuteSound()
            enableButton.Visible = true
            disableButton.Visible = false
        end
        saveLagReductionSetting(isEnabled)
    end

    enableButton.MouseButton1Click:Connect(function()
        toggleLagReduction(true)
    end)

    disableButton.MouseButton1Click:Connect(function()
        toggleLagReduction(false)
    end)

    local isLagReductionEnabled = loadLagReductionSetting()
    if isLagReductionEnabled == nil then
        isLagReductionEnabled = false
    end
    toggleLagReduction(isLagReductionEnabled)
end

-- Gọi function tạo GUI trực tiếp
createGUI()
