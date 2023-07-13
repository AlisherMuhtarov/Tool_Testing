variable "config" {
  default = {
    "server1" = {
      ports = [
        {
          from   = 3000
          to     = 3000
          source = "0.0.0.0/0"
        },
        {
          from   = 22
          to     = 22
          source = "::/0"
        },
        {
          from   = 80
          to     = 80
          source = "0.0.0.0/0"
        },
        {
          from   = 443
          to     = 443
          source = "0.0.0.0/0"
        }
      ]
    }
  }
}