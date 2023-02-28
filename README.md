# Fasttel-Elan-Driver

### Introduction
**[Fasttel](https://www.fasttel.com/en/)** is a is a brand of IP-based intercoms with a sleek and unique design. For 30 years, Fasttel has been a leader in the development of parlophony systems that are all integrated into the customer’s telephony network. Design, technology and ease of use is in our DNA.  Fasttel is located in Lokeren – Belgium (head office) and Moergestel (head office in the Netherlands). We develop and manufacture all our products ourselves, and also offer local support to our customers.

**[Elan](https://elancontrolsystems.com/)** is a home automation platform with an integration API. ELAN is the industry leader in smart home & business technology solutions. Integration of Fasttel intercoms via SIP-based communication is done via the intercom internal settings, and thus will not be outlined in this repository. The aim of this driver is to integrate Akuovox's relay control to Elan via the Elan driver development API. 

### How to Integrate
* Download the **Fasttel_Relay_Control.EDRVC** file from this repository.
* In the Elan configurator, navigate to the Input/Output tab.
* Right + Click **Relay Outputs** and **Add New Output Controller**.
* In the list as shown below, click on the **Search Folder** button, navigate to the folder where the file was downloaded, then press ok.

![image](https://user-images.githubusercontent.com/50086268/221861027-ed9a34ac-1a15-4f8f-b6ad-180727674bb4.png)

* Highlight the Fasttel Relay Control, then press OK.
* Add the intercom's IP address.
* Add the inercom's relay admin and password if added.

![image](https://user-images.githubusercontent.com/50086268/221861389-85594757-36de-4606-b59b-295d88468993.png)

* You'd be able to tell if connection was successful if the intercom Model, MAC address and Firmware version populate automatically in their respective fields.

### Disclaimer
This is an unsupported driver which I wrote in my spare time. Neither Elan nor Indigo Distribution (Premium Elan Distributor in the UK and Ireland) hold any responsibilty or offer any support for the use of this driver in your Elan systems. By adding this driver you accept all risks associated with introducing a hastily written driver to your controller software; you do this at YOUR OWN RISK. And as ever: **ALWAYS BACKUP YOUR SYSTEM**
