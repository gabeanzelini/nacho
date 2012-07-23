#Nacho
##Description
Nacho is a status bar app that displays the status of [nagios](http://www.nagios.org/) hosts via [nagios-api](https://github.com/xb95/nagios-api/).

##Setup
Go get https://github.com/xb95/nagios-api/[nagios-api](http://github.com/xb95/nagios-api/) and install it.

###Download
- Download [nacho.zip](https://github.com/downloads/gabeanzelini/nacho/nacho.zip)
- Unzip (if Safari didn't do it for you)
- Drag to /Applications
- Run it
- Click on the status bar icon and go to preferences and point it to your server/port

###Build from source
- Clone the repo
- Open in Xcode 4.3.3
- Build


##Usage
Nacho will pull the server every 30 seconds. It then provides a list of hosts in the dropdown menu. You can select any of these to go to the webpage on the nagios server with more details. If the status of the host is not "0" (meaning "OK") then it the status bar icon will be red and you will have a red dot next to the down host. If nacho cannot connect to the server for some reason, the icon will go yellow.

##Troubleshooting
- Go to preferences
- Verify that the url is in the pattern "http://nagios"
- Verify the port is correct
- You can test them by going to the Terminal and typing in curl HOST:PORT (ie curl http://nagios:8080)
    - If you get a bunch of json data, the app should work. If it doesn't file a bug.
    - If you don't get a bunch of json data, fix the url, port, and/or your nagios-api install.
