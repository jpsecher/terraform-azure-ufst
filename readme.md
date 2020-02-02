# Infrastructure as Code

Demonstration of _IaC_ by using Terraform to control an set of Azure environments.

## Azure setup

Terraform needs a place to store the state of the resources it manages, so manually create a storage account in Azure exclusively for Terraform.  For a free account, it has to be in US East.  I have used `kaleidoscopesoftware` in group `terraform-ufst`.  In the new storage account, create a container named `terraform-state`.


## Local workstation setup

Install the Azure command-line interface and login to your account:

    $ brew install azure-cli
    $ az login
    $ az account list
    [
      {
        "cloudName": "AzureCloud",
        "id": "706d86d5-97b7-471b-b1c6-410f6648f186",
        "isDefault": true,
        "name": "Free Trial",
        "state": "Enabled",
        "tenantId": "108173b6-70a4-462b-b7f2-7fc84cc60307",
        "user": {
          "name": "me@email.org",
          "type": "user"
        }
      }
    ]

Create a `secrets.tf` file and put your credentials in it:

    variable "azure-tenant-id" {
      default = "108173b6-70a4-462b-b7f2-7fc84cc60307"
    }
    variable "azure-subscription-id" {
      default = "706d86d5-97b7-471b-b1c6-410f6648f186"
    }
    variable "azure-environment-name" {
      default = "Free Trial"
    }

And create a `common.tf` file that tells Terraform to use your Azure account and put the state in the storage account from above.

    provider azurerm {
      tenant_id = var.azure-tenant-id
      subscription_id = var.azure-subscription-id
      environment = var.azure-environment-name
      version = ">= 1.42.0"
    }
    terraform {
      backend "azurerm" {
        resource_group_name = "terraform-ufst"
        storage_account_name = "kaleidoscopesoftware"
        container_name = "terraform-state"
        key = "dev.tfstate"
      }
      required_version = ">= 0.12"
    }

And run the local workstation setup:

    $ terraform init

Now you can deploy your new shiny empty infrastructure:

    $ terraform apply


## Notes

### Azure

The `tenant_id` is the Directory ID, see [portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties).  It is a fixed, global property.

The `subscription_id` can be found through the [portal](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).  It is a kind of a cost group or account.  Which one to use depends on whether you are creating resources for experimentation (*Sandbox*) or test (*Games*).  See `../module/settings-azure` for a list.

The `client_id` is (currently) the Application ID of *Terraform v1*, see [portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationBlade/appId/a614832f-710d-4061-ba3b-90eda3da7392/objectId/85cceaa8-eb09-4e1f-ad7a-d9939bb00b1a).  It should be set in your `secrets-azure.tf` file.

The `client_secret` is a personal token, issued through Azure console.  It should be set in your `secrets-azure.tf` file.

### Terraform

- Explain command line.
- Explain resource creation.
- Explain Terraform state.  Why is it needed, how can it be managed, what are the pitfalls.
- Explain data retrieval versus resource creation.
- Explain HCL by expanding to JSON and back again so that people can read it.

