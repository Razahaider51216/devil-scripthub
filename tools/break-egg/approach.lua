    local eggReachSettings={Margin=1,StandOff=2,RecoveryStandOff=.5,SearchSteps=24}
    local function eggReach()
        return math.max(0,(tonumber(eggConfig.HitRange)or 8)-eggReachSettings.Margin)
    end
    local function eggHitDistance(m,position)
        if m:IsA("BasePart")and type(eggTargeting.SurfaceDistance)=="function"then
            local ok,value=pcall(eggTargeting.SurfaceDistance,m,position)
            if ok and type(value)=="number"and value==value and value<math.huge then return math.max(0,value)end
        end
        return surfaceDistance(m,position)
    end
    local function eggApproach(m,root,closer)
        local center=m and point(m);if not center then return end
        local origin=root.Position
        local distance=eggHitDistance(m,origin)
        local standOff=closer and math.min(eggReachSettings.RecoveryStandOff,eggReach())or math.max(0,eggReach()-eggReachSettings.StandOff)
        if distance<=standOff then return origin,distance end
        -- Use the game's surface metric for both navigation and the swing gate.
        -- A large mesh's bounding box can extend beyond its actual hit surface.
        local inside=Vector3.new(center.X,origin.Y,center.Z)
        if eggHitDistance(m,inside)>standOff then return inside,distance end
        local outside=origin
        for _=1,eggReachSettings.SearchSteps do
            local middle=(outside+inside)*.5
            if eggHitDistance(m,middle)<=standOff then inside=middle else outside=middle end
        end
        return inside,distance
    end
