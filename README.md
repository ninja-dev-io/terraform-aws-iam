## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.group_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.group_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.user_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_policy.user_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy_attachment.user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_key_pair.authorized_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_iam_policy.aws_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.customer_managed_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.inline_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_policies"></a> [aws\_policies](#input\_aws\_policies) | n/a | `list(string)` | n/a | yes |
| <a name="input_customer_policies"></a> [customer\_policies](#input\_customer\_policies) | n/a | <pre>list(object({<br>    name        = string<br>    description = string<br>    statements = list(object({<br>      effect    = string<br>      actions   = list(string)<br>      resources = list(string)<br>      condition = list(object({<br>        test     = string<br>        variable = string<br>        values   = list(string)<br><br>      }))<br>      principals = list(object({<br>        type        = string<br>        identifiers = list(string)<br><br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_groups"></a> [groups](#input\_groups) | n/a | <pre>list(object({<br>    name            = string<br>    path            = string<br>    policies        = list(string)<br>    inline_policies = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | n/a | <pre>list(object({<br>    name        = string<br>    description = string<br>    statements = list(object({<br>      effect    = string<br>      actions   = list(string)<br>      resources = list(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | n/a | <pre>list(object({<br>    name = string<br>    assume_role_policy = object({<br>      statements = list(object({<br>        actions = list(string)<br>        principals = list(object({<br>          type        = string<br>          identifiers = list(string)<br>        }))<br>      }))<br>    })<br>    policies        = list(string)<br>    inline_policies = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | n/a | <pre>list(object({<br>    name = string<br>    path = string<br>    key = object({<br>      path      = string<br>      algorithm = string<br>    })<br>    groups          = list(string)<br>    policies        = list(string)<br>    inline_policies = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_groups"></a> [groups](#output\_groups) | n/a |
| <a name="output_policies"></a> [policies](#output\_policies) | n/a |
| <a name="output_roles"></a> [roles](#output\_roles) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |