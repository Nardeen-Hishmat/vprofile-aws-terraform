# vProfile: Multi-Tier Web Application Deployment on AWS with Terraform

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)
![RabbitMQ](https://img.shields.io/badge/Rabbitmq-FF6600?style=for-the-badge&logo=rabbitmq&logoColor=white)
![Memcached](https://img.shields.io/badge/Memcached-00A32A?style=for-the-badge&logo=memcached&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/apache%20tomcat-%23F8DC75.svg?style=for-the-badge&logo=apache-tomcat&logoColor=black)
![Maven](https://img.shields.io/badge/Apache%20Maven-C71A36?style=for-the-badge&logo=Apache%20Maven&logoColor=white)

This repository contains the Infrastructure as Code (IaC) scripts required to provision a production-ready environment on AWS for the vProfile Java application. The project leverages Terraform to automate the creation of network configurations, security groups, and backend services.

## Project Architecture

The architecture follows a standard multi-tier pattern deployed on AWS:

* **Load Balancing:** AWS Security Groups configured to simulate load balancer traffic distribution.
* **Application Layer:** EC2 Instance hosting Apache Tomcat 9 and the Java application artifact.
* **Backend Services:**
    * **Database:** Amazon RDS (MySQL) for persistent data storage.
    * **Caching:** Amazon ElastiCache (Memcached) for database caching.
    * **Message Broker:** Amazon MQ (RabbitMQ) for asynchronous messaging.

### Infrastructure Diagram

```mermaid
graph TD
    User[User / Internet] -->|HTTP:8080| AppSG[App Security Group]
    
    subgraph "AWS Cloud (us-east-1)"
        AppSG --> EC2[EC2 Instance / Tomcat 9]
        
        subgraph "Backend Services"
            EC2 -->|JDBC:3306| RDS[(Amazon RDS / MySQL)]
            EC2 -->|TCP:11211| Cache[(ElastiCache / Memcached)]
            EC2 -->|AMQP:5671| MQ[Amazon MQ / RabbitMQ]
        end
    end
    
    style EC2 fill:#f9f,stroke:#333,stroke-width:2px
    style RDS fill:#ff9,stroke:#333,stroke-width:2px
    style Cache fill:#9f9,stroke:#333,stroke-width:2px
    style MQ fill:#99f,stroke:#333,stroke-width:2px
```
---
## Prerequisites

Ensure the following tools are installed and configured on your local machine before starting the deployment:

* **AWS CLI:** Configured with valid `Access Key ID` and `Secret Access Key` for an IAM user with appropriate permissions.
* **Terraform:** Version 1.0 or later.
* **Java Development Kit (JDK):** Version 11.
* **Apache Maven:** For building the Java artifact.
* **Git:** For version control and cloning the repository.
* **SSH Client:** OpenSSH or similar terminal client.

## Project Structure

This project uses modular Terraform configuration files to manage specific components of the infrastructure:

* **`provider.tf`**: Configures the AWS provider and target region.
* **`variables.tf`**: Defines input variables for resource customization (e.g., AMI IDs, instance types).
* **`terraform.tfvars`**: Stores sensitive variable values (e.g., database passwords). *Note: This file is excluded from version control.*
* **`backend.tf`**: Provisions backend services including Amazon RDS (MySQL), Amazon ElastiCache (Memcached), and Amazon MQ (RabbitMQ).
* **`secgrp.tf`**: Defines Security Groups to control network traffic between the Load Balancer, Application, and Backend layers.
* **`keypair.tf`**: Manages the SSH Key Pair for secure access to EC2 instances.
* **`instance.tf`**: Provisions the EC2 application server and configures the User Data script.
* **`userdata.sh`**: A shell script executed upon instance initialization to install dependencies (Tomcat 9, Java 11) and initialize the database schema.

## Deployment Guide

Follow these steps to deploy the application stack:

### 1. Infrastructure Provisioning
Initialize the Terraform working directory and apply the configuration to create the AWS resources.

```bash
terraform init
terraform validate
terraform apply --auto-approve

**Note:** The creation of the RDS instance may take approximately 10-15 minutes.

### 2. Application Configuration
After the infrastructure is provisioned, retrieve the endpoints for RDS, ElastiCache, and Amazon MQ from the AWS Console. Update the `src/main/resources/application.properties` file with the new hostnames and credentials.

### 3. Build Artifact
Compile the source code and package the application into a WAR file using Maven.

```bash
mvn install

Ensure the build completes with a `BUILD SUCCESS` message.

### 4. Deploy Artifact to Application Server
Transfer the generated artifact to the EC2 instance and deploy it to the Apache Tomcat server.

**Upload the WAR file:**
```bash
scp -i vprofile-key target/vprofile-v2.war ubuntu@<EC2_PUBLIC_IP>:/tmp/

**Deploy script (SSH into the server):**
```bash
ssh -i vprofile-key ubuntu@<EC2_PUBLIC_IP>

# Execute the following commands on the server:
sudo systemctl stop tomcat9
sudo rm -rf /var/lib/tomcat9/webapps/ROOT
sudo rm -rf /var/lib/tomcat9/webapps/ROOT.war
sudo cp /tmp/vprofile-v2.war /var/lib/tomcat9/webapps/ROOT.war
sudo systemctl start tomcat9

### 5. Validation
Open a web browser and navigate to the public IP of the EC2 instance on port 8080 to access the application.
```bash
http://<EC2_PUBLIC_IP>:8080/login
![WhatsApp Image 2025-11-27 at 05 53 31_d67c6bfa](https://github.com/user-attachments/assets/82109a04-3c68-43c5-8840-8d67ac287ee1)
---
# Clean Up
* To prevent incurring unnecessary costs, destroy all provisioned resources once testing is complete.
* Open a web browser and navigate to the public IP of the EC2 instance on port 8080 to access the application.
```bash
terraform destroy --auto-approve
<img width="852" height="394" alt="image" src="https://github.com/user-attachments/assets/e88e9097-73a7-4f5a-8479-d08a29f64b4c" />
----
