locals {
  capacity   = { storage = var.volume.size }
  namespaces = toset(alltrue([(length(var.volume.namespaces) == 0)]) ? [var.volume.name] : var.volume.namespaces)
}
