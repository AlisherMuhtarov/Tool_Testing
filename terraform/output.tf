output "my_ip" {
  value = cidrhost(data.aws_ip_ranges.current.prefixes[0].ip_prefix, 0)
}