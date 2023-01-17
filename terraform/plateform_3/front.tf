resource "aws_s3_bucket" "front" {
  bucket        = "www.epita-arinf-duckapi-bucket"
  force_destroy = true

  provisioner "local-exec" {
    command = "REACT_APP_API_URL=${aws_api_gateway_stage.api.invoke_url} npm run build"
    working_dir = "../../duckfront"
    when = create
  }
}

resource "aws_s3_bucket_acl" "front" {
  bucket = aws_s3_bucket.front.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "front" {
  bucket = aws_s3_bucket.front.bucket
  policy = data.aws_iam_policy_document.public_read.json
}

data "aws_iam_policy_document" "public_read" {
  statement {
    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.front.arn,
      "${aws_s3_bucket.front.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_cors_configuration" "front" {
  bucket = aws_s3_bucket.front.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_object" "front_build" {
  # for_each = fileset("../../duckfront/build", "**")
  for_each     = module.dir.files
  key          = each.key
  content_type = each.value.content_type

  bucket        = aws_s3_bucket.front.bucket
  source        = each.value.source_path
  force_destroy = true

  etag = each.value.digests.md5
}

module "dir" {
  source   = "hashicorp/dir/template"
  version  = "1.0.2"
  # insert the 1 required variable here
  base_dir = "../../duckfront/build/"
}

resource "aws_s3_bucket_website_configuration" "front" {
  bucket = aws_s3_bucket.front.bucket

  index_document {
    suffix = "index.html"
  }

  depends_on = [aws_s3_object.front_build]
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.front.website_domain
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.front.website_endpoint
}