terraform {
  backend "remote" {
    organization = "FlyingLlamas"

    workspaces {
      name = "terraform-example"
    }
  }
}

resource "launchdarkly_project" "yoz-terraform-project" {
    key     = "yozterraform"
    name    = "Yoz's Terraform Project"

    tags = [
        "terraform",
    ]
}

resource "launchdarkly_environment" "yoz-terraform-env" {
    name    = "Production"
    key     = "production"
    color   = "417505"

    project_key = launchdarkly_project.yoz-terraform-project.key

    // lifecycle {
    //     ignore_changes = all
    // }
}

resource "launchdarkly_feature_flag" "yoz-test-flag" {
    project_key = launchdarkly_project.yoz-terraform-project.key
    key         = "yoztestflag"
    name        = "Yoz's Test Flag"
    variation_type = "boolean"
}

resource "launchdarkly_segment" "example" {
  key         = "example-segment-key"
  project_key = launchdarkly_project.yoz-terraform-project.key
  env_key     = launchdarkly_environment.yoz-terraform-env.key
  name        = "example segment"
  description = "This segment is managed by Terraform"
  tags        = ["segment-tag-1", "segment-tag-2"]
  included    = ["user1", "user2"]
  excluded    = ["user3", "user4"]
}