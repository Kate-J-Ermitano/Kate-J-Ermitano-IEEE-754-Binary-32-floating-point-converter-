# IEEE-754-Binary-32-floating-point-converter
<b>Link: http://localhost:3000/floating-point-converter/</b> <br>
Simulation Project for CSARCH2

<b>DOWNLOADING APACHE TOMCAT SERVER:</b><br>
1.) Download Apache Tomcat Server Version 9 (https://tomcat.apache.org/download-90.cgi).<br>
2.) Download Apache Tomcat 32-bit/64-bit Windows Service Installer (https://tomcat.apache.org/download-90.cgi).<br>
![image](https://user-images.githubusercontent.com/80894347/232778122-fd27eabb-a106-4c4f-8328-294293e4ddab.png)<br>
3.) Install the Apache Tomcat exe file. Upon set-up, in Choose Components, tick the 'Host Manager' and 'Examples' items.<br>
![image](https://user-images.githubusercontent.com/80894347/232778362-356f16c6-6305-4fc8-914d-96a1d378fb9c.png)<br>
4.) Set HTTP/1.1 Connector Port to <b>3000</b>.<br>
![image](https://user-images.githubusercontent.com/80894347/232778424-13d5de67-de4a-44da-88ce-f76598a42a8f.png)<br>
5.) <b>Do not run</b> Apache Tomcat yet.

<b>DOWNLOADING THE APPLICATION</b>
1.) Download the <i>floating-point-converter.war</i> file from the repository.<br>
![image](https://user-images.githubusercontent.com/80894347/232778560-fdac6180-3b1f-4e50-a417-5064f046ba86.png)<br>
2.) Locate the <i>apache-tomcat-9.0.73-windows-x64</i> folder then go to the<i>webapps</i> folder.<br>
3.) Move the <i>floating-point-converter.war</i> file to the <i>webapps</i> folder.<br>
![image](https://user-images.githubusercontent.com/80894347/232780629-1fb502ac-3a6a-49bb-9899-d759609d3189.png)<br>
6.) Open <i>Run</i> and enter services.msc or simply search services in the start menu.<br>
7.) In Services, locate the Apache Tomcat 9.0 Tomcat9 service and then right click and select <i>Start</i>.<br>
![image](https://user-images.githubusercontent.com/80894347/232778837-7f3ca2e1-d310-4178-8b6f-142cf3d69cae.png)<br>
8.) Once the service is running, open http://localhost:3000/floating-point-converter/.<br>

<b>CLOSING THE CONVERTER AND TOMCAT SERVER:</b><br>
1.) Close the web page.<br>
2.) To shutdown the Apache Tomcat service, go to Run and enter services.msc or simply search services in the start menu.<br>
3.) In Services, locate the Apache Tomcat 9.0 Tomcat9 service and then right click and select <i>Stop</i>.<br>
