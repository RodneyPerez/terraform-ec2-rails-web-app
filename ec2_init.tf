# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "log_config.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/log_config.yaml", { Environment = var.env, Application = local.app_name_lowercase })
  }

  part {
    filename     = "startup_script.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/startup_script.sh", { Environment = var.env, Application = local.app_name_lowercase, region = var.region })
  }
}
