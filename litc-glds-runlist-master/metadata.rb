name             'litc-glds-runlist'
maintainer       'Martin Schygulla'
maintainer_email 'martin.schygulla@sap.com'
license          'All rights reserved'
description      'Manage Run-Lists'
version '0.1.13'

source_url 'https://github.wdf.sap.corp/LIT-DEVOPS/litc-glds-runlist' if respond_to?(:source_url)
issues_url 'https://github.wdf.sap.corp/LIT-DEVOPS/litc-glds-runlist/issues' if respond_to?(:issues_url)

supports 'suse'
supports 'redhat'
supports 'windows'

depends 'glds-inventory'
depends 'litc-glds-ntp'
depends 'litc-glds-dnssuffix'
depends 'litc-glds-rsh'
depends 'litc-glds-bginfo'
depends 'litc-mmci'
depends 'litc-glds-motd'
depends 'litc-glds-osconfig-files'
depends 'litc-chef-agent'
depends 'litc-base-line-hardening'
depends 'litc-glds-findsid'
depends 'litc-mmci-winrm-service'
