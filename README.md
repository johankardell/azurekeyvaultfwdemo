**Background**

I'm trying to create use cases to show the needed settings for getting Application gateway and Keyvault together with Managed Identity and Keyvault RBAC. I want to generate a new (self signed) cert in Keyvault, using Keyvault, and use it in Appgw.

It's been a bumpy ride, since any misconfiguration of these parameters seems to just end up with an InternalServerError with no further explanation.

| Settings      | Works |
| ----------- | ----------- |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw public IP + Service endpoints      | Yes       |
| Trusted Services + KV Soft delete 7 days + FW allow Appgw public IP + Service endpoints   | No        |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw public IP | Yes |
| KV Soft delete 90 days + FW allow Appgw public IP | No |
| KV Soft delete 90 days + FW allow Appgw public IP + Service endpoint | No |
| Trusted Services + KV Soft delete 90 days + Service endpoints | No |