resource "aws_iam_role" "this" {
  name = "${var.iam-role-name}-lambda-assume-role"

  assume_role_policy = file("${path.module}/lambda-assume-role-policy.json")

  tags = {
    "tag-key" = "tag-value"
  }
}

resource "aws_iam_role_policy" "this" {
  name = "lambda_assume_role_policy"

  role   = aws_iam_role.this.id
  policy = file("${path.module}/lambda-policy.json")
}
