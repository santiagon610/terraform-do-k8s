resource "digitalocean_project" "github-demo-dev" {
  name        = "Github Demo - DEV"
  description = "A project to represent development resources."
  purpose     = "Operational / Developer tooling"
  environment = "Development"
}
