/*- resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
    }
EOF
}
*/

locals {
  s3_origin_id = "gregstephens.s3.eu-west-2.amazonaws.com"
}

/*resource "aws_s3_bucket" "importeds3bucket" {
  acceleration_status = null
  bucket              = "gregstephens"
  bucket_prefix       = null
  object_lock_enabled = false
  policy = jsonencode(
    {
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Action = "s3:GetObject"
          Condition = {
            StringEquals = {
              "AWS:SourceArn" = "arn:aws:cloudfront::339713013072:distribution/E2HLP4YKICY6WO"
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "cloudfront.amazonaws.com"
          }
          Resource = "arn:aws:s3:::gregstephens/*"
          Sid      = "AllowCloudFrontServicePrincipal"
        },
      ]
      Version = "2008-10-17"
    }
  )
  request_payer = "BucketOwner"
  tags = {
    "project" = "gregcv"
  }
  tags_all = {
    "project" = "gregcv"
  }

  grant {
    id = "409798bc8fbb6835f9bf66185a54ef474e83fe89234c01f27c8192988c7f2ad0"
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"
    uri  = null
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default {
        kms_master_key_id = null
        sse_algorithm     = "AES256"
      }
    }
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
*/

/*resource "aws_cloudfront_distribution" "s3distribution1" {
  aliases = [
    "cv.gregstephens.co.uk",
  ]
  continuous_deployment_policy_id = null
  default_root_object             = "index.html"
  enabled                         = true
  http_version                    = "http2and3"
  is_ipv6_enabled                 = true
  price_class                     = "PriceClass_All"
  retain_on_delete                = false
  staging                         = false
  tags                            = {}
  tags_all                        = {}
  wait_for_deployment             = true
  web_acl_id                      = null

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "gregstephens.s3.eu-west-2.amazonaws.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
  }

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "gregstephens.s3.eu-west-2.amazonaws.com"
    origin_access_control_id = "E3P5J8DOHQGPSA"
    origin_id                = "gregstephens.s3.eu-west-2.amazonaws.com"
    origin_path              = null
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:339713013072:certificate/382f4ddc-86cf-4fb6-b3e0-0d834415ddf5"
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
*/

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/packedlambda.zip"

}

/* resource "aws_lambda_function" "lambdafunction_gregcv" {
  architectures = [
    "x86_64",
  ]
  filename                       = data.archive_file.zip.output_path
  code_signing_config_arn        = null
  description                    = null
  function_name                  = "gregcv-api"
  handler                        = "lambda_function.lambda_handler"
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 128
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = "arn:aws:iam::339713013072:role/service-role/gregcv-api-role-66ydfi08"
  runtime                        = "python3.12"
  signing_job_arn                = null
  signing_profile_version_arn    = null
  skip_destroy                   = false
  source_code_hash               = null
  tags                           = {}
  tags_all                       = {}
  timeout                        = 3

  ephemeral_storage {
    size = 512
  }

  logging_config {
    application_log_level = null
    log_format            = "Text"
    log_group             = "/aws/lambda/gregcv-api"
    system_log_level      = null
  }

  tracing_config {
    mode = "PassThrough"
  }
}
*/

resource "aws_lambda_function_url" "lambdafunction_url1" {
  authorization_type = "NONE"
  function_name      = "gregcv-api"
  invoke_mode        = "BUFFERED"
  qualifier          = null

  cors {
    allow_credentials = false
    allow_headers     = []
    allow_methods     = []
    allow_origins = [
      "https://cv.gregstephens.co.uk",
    ]
    expose_headers = []
    max_age        = 0
  }
}

resource "aws_route53domains_registered_domain" "gregstephens_domain" {
  admin_privacy      = true
  auto_renew         = true
  billing_privacy    = true
  domain_name        = "gregstephens.co.uk"
  registrant_privacy = true
  reseller           = null
  tags               = {}
  tags_all           = {}
  tech_privacy       = true
  transfer_lock      = true

  admin_contact {
    address_line_1 = "7 St Georges Court"
    address_line_2 = null
    city           = "Camberley"
    contact_type   = "PERSON"
    country_code   = "GB"
    email          = "ramboblad@hotmail.co.uk"
    extra_params = {
      "UK_CONTACT_TYPE" = "IND"
    }
    fax               = null
    first_name        = "Greg"
    last_name         = "Stephens"
    organization_name = null
    phone_number      = "+44.7903281669"
    state             = null
    zip_code          = "GU15 3QZ"
  }

  billing_contact {
    address_line_1 = "7 St Georges Court"
    address_line_2 = null
    city           = "Camberley"
    contact_type   = "PERSON"
    country_code   = "GB"
    email          = "ramboblad@hotmail.co.uk"
    extra_params = {
      "UK_CONTACT_TYPE" = "IND"
    }
    fax               = null
    first_name        = "Greg"
    last_name         = "Stephens"
    organization_name = null
    phone_number      = "+44.7903281669"
    state             = null
    zip_code          = "GU15 3QZ"
  }

  name_server {
    glue_ips = []
    name     = "ns-610.awsdns-12.net"
  }
  name_server {
    glue_ips = []
    name     = "ns-1530.awsdns-63.org"
  }
  name_server {
    glue_ips = []
    name     = "ns-1544.awsdns-01.co.uk"
  }
  name_server {
    glue_ips = []
    name     = "ns-467.awsdns-58.com"
  }

  registrant_contact {
    address_line_1 = "7 St Georges Court"
    address_line_2 = null
    city           = "Camberley"
    contact_type   = "PERSON"
    country_code   = "GB"
    email          = "ramboblad@hotmail.co.uk"
    extra_params = {
      "UK_CONTACT_TYPE" = "IND"
    }
    fax               = null
    first_name        = "Greg"
    last_name         = "Stephens"
    organization_name = null
    phone_number      = "+44.7903281669"
    state             = null
    zip_code          = "GU15 3QZ"
  }

  tech_contact {
    address_line_1 = "7 St Georges Court"
    address_line_2 = null
    city           = "Camberley"
    contact_type   = "PERSON"
    country_code   = "GB"
    email          = "ramboblad@hotmail.co.uk"
    extra_params = {
      "UK_CONTACT_TYPE" = "IND"
    }
    fax               = null
    first_name        = "Greg"
    last_name         = "Stephens"
    organization_name = null
    phone_number      = "+44.7903281669"
    state             = null
    zip_code          = "GU15 3QZ"
  }
}

resource "aws_route53_zone" "r53hostedzone" {
  comment           = "HostedZone created by Route53 Registrar"
  delegation_set_id = null
  name              = "gregstephens.co.uk"
  tags                = {}
  tags_all            = {}
}

#resource "aws_route53_record" "gs_NS_record" {}



resource "aws_s3_bucket" "terraform_state_s3bucket" {
    bucket = "greg-tf-state"
    versioning {
      enabled = true
    }

    tags = {
      Name = "greg-tf-state-bucket"
      environment = "prod"
    }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_dyndb_table" {
  name = "greg-terraform-dyndb-table"
  billing_mode = "PAY_PER_REQUEST"

    attribute {
      name = "LockID"
      type = "S"
    }

    hash_key = "LockID"

    tags = {
      name = "greg-terraform-dyndb-table"
      environment = "prod"
    }

}
