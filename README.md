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
