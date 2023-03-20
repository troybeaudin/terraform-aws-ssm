# AWS VPC Terraform Module

Create features in AWS Systems Manager (SSM)

# Requirements

```hcl

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40"
    }
  }
}
```


# TODO
- Patch Manager
- Command and Automation Documents



# Resources

The following resources are used in this module:

[aws_ssm_maintenance_window](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window)

[aws_ssm_maintenance_window_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target)

[aws_ssm_maintenance_window_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task)


# Usage

This is an example of a maintenance window

```hcl

module "ssm_window" {
  source = "./terraform-aws-ssm"

  maintenance_window = {
    main_window1 = {
      schedule           = "cron(30 23 ? * TUES#3 *)"
      window_name        = "maintenance-window-test"
      duration           = 6
      cutoff             = 1
      target_name        = "maintenance-window-target"
      target_description = "This is a maintenance window target"
      target_key         = "tag: Patch Group"
      target_values      = ["Test", "Dev"]
      parameter_name     = "Operation"
      parameter_value    = ["Install"]
    },
    main_window2 = {
      schedule        = "cron(0 0 ? * THU#2 * )"
      duration        = 6
      cutoff          = 0
      target_key      = "tag: Name"
      target_values   = ["Test"]
      parameter_name  = "Operation"
      parameter_value = ["Scan"]
    }
  }
}

```