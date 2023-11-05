--- Program by MRKEY2B ---
--- Integration MineColonies ---

-- 1. GetCitizens
    -- 1a. PrintCitizens
    -- 1b. centerText - prepareMonitor(mon)
-- 2. GetVisitors
    -- 2a. PrintVisitors
    -- 2b. centerTextv - prepareMonitor(mon3)
-- 3. GetWorkOrders
    -- 3a. PrintWorkOrders
    -- 3b. //
-- 4. GetRequests
    -- 4a. PrintRequests
    -- 4b. //

-- SETUP PROGRAM
colony = peripheral.wrap("colonyIntegrator_1")

mon = peripheral.wrap("back")
mon1 = peripheral.wrap("monitor_4")
mon2 = peripheral.wrap("monitor_5")
mon3 = peripheral.wrap("monitor_6")
mon.clear()
mon1.clear()
mon2.clear()
mon3.clear()
term.clear()

---------------

-- PNJ

function centerText(text, mon, line, txtback, txtcolor, pos)
    monX, monY = mon.getSize()
    mon.setBackgroundColor(txtback)
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        mon.setCursorPos(x+1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text) 
    elseif pos == "center" then
        mon.setCursorPos(32, line)
        mon.write(text)
    elseif pos == "right" then
        mon.setCursorPos(monX-length, line)
        mon.write(text)
    end
end

function prepareMonitor(mon) 
    mon.clear()
    mon.setTextScale(0.5)
    
    local citizens = colony.getCitizens()
    local maleCount = 0
    local femaleCount = 0
    
    for _, v in ipairs(citizens) do
        if v.gender == "male" then
            maleCount = maleCount + 1
        elseif v.gender == "female" then
            femaleCount = femaleCount + 1
        end
    end
    
    local headerText = "Ville de Sidonia - M: " .. maleCount .. " F: " .. femaleCount
    centerText(headerText, mon, 1, colors.black, colors.orange, "head")
end


function printCitizens()
    mon.clear()
    mon.setTextScale(0.5)
    local maleCount = 0
    local femaleCount = 0
    local citizens = colony.getCitizens()
    
    for _, v in ipairs(citizens) do
        if v.gender == "male" then
            maleCount = maleCount + 1
        elseif v.gender == "female" then
            femaleCount = femaleCount + 1
        end
    end
    
    local headerText = "M: " .. maleCount .. " F: " .. femaleCount
    centerText(headerText, mon, 1, colors.black, colors.lime, "right")
    centerText("Ville de Sidonia", mon, 1, colors.black, colors.orange, "head")

    local maxLinesPerColumn = 35
    
    local leftColumn = {}
    local centerColumn = {}
    local rightColumn = {}
    local leftColors = {}
    local centerColors = {}
    local rightColors = {}
    
    for _, v in ipairs(citizens) do
        local gender = ""
        local genderColor = ""
        if v.gender == "male" then
            gender = "M"
            genderColor = colors.lightBlue
        else
            gender = "F"
            genderColor = colors.pink
        end
        
        local citizenInfo = v.name .. " - " .. gender
        
        if #leftColumn < maxLinesPerColumn then
            table.insert(leftColumn, citizenInfo)
            table.insert(leftColors, genderColor)
        elseif #centerColumn < maxLinesPerColumn then
            table.insert(centerColumn, citizenInfo)
            table.insert(centerColors, genderColor)
        else
            table.insert(rightColumn, citizenInfo)
            table.insert(rightColors, genderColor)
        end
    end
    
    local line = 3
    
    for i, text in ipairs(leftColumn) do
        centerText(text, mon, line, colors.black, leftColors[i], "left")
        line = line + 1
    end
    
    line = 3
    
    for i, text in ipairs(centerColumn) do
        centerText(text, mon, line, colors.black, centerColors[i], "center")
        line = line + 1
    end
    
    line = 3
    
    for i, text in ipairs(rightColumn) do
        centerText(text, mon, line, colors.black, rightColors[i], "right")
        line = line + 1
    end
end


-- Visitor

function centerTextv(text, mon3, line, txtback, txtcolor, pos)
    mon3X, mon3Y = mon3.getSize()
    mon3.setBackgroundColor(txtback)
    mon3.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(mon3X-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        mon3.setCursorPos(x+1, line)
        mon3.write(text)
    elseif pos == "left" then
        mon3.setCursorPos(2, line)
        mon3.write(text) 
    elseif pos == "right" then
        mon3.setCursorPos(monX-length, line)
        mon3.write(text)
    end
end



function prepareMonitor(mon3) 
    mon3.clear()
    mon3.setTextScale(0.5)
    local maleCount = 0
    local femaleCount = 0
    local visitors = colony.getVisitors()
    
    for _, v in ipairs(visitors) do
        if v.gender == "male" then
            maleCount = maleCount + 1
        elseif v.gender == "female" then
            femaleCount = femaleCount + 1
        end
    end
    centerText("Ville de Sidonia", mon3, 1, colors.black, colors.orange, "head")
end

function printVisitors()
    mon3.clear()
    mon3.setTextScale(0.5)
    centerText("Visiteur de Sidonia", mon3, 1, colors.black, colors.orange, "head")
    
    local visitors = colony.getVisitors()
    local line = 3
    local scrollCounter = 0
    local groupCounter = 0
    local linesPerGroup = 10

    local maleCount = 0
    local femaleCount = 0
    
    for _, v in ipairs(visitors) do
        if v.gender == "male" then
            maleCount = maleCount + 1
        elseif v.gender == "female" then
            femaleCount = femaleCount + 1
        end
    end

    for _, visitor in ipairs(visitors) do

        if groupCounter == 0 then
            mon3.clear()
            local headerText = "M: " .. maleCount .. " F: " .. femaleCount
            centerText(headerText, mon3, 1, colors.black, colors.lime, "right")
            centerText("Visiteur de Sidonia", mon3, 1, colors.black, colors.orange, "head")
            line = 3
        end
        
        if scrollCounter == 60 then
            sleep(2)
            mon3.scroll(1)
            mon3.setCursorPos(1, mon3.getSize())
            mon3.write("                 ")
            scrollCounter = 0
        end
        
        centerText("Nom: " .. visitor.name, mon3, line, colors.black, colors.white, "left")
        line = line + 1
        centerText("Genre: " .. visitor.gender, mon3, line, colors.black, colors.white, "left")
        line = line + 1

        if visitor.recruitCost then
            for _, item in ipairs(visitor.recruitCost) do
                centerText("Coût: " .. item.displayName .. " x" .. item.count, mon3, line, colors.black, colors.white, "left")
                line = line + 1
            end
        end
        
        line = line + 2
        
        scrollCounter = scrollCounter + 1
        groupCounter = groupCounter + 1
        
        if groupCounter == linesPerGroup then
            groupCounter = 0
            sleep(10)
        end
    end
end


function printWorkOrders()
    mon1.setTextScale(0.5)
    centerText("Liste des Work Orders", mon1, 1, colors.black, colors.orange, "head")
    
    local workOrders = colony.getWorkOrders()
    local line = 3
    local isBuilderPositionShown = false
    
    local scrollCounter = 0
    local groupCounter = 0
    local linesPerGroup = 16

    centerText("R: " .. #workOrders, mon1, 2, colors.black, colors.orange, "right")
    
    for _, workOrder in ipairs(workOrders) do

        if groupCounter == 0 then
            mon1.clear()
            centerText("Liste des Work Orders", mon1, 1, colors.black, colors.orange, "head")
            centerText("R: " .. #workOrders, mon1, 1, colors.black, colors.lime, "right")
            line = 3
        end

        if scrollCounter == 60 then
            sleep(2)
            mon1.scroll(1)
            mon1.setCursorPos(1, mon1.getSize())
            mon1.write("                 ")
            scrollCounter = 0
        end
        
        if workOrder.builder then
            isBuilderPositionShown = true
            mon1.setTextColor(colors.lime)
        else
            isBuilderPositionShown = false
            mon1.setTextColor(colors.white)
        end
        
        centerText("Type: " .. workOrder.workOrderType, mon1, line, colors.black, colors.white, "left")
        line = line + 1
        centerText("Building: " .. workOrder.buildingName, mon1, line, colors.black, colors.white, "left")
        line = line + 1
        if workOrder.builder then
            centerText("Builder Position: " .. workOrder.builder.x .. ", " .. workOrder.builder.y .. ", " .. workOrder.builder.z, mon1, line, colors.black,  colors.lime, "left")
            line = line + 1
        end
        
        line = line + 2
        
        scrollCounter = scrollCounter + 1
        groupCounter = groupCounter + 1
    
        if groupCounter == linesPerGroup then
            groupCounter = 0
            sleep(10)
        end
    end
end



function printRequests()
    mon2.clear()
    mon2.setTextScale(0.5)
    centerText("Liste des Demandes", mon2, 1, colors.black, colors.orange, "head")
    
    local requests = colony.getRequests()
    local line = 3
    local scrollCounter = 0
    local groupCounter = 0
    local linesPerGroup = 10
    
    for _, request in ipairs(requests) do

        if groupCounter == 0 then
            mon2.clear()
            centerText("Liste des Demandes", mon2, 1, colors.black, colors.orange, "head")
            centerText("R: " .. #requests, mon2, 1, colors.black, colors.lime, "right")
            line = 3
        end
        
        if scrollCounter == 60 then
            sleep(2)
            mon2.scroll(1)
            mon2.setCursorPos(1, mon2.getSize())
            mon2.write("                 ")
            scrollCounter = 0
        end
        
        centerText("Demandeur: " .. request.target, mon2, line, colors.black, colors.red, "left")
        line = line + 2
        centerText("Name: " .. request.name, mon2, line, colors.black, colors.white, "left")
        line = line + 1
        --centerText("Description: " .. request.desc, mon2, line, colors.black, colors.white, "left")
        --line = line + 1
        centerText("State: " .. request.state, mon2, line, colors.black, colors.white, "left")
        line = line + 1
        centerText("Count: " .. request.count, mon2, line, colors.black, colors.white, "left")
        line = line + 1
        centerText("Minimum Count: " .. request.minCount, mon2, line, colors.black, colors.white, "left")
        line = line + 1
        
        if request.items then
            for _, item in ipairs(request.items) do
               -- centerText("Item: " .. item.displayName, mon2, line, colors.black, colors.white, "left")
                --line = line + 1
                centerText("Count: " .. item.count, mon2, line, colors.black, colors.white, "left")
                line = line + 1
            end
        end
        
        line = line + 2
        
        scrollCounter = scrollCounter + 1
        groupCounter = groupCounter + 1
        
        if groupCounter == linesPerGroup then
            groupCounter = 0
            sleep(10)
        end
    end
end

-- Start Program --

prepareMonitor(mon)
prepareMonitor(mon3)

while true do
    printCitizens()
    printVisitors()
    printWorkOrders()
    printRequests()
    sleep(10)
end
