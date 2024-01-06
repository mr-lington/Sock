# SOCK-SHOP<br>
This project is a deployment with kubernetes. this is a Sock-shop

## JENKINS<br>
Jenkins is the first will be applied first as a stand alone, then jenkins will be deploy other infrastructure<br>

<img width="1162" alt="Screenshot 2024-01-01 at 20 42 04" src="https://github.com/mr-lington/Sock/assets/99319094/10816ba1-1cf0-42aa-95f3-a17645d6a9f1"><br>

Cat path to get the default password<br>
<img width="597" alt="Screenshot 2024-01-01 at 20 55 26" src="https://github.com/mr-lington/Sock/assets/99319094/3b8fe947-e3a6-4ee3-b265-09ebaf6a8c64"><br>

### Install suggested plugin<br>
<img width="1093" alt="Screenshot 2024-01-01 at 20 57 26" src="https://github.com/mr-lington/Sock/assets/99319094/e2095df5-17cc-48ab-be5b-2ced4db59565"><br>
Choose change your password and username<br>

Install the plugin needed for the project<br>
1. aws credential<br>
2. terraform<br>
3. ssh agent<br>
4. slack<br>

### Configure Credentials<br>
<img width="1163" alt="Screenshot 2024-01-01 at 21 58 59" src="https://github.com/mr-lington/Sock/assets/99319094/4e275ba1-182d-4a6f-b595-8b6dd468e18a"><br>

### Configure Tools<br>
<img width="1155" alt="Screenshot 2024-01-01 at 22 04 29" src="https://github.com/mr-lington/Sock/assets/99319094/f02b4419-06ba-40b5-a4b4-ae26a1fd42f4"><br>

## Create pipeline to deploy the infrastructure<br>
1. Use parameterised<br>
2. select choice parameter(add apply and destroy)<br>
<img width="1044" alt="Screenshot 2024-01-01 at 22 16 14" src="https://github.com/mr-lington/Sock/assets/99319094/ee598a95-29e1-4ef3-bdc9-96843d8a6be8"><br>

3. create the pipeline using script from SCM<br>
<img width="1038" alt="Screenshot 2024-01-01 at 22 22 41" src="https://github.com/mr-lington/Sock/assets/99319094/77a7015e-fed7-4123-bf40-4a7d815cb136"><br>

4. Build the pipeline with parameter.<br>
<img width="1033" alt="Screenshot 2024-01-01 at 22 25 22" src="https://github.com/mr-lington/Sock/assets/99319094/10eb7834-49f2-4a26-ae5e-d3a77628560e"><br>

<img width="1425" alt="Screenshot 2024-01-01 at 22 31 24" src="https://github.com/mr-lington/Sock/assets/99319094/9bb9bf00-78a5-4aae-ac13-68e32e367279"><br>

<img width="1195" alt="Screenshot 2024-01-01 at 22 32 45" src="https://github.com/mr-lington/Sock/assets/99319094/ca267df3-37e7-432e-812f-0d4311103e99"><br>

<img width="864" alt="Screenshot 2024-01-01 at 22 43 08" src="https://github.com/mr-lington/Sock/assets/99319094/5638cb92-1d08-437c-be3e-077a8039d22b"><br>

## Accessing other infrastructure
1. you have to enter the commmand sudo su in the jenkins to switch to root user then<br>
<img width="848" alt="Screenshot 2024-01-01 at 23 23 29" src="https://github.com/mr-lington/Sock/assets/99319094/8f00059b-3dae-4f63-94da-25827be646ce"><br>

2. ssh into ansible
<img width="838" alt="Screenshot 2024-01-01 at 23 26 08" src="https://github.com/mr-lington/Sock/assets/99319094/1273676d-c8b7-4761-bc22-61f6d5754d7d"><br>
<img width="831" alt="Screenshot 2024-01-01 at 23 27 04" src="https://github.com/mr-lington/Sock/assets/99319094/fa95be06-c1cb-4031-a81a-6532815f0b3a"><br>

3. check for ansible host inventory file<br>
<img width="1008" alt="Screenshot 2024-01-01 at 23 38 27" src="https://github.com/mr-lington/Sock/assets/99319094/c1892492-118b-4189-8c44-eecce99eff45"><br>

## Accessing application with domains<br>
You can now access the stage and production with the domain names<br>
stage.example.com<br>
prod.example.com<br>
<img width="1045" alt="Screenshot 2024-01-06 at 15 04 53" src="https://github.com/mr-lington/Sock/assets/99319094/fe525236-0d80-4596-9d14-7650ca315808"><br>

## Accessing monitoring application with domains<br>
enter usename: admin<br>
enter password: prom-operator<br>

import dashboard for name spaces<br>

<img width="1725" alt="Screenshot 2024-01-06 at 15 37 40" src="https://github.com/mr-lington/Sock/assets/99319094/edc0471a-8551-4185-adf6-d76de140c112"><br>

<img width="1728" alt="Screenshot 2024-01-06 at 15 38 30" src="https://github.com/mr-lington/Sock/assets/99319094/bfd5474b-a154-46a4-bf83-b5759f47d581"><br>


<img width="1728" alt="Screenshot 2024-01-06 at 15 44 55" src="https://github.com/mr-lington/Sock/assets/99319094/5f5f1d13-0c1d-4384-aaea-4a8395894db1"><br>


<img width="1724" alt="Screenshot 2024-01-06 at 15 46 08" src="https://github.com/mr-lington/Sock/assets/99319094/155af463-efef-4a8f-95db-2bd827d24963"><br>

## Now we will set up the Second pipeline for continous integration<br>
1. Configure credential for ansible<br>
<img width="1055" alt="Screenshot 2024-01-06 at 17 05 34" src="https://github.com/mr-lington/Sock/assets/99319094/c40afd00-a815-4518-b51b-f9b48f0a66cc"><br>

2. Configure GitHub hook trigger for gitScm polling<br>
<img width="1050" alt="Screenshot 2024-01-06 at 17 10 17" src="https://github.com/mr-lington/Sock/assets/99319094/25a35c38-ae90-4a15-9876-6195851bd991"><br>
<img width="1045" alt="Screenshot 2024-01-06 at 17 11 10" src="https://github.com/mr-lington/Sock/assets/99319094/46b41e3e-3e45-4a21-a274-f455130c008f"><br>

3. Configure the webhook in github<br>

<img width="1085" alt="Screenshot 2024-01-06 at 17 22 05" src="https://github.com/mr-lington/Sock/assets/99319094/534332b5-8a8f-44c4-8025-465f8d7d7686"><br>
<img width="1087" alt="Screenshot 2024-01-06 at 17 31 23" src="https://github.com/mr-lington/Sock/assets/99319094/5935fd7f-3100-4463-a78b-f1172d519488"><br>

4. Configure Slack Notification<br>
click add app && click on configure<br>
<img width="790" alt="Screenshot 2024-01-06 at 17 43 48" src="https://github.com/mr-lington/Sock/assets/99319094/c3d81942-d669-4902-92a9-e2a095f921ad"><br>

click on Add Slack<br>
<img width="1046" alt="Screenshot 2024-01-06 at 17 44 58" src="https://github.com/mr-lington/Sock/assets/99319094/d08923c5-972f-46e2-b808-690d8cfd6a3a"><br>

choose a channel && Add Jenkins Cl integration<br>
<img width="1049" alt="Screenshot 2024-01-06 at 17 47 36" src="https://github.com/mr-lington/Sock/assets/99319094/18198a3a-213f-4495-b339-148be382f494"><br>

copy token generated and used it to create a credential for slack<br>
<img width="998" alt="Screenshot 2024-01-06 at 17 49 42" src="https://github.com/mr-lington/Sock/assets/99319094/e15f3bd7-7290-457b-9b5d-3f93add0ac67"><br>

configure system for slack<br>
<img width="927" alt="Screenshot 2024-01-06 at 18 04 25" src="https://github.com/mr-lington/Sock/assets/99319094/94beda6b-c5f7-4ef0-85e1-d63f5f973d59"><br>

update the front-end of stage and production<br>

<img width="1047" alt="Screenshot 2024-01-06 at 18 25 27" src="https://github.com/mr-lington/Sock/assets/99319094/44baf492-92a1-4610-bbce-1d4ead8b6934"><br>

