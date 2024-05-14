hook.Remove("PostDrawTranslucentRenderables", "MainDraw")
hook.Remove("OnEntityCreated", "RegisterBolt")
hook.Remove("EntityRemoved", "RemoveBolt")
hook.Remove("HUDPaint", "MainHudPaint")
hook.Remove("KeyPress", "startPersist")
hook.Remove("CalcView", "MainCalcView")
hook.Remove("PopulateToolMenu", "crossbowSettings")
hook.Remove("InitPostEntity", "CrossbowPredictionInit")
hook.Remove("CalcView", "RTCalcView")


-----------------------------------------------------
-- Made by Peyton

local vars = {
    crossbowPred_enabled = {
        value = 1,
        info = "Enables the crossbow bolt prediction."
    },
    crossbowPred_colorRed = {
        subValue = true,
        subValues = {
            predPos = 255,
            hitPos = 0,
            lastPos = 21,
            otherPlayers = 0,
            boltPos = 0,
            actualPredPos = 255,
        },
        info = "The color of the bolt prediction."
    },
    crossbowPred_colorGreen = {
        subValue = true,
        subValues = {
            predPos = 174,
            hitPos = 0,
            lastPos = 255,
            otherPlayers = 17,
            boltPos = 0,
            actualPredPos = 255,

        },
        info = "The color of the bolt prediction."
    },
    crossbowPred_colorBlue = {
        subValue = true,
        subValues = {
            predPos = 0,
            hitPos = 0,
            lastPos = 0,
            otherPlayers = 255,
            boltPos = 255,
            actualPredPos = 255,
        },
        info = "The color of the bolt prediction."
    },
    crossbowPred_serverTickPred = {
        value = 1,
        info = "Use the server's tickrate to predict the bolt's trajectory. (Probably the best accuracy but can be jittery if the server has an unstable tickrate)"
    },
    crossbowPred_simstep = {
        value = 0,
        info = "The higher the interval, the better the simulation of a crossbow bolt (More accurate but less performance). No effect whenever we use the server's tickrate to predict the bolt's trajectory."
    },
    crossbowPred_simtime = {
        value = 10,
        info = "The amount of time the bolt will be simulated for in seconds. (NOT ALWAYS ACURATE!)"
    },
    crossbowPred_maxsim = {
        value = 7,
        info = "The amount of bolt simulations that can be shown at once."
    },
    crossbowPred_followBolt = {
        value = 1,
        info = "Follows the bolt itself when you shoot it."
    },
    crossbowPred_followBolt_popoutBox = {
        value = 0,
        info = "Pops out a box showing the camera that is following the bolt."
    },
    crossbowPred_followBolt_restoredViewAngles = {
        value = 0,
        info = "Restores your view angles after the bolt is removed from the world."
    },
    crossbowPred_followBoltOffsetX = {
        value = 0,
        info = "The offset of the bolt on the X axis."
    },
    crossbowPred_followBoltOffsetY = {
        value = 0,
        info = "The offset of the bolt on the Y axis."
    },
    crossbowPred_followBoltOffsetZ = {
        value = 0,
        info = "The offset of the bolt on the Z axis."
    },
    crossbowPred_sendPos = {
        value = 1,
        info = "Sends the position of the bolt to the server to show to other players (Useful for your friends to see the bolt simulation too!)"
    },
    crossbowPred_receivePos = {
        value = 1,
        info = "Receives the info of other player's bolt simulation. (Useful for seeing where your friends are shooting their bolts)"
    },
    crossbowPred_showLastPos = {
        value = 1,
        info = "Shows the last position of the bolt."
    },
    crossbowPred_showHitPos = {
        value = 1,
        info = "Shows the position where the bolt is predicted to hit a surface."
    },
    crossbowPred_showPredictedPos = {
        value = 1,
        info = "Shows the predicted position of the bolt."
    },
    crossbowPred_showActualPos = {
        value = 1,
        info = "Shows the actual position of the bolt."
    },
    crossbowPred_showInfo ={
        value = 1,
        info = "Shows the total amount of bounces and the entity that was hit by the bolt"
    },

}

hook.Add("PopulateToolMenu", "crossbowSettings", function()
    spawnmenu.AddToolMenuOption("Utilities", "Crossbow Prediction", "crossbowSettings", "Settings", "", "", function(panel)
        panel:CheckBox("Enabled", "crossbowPred_enabled")

        panel:Help("\n--- Color Settings ---")
        panel:ColorPicker("Trajectory Color", "crossbowPred_colorRed_predPos", "crossbowPred_colorGreen_predPos", "crossbowPred_colorBlue_predPos")
        panel:ColorPicker("Actual Trajectory Color", "crossbowPred_colorRed_actualPredPos", "crossbowPred_colorGreen_actualPredPos", "crossbowPred_colorBlue_actualPredPos")
        panel:ColorPicker("Hit Position Color", "crossbowPred_colorRed_hitPos", "crossbowPred_colorGreen_hitPos", "crossbowPred_colorBlue_hitPos")
        panel:ColorPicker("Last Position Color", "crossbowPred_colorRed_lastPos", "crossbowPred_colorGreen_lastPos", "crossbowPred_colorBlue_lastPos")
        panel:ColorPicker("Other Players Color", "crossbowPred_colorRed_otherPlayers", "crossbowPred_colorGreen_otherPlayers", "crossbowPred_colorBlue_otherPlayers")
        panel:ColorPicker("Bolt Position Color", "crossbowPred_colorRed_boltPos", "crossbowPred_colorGreen_boltPos", "crossbowPred_colorBlue_boltPos")

        panel:Help("\n--- Simulation Settings ---")

        panel:CheckBox("Use Server's Tickrate", "crossbowPred_serverTickPred")
        panel:ControlHelp(vars.crossbowPred_serverTickPred.info)
        panel:NumSlider("Simulation Step Interval", "crossbowPred_simstep", 1, 600, 0)
        panel:ControlHelp(vars.crossbowPred_simstep.info)
        panel:NumSlider("Simulation Time", "crossbowPred_simtime", 0, 30)
        panel:ControlHelp(vars.crossbowPred_simtime.info)
        panel:NumSlider("Max Simulations", "crossbowPred_maxsim", 0, 15, 0)
        panel:ControlHelp(vars.crossbowPred_maxsim.info)


        panel:Help("\n--- Visual Settings ---")
        panel:CheckBox("Follow Bolt", "crossbowPred_followBolt")
        panel:ControlHelp(vars.crossbowPred_followBolt.info)
        panel:CheckBox("Follow Bolt Popout Box", "crossbowPred_followBolt_popoutBox")
        panel:ControlHelp(vars.crossbowPred_followBolt_popoutBox.info)
        panel:CheckBox("Restore View Angles", "crossbowPred_followBolt_restoredViewAngles")
        panel:ControlHelp(vars.crossbowPred_followBolt_restoredViewAngles.info)
        panel:NumSlider("Follow Bolt Offset X", "crossbowPred_followBoltOffsetX", -200, 200)
        panel:ControlHelp(vars.crossbowPred_followBoltOffsetX.info)
        panel:NumSlider("Follow Bolt Offset Y", "crossbowPred_followBoltOffsetY", -200, 200)
        panel:ControlHelp(vars.crossbowPred_followBoltOffsetY.info)
        panel:NumSlider("Follow Bolt Offset Z", "crossbowPred_followBoltOffsetZ", -200, 200)
        panel:ControlHelp(vars.crossbowPred_followBoltOffsetZ.info)
        panel:CheckBox("Show Predicted Position", "crossbowPred_showPredictedPos")
        panel:ControlHelp(vars.crossbowPred_showPredictedPos.info)
        panel:CheckBox("Show Hit Position", "crossbowPred_showHitPos")
        panel:ControlHelp(vars.crossbowPred_showHitPos.info)
        panel:CheckBox("Show Last Position", "crossbowPred_showLastPos")
        panel:ControlHelp(vars.crossbowPred_showLastPos.info)
        panel:CheckBox("Show Actual Position", "crossbowPred_showActualPos")
        panel:ControlHelp(vars.crossbowPred_showActualPos.info)
        panel:CheckBox("Show Info", "crossbowPred_showInfo")
        panel:ControlHelp(vars.crossbowPred_showInfo.info)

        panel:Help("\n--- Network Settings ---")
        panel:CheckBox("Send Position", "crossbowPred_sendPos")
        panel:ControlHelp(vars.crossbowPred_sendPos.info)
        panel:CheckBox("Receive Position", "crossbowPred_receivePos")
        panel:ControlHelp(vars.crossbowPred_receivePos.info)
    end)
end)


for k, v in pairs(vars) do
    if v.subValue then
        for subK, subV in pairs(v.subValues) do
            CreateClientConVar(k .. "_" .. subK, subV, true, false, v.info)
        end
    else
        CreateClientConVar(k, v.value, true, false, v.info)
    end
end

hook.Add("InitPostEntity", "CrossbowPredictionInit", function()
    local ply = LocalPlayer()

    local sv_gravity = Vector(0, 0, -GetConVar("sv_gravity"):GetInt())
    local boltSims = {
        simulated_shot = {
            gravity = sv_gravity * 0.05,
            fullGravityApplied = false,
            velocity = Vector(0, 0, 0),
            mins = Vector(-1, -1, -1),
            maxs = Vector(1, 1, 1),
            predictedPositions = {},
            hitPositions = {},
            lastPos = Vector(0, 0, 0),
            persist = false,
            followBolt = GetConVar("crossbowPred_followBolt"):GetBool(),
            completionTime = 0,
            hitEntity = "Nothing",
        },
        
    }
    
    
    local net_boltSims = {
    
    }
    
    local plyViewAngles = Angle(0, 0, 0)
    local shouldSaveViewAngles = true
    local restoreViewAngles = false
    
    
    
    hook.Add("OnEntityCreated", "RegisterBolt", function(ent)
        if ent:GetClass() == "crossbow_bolt" and ent:GetOwner() == ply then
            print("Registered bolt")
            boltSims[ent] = {
                gravity = physenv.GetGravity() * 0.05,
                velocity = ent:GetAbsVelocity(),
                mins = ent:OBBMins(),
                maxs = ent:OBBMaxs(),
                predictedPositions = {},
                hitPositions = {},
                actualPositions = {},
                persist = false,
                completionTime = 0,
                currentPos = ent:GetPos(),
            }

        end
    end)
    
    hook.Add("EntityRemoved", "RemoveBolt", function(ent)
        if boltSims[ent] then
            print("Removed bolt")
            boltSims[ent] = nil 
            boltSims["simulated_shot"].persist = false
            restoreViewAngles = true

            timer.Simple(0.1, function()
                shouldSaveViewAngles = true
            end)
        end
    end)
    
    
    hook.Add("KeyPress", "startPersist", function(ply, key)
        local data = boltSims["simulated_shot"]
        if key == IN_ATTACK then
            data.persist = true
            boltSims["simulated_shot"].completionTime = SysTime()
            shouldSaveViewAngles = false
        end
    end)
    
    
    
    print(" $=-=-=-=-=-= Crossbow Prediction Loaded! =-=-=-=-=-=$")
    print(" $=-=-=-=-=-= Crossbow Prediction Loaded! =-=-=-=-=-=$")
    print(" $=-=-=-=-=-= Crossbow Prediction Loaded! =-=-=-=-=-=$")
    print(" $=-=-=-=-=-= Crossbow Prediction Loaded! =-=-=-=-=-=$")
    print(" $=-=-=-=-=-= Crossbow Prediction Loaded! =-=-=-=-=-=$")
    
    hook.Add("PostDrawTranslucentRenderables", "MainDraw", function()
        if GetConVar("crossbowPred_enabled"):GetBool() == false then return end
        -- time in seconds
        local simTime = GetConVar("crossbowPred_simtime"):GetFloat()
        local maxSims = GetConVar("crossbowPred_maxsim"):GetInt()
        local currentSims = 0
        local frameTimePrediction = GetConVar("crossbowPred_serverTickPred"):GetBool()
        local simSegments = 0
    
        --PrintTable(net_boltSims)
    
    
    
    
    
        local boltVel = 3500
    
        if ply:WaterLevel() > 2 then
            boltVel = 1500
        end
    
        
    
    
    
        local wep = ply:GetActiveWeapon()
        local shootPos = ply:GetShootPos()
        local shootVel = ply:GetAimVector() * boltVel

        if shouldSaveViewAngles then
            plyViewAngles = ply:EyeAngles()
        end
    
        
    
        function simPhys(startVel, startPos, ent, remainingTime)
            if startVel:Length() < 1 then return end
            if currentSims > maxSims then 
                boltSims[ent].lastPos = startPos
                return
            end
    
            if frameTimePrediction then
                simSegments = remainingTime * 1/engine.TickInterval()
            else
                simSegments = remainingTime * GetConVar("crossbowPred_simstep"):GetInt()
            end
            local simStep = remainingTime / simSegments
            
    
    
            local function bounceBolt(vel, normal, predictedPos, timeStep)
    
                local data = boltSims[ent]
                local speed = vel:Length()
                local vecDir = vel:GetNormalized()
                local dot = vecDir:Dot(-normal)
            
                if dot < 0.5 and speed > 100 then
                    local reflection = 2 * normal * dot + vecDir
                    
                    local newVel = (reflection * speed) * 0.75
    
                    
                    if not data.fullGravityApplied then
                        data.gravity = physenv.GetGravity()
                        data.fullGravityApplied = true  
                    end
    
                    
                    local newPos = predictedPos + newVel * timeStep
    
                    return newPos, newVel, true
                else
                    return predictedPos, vel, false
                end
            end
    
            
    
    
            local predictedVel = startVel
            local predictedPos = startPos
    
            table.insert(boltSims[ent].predictedPositions, predictedPos)
    
            local t = 0
            
    
    
            while t < remainingTime do
                predictedVel = (predictedVel + boltSims[ent].gravity * simStep)
    
                local newPos = predictedPos + predictedVel * simStep
    
                local tr = util.TraceHull({
                    start = predictedPos,
                    endpos = newPos,
                    mins = boltSims[ent].mins,
                    maxs = boltSims[ent].maxs,
                    filter = {ply, ent},
                    mask = MASK_SHOT,
                })
    
    
                if tr.Hit then
                    local surfaceNormal = tr.HitNormal
                    local entityHit = tr.Entity
    
                    if tr.HitSky then
                        boltSims[ent].lastPos = tr.HitPos
                        break
                    end
    
                    if IsValid(entityHit) then
                        boltSims[ent].hitEntity = entityHit
                    end
                    newPos = tr.HitPos
    
                    table.insert(boltSims[ent].predictedPositions, newPos)
                    table.insert(boltSims[ent].hitPositions, newPos)
    
                    local newPos, newVel, bounced = bounceBolt(predictedVel, surfaceNormal, newPos, simStep)
    
                    if bounced then
                        currentSims = currentSims + 1
                        table.insert(boltSims[ent].predictedPositions, newPos)
                        simPhys(newVel, newPos, ent, remainingTime - t - simStep)
                        break
                    else 
                        table.insert(boltSims[ent].predictedPositions, newPos)
                        boltSims[ent].lastPos = newPos
                    end
                    break
                else 
                    predictedPos = newPos
                    table.insert(boltSims[ent].predictedPositions, predictedPos)
                end
                t = t + simStep
            end
        end


        if GetConVar("crossbowPred_receivePos"):GetBool() then
            net.Receive("CrossbowThing", function(len)
                local lastPos = net.ReadVector()
                local id = net.ReadUInt(32)
                if id == ply:UserID() then return end
                net_boltSims[id] = lastPos
            end)
        end
    
    
    
        if IsValid(wep) and wep:GetClass() == "weapon_crossbow" then
            -- do server stuff here (we are the client)
    
            local shotData = boltSims["simulated_shot"]
            -- reset all values!
            if shotData.persist then
                for ent, data in pairs(boltSims) do 
                    data.entity = ent
                    if IsValid(ent) then
                        if GetConVar("crossbowPred_showActualPos"):GetBool()  then
                            data.currentPos = ent:GetPos()
    
                            if GetConVar("crossbowPred_followBolt"):GetBool() == false then
                                -- we dont wanna draw the box if we are following the bolt
                                render.DrawWireframeSphere(data.currentPos, 5, 10, 10, Color(
                                    GetConVar("crossbowPred_colorRed_boltPos"):GetInt(),
                                    GetConVar("crossbowPred_colorGreen_boltPos"):GetInt(),
                                    GetConVar("crossbowPred_colorBlue_boltPos"):GetInt()
                                ), false)
                            end
                            table.insert(data.actualPositions, data.currentPos)
    
                            for i = 1, #data.actualPositions - 1 do 
                                local startPos = data.actualPositions[i]
                                local endPos = data.actualPositions[i + 1]
                        
                                render.DrawLine(startPos, endPos, Color(
                                    GetConVar("crossbowPred_colorRed_actualPredPos"):GetInt(),
                                    GetConVar("crossbowPred_colorGreen_actualPredPos"):GetInt(),
                                    GetConVar("crossbowPred_colorBlue_actualPredPos"):GetInt()
                                ), false)
                            end
                        end
                    end
                end
            else 
                boltSims["simulated_shot"] = {
                    gravity = physenv.GetGravity() * 0.05,
                    fullGravityApplied = false,
                    velocity = Vector(0, 0, 0),
                    mins = Vector(-1, -1, -1),
                    maxs = Vector(1, 1, 1),
                    predictedPositions = {},
                    hitPositions = {},
                    lastPos = Vector(0, 0, 0),
                    persist = false,
                    followBolt = true ,
                    completionTime = 0,
                    hitEntity = "Nothing",
                }
                simPhys(shootVel, shootPos, "simulated_shot", simTime)
            end
        else
            boltSims["simulated_shot"] = {
                gravity = physenv.GetGravity() * 0.05,
                fullGravityApplied = false,
                velocity = Vector(0, 0, 0),
                mins = Vector(-1, -1, -1),
                maxs = Vector(1, 1, 1),
                predictedPositions = {},
                hitPositions = {},
                lastPos = Vector(0, 0, 0),
                persist = false,
                followBolt = true ,
                completionTime = 0,
                hitEntity = "Nothing",
            }
        end
    
    
        if GetConVar("crossbowPred_showPredictedPos"):GetBool() then
            for ent, data in pairs(boltSims) do 
                local predictedPositions = data.predictedPositions
                for i = 1, #predictedPositions - 1 do 
                    local startPos = predictedPositions[i]
                    local endPos = predictedPositions[i + 1]
            
                    render.DrawLine(startPos, endPos, Color(
                        GetConVar("crossbowPred_colorRed_predPos"):GetInt(),
                        GetConVar("crossbowPred_colorGreen_predPos"):GetInt(),
                        GetConVar("crossbowPred_colorBlue_predPos"):GetInt()
                    ), false)
                end
            end
        end
    
        if GetConVar("crossbowPred_showHitPos"):GetBool() then
            for ent, data in pairs(boltSims) do 
                local hitPositions = data.hitPositions
                for i = 1, #hitPositions - 1 do 
                    local hitPos = hitPositions[i]
    
                    render.DrawWireframeSphere(hitPos, 5, 100, 100, Color(
                        GetConVar("crossbowPred_colorRed_hitPos"):GetInt(),
                        GetConVar("crossbowPred_colorGreen_hitPos"):GetInt(),
                        GetConVar("crossbowPred_colorBlue_hitPos"):GetInt()
                    ), false)
                end
            end
        end
    
        if GetConVar("crossbowPred_showLastPos"):GetBool() then
            render.DrawWireframeSphere(boltSims["simulated_shot"].lastPos, 8, 100, 100, Color(
                GetConVar("crossbowPred_colorRed_lastPos"):GetInt(),
                GetConVar("crossbowPred_colorGreen_lastPos"):GetInt(),
                GetConVar("crossbowPred_colorBlue_lastPos"):GetInt()
            ), false)
        end

        local rt = GetRenderTarget("crossbowPredRT", 512, 512)
        local rtMat = CreateMaterial("crossbowPredRtMat", "UnlitGeneric", {
            ["$basetexture"] = rt:GetName(),
        })




    
        hook.Add("HUDPaint", "MainHudPaint", function()
            if not (wep:GetClass() == "weapon_crossbow") then return end
            if GetConVar("crossbowPred_enabled"):GetBool() == false then return end
            if GetConVar("crossbowPred_showInfo"):GetBool() == false then return end
            local w, h = ScrW(), ScrH()
            local x, y = w / 2, h / 2
    
            local text = "Total Bounces: " .. #boltSims["simulated_shot"].hitPositions - 1
            local text2 = "Entity Hit: " .. tostring(boltSims["simulated_shot"].hitEntity)
            -- put at top center of screen
            draw.SimpleText(text, "DermaLarge", x, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(text2, "DermaLarge", x, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if GetConVar("crossbowPred_followBolt_popoutBox"):GetBool() then
                for ent, data in pairs(boltSims) do 
                    data.entity = ent 
                    if IsValid(ent) then
                        render.PushRenderTarget(rt)
                        
                        cam.Start({type="3D"})
                        local currentPos = ent:GetPos()
                        local currentVel = ent:GetVelocity()
                        local speed = currentVel:Length()
                
                
                        local normalizedVel = currentVel:GetNormalized()
                        local dynamicOffset = normalizedVel * -20
                
                        local fixedOffset = Vector(
                            GetConVar("crossbowPred_followBoltOffsetX"):GetInt(),
                            GetConVar("crossbowPred_followBoltOffsetY"):GetInt(),
                            GetConVar("crossbowPred_followBoltOffsetZ"):GetInt()
                        )
                

                        local worldOffset = ent:LocalToWorld(fixedOffset)

                        local movementToOrigin = currentPos + dynamicOffset + (worldOffset - ent:GetPos())

                        local camAngles = (ent:GetPos() - movementToOrigin):Angle()

                        -- TODO: we add a bit of animation to camAngles



                        render.RenderView({
                            origin = movementToOrigin,
                            angles = camAngles,
                            x = 0,
                            y = 0,
                            w = 512,
                            h = 512,
                            drawhud = false,
                            drawmonitors = false,
                            drawviewmodel = false,
                            dopostprocess = false,
                        })
                        cam.End()

                        render.PopRenderTarget()

                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial(rtMat)
                        surface.DrawTexturedRect(0, 0, 512, 512)

                        
                    end
                end
            end

        end)

        
    
        hook.Add("CalcView", "MainCalcView", function(ply, pos, angles, fov)
            if GetConVar("crossbowPred_enabled"):GetBool() == false then return end
            if GetConVar("crossbowPred_followBolt"):GetBool() == false then return end
            if GetConVar("crossbowPred_followBolt_popoutBox"):GetBool() then return end
            for ent, data in pairs(boltSims) do
                data.entity = ent
                if IsValid(ent) then
                    local currentPos = ent:GetPos()

                    if boltSims["simulated_shot"].persist and boltSims["simulated_shot"].followBolt then
                        local fixedOffset = Vector(
                            GetConVar("crossbowPred_followBoltOffsetX"):GetInt(),
                            GetConVar("crossbowPred_followBoltOffsetY"):GetInt(),
                            GetConVar("crossbowPred_followBoltOffsetZ"):GetInt()
                        )
                        
                        local worldOffset = ent:LocalToWorld(fixedOffset)

                        return {
                            origin = currentPos + (worldOffset - ent:GetPos()),
                            angles = angles,
                            fov = fov,
                            drawviewer = true
                        }

                    else
                        return {
                            origin = pos,
                            angles = angles,
                            fov = fov
                        }
                    end
                end
            end
            if GetConVar("crossbowPred_followBolt_restoredViewAngles"):GetBool() then
                if restoreViewAngles then
                    ply:SetEyeAngles(plyViewAngles)
                    restoreViewAngles = false
                end
            end
        end)
    
    
    
    
        -- check if there are any old bolt simulations that need to be removed
    
    
    
    
    
        if GetConVar("crossbowPred_receivePos"):GetBool() then
            for id, pos in pairs(net_boltSims) do
                render.DrawWireframeBox(pos, Angle(0, 0, 0), Vector(-15,-15,-15), Vector(15,15,15), Color(
                    GetConVar("crossbowPred_colorRed_otherPlayers"):GetInt(),
                    GetConVar("crossbowPred_colorGreen_otherPlayers"):GetInt(),
                    GetConVar("crossbowPred_colorBlue_otherPlayers"):GetInt()
                ), false)
            end
        end
    
    
    end)
    
    
    timer.Create("SendBoltData", 0.1, 0, function()
        if GetConVar("crossbowPred_sendPos"):GetBool() == false then return end
        net.Start("CrossbowThing")
        net.WriteVector(boltSims["simulated_shot"].lastPos)
        net.WriteUInt(ply:UserID(), 32)
        net.SendToServer()
    end)

end)    

