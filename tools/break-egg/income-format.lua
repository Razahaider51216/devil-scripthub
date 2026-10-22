    local incomeUnits={{"Dc",1e33},{"No",1e30},{"Oc",1e27},{"Sp",1e24},{"Sx",1e21},{"Qi",1e18},{"Qa",1e15},{"T",1e12},{"B",1e9},{"M",1e6},{"k",1e3}}
    local function formatIncome(value)
        for _,unit in ipairs(incomeUnits)do
            if value>=unit[2]then
                local amount=value/unit[2]
                local text=string.format("%.15g",amount)
                -- Keep a short label only when it represents the exact threshold.
                if tonumber(text)*unit[2]==value then return text..unit[1]end
                break
            end
        end
        return tostring(value)
    end
