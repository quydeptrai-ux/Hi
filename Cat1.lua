getgenv().config = {
    Setting = {
        ["Select Team"] = "Pirates", -- Chọn team (Pirates hoặc Marines)
    },
}

repeat wait() until game:IsLoaded()
wait(2)

local teamToSelect = getgenv().config.Setting["Select Team"] or "Pirates"

while not game.Players.LocalPlayer.Team do
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", teamToSelect)
    end)

    if success then
        print("Đã chọn team: " .. teamToSelect)
    else
        warn("Lỗi khi chọn team: ", err)
    end

    wait(1) -- Chờ 1 giây trước khi thử lại
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/quydeptrai-ux/Hi/refs/heads/main/Cat.lua"))()
