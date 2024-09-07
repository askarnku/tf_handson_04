output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_1b_id" {
  value = aws_subnet.public_1b.id
}

output "public_1a_id" {
  value = aws_subnet.public_1a.id
}

output "private_1b_id" {
  value = aws_subnet.private_1b.id
}

output "private_1a_id" {
  value = aws_subnet.private_1a.id
}

output "aws_security_group_id" {
  value = aws_security_group.allow_ssh_http.id
}

output "pubic_assn_1a_id" {
  value = aws_route_table_association.pubic_assn_1a.id
}

output "pubic_assn1b_id" {
  value = aws_route_table_association.pubic_assn1b.id
}

output "private_assn_1b_id" {
  value = aws_route_table_association.private_assn_1b.id
}

output "private_assn_1a" {
  value = aws_route_table_association.private_assn_1a.id
}

output "public_rtb_id" {
  value = aws_route_table.public_rtb.id
}

output "private_rtb_id" {
  value = aws_route_table.private_rtb.id
}

output "name" {
  value = aws_nat_gateway.nat_gw.id
}

# aws_instance.web_server_1a
# aws_instance.web_server_1b

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "web_server_1a_id" {
  value = aws_instance.web_server_1a.id
}

output "web_server_1b_id" {
  value = aws_instance.web_server_1b.id
}
