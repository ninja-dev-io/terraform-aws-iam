locals {

  arns             = merge(local.groups, local.users, local.roles)
  aws_managed      = { for policy in var.aws_policies : policy => policy }
  customer_managed = { for policy in var.customer_policies : policy.name => policy }
  inline           = { for policy in var.inline_policies : policy.name => policy }
  policies         = merge(zipmap(keys(local.customer_managed), values(aws_iam_policy.customer_managed)[*].arn), zipmap(keys(local.aws_managed), values(data.aws_iam_policy.aws_managed)[*].arn))
}

data "aws_iam_policy" "aws_managed" {
  for_each = local.aws_managed
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

data "aws_iam_policy_document" "customer_managed_document" {
  for_each = local.customer_managed
  dynamic "statement" {
    for_each = each.value.statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
      dynamic "condition" {
        for_each = statement.value.condition
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = [for identifier in principals.value.identifiers : lookup(local.arns, identifier) != null ? lookup(local.arns, identifier) : identifier]
        }
      }
    }
  }
}

data "aws_iam_policy_document" "inline_document" {
  for_each = local.inline
  dynamic "statement" {
    for_each = each.value.statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  for_each = { for role in var.roles : role.name => role.assume_role_policy }
  dynamic "statement" {
    for_each = each.value.statements
    content {
      actions = statement.value.actions
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}
resource "aws_iam_policy" "customer_managed" {
  for_each    = local.customer_managed
  name        = each.value.name
  description = each.value.description
  policy      = data.aws_iam_policy_document.customer_managed_document[each.key].json
}



