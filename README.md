# Background

I'm trying to create use cases to show the needed settings for getting Application gateway and Keyvault together with Managed Identity and Keyvault RBAC. I want to generate a new (self signed) cert in Keyvault, using Keyvault, and use it in Appgw for HTTPS (yes, well aware that a self signed cert will give me a warning in the browser).

It's been a bumpy ride, since any misconfiguration of these parameters seems to just end up with an InternalServerError with no further explanation. Another comlication is that sometimes I apply settings to Keyvault, and it needs 30-60 seconds to actually work after Azure + Terraform says it's done. Role assignment is the most obvious one. This means that sometimes just re-running terraform apply without changing anything will work even if the first apply failed. (adding a sleep should solve this)

## Test cases

| **Settings**      | **Works** |
| ----------- | ----------- |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw public IP + Service endpoints      | Yes       |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw public IP and Appgw Subnet + Service endpoints      | Yes       |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw Subnet + Service endpoints      | Yes       |
| Trusted Services + KV Soft delete 7 days + FW allow Appgw public IP + Service endpoints   | No        |
| Trusted Services + KV Soft delete 90 days + FW allow Appgw public IP | Yes |
| KV Soft delete 90 days + FW allow Appgw public IP | No |
| KV Soft delete 90 days + FW allow Appgw public IP + Service endpoint | No |
| Trusted Services + KV Soft delete 90 days + Service endpoints | No |


### Error messages

Appgw has not been giving me the most clear error messages (like I wrote in the background). An example could look like this:

```
Error: waiting for create/update of Application Gateway: (Name "appgw" / Resource Group "keyvault-demo"): Code="InternalServerError" Message="An error occurred." Details=[]
```