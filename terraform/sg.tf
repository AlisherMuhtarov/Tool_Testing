    resource "aws_security_group" "main_sg" {   
    name        = "main"
    description = "Allow SSH inbound traffic"

    ingress {
        from_port        = var.ports[2]
        to_port          = var.ports[2]
        protocol         = var.protocol[1]
        cidr_blocks      = [var.cidrs[1]]
    }

    egress {
        from_port        = var.ports[0]
        to_port          = var.ports[0]
        protocol         = var.protocol[0]
        cidr_blocks      = [var.cidrs[0]]
    }
    
}