locals {
  server_sg_ids = [
    for sg_k, sg_v in module.security_groups.sg : sg_v if sg_k == "public_instance_sg"
  ]
}

