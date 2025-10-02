-- ================================================================= --
--                اسکریپت پایه ESP با Line و Box                    --
--                      زبان: Lua                                    --
-- ================================================================= --

--[[
    تنظیمات ESP
    این مقادیر را می‌توانید برای شخصی‌سازی تغییر دهید.
]]
local espEnabled = true      -- آیا ESP فعال باشد یا خیر
local drawBox = true         -- آیا جعبه دور بازیکنان کشیده شود؟
local drawLine = true        -- آیا خط به سمت بازیکنان کشیده شود؟

-- رنگ‌ها (در فرمت RGBA: قرمز، سبز، آبی، شفافیت)
-- مقادیر بین 0 تا 255 هستند.
local boxColor = { r = 255, g = 0, b = 0, a = 255 }     -- رنگ جعبه (قرمز)
local lineColor = { r = 255, g = 255, b = 0, a = 200 }   -- رنگ خط (زرد)

--[[
    توابع مورد نیاز بازی (باید توسط شما جایگزین شوند)
    این توابع فرضی هستند و در بازی شما ممکن است نام دیگری داشته باشند.
]]
-- این تابع باید تمام بازیکنان موجود در سرور را برگرداند
function GetAllPlayers()
    -- مثال: return game.Players:GetPlayers() -- (در روبلاکس)
    -- این قسمت باید با API بازی شما پر شود
    return {} -- یک لیست خالی به عنوان مثال
end

-- این تابع باید بازیکن محلی (خود شما) را برگرداند
function GetLocalPlayer()
    -- مثال: return game.Players.LocalPlayer -- (در روبلاکس)
    return nil -- به عنوان مثال
end

-- این تابع باید موقعیت سه‌بعدی یک بازیکن را برگرداند
function GetPlayerPosition(player)
    -- مثال: return player.Character.HumanoidRootPart.Position -- (در روبلاکس)
    return { x = 0, y = 0, z = 0 } -- به عنوان مثال
end

-- این تابع باید وضعیت زنده بودن بازیکن را چک کند
function IsPlayerAlive(player)
    -- مثال: return player.Character.Humanoid.Health > 0 -- (در روبلاکس)
    return true -- به عنوان مثال
end

-- این تابع باید مختصات دنیای سه‌بعدی را به مختصات صفحه‌نمایش دوبعدی تبدیل کند
-- معمولا دو مقدار برمی‌گرداند: مختصات روی صفحه (x, y) و یک بولین (boolean) که نشان می‌دهد آیا نقطه در دیدرس هست یا نه
function WorldToScreen(worldPos)
    -- این تابع بسیار وابسته به انجین بازی است
    -- مثال: local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(worldPos)
    -- return screenPos.X, screenPos.Y, onScreen
    return 0, 0, false -- به عنوان مثال
end

-- این تابع باید یک خط روی صفحه رسم کند
function DrawLine(startX, startY, endX, endY, color)
    -- این تابع باید با استفاده از API گرافیکی بازی پیاده‌سازی شود
    -- print(string.format("Drawing line from (%d,%d) to (%d,%d)", startX, startY, endX, endY))
end

-- این تابع باید یک جعبه (مستطیل) روی صفحه رسم کند
function DrawBox(x, y, width, height, color)
    -- این تابع هم باید با API گرافیکی بازی پیاده‌سازی شود
    -- print(string.format("Drawing box at (%d,%d) with size (%d,%d)", x, y, width, height))
end

-- این تابع باید اندازه صفحه نمایش را برگرداند
function GetScreenSize()
    -- مثال: return workspace.CurrentCamera.ViewportSize
    return { X = 1920, Y = 1080 } -- یک مقدار پیش‌فرض
end


-- ================================================================= --
--                         منطق اصلی ESP                             --
-- ================================================================= --

-- این تابع باید در هر فریم از بازی اجرا شود (معمولا به یک event متصل می‌شود)
function OnRenderStep()
    if not espEnabled then
        return
    end

    local localPlayer = GetLocalPlayer()
    if not localPlayer then return end -- اگر بازیکن محلی وجود نداشت، خارج شو

    local allPlayers = GetAllPlayers()
    local screenSize = GetScreenSize()

    for i, player in ipairs(allPlayers) do
        -- بازیکن محلی و بازیکنان مرده را نادیده بگیر
        if player ~= localPlayer and IsPlayerAlive(player) then

            local playerPos3D = GetPlayerPosition(player)

            -- تبدیل موقعیت بازیکن به مختصات صفحه
            local screenX, screenY, onScreen = WorldToScreen(playerPos3D)

            -- فقط اگر بازیکن روی صفحه قابل مشاهده بود، ESP را برایش رسم کن
            if onScreen then

                -- 1. رسم خط (Line)
                if drawLine then
                    -- خط از پایین وسط صفحه به سمت بازیکن کشیده می‌شود
                    DrawLine(screenSize.X / 2, screenSize.Y, screenX, screenY, lineColor)
                end

                -- 2. رسم جعبه (Box)
                if drawBox then
                    -- برای رسم جعبه، باید ارتفاع و عرض آن را محاسبه کنیم.
                    -- این کار معمولا با گرفتن فاصله از بازیکن و تبدیل آن به یک مقیاس روی صفحه انجام می‌شود.
                    -- در اینجا یک روش ساده‌سازی شده استفاده می‌کنیم:
                    -- موقعیت بالای سر بازیکن را هم به مختصات صفحه تبدیل می‌کنیم تا ارتفاع جعبه را بدست آوریم.
                    local headOffset = { x = playerPos3D.x, y = playerPos3D.y + 2, z = playerPos3D.z } -- کمی بالاتر از موقعیت اصلی
                    local headScreenX, headScreenY, headOnScreen = WorldToScreen(headOffset)

                    if headOnScreen then
                        local height = math.abs(screenY - headScreenY) -- محاسبه ارتفاع جعبه
                        local width = height / 2 -- عرض جعبه را نصف ارتفاع در نظر می‌گیریم (برای تناسب)
                        
                        -- مختصات گوشه بالا-چپ جعبه
                        local boxX = screenX - (width / 2)
                        local boxY = screenY - height -- چون مختصات پا را داریم، به اندازه ارتفاع بالا می‌رویم

                        DrawBox(boxX, boxY, width, height, boxColor)
                    end
                end
            end
        end
    end
end

-- اسکریپت را به حلقه رندر بازی متصل کنید
-- این بخش هم کاملا وابسته به بازی است
-- مثال در روبلاکس: game:GetService("RunService").RenderStepped:Connect(OnRenderStep)

-- برای تست، می‌توانید تابع را در یک حلقه فرضی اجرا کنید
-- while true do
--     OnRenderStep()
--     wait(0.016) -- معادل حدود 60 فریم بر ثانیه
-- end
