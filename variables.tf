variable "location" {
  default = "UK South"
}

variable "Environment" {
  default = "POC"
}

variable "tags" {
  type = map(string)
  default = {
    Deploy      = "Terraform"
    Application = "Container registries - POC"
    Owner       = "Jarek"
    Environment = "POC"
  }
  description = "Any tags which should be assigned to the resources in this example"
}