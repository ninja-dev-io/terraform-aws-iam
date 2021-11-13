locals {
  roles = zipmap(var.roles[*].name, values(aws_iam_role.roles)[*].arn)
}

resource "aws_iam_role" "roles" {
  for_each            = { for role in var.roles : role.name => role }
  name                = each.key
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy_document[each.key].json
  managed_policy_arns = [for policy in each.value.policies : lookup(local.policies, policy)]
  dynamic "inline_policy" {
    for_each = each.value.inline_policies
    content {
      name   = "${each.key}-${inline_policy.value}"
      policy = data.aws_iam_policy_document.inline_document[inline_policy.value].json
    }
  }
}






