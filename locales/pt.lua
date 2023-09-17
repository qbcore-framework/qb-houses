local Translations = {
    error = {
        ["no_keys"] = "Não tens as chaves desta casa...",
        ["not_in_house"] = "Não estás numa casa!",
        ["out_range"] = "Estás muito longe",
        ["no_key_holders"] = "Não foram encontrados porta chaves..",
        ["invalid_tier"] = "Tier da casa inválido",
        ["no_house"] = "Não existem casas ao teu redor..",
        ["no_door"] = "Não estás perto o suficiente da porta..",
        ["locked"] = "Casa trancada!",
        ["no_one_near"] = "Ninguém por perto!",
        ["not_owner"] = "Não és o proprietário desta casa.",
        ["no_police"] = "Agentes de autoridade insuficientes..",
        ["already_open"] = "Esta casa já está aberta..",
        ["failed_invasion"] = "Falha ao forçar a fechadura! Tenta novamente!",
        ["inprogress_invasion"] = "Já existe alguém a forçar a fechadura..",
        ["no_invasion"] = "Esta fechadura não foi forçada..",
        ["realestate_only"] = "Apenas agentes imbobiliários podem usar este comando",
        ["emergency_services"] = "Disponível apenas para unidades de emergência!",
        ["already_owned"] = "Esta casa já tem proprietário!",
        ["not_enough_money"] = "Não tens dinheiro suficiente..",
        ["remove_key_from"] = "Chaves removidades de %{firstname} %{lastname}",
        ["already_keys"] = "Esta pessoa já tem as chaves desta casa!",
        ["something_wrong"] = "Algo de errado aconteceu. Tenta novamente!",
        ["nobody_at_door"] = 'Não há ninguém à porta...'
    },
    success = {
        ["unlocked"] = "A casa está aberta!",
        ["home_invasion"] = "A porta está agora aberta.",
        ["lock_invasion"] = "Trancaste a porta da casa novamente..",
        ["recieved_key"] = "Recebeste as chaves da casa %{value}!",
        ["house_purchased"] = "Comprou a casa com sucesso!"
    },
    info = {
        ["door_ringing"] = "Alguém tocou à campainha!",
        ["speed"] = "Velocidade: %{value}",
        ["added_house"] = "Adicionaste uma casa: %{value}",
        ["added_garage"] = "Adicionaste uma garagem: %{value}",
        ["exit_camera"] = "Sair da câmera",
        ["house_for_sale"] = "Casa à venda",
        ["decorate_interior"] = "Decorar interior",
        ["create_house"] = "Criar casa (somente agentes imobiliários)",
        ["price_of_house"] = "Preço da casa",
        ["tier_number"] = "Número do nível da casa",
        ["add_garage"] = "Adicionar garagem residencial (somente agentes imobiliários)",
        ["ring_doorbell"] = "Tocas a campainha"
    },
    menu = {
        ["house_options"] = "Opções da casa",
        ["close_menu"] = "⬅ Fechar menu",
        ["enter_house"] = "Entrar em casa",
        ["give_house_key"] = "Dar chaves da casa",
        ["exit_property"] = "Sair de casa",
        ["front_camera"] = "Câmera da frente",
        ["back"] = "Voltar",
        ["remove_key"] = "Remover chaves",
        ["open_door"] = "Abrir porta",
        ["view_house"] = "Ver casa",
        ["ring_door"] = "Tocar à campainha",
        ["exit_door"] = "Sair de casa",
        ["open_stash"] = "Abrir baú",
        ["stash"] = "Baú",
        ["change_outfit"] = "Mudar outfit",
        ["outfits"] = "Outfits",
        ["change_character"] = "Alterar personagem",
        ["characters"] = "Personagens",
        ["enter_unlocked_house"] = "Entrar na casa",
        ["lock_door_police"] = "Trancar porta"
    },
    target = {
        ["open_stash"] = "[E] Abrir baú",
        ["outfits"] = "[E] Mudar outfits",
        ["change_character"] = "[E] Alterar personagem",
    },
    log = {
        ["house_created"] = "Casa criada:",
        ["house_address"] = "**Endereço**: %{label}\n\n**Preço do anúncio**: %{price}\n\n**Nível**: %{tier}\n\n**Agente imobiliário**: %{agent}",
        ["house_purchased"] = "Casa comprada:",
        ["house_purchased_by"] = "**Endereço**: %{house}\n\n**Preço da compra**: %{price}\n\n**Comprador**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
