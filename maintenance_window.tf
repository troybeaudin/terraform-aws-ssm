locals {
  task_invocation_parameters = {
    run_command_parameters = {
      output_s3_bucket     = var.output_s3_bucket
      output_s3_key_prefix = var.output_s3_key_prefix
      service_role_arn     = var.service_role_arn
      timeout_seconds      = var.timeout_seconds
      notification_config  = {
        notification_arn    = var.notification_arn
        notification_events = var.notification_events
        notification_type   = var.notification_type
      }
      #parameter = [
      #  {
      #    name   = "commands"
      #    values = var.commands
      #  }
      #]
    }
    automation_parameters = {
      document_version = var.document_version
    }
  }
}

resource "aws_ssm_maintenance_window" "ssm_window" {
  name                = var.window_name
  description         = var.window_description
  schedule            = var.schedule
  duration            = var.duration
  cutoff              = var.cutoff
  schedule_timezone   = var.schedule_timzone
}

resource "aws_ssm_maintenance_window_target" "ssm_target" {
  window_id           = aws_ssm_maintenance_window.ssm_window.id
  name                = var.target_name
  description         = var.target_description
  resource_type       = var.resource_type
  targets {           
      key             = var.target_key
      values          = var.target_values
    }
}

resource "aws_ssm_maintenance_window_task" "ssm_task" {
  window_id           = aws_ssm_maintenance_window.ssm_window.id
  name                = var.task_name
  description         = var.task_description
  max_concurrency     = var.max_concurrency
  max_errors          = var.max_errors
  priority            = var.priority
  task_arn            = var.task_arn
  task_type           = var.task_type
  targets {
            key             = var.task_target
            values          = [aws_ssm_maintenance_window_target.ssm_target.id]
        }
        
  dynamic "task_invocation_parameters" {
    for_each = var.task_type == "RUN_COMMAND" ? [1] : []

    content {
      run_command_parameters {
        output_s3_bucket     = local.task_invocation_parameters.run_command_parameters.output_s3_bucket
        output_s3_key_prefix = local.task_invocation_parameters.run_command_parameters.output_s3_key_prefix
        service_role_arn     = local.task_invocation_parameters.run_command_parameters.service_role_arn
        timeout_seconds      = local.task_invocation_parameters.run_command_parameters.timeout_seconds

        notification_config {
          notification_arn    = local.task_invocation_parameters.run_command_parameters.notification_config.notification_arn
          notification_events = local.task_invocation_parameters.run_command_parameters.notification_config.notification_events
          notification_type   = local.task_invocation_parameters.run_command_parameters.notification_config.notification_type
        }

        dynamic "parameter" {
          for_each = var.parameters
          content {
            name   = parameter.value.name
            values = parameter.value.value
          }
        }
      }
    }
  }

  dynamic "task_invocation_parameters" {
    for_each = var.task_type == "AUTOMATION" ? [1] : []

    content {
      automation_parameters {
        document_version = local.task_invocation_parameters.automation_parameters.document_version

        dynamic "parameter" {
          for_each = var.parameters
          content {
            name   = parameter.value.name
            values = parameter.value.value
          }
        }
      }
    }
  }
}
