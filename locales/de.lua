local Translations = {
    error = {
        ["no_keys"] = "Sie haben keine Schlüssel für das Haus...",
        ["not_in_house"] = "Sie sind nicht in einem Haus!",
        ["out_range"] = "Sie haben den Bereich verlassen",
        ["no_key_holders"] = "Keine Schlüsselhalter gefunden...",
        ["invalid_tier"] = "Ungültige Hausstufe",
        ["no_house"] = "Es gibt kein Haus in Ihrer Nähe",
        ["no_door"] = "Du bist nicht nah genug an der Tür...",
        ["locked"] = "Das Haus ist verschlossen!",
        ["no_one_near"] = "Niemand in der Nähe!",
        ["not_owner"] = "Dieses Haus gehört Ihnen nicht.",
        ["no_police"] = "Es ist keine Polizei anwesend.",
        ["already_open"] = "Dieses Haus ist bereits geöffnet.",
        ["failed_invasion"] = "Der Versuch ist fehlgeschlagen. Bitte versuchen Sie es erneut.",
        ["inprogress_invasion"] = "Jemand arbeitet bereits an der Tür...",
        ["no_invasion"] = "Diese Tür ist nicht aufgebrochen.",
        ["realestate_only"] = "Nur Makler können diesen Befehl verwenden.",
        ["emergency_services"] = "Dies ist nur für Notdienste möglich!",
        ["already_owned"] = "Dieses Haus ist bereits in Besitz!",
        ["not_enough_money"] = "Du hast nicht genug Geld.",
        ["remove_key_from"] = "Die Schlüssel wurden von %{firstname} %{lastname} entfernt.",
        ["already_keys"] = "Diese Person hat bereits die Schlüssel des Hauses!",
        ["something_wrong"] = "Etwas ist schief gelaufen, versuchen Sie es bitte noch einmal!",
        ["nobody_at_door"] = "Niemand ist an der Tür..."
    },
    success = {
        ["unlocked"] = "Das Haus ist nun unverschlossen!",
        ["home_invasion"] = "Die Tür ist jetzt offen.",
        ["lock_invasion"] = "Du hast das Haus wieder abgeschlossen...",
        ["recieved_key"] = "Sie haben die Schlüssel von %{Wert} erhalten!",
        ["house_purchased"] = "Sie haben das Haus erfolgreich gekauft!"
    },
    info = {
        ["door_ringing"] = "Jemand klingelt an der Tür!",
        ["speed"] = "Geschwindigkeit ist %{value}",
        ["added_house"] = "Sie haben ein Haus hinzugefügt: %{value}",
        ["added_garage"] = "Sie haben eine Garage angebaut: %{value}",
        ["exit_camera"] = "Kamera verlassen",
        ["house_for_sale"] = "Haus zu verkaufen",
        ["decorate_interior"] = "Interieur dekorieren",
        ["create_house"] = "Haus erstellen (Makler Only)",
        ["price_of_house"] = "Preis des Hauses",
        ["tier_number"] = "Hausnummer",
        ["add_garage"] = "Garage zum Haus hinzufügen (Makler Only)",
        ["ring_doorbell"] = "Klingeln Sie an der Tür"
    },
    menu = {
        ["house_options"] = "Haus Optionen",
        ["close_menu"] = "⬅ Menü schließen",
        ["enter_house"] = "Haus betreten",
        ["give_house_key"] = "Hausschlüssel übergeben",
        ["exit_property"] = "Haus verlassen",
        ["front_camera"] = "Kamera",
        ["back"] = "Zurück",
        ["remove_key"] = "Schlüssel entfernen",
        ["open_door"] = "Tür öffnen",
        ["view_house"] = "Haus ansehen",
        ["ring_door"] = "Türklingel benutzen",
        ["exit_door"] = "Haus verlassen",
        ["open_stash"] = "Lager öffnen",
        ["stash"] = "Lager",
        ["change_outfit"] = "Outfit wechseln",
        ["outfits"] = "Outfits",
        ["change_character"] = "Charakter ändern",
        ["characters"] = "Charaktere",
        ["enter_unlocked_house"] = "Unverschlossenes Haus betreten",
        ["lock_door_police"] = "Tür abschließen"
    },
    target = {
        ["open_stash"] = "[E] Schrank öffnen",
        ["outfits"] = "[E] Outfit ändern",
        ["change_character"] = "[E] Charakter ändern",
    },
    log = {
        ["house_created"] = "Haus erstellt:",
        ["house_address"] = "**Adresse**: %{label}\n\n**Preis**: %{price}\n\n**Interieur-Stufe**: %{tier}\n\n**Makler**: %{agent}",
        ["house_purchased"] = "Haus verkauft:",
        ["house_purchased_by"] = "**Adresse**: %{house}\n\n**Preis**: %{price}\n\n**Käufer**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
