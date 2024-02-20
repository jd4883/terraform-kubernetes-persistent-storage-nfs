variable "volume" {
  type = object(
    {
      access_modes   = optional(list(string), ["ReadWriteMany"])
      name           = string
      namespaces     = optional(list(string), [])
      path           = string
      read_only      = optional(bool, false)
      server         = string
      reclaim_policy = optional(string, "Retain")
      size           = string
      volume_mode    = optional(string, "Filesystem")
    }
  )
}
