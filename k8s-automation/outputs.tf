output "master_eip" {
  description = "EIP of master node"
  value       = aws_eip.master.public_ip
}

output "worker1_eip" {
  description = "EIP of worker1 node"
  value       = aws_eip.worker1.public_ip
}

output "worker2_eip" {
  description = "EIP of worker2 node"
  value       = aws_eip.worker2.public_ip
}
