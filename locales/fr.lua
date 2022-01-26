local Translations = {
    error = {
        ["no_keys"] = "Vous n\'avez aps les clées...",
        ["not_in_house"] = "Vous n\'êtes pas dans une propriété!",
        ["out_range"] = "Hors de portée",
        ["no_key_holders"] = "Aucun propriétaire trouvé..",
        ["invalid_tier"] = "Tier Invalide",
        ["no_house"] = "Il n'y a pas de propriété proche de vous",
        ["no_door"] = "Vous n'êtes pas assez proche de la porte..",
        ["locked"] = "La propriété est vérouillée!",
        ["no_one_near"] = "Personne n'est proche!",
        ["not_owner"] = "Vous n'êtes pas le propriétaire.",
        ["no_police"] = "Aucun policier présent..",
        ["already_open"] = "Cette propriété est déjà ouverte..",
        ["failed_invasion"] = "Vous avez échoué, réessayez",
        ["inprogress_invasion"] = "Quelqu'un essaie déjà d'entrer..",
        ["no_invasion"] = "Cette porte n'est pas ouverte..",
        ["realestate_only"] = "Seul les agents-immobilier peuvent utiliser cette commande",
        ["emergency_services"] = "Cela est réservé aux véhicules d'urgence!",
        ["already_owned"] = "Cette propriété est déjà ouverte!",
        ["not_enough_money"] = "Vous n'avez pas assez d'argent..",
        ["remove_key_from"] = "Les clées de %{firstname} %{lastname} ont été reprise",
        ["already_keys"] = "Cette personne a déjà les clées!",
        ["something_wrong"] = "Quelque chose ne va pas!",
    },
    success = {
        ["bought_house"] = "Maison achetée!",
        ["unlocked"] = "Propriété dévérouillée!",
        ["home_invasion"] = "La porte est ouverte.",
        ["lock_invasion"] = "Vous avez vérouillé la porte..",
        ["recieved_key"] = "Vous avez reçu les clés de %{value}!"
    },
    info = {
        ["door_ringing"] = "Quelqu'un sonne a la porte!",
        ["speed"] = "La vitesse est: %{value}",
        ["added_house"] = "Vous avez ajouté une propriété: %{value}",
        ["added_garage"] = "Vous avez ajouté un garage: %{value}"
    },
    menu = {
        ["house_options"] = "Options de Propriété",
        ["enter_house"] = "Entrer dans votre Propriété",
        ["give_house_key"] = "Donner les clées",
        ["exit_property"] = "Sortir de la Propriété",
        ["front_camera"] = "Visiophone",
        ["back"] = "Retour",
        ["remove_key"] = "Retirer la clée",
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
        ["lock_door_police"] = "Vérouiller la porte"
    }
}
Lang = Locale:new({phrases = Translations}) 
