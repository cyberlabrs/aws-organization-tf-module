module "meta" {
  source = "../meta"
  meta   = var.meta
}

locals {
  feature_set                   = var.feature_set == null ? "ALL" : var.feature_set
  aws_service_access_principals = var.aws_service_access_principals == null ? [] : var.aws_service_access_principals
  organizational_units          = var.organizational_units == null ? [] : var.organizational_units
  accounts                      = var.accounts == null ? [] : var.accounts
  all_account_attributes = [
    for account in aws_organizations_account.account[*] :
    {
      id        = account.id,
      arn       = account.arn,
      name      = account.name
      email     = account.email
      parent_id = account.parent_id,
      parent_ou = local.accounts[index(aws_organizations_account.account[*], account)].organizational_unit,
    }
  ]
}

resource "aws_organizations_organization" "organization" {
  feature_set                   = local.feature_set
  aws_service_access_principals = local.aws_service_access_principals
}


resource "aws_organizations_account" "account" {
  count = length(local.accounts)

  name  = local.accounts[count.index].name
  email = local.accounts[count.index].email

  # iam_user_access_to_billing = local.accounts[count.index].allow_iam_users_access_to_billing ? "ALLOW" : "DENY"

  parent_id = [for ou in local.all_ou_attributes : ou.id if ou.name == local.accounts[count.index].organizational_unit][0]
}

