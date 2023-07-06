output "my_ip" {
  value = data.aws_ip_ranges.current.prefixes[0].ip_prefix
}