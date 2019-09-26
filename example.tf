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
  key  = "tfdemo"
  name = "Terraform Demo Project"

  tags = [
    "terraform",
  ]
}

# resource "launchdarkly_environment" "demo" {
#   for_each    = toset(data.github_team.dev_advocates.members)
#   key         = "${each.value}-dev"
#   name        = "${title(each.value)} Dev"
#   color       = substr(md5(each.value), 0, 6)
#   project_key = launchdarkly_project.demo.key
# }

# resource "launchdarkly_environment" "yoz-terraform-env" {
#   name  = "Yoz's Demo"
#   key   = "yoz-demo"
#   color = "417505"

#   project_key = launchdarkly_project.demo.key

#   lifecycle {
#     ignore_changes = all
#   }
# }

# resource "launchdarkly_feature_flag" "building_materials" {
#   project_key    = launchdarkly_project.demo.key
#   key            = "building-materials"
#   name           = "Awesome number flag"
#   variation_type = "string"
#   variations {
#     value       = "straw"
#     name        = "Straw"
#     description = "Watch out for wind"
#   }
#   variations {
#     value       = "sticks"
#     name        = "Sticks"
#     description = "Sturdier than straw"
#   }
#   variations {
#     value       = "bricks"
#     name        = "Bricks"
#     description = "The strongest variation"
#   }
# }

# resource "launchdarkly_feature_flag_environment" "targeted_rollout" {
#   for_each          = toset(data.github_team.dev_advocates.members)
#   flag_id           = launchdarkly_feature_flag.building_materials.id
#   env_key           = launchdarkly_environment.demo[each.value].key
#   targeting_enabled = true

#   user_targets {
#     values = ["user0"]
#   }
#   user_targets {
#     values = ["user1", "user2"]
#   }
#   user_targets {
#     values = []
#   }

#   rules {
#     clauses {
#       attribute = "country"
#       op        = "startsWith"
#       values    = ["aus", "de", "united"]
#       negate    = false
#     }
#     variation = 0
#   }
#   rules {
#     clauses {
#       attribute = "email"
#       op        = "endsWith"
#       values    = ["@launchdarkly.com"]
#       negate    = false
#     }
#     variation = 2
#   }

#   flag_fallthrough {
#     rollout_weights = [20000, 40000, 0]
#   }
# }
