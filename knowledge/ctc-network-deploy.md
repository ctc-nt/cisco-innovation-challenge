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
