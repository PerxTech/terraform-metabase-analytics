output "this" {
  value = restapi_object.cards
}

output "cards_mapping" {
  value = {
    for card_name, card_details in restapi_object.cards:
      card_name => card_details.id
  }
}
