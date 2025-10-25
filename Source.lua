local XKHax = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

XKHax.Config = {
    BaseYPosition = 20,
    VerticalSpacing = 90,
    DefaultDuration = 4,
    DisplayOrder = 10,
    SoundVolume = 0.8
}

XKHax.ActiveNotifications = {}
XKHax.NotificationCounter = 0

function XKHax._cleanupInactiveNotifications()
    for id, notificationData in pairs(XKHax.ActiveNotifications) do
        if not notificationData.gui or not notificationData.gui.Parent then
            XKHax.ActiveNotifications[id] = nil
        end
    end
end

function XKHax._calculateNotificationPosition()
    XKHax._cleanupInactiveNotifications()
    
    local visibleCount = 0
    for _, notificationData in pairs(XKHax.ActiveNotifications) do
        visibleCount = visibleCount + 1
    end
    
    return XKHax.Config.BaseYPosition + (visibleCount * XKHax.Config.VerticalSpacing)
end

function XKHax._createNotificationGUI(playerGui, startYPosition)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XKHax_Notification_" .. os.time()
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = XKHax.Config.DisplayOrder
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    return screenGui
end

function XKHax._createMainFrame(screenGui, startYPosition, borderColor)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainNotification"
    mainFrame.Size = UDim2.new(0, 280, 0, 80)
    mainFrame.Position = UDim2.new(1, 10, 0, startYPosition)
    mainFrame.AnchorPoint = Vector2.new(1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.6
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 2
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainFrame
    
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Name = "BorderStroke"
    borderStroke.Color = borderColor
    borderStroke.Thickness = 4
    borderStroke.Transparency = 0.4
    borderStroke.Parent = mainFrame
    
    return mainFrame, borderStroke
end

function XKHax._createIconSection(mainFrame, iconImage, borderColor)
    local iconCircle = Instance.new("Frame")
    iconCircle.Name = "IconCircle"
    iconCircle.Size = UDim2.new(0, 50, 0, 50)
    iconCircle.Position = UDim2.new(0, 15, 0, 15)
    iconCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    iconCircle.BackgroundTransparency = 0.5
    iconCircle.BorderSizePixel = 0
    iconCircle.ZIndex = 3
    iconCircle.Parent = mainFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconCircle
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Name = "IconStroke"
    iconStroke.Color = borderColor
    iconStroke.Thickness = 2
    iconStroke.Transparency = 0.3
    iconStroke.Parent = iconCircle
    
    local iconImageLabel = Instance.new("ImageLabel")
    iconImageLabel.Name = "IconImage"
    iconImageLabel.Size = UDim2.new(1.1, 0, 1.1, 0)
    iconImageLabel.Position = UDim2.new(-0.05, 0, -0.05, 0)
    iconImageLabel.BackgroundTransparency = 1
    iconImageLabel.Image = iconImage
    iconImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    iconImageLabel.ScaleType = Enum.ScaleType.Fit
    iconImageLabel.ZIndex = 4
    iconImageLabel.Parent = iconCircle
    
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(1, 0)
    imageCorner.Parent = iconImageLabel
    
    return iconCircle
end

function XKHax._createContentSection(mainFrame, title, subMessage, message)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -75, 1, -20)
    contentFrame.Position = UDim2.new(0, 75, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 3
    contentFrame.Parent = mainFrame
    
    local mainMessage = Instance.new("TextLabel")
    mainMessage.Name = "MainMessage"
    mainMessage.Size = UDim2.new(1, 0, 0, 25)
    mainMessage.Position = UDim2.new(0, 0, 0, 0)
    mainMessage.BackgroundTransparency = 1
    mainMessage.Text = title or "Auto Rooms"
    mainMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainMessage.TextSize = 17
    mainMessage.Font = Enum.Font.RobotoCondensed
    mainMessage.TextXAlignment = Enum.TextXAlignment.Left
    mainMessage.TextYAlignment = Enum.TextYAlignment.Top
    mainMessage.TextWrapped = true
    mainMessage.TextTruncate = Enum.TextTruncate.None
    mainMessage.ZIndex = 4
    mainMessage.Parent = contentFrame
    
    local subTitle = Instance.new("TextLabel")
    subTitle.Name = "SubTitle"
    subTitle.Size = UDim2.new(1, 0, 0, 18)
    subTitle.Position = UDim2.new(0, 0, 0, 25)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = subMessage or "Entity Detection"
    subTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    subTitle.TextSize = 15
    subTitle.Font = Enum.Font.RobotoCondensed
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.TextYAlignment = Enum.TextYAlignment.Top
    subTitle.TextWrapped = true
    subTitle.TextTruncate = Enum.TextTruncate.None
    subTitle.ZIndex = 4
    subTitle.Parent = contentFrame
    
    local detailMessage = Instance.new("TextLabel")
    detailMessage.Name = "DetailMessage"
    detailMessage.Size = UDim2.new(1, 0, 0, 20)
    detailMessage.Position = UDim2.new(0, 0, 0, 43)
    detailMessage.BackgroundTransparency = 1
    detailMessage.Text = message or "Entidade detectada! Procurando armario..."
    detailMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    detailMessage.TextSize = 15
    detailMessage.Font = Enum.Font.RobotoCondensed
    detailMessage.TextXAlignment = Enum.TextXAlignment.Left
    detailMessage.TextYAlignment = Enum.TextYAlignment.Top
    detailMessage.TextWrapped = true
    detailMessage.TextTruncate = Enum.TextTruncate.None
    detailMessage.ZIndex = 4
    detailMessage.Parent = contentFrame
    
    return contentFrame
end

function XKHax._createGlowEffects(mainFrame, iconCircle, borderColor)
    local glowEffect = Instance.new("ImageLabel")
    glowEffect.Name = "GlowEffect"
    glowEffect.Size = UDim2.new(1, 60, 1, 60)
    glowEffect.Position = UDim2.new(0, -30, 0, -30)
    glowEffect.BackgroundTransparency = 1
    glowEffect.Image = "rbxassetid://8992231221"
    glowEffect.ImageColor3 = borderColor
    glowEffect.ImageTransparency = 0.8
    glowEffect.ScaleType = Enum.ScaleType.Slice
    glowEffect.SliceCenter = Rect.new(20, 20, 20, 20)
    glowEffect.ZIndex = 0
    glowEffect.Parent = mainFrame
    
    local innerGlow = Instance.new("ImageLabel")
    innerGlow.Name = "InnerGlow"
    innerGlow.Size = UDim2.new(1, 20, 1, 20)
    innerGlow.Position = UDim2.new(0, -10, 0, -10)
    innerGlow.BackgroundTransparency = 1
    innerGlow.Image = "rbxassetid://8992231221"
    innerGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
    innerGlow.ImageTransparency = 0.9
    innerGlow.ScaleType = Enum.ScaleType.Slice
    innerGlow.SliceCenter = Rect.new(20, 20, 20, 20)
    innerGlow.ZIndex = 1
    innerGlow.Parent = mainFrame
   
    local iconGlow = Instance.new("ImageLabel")
    iconGlow.Name = "IconGlow"
    iconGlow.Size = UDim2.new(1.1, 0, 1.1, 0)
    iconGlow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    iconGlow.BackgroundTransparency = 1
    iconGlow.Image = "rbxassetid://8992231221"
    iconGlow.ImageColor3 = borderColor
    iconGlow.ImageTransparency = 0.7
    iconGlow.ScaleType = Enum.ScaleType.Slice
    iconGlow.SliceCenter = Rect.new(20, 20, 20, 20)
    iconGlow.ZIndex = 2
    iconGlow.Parent = iconCircle
    
    local iconGlowCorner = Instance.new("UICorner")
    iconGlowCorner.CornerRadius = UDim.new(1, 0)
    iconGlowCorner.Parent = iconGlow
    
    return glowEffect, innerGlow, iconGlow
end

function XKHax._createSound(screenGui)
    local notificationSound = Instance.new("Sound")
    notificationSound.SoundId = "rbxassetid://4590662766"
    notificationSound.Volume = XKHax.Config.SoundVolume
    notificationSound.Parent = screenGui
    return notificationSound
end

function XKHax._setupAnimations(mainFrame, iconCircle, glowEffect, innerGlow, iconGlow, borderStroke)
    local slideInInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local slideOutInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local glowInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
    local quickGlowInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 2, true)
    
    return {
        slideIn = TweenService:Create(mainFrame, slideInInfo, {Position = UDim2.new(1, -20, 0, mainFrame.Position.Y.Offset)}),
        slideOut = TweenService:Create(mainFrame, slideOutInfo, {Position = UDim2.new(1, 10, 0, mainFrame.Position.Y.Offset)}),
        glowTween = TweenService:Create(glowEffect, glowInfo, {ImageTransparency = 0.4}),
        innerGlowTween = TweenService:Create(innerGlow, quickGlowInfo, {ImageTransparency = 0.6}),
        iconGlowTween = TweenService:Create(iconGlow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1.2, 0, 1.2, 0),
            ImageTransparency = 0.4
        }),
        iconTween = TweenService:Create(iconCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 55, 0, 55)
        }),
        borderGlowTween = TweenService:Create(borderStroke, quickGlowInfo, {Transparency = 0.1})
    }
end

function XKHax._playEntryAnimation(animations, sound)
    spawn(function()
        sound:Play()
        
        animations.slideIn:Play()
        animations.glowTween:Play()
        animations.innerGlowTween:Play()
        animations.iconGlowTween:Play()
        animations.borderGlowTween:Play()
        wait(0.1)
        animations.iconTween:Play()
        
        wait(1.5)
        local fadeGlow = TweenService:Create(animations.glowTween.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 0.8
        })
        fadeGlow:Play()
        
        local fadeIconGlow = TweenService:Create(animations.iconGlowTween.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 0.8
        })
        fadeIconGlow:Play()
    end)
end

function XKHax.Show(title, message, subMessage, duration, iconImage, borderColor)
    duration = duration or XKHax.Config.DefaultDuration
    iconImage = iconImage or "rbxassetid://0"
    borderColor = borderColor or Color3.fromRGB(80, 80, 100)
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    XKHax.NotificationCounter = XKHax.NotificationCounter + 1
    local notificationId = XKHax.NotificationCounter
    local startYPosition = XKHax._calculateNotificationPosition()
    
    local screenGui = XKHax._createNotificationGUI(playerGui, startYPosition)
    local mainFrame, borderStroke = XKHax._createMainFrame(screenGui, startYPosition, borderColor)
    local iconCircle = XKHax._createIconSection(mainFrame, iconImage, borderColor)
    XKHax._createContentSection(mainFrame, title, subMessage, message)
    local glowEffect, innerGlow, iconGlow = XKHax._createGlowEffects(mainFrame, iconCircle, borderColor)
    local sound = XKHax._createSound(screenGui)
    
    local animations = XKHax._setupAnimations(mainFrame, iconCircle, glowEffect, innerGlow, iconGlow, borderStroke)
    
    XKHax.ActiveNotifications[notificationId] = {
        gui = screenGui,
        id = notificationId,
        startY = startYPosition
    }
    
    XKHax._playEntryAnimation(animations, sound)
    
    spawn(function()
        wait(duration)
        animations.slideOut:Play()
        animations.slideOut.Completed:Wait()
        
        XKHax.ActiveNotifications[notificationId] = nil
        XKHax._rearrangeNotifications()
        screenGui:Destroy()
    end)
    
    return screenGui
end

function XKHax._rearrangeNotifications()
    local activeNotificationsList = {}
    for id, notificationData in pairs(XKHax.ActiveNotifications) do
        if notificationData.gui and notificationData.gui.Parent then
            table.insert(activeNotificationsList, {
                id = id,
                data = notificationData
            })
        end
    end
    
    table.sort(activeNotificationsList, function(a, b)
        return a.id < b.id
    end)
    
    for index, notification in ipairs(activeNotificationsList) do
        local newYPosition = XKHax.Config.BaseYPosition + ((index - 1) * XKHax.Config.VerticalSpacing)
        local mainFrame = notification.data.gui:FindFirstChild("MainNotification")
        
        if mainFrame then
            local repositionTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0, newYPosition)
            })
            repositionTween:Play()
            
            XKHax.ActiveNotifications[notification.id].startY = newYPosition
        end
    end
end

function XKHax.ShowMultiple(notifications, delayBetween)
    delayBetween = delayBetween or 0.7
    
    for i, notification in ipairs(notifications) do
        XKHax.Show(
            notification.title,
            notification.message,
            notification.subMessage,
            notification.duration,
            notification.iconImage,
            notification.borderColor
        )
        
        if i < #notifications then
            wait(delayBetween)
        end
    end
end

function XKHax.ClearAll()
    for id, notificationData in pairs(XKHax.ActiveNotifications) do
        if notificationData.gui then
            notificationData.gui:Destroy()
        end
    end
    XKHax.ActiveNotifications = {}
    XKHax.NotificationCounter = 0
end

return XKHax