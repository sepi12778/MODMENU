--[[
    اسکریپت ESP خودکار
    - این اسکریپت به محض اجرا، برای تمام بازیکنان دیگر ESP (هایلایت) ایجاد می‌کند.
    - نیازی به کلیک روی دکمه نیست و هیچ منویی نمایش داده نمی‌شود.
    - رنگ هایلایت بر اساس "نقش" (Role) بازیکن تغییر می‌کند: قرمز برای "Beast" و سبز برای بقیه.
]]

-- سرویس‌های مورد نیاز
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تابعی برای ساخت هایلایت برای یک بازیکن
local function CreateESP(player)
    -- برای بازیکن محلی (خودمان) هایلایت ایجاد نکن
    if player == LocalPlayer then return end
    
    -- منتظر می‌مانیم تا کاراکتر بازیکن لود شود
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end -- اگر کاراکتر وجود نداشت، ادامه نده

    -- اگر از قبل هایلایت وجود داشت، آن را حذف می‌کنیم تا تکراری نشود
    if character:FindFirstChild("Highlight") then
        character.Highlight:Destroy()
    end
    
    -- یک هایلایت جدید می‌سازیم
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- همیشه روی بقیه چیزها نمایش داده شود
    
    -- رنگ هایلایت را بر اساس نقش بازیکن تنظیم می‌کنیم
    if player:FindFirstChild("Role") and player.Role.Value == "Beast" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- قرمز
        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
    else
        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- سبز
        highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    end
    
    -- وقتی بازیکن بمیرد و دوباره اسپاون شود، هایلایت برای کاراکتر جدیدش هم ساخته شود
    player.CharacterAdded:Connect(function(newChar)
        -- هایلایت قبلی را پاک می‌کنیم (اگر وجود داشته باشد)
        if highlight then highlight:Destroy() end

        -- هایلایت جدید برای کاراکتر جدید می‌سازیم
        highlight = Instance.new("Highlight")
        highlight.Parent = newChar
        highlight.Adornee = newChar
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        if player:FindFirstChild("Role") and player.Role.Value == "Beast" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
        end
    end)
    
    -- اگر کاراکتر بازیکن حذف شد (مثلاً از بازی خارج شد)، هایلایت را هم پاک کن
    player.CharacterRemoving:Connect(function()
        if highlight then
            highlight:Destroy()
        end
    end)
end

-- وقتی اسکریپت اجرا می‌شود، برای تمام بازیکنان موجود ESP می‌سازد
for _, player in ipairs(Players:GetPlayers()) do
    -- با یک تاخیر کوتاه اجرا می‌کنیم تا مطمئن شویم کاراکترها لود شده‌اند
    task.spawn(CreateESP, player)
end

-- اگر بازیکن جدیدی وارد سرور شد، برای او هم ESP بساز
Players.PlayerAdded:Connect(function(player)
    task.spawn(CreateESP, player)
end)

-- به طور مداوم رنگ هایلایت را بر اساس نقش بازیکن آپدیت می‌کند
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Highlight") then
            local highlight = player.Character.Highlight
            
            -- چک کردن مجدد نقش و تغییر رنگ در صورت نیاز
            if player:FindFirstChild("Role") and player.Role.Value == "Beast" then
                if highlight.FillColor ~= Color3.fromRGB(255, 0, 0) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                end
            else
                if highlight.FillColor ~= Color3.fromRGB(0, 255, 0) then
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                end
            end
        end
    end
end)

print("اسکریپت ESP خودکار فعال شد.")
