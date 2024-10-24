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
  policy_name = each.key # policy > properties.name 으로 들어감
  file_path   = each.value
}

# 현재 구독에 정책 할당
module "assign_definition" {
  source = "gettek/policy-as-code/azurerm//modules/def_assignment"
  for_each = {
    for p in fileset(path.module, "./policies-test/*.json") :
    trimsuffix(basename(p), ".json") => pathexpand(p)
  }
  skip_remediation    = true
  assignment_location = "koreacentral"
  definition          = module.definition[each.key].definition
  assignment_name     = each.key
  assignment_scope    = data.azurerm_subscription.test.id
}