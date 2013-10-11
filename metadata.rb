name             'dokku'
maintainer       'Fabio Rehm'
maintainer_email 'fgrehm@gmail.com'
license          'MIT'
description      'Installs/Configures dokku'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

supports 'ubuntu', '= 13.04'

%w{apt git build-essential nginx docker user}.each do |dep|
  depends dep
end
