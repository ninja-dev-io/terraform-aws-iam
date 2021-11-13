variable "env" {
  type = string
}

variable "groups" {
  type = list(object({
    name            = string
    path            = string
    policies        = list(string)
    inline_policies = list(string)
  }))
}

variable "users" {
  type = list(object({
    name = string
    path = string
    key = object({
      path      = string
      algorithm = string
    })
    groups          = list(string)
    policies        = list(string)
    inline_policies = list(string)
  }))
}

variable "roles" {
  type = list(object({
    name = string
    assume_role_policy = object({
      statements = list(object({
        actions = list(string)
        principals = list(object({
          type        = string
          identifiers = list(string)
        }))
      }))
    })
    policies        = list(string)
    inline_policies = list(string)
  }))
}

variable "aws_policies" {
  type = list(string)
}

variable "customer_policies" {
  type = list(object({
    name        = string
    description = string
    statements = list(object({
      effect    = string
      actions   = list(string)
      resources = list(string)
      condition = list(object({
        test     = string
        variable = string
        values   = list(string)

      }))
      principals = list(object({
        type        = string
        identifiers = list(string)

      }))
    }))
  }))
}

variable "inline_policies" {
  type = list(object({
    name        = string
    description = string
    statements = list(object({
      effect    = string
      actions   = list(string)
      resources = list(string)
    }))
  }))
}
