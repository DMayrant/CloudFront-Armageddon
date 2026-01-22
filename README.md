# AWS CloudFront 🌏

AWS Cloudfront is a fully managed service that allows globally cached and content delivery, to reduce latency and increase performance for users. WAF can enabled as a security backend to CloudFront, WAF enforcement begins at the cloudfront edge level and protect against Distributed Denial of Service (DDOS attacks). An ALB load balancer receives traffic from CloudFront and is directed to target groups in the private subnet. An ALB cannot be reached even if you have the DNS, you can only access it through CloudFront

# SSL/TLS Encryption and TLS termination 🔒 and Amazon Certificate Manager (ACM) 🥇

ACM is managed service by AWS for certificate management and placing SSL/TLS certificate on ingress traffic coming into your network. ACM removes the overhead of manually replacing expired certificates. AWS edge or load balancing uses those certs for TLS termination. TLS handshake happens at AWS endpoint and is terminated by CloudFront, Elastic Load Balancing (ALB, NLB) and API Gateway. 

HTTPS traffic flow from the public internet and reaches the ALB. The ALB performs TLS termination (decryption) and traffic forwarded to your target group in your private subnet over HTTP, you must have a Nginx or Apache2 server listening on port 80 behind your TLS terminating proxy. The ALB is configured with AWS WAF for OWASP top 10 compliance such as SQL injection, XML external entities and insecure deserialization. AWS ACM is also configured with the ALB for the issuance, validation and management of SSL/TLS certificates. 

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
