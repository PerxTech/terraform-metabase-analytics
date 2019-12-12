resource "restapi_object" "collection" {
  count = var.metabase_collection_id != "" ? 0 : 1
  path  = "/collection"
  data  = jsonencode(var.metabase_collection)
}

locals {
  metabase_collection_id = var.metabase_collection_id != "" ? var.metabase_collection_id : "${restapi_object.collection[0].api_data.id}"
  # metabase_collection_id = var.metabase_collection_id
}

resource "random_uuid" "variable-uuid" {
  for_each = var.metabase_cards
}

resource "restapi_object" "cards" {
  for_each = var.metabase_cards

  path     = "/card"
  data = jsonencode({
    name = each.value.name
    dataset_query = {
      native = {
        query = each.value.native_query
        template-tags = {
          for index, variable in each.value.variables :
          variable.name => {
            id           = "${substr(random_uuid.variable-uuid[each.key].result, 0, 35)}${format("%02d", index)}"
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
      database = tonumber(each.value.database_id)
    }
    display                = "table"
    description            = each.value.description
    collection_id          = tonumber(local.metabase_collection_id)
    visualization_settings = lookup(each.value, "visualization_settings", {})
    embedding_params = {
      for variable in each.value.variables :
      variable.name => variable.embedding_param
    }
    enable_embedding = each.value.enable_embedding
  })
}
