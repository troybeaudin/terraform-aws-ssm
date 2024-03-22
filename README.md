# AWS VPC Terraform Module

Create Patch Manager Baselines, Patch Groups, and Maintenance Windows for run commands and automation documents in AWS Systems Manager (SSM)


# Usage

This is an example of a maintenance window

```hcl

module "ssm_auto_window" {
  source = "./terraform-aws-ssm"

  schedule           = "cron(00 10 15 4 ? 2023)"
  window_name        = "maintenance-window-automation"
  window_description = "Test window for automation"
  task_arn           = "AWS-RestartEC2Instance"
  task_type          = "AUTOMATION"
  task_name          = "AutomationTask"
  duration           = 6
  cutoff             = 1
  target_name        = "maintenance-window-target"
  target_description = "This is a maintenance window target"
  target_key         = "InstanceIds"
  target_values      = ["i-0909123123"]
  timeout_seconds    = 600
  parameters = [{
    name  = "InstanceIds"
    value = ["i-00123023123"]
  }]
}

module "ssm_run_window" {
  source = "./terraform-aws-ssm"

  schedule            = "cron(00 10 15 4 ? 2023)"
  window_name         = "maintenance-window-test"
  window_description  = "Test window for other apps and dbs patching Apr 15"
  duration            = 6
  cutoff              = 1
  target_name         = "maintenance-window-target"
  target_description  = "This is a maintenance window target"
  target_key          = "tag: Patch Group"
  target_values       = ["Test", "Dev"]
  task_name           = "RunCommandTask"
  service_role_arn    = "arn:aws:iam::052659884349:role/aws-elasticbeanstalk-service-role"
  notification_arn    = "arn:aws:sns:us-east-1:052659884349:codecommit-notifications:0d6010b5-cbbd-4462-9dce-5156cdbdb5fd"
  notification_events = ["Failed"]
  notification_type   = "Invocation"
  parameters = [{
    name  = "Operation"
    value = ["Install"]
  }]
}

module "windows_baseline" {
  source               = "./terraform-aws-ssm"
  baseline_name        = "Custom-ISGUpdates"
  baseline_description = "Windows - PatchBaseLine"
  patch_groups         = ["Dev", "UAT"]
  rejected_patches     = ["KB5012170"]
  # define rules inside patch baseline
  approval_rule = [
    {
      approve_after_days = 0
      compliance_level   = "UNSPECIFIED"
      patch_filters = [
        {
          name   = "PRODUCT"
          values = ["WindowsServer2016", "WindowsServer2012R2", "WindowsServer2019", "WindowsServer2022"]
        },
        {
          name   = "CLASSIFICATION"
          values = ["CriticalUpdates", "SecurityUpdates", "UpdateRollups", "Updates"]
        },
        {
          name   = "MSRC_SEVERITY"
          values = ["*"]
        }
      ]
    }
  ]
}

module "windows_baseline2" {
  source               = "./terraform-aws-ssm"
  baseline_name        = "Custom-ISGUpdates2"
  baseline_description = "Windows - PatchBaseLine"
  patch_groups         = ["non-prod", "test"]
  # define rules inside patch baseline
  approval_rule = [
    {
      approve_after_days = 7
      compliance_level   = "UNSPECIFIED"
      patch_filters = [
        {
          name   = "PRODUCT"
          values = ["WindowsServer2016", "WindowsServer2012R2", "WindowsServer2019"]
        },
        {
          name   = "CLASSIFICATION"
          values = ["CriticalUpdates", "SecurityUpdates", "UpdateRollups", "Updates"]
        },
        {
          name   = "MSRC_SEVERITY"
          values = ["*"]
        }
      ]
    }
  ]
}

```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.40 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_default_patch_baseline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_default_patch_baseline) | resource |
| [aws_ssm_maintenance_window.ssm_window](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window) | resource |
| [aws_ssm_maintenance_window_target.ssm_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target) | resource |
| [aws_ssm_maintenance_window_task.ssm_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task) | resource |
| [aws_ssm_patch_baseline.baseline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline) | resource |
| [aws_ssm_patch_group.baseline_patchgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_approval_rule"></a> [approval\_rule](#input\_approval\_rule) | List of patch approval rules. Patch filter settings required. Cannot be used with 'approved\_patches' | `any` | `[]` | no |
| <a name="input_approved_patches"></a> [approved\_patches](#input\_approved\_patches) | List of approved patches. Cannot be used along with 'approval\_rule' | `list(string)` | `[]` | no |
| <a name="input_baseline_description"></a> [baseline\_description](#input\_baseline\_description) | Description of Patch Baseline | `string` | `""` | no |
| <a name="input_baseline_name"></a> [baseline\_name](#input\_baseline\_name) | Name of Patch Baseline | `string` | `""` | no |
| <a name="input_cutoff"></a> [cutoff](#input\_cutoff) | Number of hours before end of Maintenance Window | `number` | `6` | no |
| <a name="input_default_baseline"></a> [default\_baseline](#input\_default\_baseline) | Set value to true to set the baseline as default for that OS | `bool` | `false` | no |
| <a name="input_document_version"></a> [document\_version](#input\_document\_version) | n/a | `string` | `"$LATEST"` | no |
| <a name="input_duration"></a> [duration](#input\_duration) | Duration of Maintenance Window Runtime | `number` | `6` | no |
| <a name="input_max_concurrency"></a> [max\_concurrency](#input\_max\_concurrency) | Maximum number of concurrent jobs running | `number` | `50` | no |
| <a name="input_max_errors"></a> [max\_errors](#input\_max\_errors) | Maximum number of errors before failing | `number` | `0` | no |
| <a name="input_notification_arn"></a> [notification\_arn](#input\_notification\_arn) | Notifications ARN | `string` | `""` | no |
| <a name="input_notification_events"></a> [notification\_events](#input\_notification\_events) | Notifications Events | `list(string)` | `[]` | no |
| <a name="input_notification_type"></a> [notification\_type](#input\_notification\_type) | Notifications type | `string` | `"Invocation"` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | Type of OS the baseline will be used with | `string` | `"WINDOWS"` | no |
| <a name="input_output_s3_bucket"></a> [output\_s3\_bucket](#input\_output\_s3\_bucket) | S3 Bucket for output of Tasks | `string` | `null` | no |
| <a name="input_output_s3_key_prefix"></a> [output\_s3\_key\_prefix](#input\_output\_s3\_key\_prefix) | S3 key prefix for Output bucket | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Task Invocation Parameters | `any` | `{}` | no |
| <a name="input_patch_groups"></a> [patch\_groups](#input\_patch\_groups) | Patch Group to be associated with the patch baseline | `list(string)` | `[]` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | Priority number for the task | `number` | `1` | no |
| <a name="input_rejected_patches"></a> [rejected\_patches](#input\_rejected\_patches) | List of rejected patches | `list(string)` | `[]` | no |
| <a name="input_rejected_patches_action"></a> [rejected\_patches\_action](#input\_rejected\_patches\_action) | Action to be taken with rejected patches. Valid values are ALLOW\_AS\_DEPENDENCY and BLOCK | `string` | `"ALLOW_AS_DEPENDENCY"` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | Type of resource for SSM Target | `string` | `"INSTANCE"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | CRON Schedule for Window | `string` | `""` | no |
| <a name="input_schedule_timzone"></a> [schedule\_timzone](#input\_schedule\_timzone) | Timezone for Maintenance Window | `string` | `"America/Toronto"` | no |
| <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn) | Role ARN for the task to run as | `string` | `null` | no |
| <a name="input_target_description"></a> [target\_description](#input\_target\_description) | Target Description | `string` | `"Maintenace Target"` | no |
| <a name="input_target_key"></a> [target\_key](#input\_target\_key) | Tag key for target | `string` | `"tag:PatchGroup"` | no |
| <a name="input_target_name"></a> [target\_name](#input\_target\_name) | Name of the target | `string` | `"PatchingWindowTarget"` | no |
| <a name="input_target_values"></a> [target\_values](#input\_target\_values) | Tag values for target | `list` | `[]` | no |
| <a name="input_task_arn"></a> [task\_arn](#input\_task\_arn) | ARN of the task to run | `string` | `"AWS-RunPatchBaseline"` | no |
| <a name="input_task_description"></a> [task\_description](#input\_task\_description) | Description of SSM Task | `string` | `"SSM Maintenance Window Task"` | no |
| <a name="input_task_name"></a> [task\_name](#input\_task\_name) | SSM Task Name | `string` | `"PatchTask"` | no |
| <a name="input_task_target"></a> [task\_target](#input\_task\_target) | Targets of the tasks to run against | `string` | `"WindowTargetIds"` | no |
| <a name="input_task_type"></a> [task\_type](#input\_task\_type) | Type of task to run | `string` | `"RUN_COMMAND"` | no |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | Timeout value for the task | `number` | `600` | no |
| <a name="input_window_description"></a> [window\_description](#input\_window\_description) | Maintenace Window Description | `string` | `""` | no |
| <a name="input_window_name"></a> [window\_name](#input\_window\_name) | Maintenance Window Name | `string` | `"PatchingWindow"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->