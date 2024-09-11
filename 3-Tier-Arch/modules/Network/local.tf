locals {
    ingress_rules = [
        {
            description = "Allow inbound SSH traffic from registered ip addresses"
            port = 22
            protocol = "tcp"
        },
        {
            description = "Allow inbound HTTP traffic"
            port = 80
            protocol = "tcp"
        },
        {
            description = "Allow inbound HTTPS traffic"
            port = 443
            protocol = "tcp"
        }
    ]

    rds_ingress_rules = [
        {
            description = "Allow MySQL inbound traffic"
            port = 3306
            protocol = "tcp"
        }
    ]
    egress_rules = [
        {
            description = "Allow all outbound traffic"
            port = 0
        }
    ]
}