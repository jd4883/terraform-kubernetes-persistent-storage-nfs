resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name   = var.volume.name
    labels = { name = var.volume.name }
  }
  spec {
    access_modes                     = var.volume.access_modes
    capacity                         = local.capacity
    persistent_volume_reclaim_policy = var.volume.reclaim_policy
    volume_mode                      = var.volume.volume_mode
    dynamic "claim_ref" {
      for_each = local.namespaces
      content {
        name      = var.volume.name
        namespace = claim_ref.value
      }
    }
    persistent_volume_source {
      nfs {
        path      = var.volume.path
        read_only = var.volume.read_only
        server    = var.volume.server
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = local.namespaces
  metadata {
    name      = var.volume.name
    namespace = each.value
  }
  spec {
    access_modes = kubernetes_persistent_volume.pv.spec.0.access_modes
    volume_name  = kubernetes_persistent_volume.pv.metadata.0.name
    resources { requests = kubernetes_persistent_volume.pv.spec.0.capacity }
    selector { match_labels = { name = kubernetes_persistent_volume.pv.metadata.0.labels.name } }
  }
}
