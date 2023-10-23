variable "env" {
  description = "Meant to seperate production infra from other environments. Not to be confused with rails running env and branch"
  type        = string
  default     = "testing"
}
variable "rails_env" {
  description = "the env used during runtime for the rails application"
  type        = string
}
variable "rails_master_key" {
  type = string
}
variable "cert_arn" {
  type = string
}
variable "access_ips" {
  type = list(any)
}
variable "application_name" {
  type = string
}
variable "branch" {
  type    = string
  default = "master"
}
variable "region" {
  type    = string
  default = "us-east-2"
}
variable "hosted_zone" {
  type = string
}
variable "ami_name" {
  type = string
}
variable "key_pair_name" {
  type = string
}
variable "public_paperclip_bucket" {
  type    = bool
  default = true
}
variable "org" {
  type = string
}
