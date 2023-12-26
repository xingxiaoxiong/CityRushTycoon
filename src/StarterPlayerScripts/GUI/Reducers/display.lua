local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
    updateTime = function(state, action)
        local newState = {}
        newState = table.clone(state)
        newState.time = action.time
        return newState
    end,
    updateDestination = function(state, action)
        local newState = {}
        newState = table.clone(state)
        newState.destination = action.destination
        return newState
    end,
    toggleMessageBox = function(state, action)
        local newState = {}
        newState = table.clone(state)
        if newState.showMessageBox ~= nil then
            if not newState.showMessageBox then
                newState.showAuction = false
                newState.showBackpack = false
            end
            newState.showMessageBox = not newState.showMessageBox
        else
            newState.showMessageBox = true
            newState.showAuction = false
            newState.showBackpack = false
        end
        return newState
    end,
    toggleBackpack = function(state, action)
        local newState = {}
        newState = table.clone(state)
        if newState.showBackpack ~= nil then
            if not newState.showBackpack then
                newState.showAuction = false
                newState.showMessageBox = false
            end
            newState.showBackpack = not newState.showBackpack
        else
            newState.showBackpack = true
            newState.showAuction = false
            newState.showMessageBox = false
        end
        return newState
    end,
    toggleAuction = function(state, action)
        local newState = {}
        newState = table.clone(state)
        if newState.showAuction ~= nil then
            if not newState.showAuction then
                newState.showBackpack = false
                newState.showMessageBox = false
            end
            newState.showAuction = not newState.showAuction
        else
            newState.showAuction = true
            newState.showBackpack = false
            newState.showMessageBox = false
        end
        return newState
    end,
    enterCity = function(state, action)
        local newState = {}
        newState = table.clone(state)
        newState.city = action.city
        return newState
    end,
    updateCoin = function(state, action)
        local newState = {}
        newState = table.clone(state)
        newState.coin = action.coin
        return newState
    end,
    updateMode = function(state, action)
        local newState = {}
        newState = table.clone(state)
        newState.mode = action.mode
        return newState
    end,
})

return reducer