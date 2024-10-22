terraform {
  required_providers {
    azurerm = "~> 4.0"
  }
}
provider "azurerm" {
  features {

  }
}
data "azurerm_subscription" "test" {}

# 현재 구독에 정책 데피니션 생성
module "definition" {
  source = "gettek/policy-as-code/azurerm//modules/definition"
  for_each = {
    for p in fileset(path.module, "./policies-test/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  policy_name = each.key
  file_path   = each.value
}

# 현재 구독에 정책 할당
module "assign_definition" {
  source = "gettek/policy-as-code/azurerm//modules/def_assignment"
  for_each = {
    for p in fileset(path.module, "./policies-test/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  assignment_location = "koreacentral"
  definition          = module.definition[each.key]
  assignment_name     = each.key
  assignment_scope    = data.azurerm_subscription.test.id
}

# modify effect
data azurerm_role_definition contributor {
  name = "Contributor"
}

module "definition_modify" {
  source = "gettek/policy-as-code/azurerm//modules/definition"
  for_each = {
    for p in fileset(path.module, "./policy-modify-effect/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  policy_name = each.key
  file_path   = each.value
}
module "assign_definition_modify" {
  source = "gettek/policy-as-code/azurerm//modules/def_assignment"
  for_each = {
    for p in fileset(path.module, "./policy-modify-effect/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  role_definition_ids = [
    data.azurerm_role_definition.contributor.id
  ]
  role_assignment_scope = data.azurerm_subscription.test.id
  assignment_location = "koreacentral"
  skip_remediation  = false
  definition          = module.definition_modify[each.key]
  assignment_name     = each.key
  assignment_scope    = data.azurerm_subscription.test.id
}
output "test" {
  value = module.assign_definition_modify["inherit-tag-rg"].test
}