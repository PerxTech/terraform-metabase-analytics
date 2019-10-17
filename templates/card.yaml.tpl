name: ${name}
dataset_query:
  native:
    query: |
      ${indent(6, native_query)}
    template-tags:
      %{ for index, variable in variables }
      ${variable.name}:
        id: "${substr(variable_uuid, 0, 35)}${format("%02d", index)}"
        name: ${variable.name}
        type: ${variable.type}
        required: ${variable.required}
        display_name: ${variable.display_name}
        display-name: ${variable.display_name}
        default: ${variable.default}
      %{ endfor }
  type: native
  database: ${database_id}
display: table
description: ${description}
visualization_settings: {}
collection_id: ${collection_id}
result_metadata:
metadata_checksum:
embedding_params:
  %{ for variable in variables }
  ${variable.name}: ${variable.embedding_param}
  %{ endfor }
enable_embedding: ${enable_embedding}
