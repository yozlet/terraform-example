provider "launchdarkly" {
}

resource "launchdarkly_project" "slack" {
  key  = "slack-app"
  name = "Slack App"

  tags = ["slack", "terraform-managed"]
}

data "launchdarkly_team_member" "henry" {
  email = "hbarrow+tfdemo@launchdarkly.com"
}

resource "launchdarkly_feature_flag" "unfurl_links" {
  project_key = launchdarkly_project.slack.key
  name        = "Unfurl Links"
  key         = "unfurl-links"
  description = "whether or not to unfurl links"
  maintainer_id = data.launchdarkly_team_member.henry.id

  variation_type = "boolean"
  variations {
    value = true
  }
  variations {
    value = false
  }
}
