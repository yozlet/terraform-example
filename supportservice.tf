terraform {
  backend "remote" {
    organization = "FlyingLlamas"

    workspaces {
      name = "terraform-example"
    }
  }
}

provider "github" {
  organization = "launchdarkly"
}

data "github_team" "dev_advocates" {
  slug = "dev-advocates"
}

provider "launchdarkly" {}

resource "launchdarkly_project" "demo" {
    key     = "tfdemo"
    name    = "Terraform Demo Project"

    tags = [
        "terraform",
    ]
}

resource "launchdarkly_environment" "demo" {
  for_each    = toset(data.github_team.dev_advocates.members)
  key         = "${each.value}-dev"
  name        = "${each.value} Dev"
  color       = substr(md5(each.value), 0, 6)
  project_key = launchdarkly_project.demo.key
}

resource "launchdarkly_environment" "yoz-terraform-env" {
    name    = "Yoz's Demo"
    key     = "yoz-demo"
    color   = "417505"

    project_key = launchdarkly_project.demo.key

    lifecycle {
        ignore_changes = all
    }
}

resource "launchdarkly_feature_flag" "yoz-test-flag" {
    project_key = launchdarkly_project.demo.key
    key         = "yoztestflag"
    name        = "Yoz's Test Flag"
    variation_type = "boolean"
}

resource "launchdarkly_segment" "example" {
  key         = "example-segment-key"
  project_key = launchdarkly_project.demo.key
  env_key     = launchdarkly_environment.yoz-terraform-env.key
  name        = "example segment"
  description = "This segment is managed by Terraform"
  tags        = ["segment-tag-1", "segment-tag-2"]
  included    = ["user1", "user2"]
  excluded    = ["user3", "user4"]
}