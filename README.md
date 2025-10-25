# XKHax Notification System

一个功能强大的Roblox通知系统，具有现代化的UI设计和丰富的自定义选项。

## 功能特性

- 🎨 现代化UI设计，透明黑色背景
- 🔊 内置音效提示
- ✨ 炫酷的光效动画
- 🎯 自动位置管理，避免重叠
- 🎨 完全可自定义的颜色和图标
- ⚡ 平滑的滑入滑出动画
- 🔄 批量通知支持

## 安装使用

```lua
local XKHax = loadstring(game:HttpGet('https://raw.githubusercontent.com/DevSloPo/XKHax-Notification/refs/heads/main/Source.lua'))()

-- 基本使用
XKHax.Show("标题", "消息", "副标题", 持续时间)

-- 自定义图标和颜色
XKHax.Show("系统通知", "有新消息", "状态", 4, "rbxassetid://图标ID", Color3.fromRGB(255, 0, 0))

-- 批量显示通知
local notifications = {
    {title = "通知1", message = "消息1", subMessage = "副标题1", duration = 3, iconImage = "rbxassetid://111", borderColor = Color3.fromRGB(255, 0, 0)},
    {title = "通知2", message = "消息2", subMessage = "副标题2", duration = 4, iconImage = "rbxassetid://222", borderColor = Color3.fromRGB(0, 255, 0)}
}
XKHax.ShowMultiple(notifications, 0.5)

-- 清除所有通知
XKHax.ClearAll()