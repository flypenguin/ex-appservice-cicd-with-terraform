# Terraform, GitLab & Azure App Service

This is basically an example repo which contains code needed for [my blog post]().

## Quickstart

* `terraform init` (or `make init`)
* `terraform plan` (or `make plan`)
* `terraform apply` (or `make do`)
* Continue as per blog post

Have fun!

### Notes

* You can ignore the Makefile and the `settings-secret.sh`, it will just help you started once you're new to this Azure stuff, which is just annoyingly weird.
  * use both when you don't really know how to start, you need to get your `ARM_ACCESS_KEY` for this first though.
* **IMPORTANT** It seems when working with `app_settings` sometimes the `apply` run fails without reason. Just do it again then and you should be fine.

## Next steps

### Secrets

**NOTE:** If you know `git-secret` you do already know what to do and don't need the stuff below. That's my way cause I kinda ignored `git-secret`.

If you (what you should) don't want to check in app secrets, you can combine my [Secret Makefile]() with the [Terraform Makefile]() in this repository and change the app service configuration like this:

```hcl
resource "azurerm_app_service" "coolapp" {
  # ... etc. ...
  app_settings = yamldecode(file("${path.root}/app-coolapp-settings.insecure.yaml"))
}
```

Add this to `.gitignore` so that `whatever.insecure.yaml` is ignored by git.

```bash
*.insecure.yaml
*.open.yaml
*.pub
```

Now do this:

```
# in this order
$ touch whatever.insecure.yaml.gpg
$ touch whatever.insecure.yaml
$ make reencode
```

And you should be done.
