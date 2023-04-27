variable "host_zone_id" {
  description = "Host zone ID"
  type        = string
  default     = ""
}

variable "record_name" {
  description = "Name of record"
  type        = string
  default     = ""
}

variable "record_type" {
  description = "Type of record"
  type        = string
  default     = ""
}

variable "alias_name" {
  description = "Alias name for record"
  type        = string
  default     = ""
}

variable "alias_zone_id" {
  description = "Alias zone id for record"
  type        = string
  default     = ""
}
