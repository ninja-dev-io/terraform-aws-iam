locals {
  group_policies = flatten([for group in var.groups : [for policy in group.policies : { group = group.name, name = policy }] if length(group.policies) > 0])
  group_inline   = flatten([for group in var.groups : [for policy in group.inline_policies : { group = group.name, name = policy }] if length(group.inline_policies) > 0])

  groups = zipmap(var.groups[*].name, values(aws_iam_group.group)[*].arn)
}

resource "aws_iam_group" "group" {
  for_each = { for group in var.groups : group.name => group }
  name     = each.value.name
  path     = each.value.path
}

resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each   = { for policy in local.group_policies : "${policy.group}_${policy.name}" => policy }
  group      = each.value.group
  policy_arn = lookup(local.policies, each.value.name)
}

resource "aws_iam_group_policy" "group_inline" {
  for_each   = { for policy in local.group_inline : "${policy.group}_${policy.name}" => policy }
  name       = each.value.name
  group      = each.value.group
  policy     = data.aws_iam_policy_document.inline_document[each.value.name].json
  depends_on = [aws_iam_group.group]
}













