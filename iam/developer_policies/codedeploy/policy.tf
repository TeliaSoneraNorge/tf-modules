# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "prefix" {
  description = "Restrict access to resources with the given prefix."
}

variable "account_id" {
  description = "Restrict access to a given account ID."
}

variable "region" {
  description = "Restrict privileges to a given region."
}

variable "iam_role_name" {
  description = "Name of IAM role to attach the generated policy to."
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy" "main" {
  name   = "${var.prefix}-codedeploy-policy"
  role   = "${var.iam_role_name}"
  policy = "${data.aws_iam_policy_document.main.json}"
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    actions = [
      "codedeploy:*",
    ]

    resources = [
      "arn:aws:codedeploy:${var.region}:${var.account_id}:deploymentgroup:${var.prefix}-*",
      "arn:aws:codedeploy:${var.region}:${var.account_id}:application:${var.prefix}-*",
    ]
  }
}

# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "policy_name" {
  value = "${aws_iam_role_policy.main.name}"
}

output "policy_id" {
  value = "${aws_iam_role_policy.main.id}"
}