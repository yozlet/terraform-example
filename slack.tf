provider "launchdarkly" {
}

resource "launchdarkly_project" "slack" {
  key  = "slack-app"
  name = "Slack App"

  tags = ["slack", "terraform-managed"]
}

resource "launchdarkly_feature_flag" "unfurl_links" {
  project_key = launchdarkly_project.slack.key
  name        = "Unfurl Links"
  key         = "unfurl-links"
  description = "whether or not to unfurl links"
  maintainer_id = "hbarrow+tfdemo@launchdarkly.com"

  variation_type = "boolean"
  variations {
    value = true
  }
  variations {
    value = false
  }
}
