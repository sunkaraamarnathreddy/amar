# litc-chef-agent Cookbook
This Cookbook manages the chef-agent configuration

### Platforms
- RHEL
- SUSE
- Windows

### Chef
- Chef 11.18.12 or later

## Attributes List
---------------------------------------

| Attribute Name| Description   | Value |
|:--------------|:--------------|:------|
|['litc-chef-agent']['random_delay']| The random delay (in seconds) between chef agent execution and chef-client execution | 1200 |
|['litc-chef-agent']['splunk_url'] | The Splunk event collector URL use for reporting. | https://10.76.63.32:8088/services/collector/event |

## Recipes list
### litc-chef-agent::splunk_handler
#### Description
This recipe create a Chef-Handler that will report execution status to Splunk.

#### Usage
e.g.
Just include `litc-chef-agent::splunk_handler` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[litc-chef-agent::splunk_handler]"
  ]
}
```

### litc-chef-agent::deploy_agent
#### Description
This recipe create a file agent.rb inside the Chef local folder and enable cronjob / schedule task on the target
instance to run Chef-Client on a regular basis.

#### Usage
e.g.
Just include `litc-chef-agent::deploy_agent` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[litc-chef-agent::deploy_agent]"
  ]
}
```
### litc-chef-agent::add_gemrc_windows
#### Description
This recipe add a gemrc file inside ProgramData folder on Windows system. This is usefull to avoid gem installation
issue during Chef-Client run if the node doesn't have internet access or proxy settings correctly configured.

#### Usage
e.g.
Just include `litc-chef-agent::add_gemrc_windows` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[litc-chef-agent::deploy_agent]"
  ]
}
```

## Contributing
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Support
-------------------
Use the following IT Direct categories:

[IMIS_DEVOPS](https://itdirect.wdf.sap.corp/sap(bD1lbiZjPTAwMSZkPW1pbg==)/bc/bsp/sap/crm_ui_start/default.htm?saprole=ZITSERVREQU&crm-object-type=AIC_OB_INCIDENT&crm-object-action=D&PROCESS_TYPE=ZINE&CAT_ID=IMIS_DEVOPS) for issues\incidents
<br>
[SRIS_DEVOPS](https://itdirect.wdf.sap.corp/sap(bD1lbiZjPTAwMSZkPW1pbg==)/bc/bsp/sap/crm_ui_start/default.htm?saprole=ZITSERVREQU&crm-object-type=AIC_OB_INCIDENT&crm-object-action=D&PROCESS_TYPE=ZINE&CAT_ID=SRIS_DEVOPS) for feature\service requests

## Authors
Authors: Emmanuel Iturbide: e.iturbide@sap.com
