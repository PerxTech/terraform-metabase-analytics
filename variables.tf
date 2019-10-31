variable "metabase_collection" {
  type = object({
    name        = string
    color       = string
    description = string
    parent_id   = string
  })
}

variable "metabase_collection_id" {
  type        = string
  description = "[Optional] Existing metabase collection to add the cards into"
  default     = ""
}

variable "metabase_cards" {
  description = "A list of cards to add into the metabase collection"
  type = list(object({
    name         = string # name of the card
    description  = string
    native_query = string # native query for the card
    variables = list(object({
      name                   = string # name of the variable
      display_name           = string # display name of the variable
      type                   = string # type of variable, can be date, text
      required               = bool
      embedding_param        = string # "enabled", "disabled" or "locked"
      default                = string
      # visualization_settings = any
    }))
    database_id      = number # database ID for the query
    enable_embedding = bool
  }))
}
