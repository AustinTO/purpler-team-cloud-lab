resource "aws_security_group" "adlab-ingress-all" {
  name   = "adlab-allow-all"
  vpc_id = var.vpc_id

  # Kerberos (TCP 88)
  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }

  # RPC (TCP 135)
  ingress {
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # NetBIOS (TCP 139)
  ingress {
    from_port   = 139
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # LDAP (TCP 389)
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  # LDAP / DC Locator (UDP 389)
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }  

  # SMB & Net Logon (TCP 445)
  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # WinRM (HTTPS on port 5986) – external access allowed only from the whitelisted IP
  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }

  # Remote Desktop (TCP 3389) – external access allowed only from the whitelisted IP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }

  # Random high ports (internal)
  ingress {
    from_port   = 49152
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # DNS (UDP 53) – internal
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }

  # ICMP (Ping) – external
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.external_whitelist_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "blueteam-ingress-all" {
  name   = "allow-all-sg"
  vpc_id = var.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }
  
  # helk-ksql-server
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }

  # helk-kafka (internal)
  ingress {
    from_port   = 9092
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # helk-kafka-broker (internal)
  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # helk-nginx
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }
  
  # helk-nginx-ssl
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }
  
  # helk-logstash (internal)
  ingress {
    from_port   = 3515
    to_port     = 3515
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  ingress {
    from_port   = 8531
    to_port     = 8531
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  ingress {
    from_port   = 9600
    to_port     = 9600
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # helk-kibana
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  # helk-elasticsearch
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }
  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = [var.external_whitelist_ip]
  }
  
  # RDP (internal)
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidr_prefix}.0/24"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redteam-ingress-all" {
  name   = "caldera-allow-all-sg"
  vpc_id = var.vpc_id
  
  ingress {
    cidr_blocks = [var.external_whitelist_ip]
    from_port   = 0
    to_port     = 8888
    protocol    = "tcp"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "win2019" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "adlab-dc" {
  ami                          = data.aws_ami.win2019.id
  instance_type                = "t2.micro"
  key_name                     = var.key_name
  security_groups              = [aws_security_group.adlab-ingress-all.id]
  subnet_id                    = var.subnet_id
  associate_public_ip_address  = true
  private_ip                   = "192.168.10.100"
user_data = <<EOF
<powershell>
# Disable EC2Launch so it doesn't override settings
Stop-Service -Name EC2Launch -Force
Set-Service -Name EC2Launch -StartupType Disabled

# Configure WinRM and set the Administrator password
Enable-PSRemoting -Force
Set-Service WinRM -StartMode Automatic
Set-LocalUser -Name "Administrator" -Password (ConvertTo-SecureString "${var.default_password}" -AsPlainText -Force)

# Create a self-signed certificate and configure an HTTPS listener
$Cert = New-SelfSignedCertificate -DnsName "${var.adlab_domain}" -CertStoreLocation Cert:\LocalMachine\My
$listenerCmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`"${var.adlab_domain}`"; CertificateThumbprint=`"" + $Cert.Thumbprint + "`"}'"
Invoke-Expression $listenerCmd

# Set Basic authentication directly using the WSMan provider
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false
Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $false

# Open the HTTPS WinRM port in the firewall and set TrustedHosts
netsh advfirewall firewall add rule name="WinRM_HTTPS" dir=in action=allow protocol=TCP localport=5986
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
</powershell>
EOF


  root_block_device {
    delete_on_termination = true
    volume_size           = 30
  }
  tags = {
    Name        = "Domain Controller EC2 Machine - ${var.env}"
    Workspace   = "ADLab"
    Environment = var.env
  }
  credit_specification {
    cpu_credits = "standard"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_instance" "adlab-win10" {
  ami                          = data.aws_ami.win2019.id
  instance_type                = "t2.micro"
  key_name                     = var.key_name
  security_groups              = [aws_security_group.adlab-ingress-all.id]
  subnet_id                    = var.subnet_id
  associate_public_ip_address  = true
  private_ip                   = "192.168.10.110"
  user_data = <<EOF
<powershell>
# Disable EC2Launch so it doesn't override settings
Stop-Service -Name EC2Launch -Force
Set-Service -Name EC2Launch -StartupType Disabled

# Configure WinRM and set the Administrator password
Enable-PSRemoting -Force
Set-Service WinRM -StartMode Automatic
Set-LocalUser -Name "Administrator" -Password (ConvertTo-SecureString "${var.default_password}" -AsPlainText -Force)

# Create a self-signed certificate and configure an HTTPS listener
$Cert = New-SelfSignedCertificate -DnsName "${var.adlab_domain}" -CertStoreLocation Cert:\LocalMachine\My
$listenerCmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`"${var.adlab_domain}`"; CertificateThumbprint=`"" + $Cert.Thumbprint + "`"}'"
Invoke-Expression $listenerCmd

# Set Basic authentication directly using the WSMan provider
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Client\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false
Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $false

# Open the HTTPS WinRM port in the firewall and set TrustedHosts
netsh advfirewall firewall add rule name="WinRM_HTTPS" dir=in action=allow protocol=TCP localport=5986
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
</powershell>
EOF


  root_block_device {
    delete_on_termination = true
    volume_size           = 30
  }
  tags = {
    Name        = "Windows 10 Simple EC2 Machine - ${var.env}"
    Workspace   = "ADLab"
    Environment = var.env
  }
  credit_specification {
    cpu_credits = "standard"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
  depends_on = [aws_instance.adlab-dc]
}

resource "aws_instance" "blueteam-helk" {
  ami                          = data.aws_ami.amazonlinux.id
  instance_type                = "t2.large"
  key_name                     = var.key_name
  security_groups              = [aws_security_group.blueteam-ingress-all.id]
  subnet_id                    = var.blueteam_subnet_id
  associate_public_ip_address  = true
  private_ip                   = "192.168.20.100"
  user_data                    = file("${path.module}/blueteam-machine-config.yml")
  root_block_device {
    delete_on_termination = true
    volume_size           = 60
  }
  tags = {
    Name        = "Blue Team HELK Machine - ${var.env}"
    Workspace   = "ADLab"
    Environment = var.env
  }
  credit_specification {
    cpu_credits = "standard"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
  depends_on = [aws_instance.adlab-dc]
}

resource "aws_instance" "redteam-caldera" {
  ami                          = data.aws_ami.amazonlinux.id
  instance_type                = "t2.micro"
  key_name                     = var.key_name
  security_groups              = [aws_security_group.redteam-ingress-all.id]
  subnet_id                    = var.attacker_subnet_id
  associate_public_ip_address  = true
  private_ip                   = "192.168.30.100"
  user_data                    = file("${path.module}/redteam-machine-config.yml")
  root_block_device {
    delete_on_termination = true
    volume_size           = 20
  }
  tags = {
    Name        = "Red Team Caldera Machine - ${var.env}"
    Workspace   = "ADLab"
    Environment = var.env
  }
  credit_specification {
    cpu_credits = "standard"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}
