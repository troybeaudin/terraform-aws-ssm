
resource "aws_ssm_maintenance_window" "ssm_window" {
  for_each = var.maintenance_window
  name                = lookup(each.value, "window_name", "PatchingWindow")
  schedule            = lookup(each.value, "schedule", null)
  duration            = lookup(each.value, "duration", 6)
  cutoff              = lookup(each.value, "cutoff", 0)
  schedule_timezone   = lookup(each.value, "schedule_timzone", "America/Toronto")
}

resource "aws_ssm_maintenance_window_target" "ssm_target" {
  window_id           = aws_ssm_maintenance_window.ssm_window[each.key].id
  for_each            = var.maintenance_window
  name                = lookup(each.value, "target_name", "PatchingWindowTarget")
  description         = lookup(each.value, "target_description", null)
  resource_type       = lookup(each.value, "resource_type", "INSTANCE")
  targets {
      key             = lookup(each.value, "target_key", "tag:Patch Group")
      values          = lookup(each.value, "target_values", [])
    }
}

resource "aws_ssm_maintenance_window_task" "ssm_task" {
  window_id           = aws_ssm_maintenance_window.ssm_window[each.key].id

  for_each            = var.maintenance_window
  name                = lookup(each.value, "task_name", null)
  description         = lookup(each.value, "task_description", null)
  max_concurrency     = lookup(each.value, "max_concurrency", 50)
  max_errors          = lookup(each.value, "max_errors", 0)
  priority            = lookup(each.value, "priority", 1)
  task_arn            = lookup(each.value, "task_arn", "AWS-RunPatchBaseline")
  task_type           = lookup(each.value, "task_type", "RUN_COMMAND")
  targets {
            key             = lookup(each.value, "task_target", "WindowTargetIds")
            values          = [aws_ssm_maintenance_window_target.ssm_target[each.key].id]
        }
        
    task_invocation_parameters {
      run_command_parameters {
        output_s3_bucket     = lookup(each.value, "output_s3_bucket", null)
        output_s3_key_prefix = lookup(each.value, "output_s3_key_prefix", null)
        service_role_arn     = lookup(each.value, "service_role_arn", null)
        timeout_seconds      = lookup(each.value, "timeout_seconds", 600)
  
        notification_config {
          notification_arn    = lookup(each.value, "notification_arn", null)
          notification_events = lookup(each.value, "notification_events", null)
          notification_type   = lookup(each.value, "notification_type", null)
        }
  
        parameter {
          name              = lookup(each.value, "parameter_name", null)
          values            = lookup(each.value, "parameter_value", null)
          }
        }
      }
    }
  
