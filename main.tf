resource "restapi_object" "collection" {
  count = var.metabase_collection_id != "" ? 0 : 1
  path  = "/collection"
  data  = jsonencode(var.metabase_collection)
}

locals {
  metabase_collection_id = var.metabase_collection_id != "" ? var.metabase_collection_id : "${restapi_object.collection[0].api_data.id}"
}

resource "random_uuid" "variable-uuid" {
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
            variable_uuid = random_uuid.variable-uuid[count.index].result,
            collection_id = local.metabase_collection_id
          },
          var.metabase_cards[count.index]
        )
      )
    )
  )
}
