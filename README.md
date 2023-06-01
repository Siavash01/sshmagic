# sshmagic

A useragent to perform ssh tunnel to given server

## Getting Started

To use this, you need to install: sshuttle, sshpass <br />
After installing the dependencies run below command and put the result in /etc/sudoers.d/sshuttle_auto <br />

command:
  sshuttle --sudoers-no-modify <br />

Warning:
  The tunnel would still be running if you don't click on the stop button.
  Please make sure to click the stop button before closing the application.
  If the application is closed, but stop button hasn't been clicked on, you should kill the sshuttle process in your task manager.