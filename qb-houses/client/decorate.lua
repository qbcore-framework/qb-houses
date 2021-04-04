DecoMode = false
local MainCamera = nil
local curPos
local speeds = {0.05, 0.1, 0.2, 0.4, 0.5}
local curSpeed = 1

local cursorEnabled = true

local SelectedObj = nil
local SelObjHash = {}
local SelObjPos = {}
local SelObjRot = {}

local curRotate = {}

local ObjectList = {}
local SelObjId = 0

local isEdit = false

local rotateActive = false
local peanut = false

local previewObj = nil
-- Only enable some controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if DecoMode then
			DisableAllControlActions(0)
			EnableControlAction(0, 32, true) -- W
			EnableControlAction(0, 33, true) -- S
			EnableControlAction(0, 245, true) -- T
			EnableControlAction(0, 21, true) -- Left Shift
			EnableControlAction(0, 19, true) -- Left Alt
			EnableControlAction(0, 288, true) -- F1
            EnableControlAction(0, 289, true) -- F2
            EnableControlAction(0, 170, true) -- F3
			EnableControlAction(0, 191, true) -- Enter
			EnableControlAction(0, 174, true) -- Left Arrow
			EnableControlAction(0, 175, true) -- Right Arrow
			EnableControlAction(0, 27, true) -- Up Arrow
			EnableControlAction(0, 173, true) -- Down Arrow
			EnableControlAction(0, 10, true) -- Page Up
            EnableControlAction(0, 11, true) -- Page Down
            EnableControlAction(0, 194, true) -- Backspace

			DisplayRadar(false)

			CheckRotationInput()
            CheckMovementInput()
            
			if SelectedObj ~= nil and peanut then
				local color = {r = 116, g = 189, b = 252, a = 100}
				DrawEntityBoundingBox(SelectedObj, color)
                DrawMarker(21, SelObjPos.x, SelObjPos.y, SelObjPos.z + 1.28, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.6, 0.6, 0.6, 28, 149, 255, 100, true, true, 2, false, false, false, false)
                if rotateActive then 
                    CheckObjRotationInput()
                else
                    CheckObjMovementInput()
                end
                if IsControlJustReleased(0, 170) then -- F3
                    rotateActive = not rotateActive
				end
				if IsControlJustReleased(0, 19) then -- Left Alt
					PlaceObjectOnGroundProperly(SelectedObj)
					local groundPos = GetEntityCoords(SelectedObj)
					SelObjPos.z = groundPos.z
                end
				if IsControlJustReleased(0, 191) then -- Enter
					SetNuiFocus(true, true)
					cursorEnabled = not cursorEnabled
					if not isEdit then
						SendNUIMessage({
							type = "buyOption",
						})
					else
						SetNuiFocus(false, false)
						cursorEnabled = not cursorEnabled
						SaveDecorations()
						SelectedObj = nil
						SelObjId = 0
						peanut = false
						isEdit = false
					end
				end
			else
				if IsControlJustPressed(0, 166) then -- F5
					if not cursorEnabled then
						SetNuiFocus(true, true)
					end
				end
            end
		end
	end
end)

-- Out of area
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if DecoMode then
			local camPos = GetCamCoord(MainCamera)
			local dist = #(vector3(camPos.x, camPos.y, camPos.z) - vector3(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z))
			if dist > 50.0 then
				DisableEditMode()
				closeDecorateUI()
				QBCore.Functions.Notify("You have gone out of range!")
			end
		end
	end
end)


RegisterNetEvent("qb-houses:client:decorate")
AddEventHandler("qb-houses:client:decorate", function()
	Citizen.Wait(500)
	if inside then 
		if hasKey then 
			if not DecoMode then
				EnableEditMode()
				openDecorateUI()
			end
		else
			QBCore.Functions.Notify("You must have the keys to the house!", "error")
		end
	else
		QBCore.Functions.Notify("You are not in a house!", "error")
	end
end)

function openDecorateUI()
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "openObjects",
		furniture = Config.Furniture,
	})
	SetCursorLocation(0.5, 0.5)
end

function closeDecorateUI()
	cursorEnabled = not cursorEnabled
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "closeUI",
	})
end

RegisterNetEvent("qb-houses:server:sethousedecorations")
AddEventHandler("qb-houses:server:sethousedecorations", function(house, decorations)
	Config.Houses[house].decorations = decorations
	if inside and closesthouse == house then 
		LoadDecorations(house)
	end
end)

RegisterNUICallback("closedecorations", function(data, cb)
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
	DisableEditMode()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("deleteSelectedObject", function(data, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	table.remove(ObjectList, SelObjId)
	Citizen.Wait(100)
	SaveDecorations()
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback("cancelSelectedObject", function(data, cb)
	DeleteObject(SelectedObj)
	SelectedObj = nil
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback("buySelectedObject", function(data, cb)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	SaveDecorations()
	SelectedObj = nil
	SelObjId = 0
	peanut = false
end)

RegisterNUICallback('setupMyObjects', function(data, cb)
	local Objects = {}
	for k, v in pairs(ObjectList) do
		if ObjectList[k] ~= nil then
			table.insert(Objects, {
				rotx = v.rotx,
				object = v.object,
				y = v.y,
				hashname = v.hashname,
				x = v.x,
				rotz = v.rotz,
				objectId = v.objectId,
				roty = v.roty,
				z = v.z,
			})
		end
	end
	Wait(100)

	cb(Objects)
end)

RegisterNUICallback('removeObject', function()
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
end)

RegisterNUICallback('toggleCursor', function()
	if cursorEnabled then
		SetNuiFocus(false, false)
	end

	cursorEnabled = not cursorEnabled
end)

RegisterNUICallback('selectOwnedObject', function(data)
	local objectData = data.objectData

	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
    local rot = GetEntityRotation(ownedObject)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
end)

RegisterNUICallback('editOwnedObject', function(data)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	local objectData = data.objectData

	local ownedObject = GetClosestObjectOfType(objectData.x, objectData.y, objectData.z, 1.5, GetHashKey(objectData.hashname), false, 6, 7)
	local pos = GetEntityCoords(ownedObject, true)
	local rot = GetEntityRotation(ownedObject)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = objectData.hashname
	SelObjId = objectData.objectId
	SelectedObj = ownedObject
	isEdit = true
	FreezeEntityPosition(SelectedObj, true)
	peanut = true
end)

RegisterNUICallback('deselectOwnedObject', function()
	SelectedObj = nil
	peanut = false
end)

RegisterNUICallback('ResetSelectedProp', function()
	SelectedObj = nil
	peanut = false
end)

RegisterNUICallback("spawnobject", function(data, cb)
	SetNuiFocus(false, false)
	cursorEnabled = not cursorEnabled
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
	local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
	    Citizen.Wait(1000)
	end
	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin( degToRad( rotation.z ) ) * -1.0
	local yVect = 2.5 * math.cos( degToRad( rotation.z ) )
	
    SelectedObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
    local pos = GetEntityCoords(SelectedObj, true)
    local rot = GetEntityRotation(SelectedObj)
    SelObjRot = {x = rot.x, y = rot.y, z = rot.z}
	SelObjPos = {x = pos.x, y = pos.y, z = pos.z}
	SelObjHash = data.object
	PlaceObjectOnGroundProperly(SelectedObj)
	SetEntityCompletelyDisableCollision(SelectedObj, true) -- Prevents crazy physics when collidin with other entitys
    peanut = true
end)

RegisterNUICallback("chooseobject", function(data, cb)
	if previewObj ~= nil then 
		DeleteObject(previewObj)
	end
    local modelHash = GetHashKey(tostring(data.object))
	RequestModel(modelHash)

	local count = 0
	while not HasModelLoaded(modelHash) do
		-- Counter to prevent infinite loading when object does not exist
		if count > 10 then
			break
		end
		count = count + 1
	    Citizen.Wait(1000)
	end

	-- Make buttons selectable again
	SendNUIMessage({
		type = "objectLoaded",
	})

	local rotation = GetCamRot(MainCamera, 2)
	local xVect = 2.5 * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = 2.5 * math.cos( degToRad( rotation.z ) )
    previewObj = CreateObject(modelHash, curPos.x + xVect, curPos.y + yVect, curPos.z, false, false, false)
    PlaceObjectOnGroundProperly(previewObj)
end)

function EnableEditMode()
	local pos = GetEntityCoords(PlayerPedId(), true)
	curPos = {x = pos.x, y = pos.y, z = pos.z}
	SetEntityVisible(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityCollision(PlayerPedId(), false, false)
	CreateEditCamera()
	DecoMode = true
	TriggerEvent('qb-anticheat:client:ToggleDecorate', true)
end

function DisableEditMode()
	SaveDecorations()
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCollision(PlayerPedId(), true, true)
	SetDefaultCamera()
	EnableAllControlActions(0)
	ObjectList = nil
	SelectedObj = nil
	peanut = false
	DecoMode = false
	TriggerEvent('qb-anticheat:client:ToggleDecorate', false)
end

function UnloadDecorations()
	if ObjectList ~= nil then 
		for k, v in pairs(ObjectList) do
			if DoesEntityExist(v.object) then
				DeleteObject(v.object)
			end
		end
	end
end

function LoadDecorations(house)
	if Config.Houses[house].decorations == nil or next(Config.Houses[house].decorations) == nil then
		QBCore.Functions.TriggerCallback('qb-houses:server:getHouseDecorations', function(result)
			Config.Houses[house].decorations = result
			if Config.Houses[house].decorations ~= nil then
				ObjectList = {}
				for k, v in pairs(Config.Houses[house].decorations) do
					if Config.Houses[house].decorations[k] ~= nil then 
						if Config.Houses[house].decorations[k].object ~= nil then
							if DoesEntityExist(Config.Houses[house].decorations[k].object) then
								DeleteObject(Config.Houses[house].decorations[k].object)
							end
						end
						local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash) do
							Citizen.Wait(10)
						end
						local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
						SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
						ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
						FreezeEntityPosition(decorateObject, true)
					end
				end
			end
		end, house)
	elseif Config.Houses[house].decorations ~= nil then
		ObjectList = {}
		for k, v in pairs(Config.Houses[house].decorations) do
			if Config.Houses[house].decorations[k] ~= nil then 
				if Config.Houses[house].decorations[k].object ~= nil then
					if DoesEntityExist(Config.Houses[house].decorations[k].object) then
						DeleteObject(Config.Houses[house].decorations[k].object)
					end
				end
				local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Citizen.Wait(10)
				end
				local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
				Config.Houses[house].decorations[k].object = decorateObject
				SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
				ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
				FreezeEntityPosition(decorateObject, true)
			end
		end
	end
end

function SaveDecorations()
	if closesthouse ~= nil then
		if SelectedObj ~= nil then
			if SelObjId ~= 0 then
				ObjectList[SelObjId] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = SelObjId}
			else
				if ObjectList ~= nil then
					ObjectList[#ObjectList+1] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = #ObjectList+1}
				else
					ObjectList[1] = {hashname = SelObjHash, x = SelObjPos.x, y = SelObjPos.y, z = SelObjPos.z, rotx = SelObjRot.x, roty = SelObjRot.y, rotz = SelObjRot.z, object = SelectedObj, objectId = #ObjectList+1}
				end
			end

			for k, v in pairs(ObjectList) do
				DeleteObject(v.object)
			end
		end
		TriggerServerEvent("qb-houses:server:savedecorations", closesthouse, ObjectList)
	end
end

function CheckObjMovementInput()
	local xVect = speeds[curSpeed]
    local yVect = speeds[curSpeed]
    local zVect = speeds[curSpeed]

    if IsControlPressed( 1, 27) or IsDisabledControlPressed(1, 27) then -- Up Arrow
    	SelObjPos.x = SelObjPos.x + xVect
    end

    if IsControlPressed( 1, 173) or IsDisabledControlPressed(1, 173) then -- Down Arrow
    	SelObjPos.x = SelObjPos.x - xVect
    end

    if IsControlPressed( 1, 174) or IsDisabledControlPressed(1, 174) then -- Left Arrow
    	SelObjPos.y = SelObjPos.y + yVect
    end

    if IsControlPressed( 1, 175) or IsDisabledControlPressed(1, 175) then -- Right Arrow
    	SelObjPos.y = SelObjPos.y - yVect
    end

    if IsControlPressed( 1, 10) or IsDisabledControlPressed(1, 10) then -- Page Up
    	SelObjPos.z = SelObjPos.z + zVect
    end

    if IsControlPressed( 1, 11) or IsDisabledControlPressed(1, 11) then -- Page Down
    	SelObjPos.z = SelObjPos.z - zVect
    end

    SetEntityCoords(SelectedObj, SelObjPos.x, SelObjPos.y, SelObjPos.z)
end

function CheckObjRotationInput()
	local xVect = speeds[curSpeed] * 5.5
    local yVect = speeds[curSpeed] * 5.5
    local zVect = speeds[curSpeed] * 5.5

	if IsControlPressed( 1, 27) or IsDisabledControlPressed(1, 27) then -- Up Arrow
    	SelObjRot.x = SelObjRot.x + xVect
    end

    if IsControlPressed( 1, 173) or IsDisabledControlPressed(1, 173) then -- Down Arrow
    	SelObjRot.x = SelObjRot.x - xVect
    end

    if IsControlPressed( 1, 174) or IsDisabledControlPressed(1, 174) then -- Left Arrow
    	SelObjRot.z = SelObjRot.z + zVect
    end

    if IsControlPressed( 1, 175) or IsDisabledControlPressed(1, 175) then -- Right Arrow
    	SelObjRot.z = SelObjRot.z - zVect
    end

    if IsControlPressed( 1, 10) or IsDisabledControlPressed(1, 10) then -- Page Up
    	SelObjRot.y = SelObjRot.y + yVect
    end

    if IsControlPressed( 1, 11) or IsDisabledControlPressed(1, 11) then -- Page Down
    	SelObjRot.y = SelObjRot.y - yVect
    end

	SetEntityRotation(SelectedObj, SelObjRot.x, SelObjRot.y, SelObjRot.z)
end

function CheckRotationInput()
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(MainCamera, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(2.0)*(4.0+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(2.0)*(4.0+0.1)), -20.5)
		SetCamRot(MainCamera, new_x, 0.0, new_z, 2)
	end
end

function CheckMovementInput()
	local rotation = GetCamRot(MainCamera, 2)

	if IsControlJustReleased(0, 21) then -- Left Shift
		curSpeed = curSpeed + 1
		if curSpeed > getTableLength(speeds) then
			curSpeed = 1
		end
		QBCore.Functions.Notify("Speed is ".. tostring(speeds[curSpeed]))
	end

	local xVect = speeds[curSpeed] * math.sin( degToRad( rotation.z ) ) * -1.0
    local yVect = speeds[curSpeed] * math.cos( degToRad( rotation.z ) )
    local zVect = speeds[curSpeed] * math.tan( degToRad( rotation.x ) - degToRad( rotation.y ))

    if IsControlPressed( 1, 32) or IsDisabledControlPressed(1, 32) then -- W
    	curPos.x = curPos.x + xVect
        curPos.y = curPos.y + yVect
        curPos.z = curPos.z + zVect
    end

    if IsControlPressed( 1, 33) or IsDisabledControlPressed(1, 33) then -- S
    	curPos.x = curPos.x - xVect
        curPos.y = curPos.y - yVect
        curPos.z = curPos.z - zVect
	end

	SetCamCoord(MainCamera, curPos.x, curPos.y, curPos.z)
end

function CreateEditCamera()
	local rot = GetEntityRotation(PlayerPedId())
	local pos = GetEntityCoords(PlayerPedId(), true)
	MainCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 60.00, false, 0)
	SetCamActive(MainCamera, true)
	RenderScriptCams(true, false, 1, true, true)
end

function SetDefaultCamera()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(MainCamera, false)
	DestroyCam(MainCamera, true)
	DestroyAllCams(true)
end

function ShowHelpNotification(msg)
	BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function getTableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function degToRad( degs )
    return degs * 3.141592653589793 / 180
end

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
	local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = 
	{ 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = 
    {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = position.z + 2 * dim.z

    local BLL = 
    {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = position.z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = 
    {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = 
    {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = 
    {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = 
    {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = 
    {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = 
    {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end