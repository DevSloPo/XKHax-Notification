local XKHax = loadstring(game:HttpGet('https://raw.githubusercontent.com/DevSloPo/XKHax-Notification/refs/heads/main/Source.lua'))()

--基本使用
XKHax.Show("标题", "消息", "副标题", 5)

--自定义图标和边框颜色
XKHax.Show("系统通知", "有新消息", "状态", 4, "rbxassetid://123456789", Color3.fromRGB(255, 0, 0))

--批量显示
local notifications = {
    {title = "通知1", message = "消息1", subMessage = "副标题1", duration = 3, iconImage = "rbxassetid://111", borderColor = Color3.fromRGB(255, 0, 0)},
    {title = "通知2", message = "消息2", subMessage = "副标题2", duration = 4, iconImage = "rbxassetid://222", borderColor = Color3.fromRGB(0, 255, 0)}
}
XKHax.ShowMultiple(notifications, 0.5)