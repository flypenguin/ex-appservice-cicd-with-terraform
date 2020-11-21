# Terraform, GitLab & Azure App Service

This is basically an example repo which contains code needed for [my blog post](https://flypenguin.de/2020/11/21/gitlab-app-service-ci-cd-variant-1/).

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

If you don't want to check in app secrets ([see here](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1) for example), you can combine my Secret Makefile (link following) with the Terraform Makefile in this repository and change the app service configuration like this:

Add your public GPG key in the directory `gpg_keys/your@key.email`, and then change the terraform code like this:

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

What it does is it will no longer check in the `*.insecure.yaml` files, but you will check in the `*.insecure.yaml.gpg` files, which is just the encrypted version. It will be encrypted to all keys under `gpg_keys/`, and before you can use anything you have to `make open` (of course, cause right after pulling this is going to be _not present_). Also you must not forget to do `make reencrypt` once you changed secrets in the decrypted files, cause changes are no longer picked up by git (of course, due to the `.gitignore` entry).
