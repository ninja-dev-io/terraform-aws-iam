locals {
  role_policies = flatten([for role in var.roles : [for policy in role.policies : { role = role.name, name = policy }] if length(role.policies) > 0])
  role_inline   = flatten([for role in var.roles : [for policy in role.inline_policies : { role = role.name, name = policy }] if length(role.inline_policies) > 0])
  roles         = zipmap(var.roles[*].name, values(aws_iam_role.roles)[*].arn)
}

resource "aws_iam_role" "roles" {
  for_each           = { for role in var.roles : role.name => role }
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document[each.key].json
}

resource "aws_iam_role_policy_attachment" "role_policies" {
  for_each   = { for policy in local.role_policies : "${policy.role}_${policy.name}" => policy }
  role       = each.value.role
  policy_arn = lookup(local.policies, each.value.name)
}

resource "aws_iam_role_policy" "role_inline" {
  for_each   = { for policy in local.role_inline : "${policy.role}_${policy.name}" => policy }
  name       = each.value.name
  role       = each.value.role
  policy     = data.aws_iam_policy_document.inline_document[each.value.name].json
  depends_on = [aws_iam_role.roles]
}






