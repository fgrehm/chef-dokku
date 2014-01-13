name             'dokku'
maintainer       'Fabio Rehm'
maintainer_email 'fgrehm@gmail.com'
license          'MIT'
description      'Installs/Configures dokku'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

supports 'ubuntu', '= 13.04'

%w{apt git build-essential user sudo}.each do |dep|
  depends dep
end

depends 'nginx', '~> 2.2.0'
depends 'docker', '~> 0.24.2'
