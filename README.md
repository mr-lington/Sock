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
3. check for ansible host inventory file

<img width="1008" alt="Screenshot 2024-01-01 at 23 38 27" src="https://github.com/mr-lington/Sock/assets/99319094/c1892492-118b-4189-8c44-eecce99eff45">
