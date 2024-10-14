local Translations = {
    error = {
        ["no_keys"] = "Je hebt de sleutels van het huis niet..",
        ["not_in_house"] = "Je bent niet in een huis!",
        ["out_range"] = "Je bent uit het bereik gegaan",
        ["no_key_holders"] = "Geen sleutelhouders gevonden..",
        ["invalid_tier"] = "Ongeldig huistype",
        ["no_house"] = "Er is geen huis in de buurt",
        ["no_door"] = "Je bent niet dichtbij de deur..",
        ["locked"] = "Het huis is vergrendeld!",
        ["no_one_near"] = "Niemand in de buurt!",
        ["not_owner"] = "Je bent de eigenaar van dit huis niet.",
        ["no_police"] = "Er is geen politie aanwezig..",
        ["already_open"] = "Dit huis is al open..",
        ["failed_invasion"] = "Het is mislukt, probeer het opnieuw",
        ["inprogress_invasion"] = "Iemand is al bezig met de deur..",
        ["no_invasion"] = "Deze deur is niet opengebroken..",
        ["realestate_only"] = "Alleen vastgoed kan dit commando gebruiken",
        ["emergency_services"] = "Dit is alleen mogelijk voor nooddiensten!",
        ["already_owned"] = "Dit huis is al in bezit!",
        ["not_enough_money"] = "Je hebt niet genoeg geld..",
        ["remove_key_from"] = "Sleutels zijn verwijderd van %{firstname} %{lastname}",
        ["already_keys"] = "Deze persoon heeft de sleutels van het huis al!",
        ["something_wrong"] = "Er is iets misgegaan, probeer het opnieuw!"
    },
    success = {
        ["unlocked"] = "Het huis is ontgrendeld!",
        ["home_invasion"] = "De deur is nu open.",
        ["lock_invasion"] = "Je hebt het huis weer op slot gedaan...",
        ["recieved_key"] = "Je hebt de sleutels van %{value} ontvangen!",
        ["house_purchased"] = "Je hebt het huis succesvol gekocht!"
    },
    info = {
        ["door_ringing"] = "Iemand belt aan de deur!",
        ["speed"] = "Snelheid is %{value}",
        ["added_house"] = "Je hebt een huis toegevoegd: %{value}",
        ["added_garage"] = "Je hebt een garage toegevoegd: %{value}",
        ["exit_camera"] = "Verlaat Camera",
        ["house_for_sale"] = "Huis Te Koop",
        ["decorate_interior"] = "Interieur Inrichten",
        ["create_house"] = "Huis Maken (makelaar only)",
        ["price_of_house"] = "Prijs van het huis",
        ["tier_number"] = "Huistype",
        ["add_garage"] = "Voeg Garage Toe (makelaar only)",
        ["ring_doorbell"] = "Trek aan de deurbel"
    },
    menu = {
        ["house_options"] = "Huisopties",
        ["close_menu"] = "⬅ Menu Sluiten",
        ["enter_house"] = "Betreed Je Huis",
        ["give_house_key"] = "Geef Huissleutel",
        ["exit_property"] = "Verlaat Eigendom",
        ["front_camera"] = "Voorkant Camera",
        ["back"] = "Terug",
        ["remove_key"] = "Verwijder Sleutel",
        ["open_door"] = "Open Deur",
        ["view_house"] = "Bekijk Huis",
        ["ring_door"] = "Bel Deurbeller",
        ["exit_door"] = "Verlaat Eigendom",
        ["open_stash"] = "Open Voorraad",
        ["stash"] = "Voorraad",
        ["change_outfit"] = "Verander Outfit",
        ["outfits"] = "Outfits",
        ["change_character"] = "Verander Personage",
        ["characters"] = "Personages",
        ["enter_unlocked_house"] = "Betreed Ontgrendeld Huis",
        ["lock_door_police"] = "Vergrendel Deur"
    },
    target = {
        ["open_stash"] = "[E] Open opslag",
        ["outfits"] = "[E] Verander outfit",
        ["change_character"] = "[E] Verander karakter"
    },
    log = {
        ["house_created"] = "Huis gemaakt:",
        ["house_address"] = "**Adres**: %{label}\n\n**Prijslijst**: %{price}\n\n**Tier**: %{tier}\n\n**Listing Agent**: %{agent}",
        ["house_purchased"] = "House Purchased:",
        ["house_purchased_by"] = "**Adres**: %{house}\n\n**Verkoopprijs**: %{price}\n\n**Koop**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Lang or Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
