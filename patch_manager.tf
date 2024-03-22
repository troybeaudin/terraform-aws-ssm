resource "aws_ssm_patch_baseline" "baseline" {
  count            = var.baseline_name == "" ? 0 : 1
  name             = var.baseline_name
  description      = var.baseline_description
  approved_patches = var.approved_patches
  rejected_patches = var.rejected_patches
  rejected_patches_action = var.rejected_patches_action
  operating_system = var.operating_system

  dynamic "approval_rule" {
    for_each = var.approval_rule
    content {
      approve_after_days = approval_rule.value.approve_after_days
      compliance_level = approval_rule.value.compliance_level
      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_filters
        content {
          key = patch_filter.value.name
          values = patch_filter.value.values
        }
      }
    }
  }
}

resource "aws_ssm_default_patch_baseline" "this" {
  count = var.default_baseline == true ? 1 : 0
  baseline_id      = aws_ssm_patch_baseline.baseline[0].id
  operating_system = aws_ssm_patch_baseline.baseline[0].operating_system
}


resource "aws_ssm_patch_group" "baseline_patchgroup" {
  for_each = toset(var.patch_groups)
    baseline_id = aws_ssm_patch_baseline.baseline[0].id
    patch_group = each.key
}