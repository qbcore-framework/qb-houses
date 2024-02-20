local Translations = {
    error = {
        ["no_keys"] = "Vous n\'avez pas les clés...",
        ["not_in_house"] = "Vous n\'êtes pas dans une propriété!",
        ["out_range"] = "Hors de portée",
        ["no_key_holders"] = "Aucun propriétaire trouvé...",
        ["invalid_tier"] = "Tier Invalide",
        ["no_house"] = "Il n'y a pas de propriété proche de vous",
        ["no_door"] = "Vous n'êtes pas assez proche de la porte...",
        ["locked"] = "La propriété est verrouillé!",
        ["no_one_near"] = "Personne n'est proche!",
        ["not_owner"] = "Vous n'êtes pas le propriétaire.",
        ["no_police"] = "Aucun policier présent..",
        ["already_open"] = "Cette propriété est déjà ouverte...",
        ["failed_invasion"] = "Vous avez échoué, réessayez",
        ["inprogress_invasion"] = "Quelqu'un essaie déjà d'entrer...",
        ["no_invasion"] = "Cette porte n'est pas ouverte...",
        ["realestate_only"] = "Seul les agents immobiliers peuvent utiliser cette commande",
        ["emergency_services"] = "Cela est réservé aux véhicules d'urgence!",
        ["already_owned"] = "Cette propriété est déjà ouverte!",
        ["not_enough_money"] = "Vous n'avez pas assez d'argent...",
        ["remove_key_from"] = "Les clés de %{firstname} %{lastname} ont été reprises",
        ["already_keys"] = "Cette personne a déjà les clés!",
        ["something_wrong"] = "Quelque chose ne va pas!",
    },
    success = {
        ["unlocked"] = "Propriété déverrouillée!",
        ["home_invasion"] = "La porte est ouverte.",
        ["lock_invasion"] = "Vous avez verrouillé la porte...",
        ["recieved_key"] = "Vous avez reçu les clés de %{value}!",
        ["house_purchased"] = "Vous avez acheté la maison avec succès!"
    },
    info = {
        ["door_ringing"] = "Quelqu'un sonne a la porte!",
        ["speed"] = "La vitesse est: %{value}",
        ["added_house"] = "Vous avez ajouté une propriété: %{value}",
        ["added_garage"] = "Vous avez ajouté un garage: %{value}",
        ["exit_camera"] = "Quitter la caméra",
        ["house_for_sale"] = "Maison à vendre",
        ["decorate_interior"] = "Décorer l'intérieur",
        ["create_house"] = "Créer une maison (immobilier uniquement)",
        ["price_of_house"] = "Prix de la maison",
        ["tier_number"] = "Numéro de niveau de la maison",
        ["add_garage"] = "Ajouter un garage à la maison (immobilier uniquement)",
        ["ring_doorbell"] = "Sonner à la porte"
    },
    menu = {
        ["house_options"] = "Options de Propriété",
        ["enter_house"] = "Entrer dans votre Propriété",
        ["give_house_key"] = "Donner les clés",
        ["exit_property"] = "Sortir de la Propriété",
        ["front_camera"] = "Visiophone",
        ["back"] = "Retour",
        ["remove_key"] = "Retirer la clé",
        ["open_door"] = "Ouvrir la porte",
        ["view_house"] = "Voir la propriété",
        ["ring_door"] = "Sonner a la porte",
        ["exit_door"] = "Sortir de la propriété",
        ["open_stash"] = "Ouvrir la réserve",
        ["stash"] = "Réserve",
        ["change_outfit"] = "Changer de vêtements",
        ["outfits"] = "Tenues",
        ["change_character"] = "Changer de personnage",
        ["characters"] = "Personnages",
        ["enter_unlocked_house"] = "Entrer dans la propriété ouverte.",
        ["lock_door_police"] = "Verrouiller la porte",
        ["close_menu"] = "⬅ Fermer le menu"
    },
    log = {
        ["house_created"] = "Maison créée:",
        ["house_address"] = "**Adresse**: %{label}\n\n**Prix de vente**: %{price}\n\n**Niveau**: %{tier}\n\n**Agent de vente**: %{agent}",
        ["house_purchased"] = "Maison achetée:",
        ["house_purchased_by"] = "**Adresse**: %{house}\n\n**Prix d'achat**: %{price}\n\n**Acheteur**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
