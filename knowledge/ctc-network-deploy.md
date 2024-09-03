# Network Deployment

This Repository has several types of network deployment type.

## BGP

### deploy

This Network build with BGP protocol.
The Terraform files is placed in BGP-sample directory.

When you deploy BGP-sample network via Terraform/CML,
You can use http://TerraformAPI/terraform/ with following body

{
    "operation" : "apply",
    "network_type" : "BGP-sample",
    "options:{
        "auto-approve": true
    }
}

### destroy

When you destroy,
You can use http://TerraformAPI/terraform/ with following body

{
  "operation": "apply",
  "network_type": "BGP-sample",
  "options": {"auto-approve":true,"destroy":true}
}

## OSPF

This Network build with OSPF protocol.
The Terraform files is placed in OSPF-sample directory.


## Static

This Network build with Static route.
The Terraform files is placed in Static-sample directory.

# Network Configuration

## BGP

When you want to configure BGP for BGP topology in CML

You can use http://NSO:8080/restconf/data with following header and body

Steps:

- Call cic-l3 L3 configuration
- Call cic-bgp bgp configuration

You have to configure cic-l3 configuration before cic-bgp, don't forget this steps.

### Deploy L3 configuration with cic-l3

POST http://admin:admin@localhost:8080/restconf/data/
Content-Type: application/yang-data+json
Accept: application/yang-data+json

{
    "cic-l3:cic-l3":{
            "name": "foo",
            "device1": "R1",
            "device2": "R2",
            "device3": "R3",
            "ipv4-address-loopback-dev1": "1.1.1.1",
            "ipv4-address-loopback-dev2": "2.2.2.2",
            "ipv4-address-loopback-dev3": "3.3.3.3"
    }
}

### Deploy BGP configuration with cic-bgp

cic-l3 service should be deployed before you use this API

POST http://admin:admin@localhost:8080/restconf/data/
Content-Type: application/yang-data+json
Accept: application/yang-data+json

{
  "cic-bgp:cic-bgp": [
    {
      "name": "bar",
      "device1": "R1",
      "device2": "R2",
      "device3": "R3",
      "asn-dev1": 65001,
      "asn-dev2": 65002,
      "asn-dev3": 65003,
      "adv-route-dev1": "192.168.10.0",
      "adv-mask-dev1": "255.255.255.0",
      "adv-route-dev2": "192.168.20.0",
      "adv-mask-dev2": "255.255.255.0",
      "adv-route-dev3": "192.168.30.0",
      "adv-mask-dev3": "255.255.255.0"
    }
  ]
}