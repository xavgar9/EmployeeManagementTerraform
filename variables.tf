variable "project" {
  type        = string
  description = "The project ID to deploy to"
  default     = "western-trees-404602"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
  default     = "us-central1"

}

variable "zone" {
  type        = string
  description = "The zone to deploy to"
  default     = "us-central1-a"
}

variable "machine_type" {
  type        = string
  description = "The machine type to deploy to"
  default     = "e2-medium"
}

variable "image" {
  type        = string
  description = "The image to deploy to"
  default     = "ubuntu-minimal-2004-lts"
}

variable "credentials_file_path" {
  type        = string
  description = "The path to the credentials file to connect to GCP"
  default     = "application_default_credentials.json"
}

variable "user" {
  type    = string
  default = "root"
}

variable "email" {
  type    = string
  default = "xavier.garzon.pro@gmail.com"
}
variable "private_key_path" {
  type    = string
  default = "./gcp-key"
}

variable "public_key_path" {
  type    = string
  default = "./gcp-key.pub"
}
