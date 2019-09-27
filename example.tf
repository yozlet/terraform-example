provider "github" {
  organization = "launchdarkly"
}

data "github_team" "solutions_engineers" {
  slug = "solutions-engineers"
}

resource "launchdarkly_project" "demo" {
  key  = "tfdemo"
  name = "Terraform Demo Project"

  tags = [
    "terraform",
  ]
}

# Create an environment for each solution engineer
resource "launchdarkly_environment" "demo" {
  for_each    = toset(data.github_team.solutions_engineers.members)
  key         = "${each.value}-dev"
  name        = "${title(each.value)} Dev"
  color       = substr(md5(each.value), 0, 6)
  project_key = launchdarkly_project.demo.key
}

resource "launchdarkly_feature_flag" "kill_switch" {
  project_key    = launchdarkly_project.demo.key
  key            = "killswitch"
  name           = "Kill Switch 🧟"
  variation_type = "boolean"
  variations {
    value = false
  }
  variations {
    value = true
  }
  tags = ["terraform", "all-hands", "demo", "boolean"]
}

resource "launchdarkly_feature_flag" "building_materials" {
  project_key    = launchdarkly_project.demo.key
  key            = "building-materials"
  name           = "Building Materials 🏗"
  variation_type = "string"
  variations {
    value       = "straw"
    name        = "Straw"
    description = "Watch out for wind"
  }
  variations {
    value       = "sticks"
    name        = "Sticks"
    description = "Sturdier than straw"
  }
  variations {
    value       = "bricks"
    name        = "Bricks"
    description = "The strongest variation"
  }
  tags = ["terraform", "all-hands", "demo", "multivariate"]
}

# Update the targeting rules for each engineer's environment
resource "launchdarkly_feature_flag_environment" "targeted_rollout" {
  for_each          = toset(data.github_team.solutions_engineers.members)
  flag_id           = launchdarkly_feature_flag.building_materials.id
  env_key           = launchdarkly_environment.demo[each.value].key
  targeting_enabled = true

  user_targets {
    values = ["user0"]
  }
  user_targets {
    values = ["user1", "user2"]
  }
  user_targets {
    values = []
  }

  rules {
    clauses {
      attribute = "country"
      op        = "startsWith"
      values    = ["aus", "de", "united"]
      negate    = false
    }
    variation = 1
  }
  rules {
    clauses {
      attribute = "email"
      op        = "endsWith"
      values    = ["@launchdarkly.com"]
      negate    = false
    }
    variation = 2
  }

  flag_fallthrough {
    rollout_weights = [70000, 30000, 0]
  }
}
