data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    dynamic "principals" {
      for_each = var.assume_policy_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "policy_documents" {
  source_policy_documents = var.role_policy_documents
}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.policy_documents.json
}

# resource "aws_iam_policy" "policy" {
#   name = "${var.role_name}-policy"
#   policy = jsonencode(var.role_policy)
# }

# resource "aws_iam_role_policy_attachment" "policy_attachment_role" {
#   role = aws_iam_role.this.name
#   policy_arn = aws_iam_policy.policy.arn
# }

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.policys_to_attach

  role       = aws_iam_role.this.name
  policy_arn = each.value
}