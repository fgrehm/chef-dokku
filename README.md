# chef-dokku

Manages a [dokku](https://github.com/progrium/dokku) installation, allowing
configuration of application's [environment variables](https://github.com/progrium/dokku#environment-setup),
installation of [plugins](https://github.com/progrium/dokku/wiki/Plugins) and
management of ssh keys.

## Usage

Include the `bootstrap` recipe in your run list to have dokku installed/updated
during chef runs.

## Attributes

These attributes are under the `node['dokku']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
root | dokku's home directory | String | `/home/dokku`
domain | Domain name to write to `['dokku']['root]'/VHOST` | String | nil (`node['fqdn']` will be used)
ssh_keys | SSH keys that can push to dokku | Hash | `{}` see [SSH Keys](https://github.com/fgrehm/chef-dokku#ssh-keys)
plugins | Plugins to install | Hash with plugin name as key and GitHub repository URL as value | `{}` see [Plugins](https://github.com/fgrehm/chef-dokku#plugins)
plugin_path | Directory where plugins are installed | String | `/var/lib/dokku/plugins`
apps | App environment settings to populate | Hash | `{}` see [Apps](https://github.com/fgrehm/chef-dokku#apps)
git_repository | The git repository for the base dokku code | String | https://github.com/progrium/dokku.git
git_revision | The git revision to check out from `git_repository` | String | v0.2.0

## Configuration

While this cookbook will be able to provide you with a working dokku installation,
there is some configuration you will likely want to do first:

### SSH Keys

This is a required step to getting dokku working. You will want to set
`node['dokku']['ssh_keys']` to a hash of the following structure:

    default['dokku']['ssh_keys'] = {
      'awesome_user' => 'awesome_users_pubkey',
      'superb_user' => 'superb_users_pubkey'
    }

The [`ssh_keys`](https://github.com/fgrehm/chef-dokku#recipes) recipe will handle
setting up the keys for dokku

### Apps

Pre-configured applications. These attributes are used to configure environment
variables or remove an app:

    default['dokku']['apps'] = {
      'cool_app' => {
        'env' => {
          'ENV_VAR' => 'ENV_VAR_VALUE',
          'ENV_VAR2' => 'ENV_VAR2_VALUE'
        }
      }
    }

### Plugins

You will likely want to install plugins to expand the functionality of your
dokku installation. See the dokku [wiki page](https://github.com/progrium/dokku/wiki/Plugins)
for a list of available plugins.

Plugins are defined on the `node['dokku']['plugins']` attribute:

    default['dokku']['plugins'] = {
      'plugin_name' => 'plugin_repository_url',
      # For example:
      'postgresql' => 'https://github.com/Kloadut/dokku-pg-plugin'
    }

### Applications Attributes

These attributes are under the `node['dokku']['apps']['YOUR_APP_NAME']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
env | Application's [environment variables](https://github.com/progrium/dokku#environment-setup) | Hash | nil
remove | Whether the application should be removed | Boolean | nil

### Sync attributes

These attributes are under the `node['dokku']['sync']` namespace. They control
whether remote code bases will be updated on chef runs

Attribute | Description | Type | Default
----------|-------------|------|--------
base | Whether the dokku codebase will be synced with the remote repository | Boolean | true
plugins | Whether the dokku plugins will be synced with their remote repositories | Boolean | true
dependencies | Whether the sshcommand and pluginhook dependencies will be updated from their remotes | Boolean | true

### Build Stack attributes

These attributes are under the `node['dokku']['buildstack']` namespace. They
correspond to the [buildstep](https://github.com/progrium/buildstep) that is
used by dokku.

Attribute | Description | Type | Default
----------|-------------|------|--------
image_name | The name of the image to use when importing into Docker | String | progrium/buildstep
use_prebuilt | Whether to use the prebuilt image or build off the git repository | Boolean | true
stack_url | The url to the buildstep git repository | String | github.com/progrium/buildstep
prebuilt_url | The url to the prebuild docker image for the buildstep | String | https://s3.amazonaws.com/progrium-dokku/progrium_buildstep_79cf6805cf.tgz

### PluginHook Attributes

These attributes are under the `node['dokku']['pluginhook']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
src_url | The source url for the pluginhook .deb file | String | https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb
filename | The pluginhook .deb file name | String | pluginhook_0.1.0_amd64.deb
checksum | The SHA-256 checksum for the pluginhook .deb file | String | 26a790070ee0c34fd4c53b24aabeb92778faed4004110c480c13b48608545fe5

## Recipes

* `recipe[dokku]` - Noop. Will be used to include LWRPs in the future
* `recipe[dokku::bootstrap]` - A chef version of [`bootstrap.sh`](https://github.com/progrium/dokku/blob/master/bootstrap.sh).
   Include this recipe to have dokku installed/updated by chef
* `recipe[dokku::install]` - Clones/checks out the dokku git repository and
   copies the required files via `make copyfiles`
* `recipe[dokku::buildstack]` - Builds/imports the dokku [buildstep](https://github.com/progrium/buildstep) docker image. See
  `node['dokku']['buildstack']['use_prebuilt']` to set which buildstep is imported

## Testing and Development

### Vagrant

Here's how you can quickly get testing or developing against the cookbook thanks
to [Vagrant](http://vagrantup.com/).

    vagrant plugin install vagrant-omnibus
    git clone git://github.com/fgrehm/chef-dokku.git
    cd chef-dokku
    bundle install
    bundle exec berks install -p vendor/cookbooks
    vagrant up

You can then SSH into the running VM using the `vagrant ssh` command.

The VM can easily be stopped and deleted with the `vagrant destroy` command.
Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html)
for a more in depth explanation of available commands.

## Roadmap

* Convert things like ssh keys, app env, etc to LWPRs w/ Chefspec v3 matchers
* Reduce rewritten/overridden areas of the bootstrap process to better keep up
  with dokku's rapid development
* Plugin removal
* Use dokku app removal process
* Support dokku [addons](https://github.com/progrium/dokku/pull/292)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgrehm/chef-dokku/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
