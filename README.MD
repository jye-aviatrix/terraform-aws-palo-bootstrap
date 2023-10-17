

# Interface configuration
- Assign eth1/2 as 'Layer3' interface type. Enable eth1/2 as 'DHCP client', and uncheck 'Automatically create default route pointing to default gateway provided by server'
![](2023-10-17-10-11-42.png)
- Assign eth1/2 to Virtual Router 'default'. Create new security zone 'LAN' and assign eth1/2 as LAN
![](2023-10-17-10-55-19.png)
- Assign eth1/1 as 'Layer3' interface type. Enable eth1/1 as 'DHCP client,
![](2023-10-17-10-13-29.png)
- Assign eth1/1 to Virtual Router 'default'. Create new security zone 'WAN' and assign eth1/1 as WAN
![](2023-10-17-10-54-14.png)
- Create policy to allow LAN to LAN any traffic
![](2023-10-17-10-45-17.png)
- Create policy to allow LAN to WAN any traffic
![](2023-10-17-10-46-36.png)
- Create policy for catch all rest of traffic and deny it
![](2023-10-17-10-47-47.png)
- All policies and it's order
![](2023-10-17-10-48-20.png)
- Create source NAT route for LAN -> WAN traffic to be SNAT to eth1/1 IP
![](2023-10-17-10-49-56.png)
- Create Interface Mgmt profile for ICMP ping health check coming from Aviatrix Transit Gateway
![](2023-10-17-12-01-01.png)
- Assign this health check Interface Mgmt profile with eth1/2
![](2023-10-17-12-02-11.png)

# providers.tf
You will need to populate providers.tf, example
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
```

