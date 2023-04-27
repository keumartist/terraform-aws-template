variable "table_name" {
  description = "Name of the table"
  type        = string
}

variable "hash_key" {
  description = "Hash key for the table"
  type        = string
}

variable "range_key" {
  description = "Range key for the table"
  type        = string
  nullable    = true
}

variable "global_secondary_indexes" {
  description = "Global secondary indexes for the table"
  type = list(object({
    name            = string
    hash_key        = string
    projection_type = string
  }))
}

variable "billing_mode" {
  description = "Billing mode for the table"
  type        = string
}

variable "read_capacity" {
  description = "Read capacity for the table"
  type        = number
}

variable "write_capacity" {
  description = "Write capacity for the table"
  type        = number
}

variable "attributes" {
  description = "Attributes for the table"
  type = list(object({
    name = string
    type = string
  }))
}
