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
  data = jsonencode({
    name = var.metabase_cards[count.index].name
    dataset_query = {
      native = {
        query = var.metabase_cards[count.index].native_query
        template-tags = {
          for index, variable in var.metabase_cards[count.index].variables :
          variable.name => {
            id           = "${substr(random_uuid.variable-uuid[count.index].result, 0, 35)}${format("%02d", index)}"
            name         = variable.name
            type         = variable.type
            required     = variable.required
            display_name = variable.display_name
            display-name = variable.display_name
            default      = variable.default
          }
        }
      }
      type     = "native"
      database = tonumber(var.metabase_cards[count.index].database_id)
    }
    display                = "table"
    description            = var.metabase_cards[count.index].description
    collection_id          = tonumber(local.metabase_collection_id)
    visualization_settings = lookup(var.metabase_cards[count.index], "visualization_settings", {})
    embedding_params = {
      for variable in var.metabase_cards[count.index].variables :
      variable.name => variable.embedding_param
    }
    enable_embedding = var.metabase_cards[count.index].enable_embedding
  })
}
