// Copyright 2017 Chris Marchesi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// consul_instance_profile_policy_document defines the IAM policy for fetching
// instance data, required for host discovery.
data "aws_iam_policy_document" "consul_instance_profile_policy_document" {
  statement {
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}

// consul_instance_profile_assume_role_policy_document defines the assume role
// policy document for consul_instance_profile_iam_role.
data "aws_iam_policy_document" "consul_instance_profile_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// consul_instance_profile_iam_role defines the IAM role for the Consul
// instance profile.
resource "aws_iam_role" "consul_instance_profile_iam_role" {
  name               = "ConsulInstanceProfileRole"
  assume_role_policy = "${data.aws_iam_policy_document.consul_instance_profile_assume_role_policy_document.json}"
}

// consul_instance_profile_iam_policy creates the policy defined by
// consul_instance_profile_assume_role_policy_document.
resource "aws_iam_policy" "consul_instance_profile_iam_policy" {
  name   = "ConsulInstanceProfilePolicy"
  policy = "${data.aws_iam_policy_document.consul_instance_profile_policy_document.json}"
}

// consul_instance_profile_iam_role_policy_attachment attaches
// consul_instance_profile_policy to consul_instance_profile_iam_role.
resource "aws_iam_policy_attachment" "consul_instance_profile_iam_role_policy_attachment" {
  name       = "ConsulInstanceProfileRolePolicyAttachment"
  roles      = ["${aws_iam_role.consul_instance_profile_iam_role.name}"]
  policy_arn = "${aws_iam_policy.consul_instance_profile_iam_policy.arn}"
}

// consul_instance_profile creates the instance profile, adding
// consul_instance_profile_iam_role to it.
resource "aws_iam_instance_profile" "consul_instance_profile" {
  name = "ConsulInstanceProfile"
  role = "${aws_iam_role.consul_instance_profile_iam_role.name}"
}
