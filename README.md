# AWS CloudFront and Route 53 Network traffic 🌏

A client sends a DNS query to Route 53 for DNS resoultion for CloudFront distribution. This allows client browser and CloudFront to establish a HTTPS connection after the TLS handshake. WAF enforcement and the first TLS termination session occurs at Cloudfront edge before traffic reaches its origin. Traffic is then sent to ALB for another TLS termination session before traffic is directed to your network backend. Cloudfront is resposible for global content delivery and caching to reducing latency to users. 

# SSL/TLS Encryption and TLS termination 🔒 and Amazon Certificate Manager (ACM) 🥇

Amazon Certficate Manager (ACM) is a fully managed service that provisions and manages SSL/TLS certificates placed on CloudFront and ALB ACM for the two TLS termination sessions to occur before traffic reaches your network. ACM removes the overhead of manually replacing expired certificates. AWS edge or load balancing uses those certs for TLS termination. HTTP and traffic forwarded to your target group in your private subnet over HTTP, you must have a Nginx or Apache2 server installed and listening on port 80 behind your TLS terminating proxy to have a healthy target group.

Internet Protocols than can use SSL/TLS encryption 

FTP port 21 -> SSL/TLS -> FTPS port 990

HTTP port 80 → SSL/TLS → HTTPS port 443

SMTP port 25 → SSL/TLS → SMTPS port 465/587

POP3 port 110 → SSL/TLS → POP3S port 995

IMAP port 143 → SSL/TLS → IMAPS port 993

🚨 The purpose of SSL/TLS encryption is for data in transit to prevent eavesdropping and Man In the Middle attacks where a data packet can be intercepted by a threat actor. 

# terraform commands 🔧
```bash
terraform init
terraform validate
terraform fmt -recursive
terraform apply
```

# Verify Cloudfront Access
```bash
curl -I https://chewbacca-growl.com
```

# install a Apache or Nginx server in Amazon Linux to have a server listening on port 80

This will ensure a healthy target group for the ALB to direct traffic

🚨 Create endpoints to AWS Systems Manager to reduce attack surface to securly access your server without using SSH port 22 or a bastion host. Or avoid a NAT gateway overuse by saving money ⚠️

![image alt](https://github.com/DMayrant/CloudFront-Armageddon/blob/main/nginx.png?raw=true)

```bash
sudo dnf install nginx -y
```

# Verify, start and enable apache2
```bash 
systemctl status nginx
systemctl start nginx
systemctl enable nginx
```
DNS propagation of your Nameservers 🌎

```bash
dig NS chewbacca-growl.com +short
```
![image alt](https://github.com/DMayrant/CloudFront-Armageddon/blob/main/Screenshot%202569-01-22%20at%2000.06.04.png?raw=true)

![image alt](https://github.com/DMayrant/CloudFront-Armageddon/blob/main/CloudFront.jpeg?raw=true)
