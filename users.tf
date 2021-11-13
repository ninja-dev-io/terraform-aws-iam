locals {
  user_policies = flatten([for user in var.users : [for policy in user.policies : { user = user.name, name = policy }] if length(user.policies) > 0])
  user_inline   = flatten([for user in var.users : [for policy in user.inline_policies : { user = user.name, name = policy }] if length(user.inline_policies) > 0])

  keys = { for user in var.users : user.name => user.key if user.key != null }

  users = zipmap(var.users[*].name, values(aws_iam_user.user)[*].arn)
}

resource "aws_iam_user" "user" {
  for_each = { for user in var.users : user.name => user }
  name     = each.value.name
  path     = each.value.path
}

resource "aws_iam_user_group_membership" "user_groups" {
  for_each   = { for user in var.users : user.name => user if length(user.groups) > 0 }
  user       = each.value.name
  groups     = each.value.groups
  depends_on = [aws_iam_group.group, aws_iam_user.user]
}

resource "aws_iam_user_policy_attachment" "user_policies" {
  for_each   = { for policy in local.user_policies : "${policy.user}_${policy.name}" => policy }
  user       = each.value.user
  policy_arn = lookup(local.policies, each.value.name)
}

resource "aws_iam_user_policy" "user_inline" {
  for_each   = { for policy in local.user_inline : "${policy.user}_${policy.name}" => policy }
  name       = each.value.name
  user       = each.value.user
  policy     = data.aws_iam_policy_document.inline_document[each.value.name].json
  depends_on = [aws_iam_user.user]
}

resource "tls_private_key" "private_key" {
  for_each  = local.keys
  algorithm = each.value.algorithm
}

resource "aws_key_pair" "authorized_keys" {
  for_each   = local.keys
  key_name   = each.key
  public_key = tls_private_key.private_key[each.key].public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "local_file" "private_key_pem" {
  for_each = local.keys
  content  = tls_private_key.private_key[each.key].private_key_pem
  filename = "${each.value.path}/${each.key}.pem"
}

resource "local_file" "public_key_openssh" {
  for_each = local.keys
  content  = tls_private_key.private_key[each.key].public_key_openssh
  filename = "${each.value.path}/${each.key}.pub"
}






