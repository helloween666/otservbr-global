local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local config = {
	towns = {
		["venore"] = 9,
		["thais"] = 8,
		["kazordoon"] = 7,
		["carlin"] = 6,
		["ab\'dendriel"] = 5,
		["liberty bay"] = 14,
		["port hope"] = 15,
		["ankrahmun"] = 10,
		["darashia"] = 13,
		["edron"] = 11
	},
}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.AdventurersGuild.CharosTrav) > 6 then
		npcHandler:say("Sorry, you have traveled a lot.", cid)
		npcHandler:resetNpc(cid)
		return false
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello young friend! I can attune you to a city of your choice. If you step to the teleporter here you will not appear in the city you came from as usual, but the city of your choice. Is it what you wish?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if npcHandler.topic[cid] == 0 then
		if msgcontains(msg, "yes") then
			npcHandler:say("Fine. You have ".. -player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+7 .." attunements left. What is the new city of your choice? Thais, Carlin, Ab'Dendriel, Kazordoon, Venore, Ankrahmun, Edron, Darashia, Liberty Bay or Port Hope?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 1 then
		local cityTable = config.towns[msg:lower()]
		if cityTable then
			player:setStorageValue(Storage.AdventurersGuild.CharosTrav, player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+1)
			player:setStorageValue(Storage.AdventurersGuild.Stone, cityTable)
			npcHandler:say("Goodbye traveler!", cid)
		else
			npcHandler:say("Sorry, I don't know about this place.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
