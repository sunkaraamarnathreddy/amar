name             'litc-chef-agent'
maintainer       'Emmanuel Iturbide'
maintainer_email 'e.iturbide@sap.com'
license          'All rights reserved'
description      'Launch and configure chef agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.12'

depends 'windows', '< 2.0.0'
depends 'chef_handler', '<= 2.1.0'

supports 'windows'
supports 'linux'

issues_url 'https://github.wdf.sap.corp/LIT-DEVOPS/litc-chef-agent/issues' if respond_to?(:issues_url)
source_url 'https://github.wdf.sap.corp/LIT-DEVOPS/litc-chef-agent' if respond_to?(:source_url)
