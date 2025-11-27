#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git mysql-client -y

# 1. Install Java 11 (زي الفاجرانت بالظبط)
sudo apt-get install openjdk-11-jdk -y

# 2. Install Tomcat 9
sudo apt-get install tomcat9 tomcat9-admin -y

# 3. Setup Tomcat Service (عشان يشتغل كـ Service محترمة)
# (في أوبنتو هو بينزل جاهز كـ Service، مش محتاجين نعمل ملف unit file زي الفاجرانت)

# 4. Clean Default Apps (زي الفاجرانت)
sudo systemctl stop tomcat9
sudo rm -rf /var/lib/tomcat9/webapps/ROOT
sudo rm -rf /var/lib/tomcat9/webapps/ROOT.war

# 5. Download & Deploy Artifact (هنا بنحمل الكود ونبنيه لوكال زي الفاجرانت)
cd /tmp
git clone -b sourcecodeseniorwr https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
# (ملاحظة: بما إننا بنعمل Build على اللابتوب وبنرفعه SCP، الخطوة دي في الـ UserData
# هتكون بس عشان ملف الـ SQL، مش عشان الـ WAR)

# 6. Inject Database (الحقنة)
# الفاجرانت بيستخدم appuser، إحنا هنا هنستخدم admin بتاع RDS
mysql -h ${db_host} -u ${db_user} -p${db_pass} accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

# 7. Start Tomcat
sudo systemctl start tomcat9