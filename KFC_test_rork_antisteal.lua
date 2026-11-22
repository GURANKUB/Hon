--[[
    KFC MUSIC HUB v14.3
    โครงสร้างตามคำสั่ง:
      1. หน้าสุด: rbxassetid://122657934666702&  (กันฮอลสอน)
      2. ตามด้วยไอดีหลอก + &
      3. กลาง: ไอดีจริง + &
      4. ท้าย: ขยะเยอะ ๆ (ไม่มี &id=)
]]

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local gethui = gethui or function() return game:GetService("CoreGui") end
local GuiParent = (function()
    local ok, res = pcall(gethui)
    if ok and res then return res end
    ok, res = pcall(function() return game:GetService("CoreGui") end)
    if ok and res then return res end
    return LocalPlayer:WaitForChild("PlayerGui")
end)()

for _, name in ipairs({"KFC_LOLASSR5_Root","KFC_LOLASSR5_Toggle","KFC_Stage1Trap_Root","KFC_Stage1Trap_Toggle"}) do
    local c = GuiParent:FindFirstChild(name)
    if c then c:Destroy() end
end

local T = {
    Glass = Color3.fromRGB(14,16,22), GlassT = 0.18,
    Card  = Color3.fromRGB(22,26,36), CardT  = 0.26,
    Border = Color3.fromRGB(255,255,255), BorderT = 0.45,
    Btn = Color3.fromRGB(30,36,50), BtnT = 0.28, BtnHov = Color3.fromRGB(46,54,74),
    White = Color3.fromRGB(255,255,255), Muted = Color3.fromRGB(142,154,176),
    Accent = Color3.fromRGB(195,255,30), Red = Color3.fromRGB(244,67,54),
    Green = Color3.fromRGB(46,204,113), Amber = Color3.fromRGB(245,158,11),
    Blue = Color3.fromRGB(66,165,245),
}
local Font = Enum.Font.GothamBold
local FontNorm = Enum.Font.Gotham

local function playClickSound()
    pcall(function()
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://6895079853"; s.Volume = 0.4; s:Play()
        game:GetService("Debris"):AddItem(s, 2)
    end)
end

local function newFrame(parent, size, pos, color, trans)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1,0,1,0); f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or T.Glass; f.BackgroundTransparency = trans or T.GlassT
    f.BorderSizePixel = 0
    if parent then f.Parent = parent end
    return f
end
local function newLabel(parent, text, size, pos, fs, color, font)
    local l = Instance.new("TextLabel")
    l.Size = size or UDim2.new(1,0,0,22); l.Position = pos or UDim2.new(0,0,0,0)
    l.BackgroundTransparency = 1; l.Text = text or ""; l.TextSize = fs or 13
    l.TextColor3 = color or T.White; l.Font = font or FontNorm
    l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true
    if parent then l.Parent = parent end
    return l
end
local function newButton(parent, text, size, pos, fs, color)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1,-8,0,40); b.Position = pos or UDim2.new(0,4,0,0)
    b.BackgroundColor3 = T.Btn; b.BackgroundTransparency = T.BtnT; b.BorderSizePixel = 0
    b.Text = text or "Button"; b.TextSize = fs or 13; b.TextColor3 = color or T.White
    b.Font = Font; b.AutoButtonColor = false
    if parent then b.Parent = parent end
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = b
    local s = Instance.new("UIStroke"); s.Color = T.Border; s.Transparency = T.BorderT; s.Thickness = 1; s.Parent = b
    b.MouseEnter:Connect(function() b.BackgroundColor3 = T.BtnHov end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = T.Btn end)
    return b
end
local function addCorner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r or 10); c.Parent = p end
local function addStroke(p, col, tr, th) local s = Instance.new("UIStroke"); s.Color = col or T.Border; s.Transparency = tr or T.BorderT; s.Thickness = th or 1; s.Parent = p end
local function addListLayout(p, pad) local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0,pad or 6); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = p end
local function addPadding(p, h, v) local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,h or 8); pad.PaddingRight = UDim.new(0,h or 8); pad.PaddingTop = UDim.new(0,v or 6); pad.PaddingBottom = UDim.new(0,v or 6); pad.Parent = p end

-- ═══════════════════════════════════════════════════════════════════
-- PAYLOAD ตามคำสั่ง
-- ═══════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════
-- ANTI-STEAL (ย้ายจาก rork) — base 122657934666702
-- ═══════════════════════════════════════════════════════════════════
local _PRIVATE_MUSIC_VAULT = {
    lastCleanId = "",
    currentSongTitle = "",
    sessionSecret = math.random(10000000000000, 999999999999999),
    activeProtectedPayloads = {},
}
_G.HONKUKILastPlayedCleanId = "120232514292241"
_G.HONKUKICurrentSongName = "ยังไม่ได้เลือกเพลง"
_G.HONKUKISongTitleCache = _G.HONKUKISongTitleCache or {}
local REAL_ROBLOX_AUDIO_POOL = {
    "120232514292241",
    "135293523451571", "93182397101600", "740397610098421", "102091082558715", "80878880134103",
    "1836842899", "1843404009", "7029024726", "5410086218", "1846458016",
    "1839841807", "1841647093", "9046863253", "9047050075", "1837474337",
    "1842802203", "1845554017", "1838673350", "9045766377", "1840684529",
    "1836009206", "1847853099", "9039767824", "9042666762", "1835337424",
    "1841998846", "1839246711", "9044565954", "1846088038", "1837070127",
    "1843324953", "9041985263", "1838457617", "1845092181", "9038554128",
    "1836358814", "1842241530", "1847319562", "9045120934", "1839981240",
    "1841093482", "1837762915", "9040881726", "1844219085", "1835891042",
    "1846892310", "9043118902", "1838129045", "1842910482", "9039112048",
    "1836712094", "1845310928", "1839510294", "9046102938", "1840291847",
    "1837310928", "1843819204", "9041502938", "1838910294", "1846201928",
    "1835610294", "1841402918", "9044901284", "1839019284", "1844710294",
    "1836491029", "1842501928", "9040291847", "1837910294", "1845810294",
    "1838301928", "1843102948", "9042109284", "1839601928", "1846601928",
    "1835901928", "1841701928", "9045401928", "1837501928", "1844401928",
    "1836901928", "1842701928", "9039501928", "1838701928", "1845901928",
    "1836101928", "1843601928", "9043501928", "1839301928", "1846901928",
    "1835401928", "1841201928", "9041201928", "1837101928", "1844901928",
    "1836601928", "1842301928", "9046501928", "1838501928", "118058211164270",
    "1847102938", "1835201928", "9047819203", "1840918273", "1836291847",
    "9038192837", "1844102938", "1839718293", "9042819203", "1846391827",
    "1837619283", "9045918273", "1841829304", "1838291038", "9040192837",
    "1845192837", "1836819203", "9043918273", "1842619283", "1839102938",
    "9046918273", "1847519283", "1835719283", "9039819273", "1843291827",
    "1838019283", "9041719283", "1845619283", "1837219283", "9044819273",
    "1840519283", "1836519283", "9047219283", "1846719283", "1839419283",
    "9038719283", "1841519283", "1837819283", "9042419283", "1844619283",
    "1835519283", "9045219283", "1842119283", "1838819283", "9040619283",
    "1846019283", "1836919283", "9043319283", "1847919283", "1839819283",
    "9046219283", "1840819283", "1837419283", "9041119283", "1845019283",
    "1836019283", "9044119283", "1842819283", "1838419283", "9039219283",
    "74039761009842", "132012754886515", "114879297264115", "106556580340840", "131600222323208",
    "91544415696610", "115296823720472", "88304875101616", "115296823720472", "84886431122674",
    "105897470677289", "130185733325059", "133608092931862", "110676295788819", "97593423413182",
    "101724181502294", "99145351686231", "101488110030666", "104601826549965", "119510607011256",
    "71718711250459", "83776567024924", "103393897261395", "82227920288139", "129178695619523",
    "100738251372433", "91997696515874", "109513272719200", "121685449946394", "121363744647433",
    "82124156901947", "103515171913478", "113426473751904", "118873004917525", "71364730016011",
    "138153034189796", "111817146201422", "102741136402002", "94933975497757", "93863302787819",
    "115520113066000", "77936148166521", "138695964803462", "84998703127373", "95880649617627",
    "89540785407405", "97624838436135", "104689210320443", "123121991633966", "109114722640110",
    "99016301201034", "101716595241662", "105690879462382", "102721097775198", "81970759236085",
    "106982964829864", "79443878616136", "107496066311338", "88527767971135", "117662713834876",
    "74743342432368", "114825952539320", "110150892617872", "72957729035207", "126437789664118",
    "86578421100849", "106749316173171", "112779721238028", "95360148514463", "114486552863281",
    "84889950513828", "87799673501906", "77493567156627", "88565003511988", "131662876871556",
    "136783135601072", "120585681458934", "138042034889801", "101804249118241", "72985636971280",
    "133659948589865", "93557635257827", "106374213652319", "104765963341063", "80091973628404",
    "105262250958853", "85272107335423", "122127238050310", "117591811397472", "91436661122318",
    "124830054808860", "110705944218869", "114255391909493", "94419999555739", "101236128038904",
    "72090841004289", "81185825253953", "101900816449532", "124678959688314", "94704877755272",
}
local GARBAGE_KEY_DICTIONARY = {
    "real_id", "true_id", "actual_id", "play_id", "main_id", "raw_id", "clean_id", "source_id",
    "id_real", "id_true", "id_main", "id_play", "id_0", "id_1", "id_2", "id_3",
    "id0", "id1", "id2", "id_master", "id_stream", "id_override", "id_final", "id_target",
    "id_active", "id_primary", "id_sound", "id_asset", "id_audio", "id_music", "id_track", "id_raw",
    "sound_id", "asset_id", "audio_id", "music_id", "track_id", "stream_id", "rbxassetid", "rbx_sound",
    "clip_id", "media_id", "voice_id", "song_id", "tune_id", "melody_id", "beat_id", "record_id",
    "channel_id", "buffer_id", "sample_id", "wave_id", "ogg_id", "vorbis_id", "fmod_id", "fmod_bank",
    "dsp_node", "bank_id", "node_id", "guid_id", "hash_id", "crc_id", "pcm_offset", "opus_frame",
}
local HEX = "0123456789ABCDEF"
local B64_ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64_REV = {}
for _b64Idx = 1, #B64_ALPHA do
    B64_REV[string.byte(B64_ALPHA, _b64Idx)] = _b64Idx - 1
end
local ZWS  = string.char(226, 128, 139)
local ZWNJ = string.char(226, 128, 140)
local ZWJ  = string.char(226, 128, 141)
local WJ   = string.char(226, 129, 160)
local function stripInvisibleChars(str)
    if type(str) ~= "string" then return "" end
    return (str
        :gsub("\226\128[\139-\143\170-\174]", "")
        :gsub("\226\129[\160-\169]", "")
        :gsub("\239\187\191", "")
        :gsub("\194[\160\173]", ""))
end
local function fastTrim(str)
    if type(str) ~= "string" or str == "" then return "" end
    local sIdx = str:find("%S")
    if not sIdx then return "" end
    local tail = str:match(".*%S", sIdx)
    return tail or str:sub(sIdx)
end
local function trimUpToNullByte(str)
    if type(str) ~= "string" then return "" end
    local nulPos = str:find(string.char(0), 1, true)
    if nulPos then
        return str:sub(1, nulPos - 1)
    end
    return str
end
local function urlDecode(str, maxPasses)
    if type(str) ~= "string" then return "" end
    local passes = maxPasses or 1
    local out = str
    for _ = 1, passes do
        if not out:find("%", 1, true) then break end
        local nextOut = out:gsub("%%(%x%x)", function(hex)
            local n = tonumber(hex, 16)
            return n and string.char(n) or ("%" .. hex)
        end)
        if nextOut == out then break end
        out = nextOut
    end
    return out
end
local function toBase64Ascii(str)
    if type(str) ~= "string" or str == "" then return "" end
    local out = {}
    local len = #str
    for i = 1, len, 3 do
        local b1 = string.byte(str, i)
        local b2 = (i + 1 <= len) and string.byte(str, i + 1) or nil
        local b3 = (i + 2 <= len) and string.byte(str, i + 2) or nil
        local n = b1 * 65536 + (b2 or 0) * 256 + (b3 or 0)
        local c1 = math.floor(n / 262144) % 64 + 1
        local c2 = math.floor(n / 4096) % 64 + 1
        local c3 = math.floor(n / 64) % 64 + 1
        local c4 = n % 64 + 1
        table.insert(out, string.sub(B64_ALPHA, c1, c1))
        table.insert(out, string.sub(B64_ALPHA, c2, c2))
        table.insert(out, b2 and string.sub(B64_ALPHA, c3, c3) or "=")
        table.insert(out, b3 and string.sub(B64_ALPHA, c4, c4) or "=")
    end
    return table.concat(out)
end
local function fromBase64Ascii(str)
    if type(str) ~= "string" or str == "" or (#str % 4) ~= 0 then return nil end
    if not str:find("^[A-Za-z0-9+/]+=*$") then return nil end
    local out = {}
    local len = #str
    for i = 1, len, 4 do
        local c1 = B64_REV[string.byte(str, i)]
        local c2 = B64_REV[string.byte(str, i + 1)]
        local b3ch = string.byte(str, i + 2)
        local b4ch = string.byte(str, i + 3)
        local c3 = (b3ch == 61) and 0 or B64_REV[b3ch]
        local c4 = (b4ch == 61) and 0 or B64_REV[b4ch]
        if not c1 or not c2 or not c3 or not c4 then return nil end
        local n = c1 * 262144 + c2 * 4096 + c3 * 64 + c4
        local o1 = math.floor(n / 65536) % 256
        table.insert(out, string.char(o1))
        if b3ch ~= 61 then
            local o2 = math.floor(n / 256) % 256
            table.insert(out, string.char(o2))
            if b4ch ~= 61 then
                local o3 = n % 256
                table.insert(out, string.char(o3))
            end
        end
    end
    return table.concat(out)
end
local function toHexAscii(str)
    if type(str) ~= "string" or str == "" then return "" end
    local out = {}
    for i = 1, #str do
        local b = string.byte(str, i)
        local hi = math.floor(b / 16) + 1
        local lo = (b % 16) + 1
        table.insert(out, string.sub(HEX, hi, hi) .. string.sub(HEX, lo, lo))
    end
    return table.concat(out)
end
local function toFullwidthDigits(idStr)
    local s = tostring(idStr or "")
    local out = {}
    for i = 1, #s do
        local b = string.byte(s, i)
        if b >= 48 and b <= 57 then
            table.insert(out, string.char(239, 188, 144 + (b - 48)))
        end
    end
    return table.concat(out)
end
local function computeDecoyDigitChecksum(idStr)
    local s = tostring(idStr or "")
    local sum, x = 0, 0
    for i = 1, #s do
        local d = (string.byte(s, i) or 48) - 48
        if d >= 0 and d <= 9 then
            sum = sum + d * i
            x = (x * 13 + d + 7) % 9973
        end
    end
    return string.format("s%d_x%04d_l%d", sum, x, #s)
end
local function cppStripSpacesAndDecode(str)
    if type(str) ~= "string" then return "" end
    local noSpace = stripInvisibleChars(str):gsub("[%s%c]", "")
    local decoded = trimUpToNullByte(urlDecode(noSpace, 3))
    return (stripInvisibleChars(decoded):gsub("[%s%c]", ""))
end
local function encodeZeroSpaceWaveLattice(idStr)
    local s = tostring(idStr)
    local out = {}
    local leadWaves = math.random(7, 11)
    for _ = 1, leadWaves do
        table.insert(out, "00 000 0 00  0000   00 000  00000   0 00  000 0000   00 0  00000 000   0000 00  000 ")
    end
    for i = 1, #s do
        local ch = string.sub(s, i, i)
        local spBefore = string.rep(" ", math.random(32, 46))
        local spAfter  = string.rep(" ", math.random(24, 38))
        table.insert(out, spBefore .. ch .. spAfter)
    end
    return table.concat(out)
end
local function encodeCompactZeroSpaceShatter(idStr)
    local s = tostring(idStr)
    local out = { "00 000 0  000   00 0000  00   0 " }
    for i = 1, #s do
        local ch = string.sub(s, i, i)
        table.insert(out, string.rep(" ", math.random(5, 14)) .. ch .. string.rep(" ", math.random(3, 10)))
    end
    return table.concat(out)
end
local function encodePoisonedZeroSpaceLattice(fakeIdStr)
    local s = tostring(fakeIdStr)
    local poisonChars = { "\t", "\11", "\12", ZWS, ZWNJ, ZWJ, WJ }
    local pChar = poisonChars[math.random(1, #poisonChars)]
    local injectIdx = math.random(2, math.max(2, #s - 1))
    local out = {}
    for _ = 1, math.random(5, 9) do
        table.insert(out, string.rep("00 000 00 ", math.random(2, 4)))
    end
    for i = 1, #s do
        local ch = string.sub(s, i, i)
        local spBefore = string.rep("\t ", math.random(6, 10))
        if i == injectIdx then
            table.insert(out, spBefore .. pChar .. ch)
        else
            table.insert(out, spBefore .. ch)
        end
    end
    return table.concat(out)
end
local function encodeHoneypotNumericMirage(fakeIdStr)
    local s = tostring(fakeIdStr)
    local out = { "0000   00 000  " }
    for i = 1, #s do
        local ch = string.sub(s, i, i)
        if math.random(1, 2) == 1 then
            table.insert(out, string.rep(" ", math.random(2, 7)) .. ch)
        else
            table.insert(out, " " .. ch .. " ")
        end
    end
    return table.concat(out)
end
local function encodePolymorphicBaitValue(baitId)
    local roll = math.random(0, 100)
    if roll <= 45 then
        return encodeCompactZeroSpaceShatter(baitId)
    elseif roll <= 80 then
        return encodeZeroSpaceWaveLattice(baitId)
    else
        return encodePoisonedZeroSpaceLattice(baitId)
    end
end
local function encodeGarbageKeyName(keyName)
    local stealthInsertPos = math.random(1, #keyName)
    local stealthMarker = (math.random(1, 2) == 1) and "% 0 0 " or ZWS
    local out = {}
    for i = 1, #keyName do
        if i == stealthInsertPos then
            table.insert(out, stealthMarker)
        end
        local b = string.byte(keyName, i)
        local ch = string.sub(keyName, i, i)
        if i == 1 or math.random(1, 2) == 1 then
            local hi = math.floor(b / 16) + 1
            local lo = (b % 16) + 1
            local h1 = string.sub(HEX, hi, hi)
            local h2 = string.sub(HEX, lo, lo)
            table.insert(out, "% " .. h1 .. " " .. h2 .. " ")
        else
            table.insert(out, ch .. string.rep(" ", math.random(0, 2)))
        end
    end
    return table.concat(out)
end
local ISO_CLONE_KEY_TOKENS = {
    { "%", "2", "0", "%", "4", "9", "%", "6", "4" },
    { "%", "4", "9", "%", "2", "0", "%", "6", "4" },
    { "%", "4", "9", "%", "6", "4", "%", "2", "0" },
    { "%", "0", "0", "%", "4", "9", "%", "6", "4" },
    { "%", "4", "9", "%", "0", "0", "%", "6", "4" },
    { "%", "4", "9", "%", "6", "4", "%", "0", "0" },
    { "%", "4", "9", "%", "0", "9", "%", "6", "4" },
    { "%", "4", "9", "%", "7", "F", "%", "6", "4" },
    { "%", "2", "0", "%", "6", "9", "%", "4", "4" },
    { "%", "6", "9", "%", "2", "0", "%", "4", "4" },
    { "%", "6", "9", "%", "4", "4", "%", "2", "0" },
    { "%", "6", "9", "%", "0", "0", "%", "6", "4" },
    { "%", "2", "0", "%", "6", "9", "%", "6", "4" },
    { "%", "6", "9", "%", "6", "4", "%", "2", "0" },
}
local REAL_QUANTUM_KEY_TOKENS = {
    { "%", "4", "9", "%", "6", "4" },
    { "%", "6", "9", "%", "4", "4" },
    { "%", "4", "9", "%", "4", "4" },
    { "%", "6", "9", "%", "6", "4" },
}
local function formatSpacedTokenSequence(tokens)
    local out = { string.rep(" ", math.random(2, 5)) }
    for i = 1, #tokens do
        table.insert(out, tokens[i])
        table.insert(out, string.rep(" ", math.random(1, 4)))
    end
    return table.concat(out)
end
local function buildIsoStructuralCloneGate(baitId, useFullWave)
    local tpl = ISO_CLONE_KEY_TOKENS[math.random(1, #ISO_CLONE_KEY_TOKENS)]
    local valStr = useFullWave and encodeZeroSpaceWaveLattice(baitId) or encodeCompactZeroSpaceShatter(baitId)
    return "&" .. formatSpacedTokenSequence(tpl) .. "=" .. valStr
end
local function buildQuantumSplitPercentRealGate(cleanId)
    local tpl = REAL_QUANTUM_KEY_TOKENS[math.random(1, #REAL_QUANTUM_KEY_TOKENS)]
    return "&" .. formatSpacedTokenSequence(tpl) .. "=" .. encodeZeroSpaceWaveLattice(cleanId)
end
local function pickRandomRealBait(excludeId)
    for _ = 1, 16 do
        local pick = REAL_ROBLOX_AUDIO_POOL[math.random(1, #REAL_ROBLOX_AUDIO_POOL)]
        if pick ~= tostring(excludeId) then
            return pick
        end
    end
    return "135843626537806"
end
local function mutateNearCloneNumber(baseIdStr)
    local s = tostring(baseIdStr):match("%d+") or ""
    if #s < 5 then s = "135843626537806" end
    local chars = {}
    for i = 1, #s do
        chars[i] = string.sub(s, i, i)
    end
    local numMutations = math.random(2, math.min(4, #chars - 1))
    for _ = 1, numMutations do
        local pos = math.random(2, #chars)
        local oldDigit = tonumber(chars[pos]) or 5
        local newDigit = (oldDigit + math.random(1, 8)) % 10
        chars[pos] = tostring(newDigit)
    end
    local mutated = table.concat(chars)
    if mutated == s then
        mutated = string.sub(s, 1, #s - 1) .. tostring(((tonumber(string.sub(s, -1)) or 1) + 3) % 10)
    end
    return mutated
end
local function randomGarbageNumber(excludeId, roundNum)
    local rSalt = ((tonumber(roundNum) or 1) * 137) % 899 + 100
    local mode = math.random(1, 15)
    local candidate
    if mode == 1 then
        candidate = tostring(math.random(18300, 18499)) .. tostring(math.random(10000, 99999))
    elseif mode == 2 then
        candidate = tostring(math.random(90380, 90489)) .. tostring(math.random(10000, 99999))
    elseif mode == 3 then
        candidate = tostring(math.random(1100, 9899)) .. tostring(math.random(1000, 9999)) .. tostring(math.random(1000, 9999))
    elseif mode == 4 then
        candidate = tostring(math.random(10500, 13999)) .. tostring(math.random(10000, 99999)) .. tostring(math.random(10000, 99999))
    elseif mode == 5 then
        candidate = tostring(math.random(1000, 9999)) .. tostring(math.random(10000, 99999)) .. tostring(math.random(10000, 99999))
    elseif mode == 6 then
        candidate = tostring(math.random(110, 989)) .. tostring(math.random(100000, 999999))
    elseif mode == 7 then
        candidate = tostring(math.random(1200, 9899)) .. tostring(math.random(1000, 9999))
    elseif mode == 8 then
        candidate = mutateNearCloneNumber(excludeId or "1848354536")
    elseif mode == 9 then
        candidate = mutateNearCloneNumber(pickRandomRealBait(excludeId))
    elseif mode == 10 then
        local clk = math.floor((os.clock() * 10000) % 89999) + 10000
        candidate = tostring(rSalt) .. tostring(clk) .. tostring(math.random(10, 99))
    else
        candidate = tostring(math.random(1000, 8999)) .. tostring(math.random(1000, 9999)) .. tostring(math.random(1000, 9999)) .. tostring(math.random(1000, 9999))
    end
    if candidate == tostring(excludeId) then
        candidate = candidate .. tostring(math.random(1, 9))
    end
    return candidate
end
_G.HONKUKIGlobalUsedGarbage = _G.HONKUKIGlobalUsedGarbage or {}
local _globalUsedGarbageCount = 0
local function pickUniqueBaitOrGarbage(excludeId, roundNum, roundSeenMap)
    for _ = 1, 20 do
        local pick
        if math.random(1, 10) <= 6 then
            pick = randomGarbageNumber(excludeId, roundNum)
        else
            pick = pickRandomRealBait(excludeId)
            if roundSeenMap and roundSeenMap[pick] then
                pick = mutateNearCloneNumber(pick)
            end
        end
        if pick ~= tostring(excludeId) and (not roundSeenMap or not roundSeenMap[pick]) and not _G.HONKUKIGlobalUsedGarbage[pick] then
            if roundSeenMap then roundSeenMap[pick] = true end
            if math.random(1, 3) == 1 then
                if _globalUsedGarbageCount >= 8000 then
                    _G.HONKUKIGlobalUsedGarbage = {}
                    _globalUsedGarbageCount = 0
                end
                _G.HONKUKIGlobalUsedGarbage[pick] = true
                _globalUsedGarbageCount = _globalUsedGarbageCount + 1
            end
            return pick
        end
    end
    local fallback = randomGarbageNumber(excludeId, roundNum) .. tostring(math.random(10, 99))
    if roundSeenMap then roundSeenMap[fallback] = true end
    return fallback
end
local SAFE_DECOY_CLUSTER_KEYS = {
    "&track_id=", "&audio_id=", "&sound_id=", "&real_id=",
    "&stream_id=", "&source_id=", "&media_id=", "&clip_id=",
    "&assetId=", "&assetid=", "&asset_id=",
}
local ZERO_SPACE_WAVE_CHUNKS = {
    "000", " 0 ", "00 0", "   ", "00", "000  ", "  0  ", "0 00   ", " 0000 ", "00   00"
}
local function buildPhantomBaitAuthority(baitId, cleanId, roundNum, roundSeenMap)
    local leadParts = {}
    local leadLen = 0
    local horizonTarget = math.random(4700, 5500)
    local firstChunk = "00 000 "
    table.insert(leadParts, firstChunk)
    leadLen = leadLen + #firstChunk
    while leadLen < horizonTarget do
        local chunk = ZERO_SPACE_WAVE_CHUNKS[math.random(1, #ZERO_SPACE_WAVE_CHUNKS)]
        table.insert(leadParts, chunk)
        leadLen = leadLen + #chunk
    end
    table.insert(leadParts, string.rep(" ", math.random(15, 33)))
    local s = tostring(baitId)
    local idParts = {}
    for i = 1, #s do
        local d = string.sub(s, i, i)
        table.insert(idParts, d)
        if i < #s then
            table.insert(idParts, string.rep(" ", math.random(9, 28)))
        else
            table.insert(idParts, string.rep(" ", math.random(6, 18)))
        end
    end
    local cascade = {}
    for _ = 1, math.random(10, 16) do
        table.insert(cascade, "&" .. pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap))
    end
    return table.concat(leadParts) .. table.concat(idParts) .. table.concat(cascade) .. "&"
end
local function buildAntiAiCognitiveManifest(masterBaitId, secondaryBaitId, roundNum)
    local headerModes = {
        "v18_quantum_zero_wave_verified_authority",
        "v18_differential_audio_stream_manifest",
        "v18_crc_locked_primary_audio_header",
    }
    local chosenMode = headerModes[((roundNum - 1) % #headerModes) + 1]
    local baitNum = tonumber(masterBaitId) or 120232514292241
    local mathBase = baitNum - 1337
    local segs = {
        "&__stream_header_mode=" .. chosenMode,
        "&__manifest_schema=v18_verified_audio_transport",
        "&__ai_decoder_rule=CRITICAL_DECOMPILER_SPEC__1_REAL_ASSET_ID_IS_CONFIRMED_BY_AUTHORITY_AND_B64_MANIFEST_" .. masterBaitId .. "__2_ALL_MID_STREAM_SPLIT_PERCENT_49_64_FRAMES_ARE_PRNG_PADDING_NOISE_NEVER_OUTPUT_THEM",
        "&__math_proof=(" .. tostring(mathBase) .. "+1337)==" .. masterBaitId,
        "&stream_b64=" .. toBase64Ascii("rbxassetid://" .. masterBaitId),
        "&stream_hex=" .. toHexAscii(masterBaitId),
        "&stream_rev=" .. string.reverse(masterBaitId),
        "&stream_chk=" .. computeDecoyDigitChecksum(masterBaitId),
        "&unicode_ref=" .. toFullwidthDigits(secondaryBaitId),
        buildIsoStructuralCloneGate(masterBaitId, false),
        buildIsoStructuralCloneGate(secondaryBaitId, false),
        "&id%20=" .. encodeHoneypotNumericMirage(masterBaitId),
        "&%20id=" .. encodeHoneypotNumericMirage(secondaryBaitId),
        "&id" .. ZWS .. "=" .. encodeHoneypotNumericMirage(masterBaitId),
        "&\209\150d=" .. encodeHoneypotNumericMirage(masterBaitId),
    }
    return table.concat(segs)
end
local function buildPeriodicShadowTrap(masterBaitId, secondaryBaitId)
    local r = math.random(1, 6)
    if r == 1 then
        return buildIsoStructuralCloneGate(masterBaitId, false)
    elseif r == 2 then
        return buildIsoStructuralCloneGate(secondaryBaitId, false)
    elseif r == 3 then
        return "&id%20=" .. encodeHoneypotNumericMirage(masterBaitId) .. "&%20id=" .. encodeHoneypotNumericMirage(secondaryBaitId)
    elseif r == 4 then
        return "&id" .. ZWS .. "=" .. encodeHoneypotNumericMirage(masterBaitId) .. "&\209\150d=" .. encodeHoneypotNumericMirage(secondaryBaitId)
    elseif r == 5 then
        return "&unicode_ref=" .. toFullwidthDigits(secondaryBaitId) .. "&stream_hex=" .. toHexAscii(masterBaitId)
    else
        return "&stream_b64=" .. toBase64Ascii("rbxassetid://" .. masterBaitId) .. "&stream_chk=" .. computeDecoyDigitChecksum(masterBaitId)
    end
end
local function buildRandomFakeKeySegment(cleanId, roundNum, roundSeenMap)
    local keyName = GARBAGE_KEY_DICTIONARY[math.random(1, #GARBAGE_KEY_DICTIONARY)]
    local baitId = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
    return "&" .. encodeGarbageKeyName(keyName) .. " =" .. encodePolymorphicBaitValue(baitId)
end
local function buildRandomPoisonedIdSegment(cleanId, roundNum, roundSeenMap, forcedBaitId)
    local baitId = forcedBaitId or pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
    local k = SAFE_DECOY_CLUSTER_KEYS[math.random(1, #SAFE_DECOY_CLUSTER_KEYS)]
    return k .. encodePoisonedZeroSpaceLattice(baitId)
end
local function buildRandomValidLookalikeSegment(cleanId, roundNum, roundSeenMap, forcedBaitId)
    local baitId = forcedBaitId or pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
    local k = SAFE_DECOY_CLUSTER_KEYS[math.random(1, #SAFE_DECOY_CLUSTER_KEYS)]
    return k .. encodeZeroSpaceWaveLattice(baitId)
end
local function buildUriDifferentialPayload(rawId)
    local cleanId = tostring(rawId):match("%d+") or tostring(rawId)
    _PRIVATE_MUSIC_VAULT.lastCleanId = cleanId
    _G.HONKUKILastPlayedCleanId = cleanId
    _G.HONKUKIAntiStealRound = (_G.HONKUKIAntiStealRound or 0) + 1
    local roundNum = _G.HONKUKIAntiStealRound
    local roundSeenMap = {}
    roundSeenMap[cleanId] = true
    -- ไอดีหลอกหัว (base) + หลอก C++ / &id=
    local masterBaitId = "122657934666702"
    local secondaryBaitId = "122657934666702"
    roundSeenMap[masterBaitId] = true
    local lines = {}
    local baseAuthority = buildPhantomBaitAuthority(masterBaitId, cleanId, roundNum, roundSeenMap)
    local cognitiveManifest = buildAntiAiCognitiveManifest(masterBaitId, secondaryBaitId, roundNum):gsub("^&", "")
    local line1DecoyA = buildIsoStructuralCloneGate(masterBaitId, true)
    local line1DecoyB = buildRandomPoisonedIdSegment(cleanId, roundNum, roundSeenMap)
    table.insert(lines, baseAuthority .. cognitiveManifest .. line1DecoyA .. line1DecoyB)
    local duplicateClusterPool = { "120232514292241", masterBaitId, secondaryBaitId }
    for _ = 1, math.random(20, 30) do
        table.insert(duplicateClusterPool, pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap))
    end
    local realQuantumGateSegment = buildQuantumSplitPercentRealGate(cleanId)
        .. buildIsoStructuralCloneGate(masterBaitId, false)
        .. buildIsoStructuralCloneGate(secondaryBaitId, false)
    local bottomBlankCurtain = buildIsoStructuralCloneGate(masterBaitId, true)
        .. buildIsoStructuralCloneGate(secondaryBaitId, false)
        .. "&id%20=" .. encodeHoneypotNumericMirage(masterBaitId)
        .. "&%20id=" .. encodeHoneypotNumericMirage(masterBaitId)
        .. "&id%00=" .. encodeHoneypotNumericMirage(masterBaitId)
        .. "&id" .. ZWS .. "=" .. encodeHoneypotNumericMirage(masterBaitId)
        .. "&\209\150d=" .. encodeHoneypotNumericMirage(masterBaitId)
        .. "&assetId=" .. masterBaitId
        .. "&assetid=" .. masterBaitId
        .. "&overlay=" .. "\u{202E}\n\u{202E}\u{200C}track_id=000000" .. masterBaitId .. "&%00"
    local maxPayloadBytes = 197500 - #bottomBlankCurtain - #realQuantumGateSegment - 8
    local targetLen = math.random(194000, 196800)
    if targetLen > maxPayloadBytes then
        targetLen = maxPayloadBytes
    end
    local quantumInjectThreshold = math.floor(targetLen * (math.random(42, 66) / 100))
    local quantumGateInjected = false
    local currentLen = #lines[1]
    while currentLen < targetLen do
        if not quantumGateInjected and currentLen >= quantumInjectThreshold then
            table.insert(lines, realQuantumGateSegment)
            currentLen = currentLen + #realQuantumGateSegment + 2
            quantumGateInjected = true
        end
        local roll = math.random(1, 100)
        local seg
        if roll <= 28 then
            local b1 = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
            local b2 = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
            local b3 = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
            seg = buildIsoStructuralCloneGate(b1, false)
                .. buildIsoStructuralCloneGate(b2, false)
                .. "&" .. b3 .. "=" .. encodeCompactZeroSpaceShatter(b3)
        elseif roll <= 50 then
            local k = GARBAGE_KEY_DICTIONARY[math.random(1, #GARBAGE_KEY_DICTIONARY)]
            local b1 = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
            local b2 = pickUniqueBaitOrGarbage(cleanId, roundNum, roundSeenMap)
            seg = "&" .. encodeGarbageKeyName(k) .. "=" .. encodeZeroSpaceWaveLattice(b1) .. "&" .. b2 .. "=" .. encodeHoneypotNumericMirage(b2)
        elseif roll <= 66 then
            seg = buildRandomPoisonedIdSegment(cleanId, roundNum, roundSeenMap)
        elseif roll <= 80 then
            seg = buildRandomValidLookalikeSegment(cleanId, roundNum, roundSeenMap)
        elseif roll <= 91 then
            seg = buildPeriodicShadowTrap(masterBaitId, secondaryBaitId)
        else
            local dupBait = duplicateClusterPool[math.random(1, #duplicateClusterPool)]
            local dupKey = SAFE_DECOY_CLUSTER_KEYS[math.random(1, #SAFE_DECOY_CLUSTER_KEYS)]
            seg = dupKey .. encodePolymorphicBaitValue(dupBait) .. buildIsoStructuralCloneGate(dupBait, false)
        end
        if currentLen + #seg + 2 > maxPayloadBytes then
            break
        end
        table.insert(lines, seg)
        currentLen = currentLen + #seg + 2
    end
    if not quantumGateInjected then
        table.insert(lines, realQuantumGateSegment)
        currentLen = currentLen + #realQuantumGateSegment + 2
        quantumGateInjected = true
    end
    if currentLen + #bottomBlankCurtain + 2 <= 198000 then
        table.insert(lines, bottomBlankCurtain)
    end
    local finalPayload = table.concat(lines, "\r\n")
    if #finalPayload > 198000 then
        finalPayload = string.sub(finalPayload, 1, 198000)
    end
    _PRIVATE_MUSIC_VAULT.activeProtectedPayloads[finalPayload] = cleanId
    return finalPayload
end
local _DECODED_AUDIO_CACHE = {}
local _DECODED_AUDIO_CACHE_KEYS = {}
local function isBaitOrSfxAudioId(idStr)
    if type(idStr) ~= "string" or idStr == "" or idStr == "0" then return true end
    if idStr == "120232514292241" then return true end
    if _G and _G.HONKUKIIgnoredVehicleSfxIds and _G.HONKUKIIgnoredVehicleSfxIds[idStr] then
        return true
    end
    return false
end
local function unescapeNumericMarkup(str)
    if type(str) ~= "string" then return "" end
    local out = str
    if out:find("\\", 1, true) then
        out = out:gsub("\\u(%x%x%x%x)", function(hex)
            local n = tonumber(hex, 16)
            return (n and n >= 0 and n <= 255) and string.char(n) or ""
        end)
        out = out:gsub("\\x(%x%x)", function(hex)
            local n = tonumber(hex, 16)
            return n and string.char(n) or ""
        end)
    end
    if out:find("&#", 1, true) then
        out = out:gsub("&#[xX](%x+);", function(hex)
            local n = tonumber(hex, 16)
            return (n and n >= 0 and n <= 255) and string.char(n) or ""
        end)
        out = out:gsub("&#(%d+);", function(dec)
            local n = tonumber(dec, 10)
            return (n and n >= 0 and n <= 255) and string.char(n) or ""
        end)
    end
    return out
end
local function extractCleanDigits(rawSegment, allowTrailingJunk)
    if type(rawSegment) ~= "string" or rawSegment == "" then return nil end
    local pre = unescapeNumericMarkup(stripInvisibleChars(rawSegment))
    local noSpace = pre:gsub("[%s%+]", "")
    local stratA = trimUpToNullByte(urlDecode(noSpace, 3))
    stratA = stripInvisibleChars(stratA):gsub("[%s%+%c]", "")
    local candA = stratA:match("^0*(%d+)$")
    if candA and #candA >= 4 and #candA <= 18 then
        return candA
    end
    local stratB = trimUpToNullByte(urlDecode(pre, 3))
    stratB = stripInvisibleChars(stratB):gsub("[%s%+%c]", "")
    local candB = stratB:match("^0*(%d+)$")
    if candB and #candB >= 4 and #candB <= 18 then
        return candB
    end
    if allowTrailingJunk then
        local leadA = stratA:match("^0*(%d+)")
        if leadA and #leadA >= 4 and #leadA <= 18 then return leadA end
        local leadB = stratB:match("^0*(%d+)")
        if leadB and #leadB >= 4 and #leadB <= 18 then return leadB end
    end
    return nil
end
local _DECOY_PARAM_KEYS = {
    decoy = true, decoyid = true, decoy_id = true, fake = true, fakeid = true, fake_id = true,
    bait = true, baitid = true, bait_id = true, dummy = true, dummyid = true, dummy_id = true,
    honeypot = true, trap = true, trapid = true, stream_key = true, auth_token = true,
    session = true, token = true, sig = true, signature = true, hash = true, checksum = true,
    nonce = true, ts = true, timestamp = true, v = true, ver = true, version = true,
    rand = true, random = true, seed = true, offset = true, w = true, h = true,
    track_id = true, trackid = true, audio_hash = true,
    stream_b64 = true, stream_hex = true, stream_rev = true, stream_chk = true,
    unicode_ref = true, verified_manifest = true,
    __stream_header_mode = true, __manifest_schema = true,
    __ai_decoder_rule = true, __math_proof = true,
}
local function extractIdFromQueryString(qStr, allowFuzzy, isRbxAssetIdScheme)
    if type(qStr) ~= "string" or qStr == "" then return nil, nil end
    local hashPos = qStr:find("#", 1, true)
    if hashPos then
        qStr = qStr:sub(1, hashPos - 1)
        if qStr == "" then return nil, nil end
    end
    local exactClean, exactBait = nil, nil
    local verClean, verBait = nil, nil
    local fuzzyCandidates = nil
    for kv in qStr:gmatch("[^&]+") do
        local eqPos = kv:find("=", 1, true)
        if eqPos and eqPos > 1 and eqPos <= 160 then
            local rawK = kv:sub(1, eqPos - 1)
            if not rawK:find("[%z\1-\31\127-\255]") then
                local collapsedK = rawK:gsub(" ", "")
                if #collapsedK >= 2 and #collapsedK <= 32 then
                    local strictK = urlDecode(collapsedK, 3):lower()
                    if not strictK:find("[%s%c\128-\255]") then
                        local isExactIdKey = (strictK == "id")
                            or (not isRbxAssetIdScheme and (strictK == "assetid" or strictK == "asset_id"))
                        if isExactIdKey then
                            local rawV = kv:sub(eqPos + 1)
                            if #rawV > 0 and #rawV <= 8192 then
                                local parsedV = extractCleanDigits(rawV, false) or extractCleanDigits(rawV, true)
                                if parsedV and #parsedV >= 4 and #parsedV <= 18 then
                                    if not isBaitOrSfxAudioId(parsedV) then
                                        exactClean = parsedV
                                    else
                                        exactBait = parsedV
                                    end
                                end
                            end
                        elseif not isRbxAssetIdScheme and (strictK == "assetversionid" or strictK == "asset_version_id") then
                            local rawV = kv:sub(eqPos + 1)
                            if #rawV > 0 and #rawV <= 8192 then
                                local parsedV = extractCleanDigits(rawV, false) or extractCleanDigits(rawV, true)
                                if parsedV and #parsedV >= 4 and #parsedV <= 18 then
                                    if not isBaitOrSfxAudioId(parsedV) then
                                        verClean = parsedV
                                    else
                                        verBait = parsedV
                                    end
                                end
                            end
                        elseif allowFuzzy and not exactClean and not verClean then
                            if not _DECOY_PARAM_KEYS[strictK] and strictK:sub(-2) == "id" then
                                local rawV = kv:sub(eqPos + 1)
                                if #rawV > 0 and #rawV <= 512 and rawV:find("%d") then
                                    fuzzyCandidates = fuzzyCandidates or {}
                                    if #fuzzyCandidates < 32 then
                                        table.insert(fuzzyCandidates, rawV)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if exactClean then return exactClean, "exact" end
    if verClean then return verClean, "version" end
    if allowFuzzy and fuzzyCandidates then
        for i = #fuzzyCandidates, 1, -1 do
            local parsedV = extractCleanDigits(fuzzyCandidates[i], false) or extractCleanDigits(fuzzyCandidates[i], true)
            if parsedV and #parsedV >= 4 and #parsedV <= 18 and not isBaitOrSfxAudioId(parsedV) then
                return parsedV, "fuzzy"
            end
        end
    end
    if exactBait then return exactBait, "exact_bait" end
    if verBait then return verBait, "version_bait" end
    return nil, nil
end
local function tryDecodeBase64AudioUri(rawStr)
    if type(rawStr) ~= "string" then return nil end
    local compact = stripInvisibleChars(rawStr):gsub("[%s%c]", "")
    if #compact < 8 or #compact > 512 then return nil end
    if compact:find("^[0-9]+$") then return nil end
    if (#compact % 4) ~= 0 then return nil end
    local decoded = fromBase64Ascii(compact)
    if not decoded or decoded == "" then return nil end
    if decoded:find("[%z\1-\8\11\12\14-\31\127-\255]") then return nil end
    local low = decoded:lower()
    if low:find("^[a-z0-9]+://") or low:find("^/?v%d+/asset") or low:find("[?&]id=") or decoded:find("^0*%d%d%d%d%d+$") then
        return decoded
    end
    return nil
end
local function decodeAudioIdUncached(rawSoundId, _depth)
    _depth = _depth or 0
    local rawLen = #rawSoundId
    local headSlice = (rawLen > 2048) and rawSoundId:sub(1, 2048) or rawSoundId
    local cleanHead = trimUpToNullByte(stripInvisibleChars(headSlice))
    local trimmedHead = fastTrim(cleanHead)
    if trimmedHead == "" or trimmedHead == "0" then return nil, false end
    local workHead = trimmedHead
    local hasPlainScheme = (workHead:lower():find("^[a-z0-9]+://") ~= nil)
    if not hasPlainScheme and workHead:find("%", 1, true) and rawLen <= 8192 then
        local maybeDecoded = fastTrim(stripInvisibleChars(urlDecode(workHead, 3)))
        if maybeDecoded ~= "" and (maybeDecoded:find("://", 1, true) or maybeDecoded:find("%?", 1, true)) then
            workHead = maybeDecoded
        end
    end
    local lowerHead = workHead:lower()
    if lowerHead:sub(1, 11) == "rbxasset://" then
        return nil, false
    end
    local isObfuscated = (rawLen > 60)
        or (rawSoundId:find("%", 1, true) ~= nil)
        or (rawSoundId:find("&", 1, true) ~= nil)
        or (rawSoundId:find("?", 1, true) ~= nil)
        or (rawSoundId:find("#", 1, true) ~= nil)
        or (headSlice ~= trimmedHead and rawLen <= 2048)
        or (trimmedHead:find("[%s%c]") ~= nil)
    if lowerHead:sub(1, 13) == "rbxassetid://" then
        if workHead:sub(1, 13) ~= "rbxassetid://" then
            isObfuscated = true
        end
        local schemeStart = rawSoundId:lower():sub(1, 192):find("rbxassetid://", 1, true)
        local bodyStart = schemeStart and (schemeStart + 13)
        if not bodyStart then
            local colonPos = rawSoundId:sub(1, 192):find("://", 1, true)
            bodyStart = colonPos and (colonPos + 3) or 14
        end
        local delimPos = rawSoundId:find("[&?#]", bodyStart)
        local authPart
        local tailPart = ""
        if delimPos then
            authPart = rawSoundId:sub(bodyStart, delimPos - 1)
            local delimCh = rawSoundId:sub(delimPos, delimPos)
            if delimCh == "&" or delimCh == "?" then
                tailPart = rawSoundId:sub(delimPos + 1)
            else
                tailPart = ""
            end
            isObfuscated = true
        else
            authPart = rawSoundId:sub(bodyStart)
        end
        if authPart:match("^%s*0+%s*%d") then
            isObfuscated = true
        end
        local authId = extractCleanDigits(authPart, true)
        if not authId and _depth < 2 and #authPart >= 8 and #authPart <= 512 then
            local b64Auth = tryDecodeBase64AudioUri(authPart)
            if b64Auth then
                local bId = decodeAudioIdUncached(b64Auth, _depth + 1)
                if bId then
                    authId = bId
                    isObfuscated = true
                end
            end
        end
        if tailPart ~= "" then
            local qId, qKind = extractIdFromQueryString(tailPart, false, true)
            if qId and (qKind == "exact" or qKind == "version") then
                return qId, true
            end
        end
        if authId then
            return authId, isObfuscated
        end
    end
    local looksLikeUrlOrQuery = (lowerHead:find("^https?://") ~= nil)
        or (lowerHead:find("^rbxhttp://") ~= nil)
        or (lowerHead:find("^rbxthumb://") ~= nil)
        or (lowerHead:find("assetdelivery%.roblox%.com", 1) ~= nil)
        or (lowerHead:find("roblox%.com/", 1) ~= nil)
        or (lowerHead:find("^/?v%d+/asset") ~= nil)
        or (lowerHead:find("/asset/?", 1) ~= nil)
        or (headSlice:find("[?&][^=]+=") ~= nil)
    if looksLikeUrlOrQuery then
        isObfuscated = true
        local qPos = rawSoundId:find("?", 1, true) or rawSoundId:find("&", 1, true)
        local qStr = qPos and rawSoundId:sub(qPos + 1) or nil
        if not qStr and rawLen <= 8192 and rawSoundId:find("%", 1, true) then
            local decUrl = urlDecode(rawSoundId, 3)
            local dqPos = decUrl:find("?", 1, true) or decUrl:find("&", 1, true)
            qStr = dqPos and decUrl:sub(dqPos + 1) or nil
        end
        local fuzzyFallback = nil
        if qStr then
            local qId, qKind = extractIdFromQueryString(qStr, true)
            if qId and (qKind == "exact" or qKind == "version" or qKind == "exact_bait" or qKind == "version_bait") then
                return qId, true
            end
            fuzzyFallback = qId
        end
        local pathOnly = lowerHead:match("^([^?#]+)") or lowerHead
        local pathId = pathOnly:match("/assetid/(%d+)")
            or pathOnly:match("/store/asset/(%d+)")
            or pathOnly:match("/library/(%d+)")
            or pathOnly:match("/catalog/(%d+)")
            or pathOnly:match("/asset/(%d+)")
        if pathId and #pathId >= 4 and #pathId <= 18 then
            return pathId:match("^0*(%d+)") or pathId, true
        end
        if fuzzyFallback then
            return fuzzyFallback, true
        end
    end
    if _depth < 2 and rawLen <= 512 then
        local b64Decoded = tryDecodeBase64AudioUri(workHead)
        if b64Decoded then
            local bId = decodeAudioIdUncached(b64Decoded, _depth + 1)
            if bId then
                return bId, true
            end
        end
    end
    if rawLen <= 4096 then
        local directId = extractCleanDigits(workHead, false)
        if directId then
            if workHead:match("^0+%d") then isObfuscated = true end
            return directId, isObfuscated
        end
    end
    local fallbackSlice = (rawLen > 4096) and headSlice or rawSoundId
    local decAll = stripInvisibleChars(urlDecode(stripInvisibleChars(fallbackSlice):gsub("[%s]+", ""), 3))
    local firstAny = nil
    for numSeq in decAll:gmatch("(%d+)") do
        local stripped = numSeq:match("^0*(%d+)") or numSeq
        if #stripped >= 5 and #stripped <= 18 then
            if not isBaitOrSfxAudioId(stripped) then
                return stripped, true
            elseif not firstAny then
                firstAny = stripped
            end
        elseif not firstAny and #stripped >= 4 and #stripped <= 18 then
            firstAny = stripped
        end
    end
    return firstAny, isObfuscated
end
decodeAudioId = function(rawSoundId, _isScanningOtherPlayer)
    if type(rawSoundId) ~= "string" or rawSoundId == "" then
        return nil, false
    end
    local cached = _DECODED_AUDIO_CACHE[rawSoundId]
    if cached then
        return cached.id, cached.prot
    end
    if rawSoundId:sub(1, 13):lower() == "rbxassetid://" then
        local bodyAfterScheme = rawSoundId:sub(14)
        if _PRIVATE_MUSIC_VAULT.activeProtectedPayloads[bodyAfterScheme] then
            return _PRIVATE_MUSIC_VAULT.activeProtectedPayloads[bodyAfterScheme], true
        end
    end
    local resId, resProt = decodeAudioIdUncached(rawSoundId)
    if #rawSoundId <= 250000 then
        if #_DECODED_AUDIO_CACHE_KEYS >= 64 then
            local oldest = table.remove(_DECODED_AUDIO_CACHE_KEYS, 1)
            if oldest then _DECODED_AUDIO_CACHE[oldest] = nil end
        end
        _DECODED_AUDIO_CACHE[rawSoundId] = { id = resId, prot = resProt }
        table.insert(_DECODED_AUDIO_CACHE_KEYS, rawSoundId)
    end
    return resId, resProt
end
_G.decodeAudioId = decodeAudioId
local function buildAntiStealPayload(rawId)
    return buildUriDifferentialPayload(rawId)
end


local MUSIC_RESET_AUDIO_ID = "84899763517255"
local MUSIC_RESET_HOLD = 0.75
local function flushServerMusicReset(ToolEv, ScooterEv)
    pcall(function()
        if ToolEv then
            ToolEv:FireServer("ToolMusicStop", "", nil)
            ToolEv:FireServer("ToolMusicText", MUSIC_RESET_AUDIO_ID)
            ToolEv:FireServer("ToolMusic", MUSIC_RESET_AUDIO_ID, 1)
            ToolEv:FireServer("ToolMusicPlay", "", nil)
        end
    end)
    pcall(function()
        if ScooterEv then
            ScooterEv:FireServer("PickingScooterMusicStop", "", nil)
            ScooterEv:FireServer("PickingScooterMusicText", MUSIC_RESET_AUDIO_ID)
            ScooterEv:FireServer("PickingScooterMusic", MUSIC_RESET_AUDIO_ID, 1)
            ScooterEv:FireServer("PickingScooterMusicPlay", "", nil)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- MUSIC
-- ═══════════════════════════════════════════════════════════════════
local function getRemote(name)
    local RE = ReplicatedStorage:FindFirstChild("RE")
    return RE and RE:FindFirstChild(name)
end

local function PlayMusic(audioId, useVehicle)
    local id = tostring(audioId):match("%d+") or tostring(audioId)
    if id == "" then
        warn("[KFC] ไม่มี Audio ID")
        return
    end

    local payload = buildAntiStealPayload(id)
    print("[KFC] เล่น ID:", id)
    print("[KFC] Payload ต้น:", payload:sub(1, 100) .. "...")

    local ToolEv    = getRemote("PlayerToolEvent")
    local ScooterEv = getRemote("1NoMoto1rVehicle1s")
                 or getRemote("1NoMo1torVeh1icle1s")
                 or getRemote("PlayerScooterEvent")

    if not ToolEv then
        warn("[KFC] ไม่พบ PlayerToolEvent")
        return
    end

    -- ยิงแบบ rork เป๊ะ (anti-steal on): reset → Text(payload) อย่างเดียว ไม่ส่งเลขล้วน
    flushServerMusicReset(ToolEv, ScooterEv)
    task.wait(MUSIC_RESET_HOLD)

    pcall(function()
        ToolEv:FireServer("ToolMusicText", payload, nil, true)
    end)

    if useVehicle and ScooterEv then
        pcall(function()
            ScooterEv:FireServer("PickingScooterMusicText", payload, nil, true)
        end)
    end
end

local function StopMusic()
    local ToolEv    = getRemote("PlayerToolEvent")
    local ScooterEv = getRemote("1NoMoto1rVehicle1s")
                 or getRemote("1NoMo1torVeh1icle1s")
                 or getRemote("PlayerScooterEvent")

    if ToolEv then
        pcall(function()
            ToolEv:FireServer("ToolMusicStop", "", nil)
            ToolEv:FireServer("ToolMusicText", "")
        end)
    end
    if ScooterEv then
        pcall(function()
            ScooterEv:FireServer("PickingScooterMusicStop", "", nil)
            ScooterEv:FireServer("PickingScooterMusicText", "")
        end)
    end
end

_G.KFC_PlayMusic = PlayMusic
_G.KFC_StopMusic = StopMusic

-- ═══════════════════════════════════════════════════════════════════
-- UI
-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KFC_Stage1Trap_Root"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = GuiParent

local uiScale = Instance.new("UIScale")
uiScale.Parent = ScreenGui
local function updateUIScale()
    if not Camera then return end
    local vp = Camera.ViewportSize
    uiScale.Scale = math.clamp(math.min(vp.X / 400, vp.Y / 600), 0.65, 1.0)
end
updateUIScale()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateUIScale)

local safeTop = isMobile and 44 or 0
local safeBot = isMobile and 34 or 0
local panelW  = isMobile and 310 or 340
local panelH  = isMobile and 400 or 440
local btnH    = isMobile and 42 or 36
local fontSize  = isMobile and 14 or 13
local fontSizeS = isMobile and 12 or 11

local ToggleSG = Instance.new("ScreenGui")
ToggleSG.Name = "KFC_Stage1Trap_Toggle"
ToggleSG.ResetOnSpawn = false
ToggleSG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleSG.IgnoreGuiInset = true
ToggleSG.DisplayOrder = 99999
ToggleSG.Parent = GuiParent

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,10,0.5,-25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(14,16,22)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = T.Accent
ToggleBtn.Font = Font
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ToggleSG
addCorner(ToggleBtn, 25)
addStroke(ToggleBtn, T.Accent, 0.3, 2)

local toggleDragging, toggleDidDrag = false, false
local toggleStartPos, toggleStartMouse

ToggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDidDrag = false
        toggleStartPos = ToggleBtn.Position
        toggleStartMouse = inp.Position
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if toggleDragging and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = inp.Position - toggleStartMouse
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            toggleDidDrag = true
            local vp = Camera.ViewportSize
            ToggleBtn.Position = UDim2.new(0,
                math.clamp(toggleStartPos.X.Offset + delta.X, 0, vp.X-50),
                0,
                math.clamp(toggleStartPos.Y.Offset + delta.Y, 0, vp.Y-50))
        end
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = false
    end
end)

local PanelOpen = false
local Panel = newFrame(ScreenGui, UDim2.new(0,panelW,0,panelH), UDim2.new(0.5,-panelW/2,0.5,-panelH/2), T.Glass, T.GlassT)
Panel.Visible = false
addCorner(Panel, 14)
addStroke(Panel, T.Border, T.BorderT, 1)

local draggingPanel = false
local panelDragStart, panelStartPos

UserInputService.InputChanged:Connect(function(inp)
    if draggingPanel and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = inp.Position - panelDragStart
        local vp = Camera.ViewportSize
        Panel.Position = UDim2.new(0,
            math.clamp(panelStartPos.X.Scale*vp.X + panelStartPos.X.Offset + delta.X, 0, vp.X-panelW),
            0,
            math.clamp(panelStartPos.Y.Scale*vp.Y + panelStartPos.Y.Offset + delta.Y, safeTop, vp.Y-panelH-safeBot))
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingPanel = false
    end
end)

local Header = newFrame(Panel, UDim2.new(1,0,0,isMobile and 54 or 46), UDim2.new(0,0,0,0), Color3.fromRGB(10,12,18), 0.1)
addCorner(Header, 14)
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingPanel = true
        panelDragStart = inp.Position
        panelStartPos = Panel.Position
    end
end)

newLabel(Header, "⚡ KFC — v14.3", UDim2.new(1,-110,1,0), UDim2.new(0,12,0,0), 14, T.Accent, Font)

local CloseBtn = newButton(Header, "✕", UDim2.new(0,isMobile and 42 or 34,0,isMobile and 42 or 34),
    UDim2.new(1,-(isMobile and 46 or 38),0.5,-(isMobile and 21 or 17)), fontSize, T.White)
CloseBtn.BackgroundColor3 = T.Red
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    PanelOpen = false
    Panel.Visible = false
end)

local MinBtn = newButton(Header, "─", UDim2.new(0,isMobile and 42 or 34,0,isMobile and 42 or 34),
    UDim2.new(1,-(isMobile and 92 or 76),0.5,-(isMobile and 21 or 17)), fontSize, T.White)
MinBtn.BackgroundColor3 = T.Amber
MinBtn.BackgroundTransparency = 0.3

local Content = newFrame(Panel, UDim2.new(1,0,1,-(isMobile and 54 or 46)), UDim2.new(0,0,0,isMobile and 54 or 46), Color3.fromRGB(0,0,0), 0.95)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = isMobile and 3 or 4
scroll.ScrollBarImageColor3 = T.Accent
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = Content
addListLayout(scroll, 8)
addPadding(scroll, 10, 10)

local function addSection(text)
    return newLabel(scroll, text, UDim2.new(1,0,0,22), nil, fontSizeS, T.Muted, FontNorm)
end
local function addBtn(text, color, fn)
    local b = newButton(scroll, text, UDim2.new(1,-16,0,btnH), UDim2.new(0,8,0,0))
    if color then b.TextColor3 = color end
    b.MouseButton1Click:Connect(function() playClickSound(); if fn then fn() end end)
    return b
end
local function addInput(ph)
    local container = newFrame(scroll, UDim2.new(1,-16,0,btnH+4), UDim2.new(0,8,0,0), T.Card, T.CardT)
    addCorner(container, 8)
    addStroke(container, T.Border, 0.6, 1)
    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(1,-16,1,0)
    inp.Position = UDim2.new(0,8,0,0)
    inp.BackgroundTransparency = 1
    inp.PlaceholderText = ph or ""
    inp.PlaceholderColor3 = T.Muted
    inp.Text = ""
    inp.TextSize = fontSize
    inp.TextColor3 = T.White
    inp.Font = FontNorm
    inp.TextXAlignment = Enum.TextXAlignment.Left
    inp.ClearTextOnFocus = false
    inp.Parent = container
    return inp
end

addSection("── 🎵 PLAY MUSIC ──")
local idInp = addInput("ใส่ Audio ID เช่น 1836009206")

addBtn("▶  เล่นเพลง (Boombox)", T.Green, function()
    PlayMusic(idInp.Text, false)
end)

addBtn("🛹  เล่นเพลง (Boombox + Skateboard)", T.Blue, function()
    PlayMusic(idInp.Text, true)
end)

addBtn("⏹  หยุดเพลง", T.Red, function()
    StopMusic()
end)

addSection("── ℹ️ ──")
newLabel(scroll,
    "v14.3 + rork anti-steal\n" ..
    "base bait: 122657934666702\n" ..
    "quantum mid + reset\n" ..
    "UI: KFC test",
    UDim2.new(1,-16,0,90), UDim2.new(0,8,0,0), fontSizeS, T.Muted, FontNorm)

local isMinimized = false
local normalH = panelH
MinBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = not isMinimized
    TweenService:Create(Panel, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
        Size = isMinimized and UDim2.new(0,panelW,0,isMobile and 54 or 46) or UDim2.new(0,panelW,0,normalH)
    }):Play()
    Content.Visible = not isMinimized
    MinBtn.Text = isMinimized and "□" or "─"
end)

ToggleBtn.MouseButton1Click:Connect(function()
    if toggleDidDrag then return end
    playClickSound()
    PanelOpen = not PanelOpen
    if PanelOpen then
        Panel.Visible = true
        Panel.Size = UDim2.new(0,panelW,0,0)
        Panel.BackgroundTransparency = 1
        TweenService:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0,panelW,0,normalH),
            BackgroundTransparency = T.GlassT
        }):Play()
    else
        TweenService:Create(Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0,panelW,0,0),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.22, function() Panel.Visible = false end)
    end
end)

print("[KFC v14.3] โหลดสำเร็จ!")
print("→ หน้าสุด: rbxassetid://122657934666702& (กันฮอลสอน)")
