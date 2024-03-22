
variable "window_name" {
  description = "Maintenance Window Name"
  type = string
  default = ""
}

variable "window_description" {
  description = "Maintenace Window Description"
  type = string
  default = ""
}

variable "schedule" {
  description = "CRON Schedule for Window"
  type =  string
  default = ""
}

variable "duration" {
  description = "Duration of Maintenance Window Runtime"
  type = number
  default = 6
}

variable "cutoff" {
  description = "Number of hours before end of Maintenance Window"
  type = number
  default = 5
}

variable "schedule_timzone" {
  description = "Timezone for Maintenance Window"
  type = string
  default = "America/Toronto"
}

variable "target_name" {
  description = "Name of the target"
  type = string
  default = ""
}

variable "target_description" {
  description = "Target Description"
  type = string
  default = "Maintenace Target"
}

variable "resource_type" {
  description = "Type of resource for SSM Target"
  type = string
  default = "INSTANCE"
}

variable "target_key" {
  description = "Tag key for target"
  type = string
  default = "tag:PatchGroup"
}

variable "target_values" {
  description = "Tag values for target"
  type = list
  default = []
}

variable "task_name" {
  description = "SSM Task Name"
  type = string
  default = ""
}

variable "task_description" {
  description = "Description of SSM Task"
  type = string
  default = "SSM Maintenance Window Task"
}

variable "max_concurrency" {
  description = "Maximum number of concurrent jobs running"
  type = number
  default = 50
}

variable "max_errors" {
  description = "Maximum number of errors before failing"
  type = number
  default = 0
}

variable "priority" {
  description = "Priority number for the task"
  type = number
  default = 1
}

variable "task_arn" {
  description = "ARN of the task to run"
  type = string
  default = "AWS-RunPatchBaseline"
}

variable "task_type" {
  description = "Type of task to run"
  type = string
  default = "RUN_COMMAND"
}

variable "task_target" {
  description = "Targets of the tasks to run against"
  type = string
  default = "WindowTargetIds"
}

variable "output_s3_bucket" {
  description = "S3 Bucket for output of Tasks"
  type = string
  default = null
}

variable "output_s3_key_prefix" {
  description = "S3 key prefix for Output bucket"
  type = string
  default = null
}

variable "service_role_arn" {
  description = "Role ARN for the task to run as"
  type = string
  default = null
}

variable "timeout_seconds" {
  description = "Timeout value for the task"
  type = number
  default = 600
}

variable "notification_arn" {
  description = "Notifications ARN"
  type = string
  default = ""
}

variable "notification_events" {
  description = "Notifications Events"
  type = list(string)
  default = []
}

variable "notification_type" {
  description = "Notifications type"
  type = string
  default = "Invocation"
}

variable "parameters" {
  description = "Task Invocation Parameters"
  type = any
  default = {}
}

variable "baseline_name" {
  description = "Name of Patch Baseline"
  type = string
  default = ""
}

variable "baseline_description" {
  description = "Description of Patch Baseline"
  type = string
  default = ""
}

variable "approval_rule" {
  description = "List of patch approval rules. Patch filter settings required. Cannot be used with 'approved_patches'"
  type = any
  default = []
}

variable "approved_patches" {
  description = "List of approved patches. Cannot be used along with 'approval_rule'"
  type = list(string)
  default = []
}

variable "rejected_patches" {
  description = "List of rejected patches"
  type = list(string)
  default = []
}


variable "operating_system" {
  description = "Type of OS the baseline will be used with"
  type = string
  default = "WINDOWS"
}

variable "rejected_patches_action" {
  description = "Action to be taken with rejected patches. Valid values are ALLOW_AS_DEPENDENCY and BLOCK"
  type = string
  default = "ALLOW_AS_DEPENDENCY"
}

variable "default_baseline" {
  description = "Set value to true to set the baseline as default for that OS"
  type = bool
  default = false
}

variable "patch_groups" {
  description = "Patch Group to be associated with the patch baseline"
  type = list(string)
  default = []
}

variable "document_version" {
  type = string
  default = "$LATEST"
}