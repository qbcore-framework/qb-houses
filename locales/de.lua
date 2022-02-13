local Translations = {
    error = {
        ["no_keys"] = "Du hast nicht die Schlüssel für das Haus...",
        ["not_in_house"] = "Du bist in keinem Haus!",
        ["out_range"] = "Du bist nicht mehr im Berreich",
        ["no_key_holders"] = "Keine Besitzer gefunden..",
        ["invalid_tier"] = "Ungültige Hausstufe",
        ["no_house"] = "Es gibt kein Haus in deiner Nähe",
        ["no_door"] = "Die Tür ist zu weit weg..",
        ["locked"] = "Haus ist abgeschlossen!",
        ["no_one_near"] = "Niemand in der Nähe!",
        ["not_owner"] = "Du besitzt dieses Haus nicht.",
        ["no_police"] = "Es sind nicht genug Polizisten anwesend..",
        ["already_open"] = "Das Haus ist bereits offen..",
        ["failed_invasion"] = "Fehlgeschlagen, versuche es nochmal.",
        ["inprogress_invasion"] = "Jemand ist bereits an der Tür dran..",
        ["no_invasion"] = "Die Tür wurde noch nicht aufgebrochen..",
        ["realestate_only"] = "Nur realestate kann diesen Befehl verwende",
        ["emergency_services"] = "Dies ist nur für Notdienste möglich!",
        ["already_owned"] = "Dieses Haus wurde bereits gekauft",
        ["not_enough_money"] = "Du hast nicht genug Geld..",
        ["remove_key_from"] = "Die Schlüssel wurden entfernt von %{firstname} %{lastname}",
        ["already_keys"] = "Diese Person hat bereits die Schlüssel des Hauses!",
        ["something_wrong"] = "Etwas ist schief gelaufen versuche es es noch einmal!",
    },
    success = {
        ["unlocked"] = "Haus ist aufgeschlossen!",
        ["home_invasion"] = "Die Tür ist nun offen.",
        ["lock_invasion"] = "Die Tür wurde wieder geschlossen..",
        ["recieved_key"] = "Du hast die Schlüssel von %{value} bekommen!"
    },
    info = {
        ["door_ringing"] = "Jemand klingelt an der Tür!",
        ["speed"] = "Schnelligkeit ist %{value}",
        ["added_house"] = "Du hast ein Haus hinzugefügt: %{value}",
        ["added_garage"] = "Du hast eine Garage hinzugefügt: %{value}",
        ["exit_camera"] = "Verlasse Kamera",
        ["house_for_sale"] = "Haus zum Verkauf",
        ["decorate_interior"] = "Interieur dekorieren",
        ["create_house"] = "Haus erstellen (Nur Real Estate)",
        ["price_of_house"] = "Preis vom Haus",
        ["tier_number"] = "Haus Stufe",
        ["add_garage"] = "Haus Garage hinzufügen (Real Estate Only)",
        ["ring_doorbell"] = "An der Tür klingeln"
    },
    menu = {
        ["house_options"] = "Haus Optionen",
        ["enter_house"] = "Haus betreten",
        ["give_house_key"] = "Schlüssel geben",
        ["exit_property"] = "Haus verlassen",
        ["front_camera"] = "Front Kamera",
        ["back"] = "Zurück",
        ["remove_key"] = "Schlüssel entfernen",
        ["open_door"] = "Tür öffnen",
        ["view_house"] = "Haus anschauen",
        ["ring_door"] = "An der Tür klingeln",
        ["exit_door"] = "Haus verlassen",
        ["open_stash"] = "Stauraum öffnen",
        ["stash"] = "Stauraum",
        ["change_outfit"] = "Outfit ändern",
        ["outfits"] = "Outfits",
        ["change_character"] = "Character wechseln",
        ["characters"] = "Characters",
        ["enter_unlocked_house"] = "Offenes Haus betreten",
        ["lock_door_police"] = "Tür schliessen"
    },
    log = {
        ["house_created"] = "Haus erstellt:",
        ["house_address"] = "**Address**: %{label}\n\n**Listing Price**: %{price}\n\n**Tier**: %{tier}\n\n**Listing Agent**: %{agent}",
        ["house_purchased"] = "Haus gekauft:",
        ["house_purchased_by"] = "**Address**: %{house}\n\n**Purchase Price**: %{price}\n\n**Purchaser**: %{firstname} %{lastname}"
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
