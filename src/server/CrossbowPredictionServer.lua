hook.Remove("Think", "MainThink")
util.AddNetworkString("CrossbowThing")

local boltSims = {

}


CreateConVar("crossbowPred_net_update", 0.1, FCVAR_ARCHIVE, "The rate at which the bolt simulation data is sent to the clients.")

hook.Add("Think", "MainThink", function()
    net.Receive("CrossbowThing", function(len, ply)
        local lastPos = net.ReadVector()
        local id  = net.ReadUInt(32)
        boltSims[id] = lastPos
    end)

end)


timer.Create("SendBoltSims", GetConVar("crossbowPred_net_update"):GetInt(), 0, function()
    -- clean up so that there isnt random boxes everywhere!!
    for k, v in pairs(boltSims) do
        if not IsValid(player.GetByID(k)) then
            boltSims[k] = nil
        end
    end

    for k, v in pairs(boltSims) do
        net.Start("CrossbowThing")
        net.WriteVector(v)
        net.WriteUInt(k, 32)
        net.Broadcast()
    end
end)
