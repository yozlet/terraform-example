terraform {
  backend "remote" {
    organization = "FlyingLlamas"

    workspaces {
      name = "terraform-example"
    }
  }
}
