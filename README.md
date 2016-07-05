# Overview

This repository contains the Vagrant setup files to create a Ubuntu VM
running the clouddata services as described on the dustcloud blog post,
Building clouddata.dustcloud.org.

https://dustcloud.atlassian.net/wiki/display/ALLDOC/2016/06/02/Building+clouddata.dustcloud.org

The Vagrant VM is published to Vagrant Cloud.

https://atlas.hashicorp.com/dbacher-linear/boxes/dust-clouddata

The Vagrant definition automates much of the package installation and
configuration.

There are several steps that are not automated:

- setting the hostname
- grafana configuartion
  - configure the influxdb data source
  - create the dashboard
  - enable anonymous access
- configuring the local firewall


# Common operations

Bring up the VM:

$ vagrant up

Stop a running VM:

$ vagrant halt

Create a package from the current VM:

$ vagrant package --output clouddata.box
