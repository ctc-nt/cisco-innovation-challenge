# Operation procedure in CTC network


## New Deployment

Use terraform to create Network VMs on CML if you would like to deploy new network.



## Bypass Route

Perform the following operations when you need to bypass route.

In order to bypass route, first, you need to shutdown unstable link.
The command to shutdown depends on the software type of device. 


The IOS case:

```
configure terminal
interface X
shutdown
```

The IOS XR case:

```
configure
interface X
shutdown
commit
```

