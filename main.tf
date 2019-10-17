resource "restapi_object" "collection" {
  path = "/collection"
  data = jsonencode(var.metabase_collection)
}

resource "random_uuid" "variable_uuid" {
  count = length(var.metabase_cards)
}

resource "restapi_object" "cards" {
  count = length(var.metabase_cards)
  path  = "/card"
  data = jsonencode(
    yamldecode(
      templatefile(
        "${path.module}/templates/card.yaml.tpl",
        merge(
          {
            variable_uuid = random_uuid.variable_uuid[count.index].result,
            collection_id = restapi_object.collection.api_data.id
          },
          var.metabase_cards[count.index]
        )
      )
    )
  )
}
