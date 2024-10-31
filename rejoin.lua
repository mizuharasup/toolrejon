local function adjustGraphicsAndMuteSound()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    local success, message = pcall(function()
        local UserSettings = UserSettings()
        local GameSettings = UserSettings.GameSettings
        GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        GameSettings.GraphicsMode = Enum.GraphicsMode.Manual
    end)

    if not success then
        warn("Không thể thay đổi cài đặt đồ họa: " .. tostring(message))
    end

    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") then
            descendant.Volume = 0
        end
    end)
end

adjustGraphicsAndMuteSound()

local runService = game:GetService("RunService")
runService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    if fps > 30 then
        runService.RenderStepped:Wait()
    end
end)

local function createOrUpdateFPSDisplay()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local fpsDisplay = playerGui:FindFirstChild("FPSDisplay")
    if not fpsDisplay then
        fpsDisplay = Instance.new("ScreenGui")
        fpsDisplay.Name = "FPSDisplay"
        fpsDisplay.ResetOnSpawn = false
        fpsDisplay.Parent = playerGui

        local displayFrame = Instance.new("Frame")
        displayFrame.Size = UDim2.new(0, 200, 0, 80)
        displayFrame.Position = UDim2.new(0.5, -100, 0, 10)
        displayFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        displayFrame.BackgroundTransparency = 0.3
        displayFrame.BorderSizePixel = 0
        displayFrame.Parent = fpsDisplay

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0.1, 0)
        frameCorner.Parent = displayFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -20, 0, 30)
        nameLabel.Position = UDim2.new(0, 10, 0, 10)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        nameLabel.TextSize = 20
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Text = player.Name
        nameLabel.Parent = displayFrame

        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(1, -20, 0, 30)
        fpsLabel.Position = UDim2.new(0, 10, 0, 40)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.TextColor3 = Color3.new(1, 1, 1)
        fpsLabel.TextSize = 18
        fpsLabel.Font = Enum.Font.SourceSans
        fpsLabel.Text = "FPS: Calculating..."
        fpsLabel.Parent = displayFrame

        while true do
            fpsLabel.Text = "FPS: " .. math.floor(1 / runService.RenderStepped:Wait())
            wait(1)
        end
    end
end

createOrUpdateFPSDisplay()

local MarketplaceService = game:GetService("MarketplaceService")
local gamePassID = 855088392

local function createOrSlideInAvatarDisplay()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local customUsername = "Mizuhara0.0"

    local slideDisplay = playerGui:FindFirstChild("SlideAvatarDisplay")
    if slideDisplay then
        local avatarFrame = slideDisplay:FindFirstChild("AvatarFrame")
        if avatarFrame then
            avatarFrame:TweenPosition(UDim2.new(1, -160, 1, -70), "Out", "Quad", 0.5, true)
            wait(4)
            avatarFrame:TweenPosition(UDim2.new(1, 0, 1, -70), "In", "Quad", 0.5, true)
            return
        end
    else
        slideDisplay = Instance.new("ScreenGui")
        slideDisplay.Name = "SlideAvatarDisplay"
        slideDisplay.ResetOnSpawn = false
        slideDisplay.Parent = playerGui

        local avatarFrame = Instance.new("Frame")
        avatarFrame.Name = "AvatarFrame"
        avatarFrame.Size = UDim2.new(0, 150, 0, 60)
        avatarFrame.Position = UDim2.new(1, 0, 1, -70)
        avatarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        avatarFrame.BackgroundTransparency = 0.4
        avatarFrame.BorderSizePixel = 0
        avatarFrame.Parent = slideDisplay

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = avatarFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 80, 1, 0)
        nameLabel.Position = UDim2.new(0, 60, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 18
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Text = customUsername
        nameLabel.Parent = avatarFrame

        local success, productInfo = pcall(function()
            return MarketplaceService:GetProductInfo(gamePassID, Enum.InfoType.GamePass)
        end)

        if success and productInfo then
            local avatarImage = Instance.new("ImageLabel")
            avatarImage.Size = UDim2.new(0, 40, 0, 40)
            avatarImage.Position = UDim2.new(0, 5, 0, 10)
            avatarImage.BackgroundTransparency = 1
            avatarImage.Image = "rbxassetid://" .. productInfo.AssetId
            avatarImage.Parent = avatarFrame

            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatarImage
        else
            warn("Không thể tải hình ảnh GamePass: " .. tostring(productInfo))
        end

        avatarFrame:TweenPosition(UDim2.new(1, -160, 1, -70), "Out", "Quad", 0.5, true)
        wait(8)
        avatarFrame:TweenPosition(UDim2.new(1, 0, 1, -70), "In", "Quad", 0.5, true)
    end
end

createOrSlideInAvatarDisplay()
