

resource "github_repository" "git_fisrt_repo" {
  name        = "first_test_repo"
  description = "Repo created by Guddu"
  visibility  = "public"
  auto_init   = true

  pages {
    source {
      branch = "main"
    }
  }
}

resource "github_repository" "git_second_repo" {
  name        = "second_test_repo"
  description = "Repo created by Guddu"
  visibility  = "public"
  auto_init   = true

  pages {
    source {
      branch = "main"
    }
  }
}

output "first-gitrepo-url" {
  value = github_repository.git_fisrt_repo.html_url
}