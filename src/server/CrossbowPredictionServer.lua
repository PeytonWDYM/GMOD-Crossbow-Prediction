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

    for k, v in pairs(boltSims) do
        net.Start("CrossbowThing")
        net.WriteVector(v)
        net.WriteUInt(k, 32)
        -- maybe send a config to the server listing whether they want to receive it or not (basically sending to selected clients), maybe don't use net.Broadcast()?
        net.Broadcast()
        PrintTable(boltSims)
    end
end)
