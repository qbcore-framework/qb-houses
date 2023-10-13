local Translations = {
    error = {
        ["no_keys"] = "Você não possui as chaves da casa...",
        ["not_in_house"] = "Você não está em uma casa!",
        ["out_range"] = "Você saiu do alcance",
        ["no_key_holders"] = "Nenhum detentor de chaves encontrado...",
        ["invalid_tier"] = "Tier de casa inválido",
        ["no_house"] = "Não há uma casa perto de você",
        ["no_door"] = "Você não está perto o suficiente da porta...",
        ["locked"] = "A casa está trancada!",
        ["no_one_near"] = "Ninguém por perto!",
        ["not_owner"] = "Você não é dono desta casa.",
        ["no_police"] = "Não há força policial presente...",
        ["already_open"] = "Esta casa já está aberta...",
        ["failed_invasion"] = "Falhou, tente novamente",
        ["inprogress_invasion"] = "Alguém já está trabalhando na porta...",
        ["no_invasion"] = "Esta porta não está arrombada...",
        ["realestate_only"] = "Somente agentes imobiliários podem usar este comando",
        ["emergency_services"] = "Isso só é possível para serviços de emergência!",
        ["already_owned"] = "Esta casa já está ocupada!",
        ["not_enough_money"] = "Você não tem dinheiro suficiente...",
        ["remove_key_from"] = "As chaves foram removidas de %{firstname} %{lastname}",
        ["already_keys"] = "Essa pessoa já tem as chaves da casa!",
        ["something_wrong"] = "Algo deu errado, tente novamente!",
        ["nobody_at_door"] = 'Não há ninguém na porta...'
    },
    success = {
        ["unlocked"] = "A casa está destrancada!",
        ["home_invasion"] = "A porta está agora aberta.",
        ["lock_invasion"] = "Você trancou a casa novamente...",
        ["recieved_key"] = "Você recebeu as chaves de %{value}!",
        ["house_purchased"] = "Você comprou a casa com sucesso!"
    },
    info = {
        ["door_ringing"] = "Alguém está tocando a campainha!",
        ["speed"] = "Velocidade é %{value}",
        ["added_house"] = "Você adicionou uma casa: %{value}",
        ["added_garage"] = "Você adicionou uma garagem: %{value}",
        ["exit_camera"] = "Sair da Câmera",
        ["house_for_sale"] = "Casa à venda",
        ["decorate_interior"] = "Decorar Interior",
        ["create_house"] = "Criar Casa (Apenas para agentes imobiliários)",
        ["price_of_house"] = "Preço da casa",
        ["tier_number"] = "Número do Tier da Casa",
        ["add_garage"] = "Adicionar Garagem à Casa (Apenas para agentes imobiliários)",
        ["ring_doorbell"] = "Tocar a Campainha"
    },
    menu = {
        ["house_options"] = "Opções da Casa",
        ["close_menu"] = "⬅ Fechar Menu",
        ["enter_house"] = "Entrar na Sua Casa",
        ["give_house_key"] = "Dar Chave da Casa",
        ["exit_property"] = "Sair da Propriedade",
        ["front_camera"] = "Câmera Frontal",
        ["back"] = "Voltar",
        ["remove_key"] = "Remover Chave",
        ["open_door"] = "Abrir Porta",
        ["view_house"] = "Ver Casa",
        ["ring_door"] = "Tocar a Campainha",
        ["exit_door"] = "Sair da Propriedade",
        ["open_stash"] = "Abrir Esconderijo",
        ["stash"] = "Esconderijo",
        ["change_outfit"] = "Mudar Visual",
        ["outfits"] = "Visuais",
        ["change_character"] = "Mudar Personagem",
        ["characters"] = "Personagens",
        ["enter_unlocked_house"] = "Entrar em uma Casa Destrancada",
        ["lock_door_police"] = "Trancar Porta"
    },
    target = {
        ["open_stash"] = "[E] Abrir Esconderijo",
        ["outfits"] = "[E] Mudar Visuais",
        ["change_character"] = "[E] Mudar Personagem",
    },
    log = {
        ["house_created"] = "Casa Criada:",
        ["house_address"] = "**Endereço**: %{label}\n\n**Preço de Venda**: %{price}\n\n**Tier**: %{tier}\n\n**Agente de Vendas**: %{agent}",
        ["house_purchased"] = "Casa Comprada:",
        ["house_purchased_by"] = "**Endereço**: %{house}\n\n**Preço da Compra**: %{price}\n\n**Comprador**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end