# sshmagic

A useragent to perform ssh tunnel to given server

## Getting Started

To user this, you need to install: sshuttle, sshpass
after installing the dependencies run below command and put the result in /etc/sudoers.d/sshuttle_auto

command:
  sshuttle --sudoers-no-modify

Warning:
  The tunnel is still running if you don't click stop button but close the application.
  Please make sure to stop the tunnel before you close the application.
  If you closed the application but did click the stop button, kill the sshuttle process in your task manager.