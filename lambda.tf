/*resource "aws_iam_policy" "my_s3_policy" {
  name = "my_custom_s3_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action : [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect : "Allow"
        Resource : ["arn:aws:s3:::vettellambdabucket",
        "arn:aws:s3:::vettellambdabucket/*"]
      }
    ]
  })
}*/

/*resource "aws_iam_policy_attachment" "custom_s3_policy" {
  name       = "custom_s3_policy_attachment"
  policy_arn = aws_iam_role_policy.custom_s3_policy.arn
  roles      = [aws_iam_role.vettel_role.name]
}*/


resource "aws_iam_role" "vettel_role" {
  name = "vettel_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_s3_access" {
  name       = "vettel-lambda-role-attachement"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  roles      = [aws_iam_role.vettel_role.name]
}

resource "aws_iam_policy" "delete_snapshots_policy" {
  name = "Delete_snapshots_policy1"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action : [
                "ec2:DescribeSnapshots",
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes",
                "ec2:DeleteSnapshot"
            ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_snapshot_access" {
  name       = "vettel-snapshot-delete-attachement"
  policy_arn = aws_iam_policy.delete_snapshots_policy.arn
  roles      = [aws_iam_role.vettel_role.name]
}

resource "aws_lambda_function" "vettel_lambda" {
  function_name = "vettel_lambda_function"
  role          = aws_iam_role.vettel_role.arn
  runtime       = "python3.9"
  s3_bucket     = aws_s3_bucket.vettel_lambda_bucket.id
  s3_key        = aws_s3_object.lambda_code.key
  #filename      = "delete_stale_volume.zip"
  handler = "delete_stale_snapshots.lambda_handler"
  timeout = "10"
}


