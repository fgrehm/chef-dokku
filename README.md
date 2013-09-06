# chef-dokku

Manages a [dokku](https://github.com/progrium/dokku) installation, allowing
configuration of application's [environment variables](https://github.com/progrium/dokku#environment-setup)
and installation of [plugins](https://github.com/progrium/dokku/wiki/Plugins).


## Attributes

These attributes are under the `node['dokku']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
stack_url | STACK_URL environment variable passed on to Dokku's bootstrap.sh | String | nil (meaning it will be whatever is configured on Dokku's [Makefile](https://github.com/progrium/dokku/blob/master/Makefile#L4))
domain | Domain name to write to `/home/git/VHOST` | String | nil (meaning it will be [auto detected](https://github.com/progrium/dokku#configuring))
plugins | Plugins to install | Hash with plugin name as key and GitHub repository URL as value | nil

### Applications Attributes

These attributes are under the `node['dokku']['apps']['YOUR_APP_NAME']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
env | Application's [environment variables](https://github.com/progrium/dokku#environment-setup) | Hash | nil


## Recipes

* `recipe[dokku]` Installs/Configures Dokku


## Usage

### Default Installation

* Add `recipe[dokku]` to your node's run list

After Dokku gets configured, you'll need to upload your SSH key with something
like:

```
$ cat ~/.ssh/id_rsa.pub | ssh your-server.com "sudo gitreceive upload-key some-dokku-user"
```


## Testing and Development

### Vagrant

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/).

    vagrant plugin install vagrant-omnibus
    git clone git://github.com/fgrehm/chef-dokku.git
    cd chef-dokku
    vagrant up

You can then SSH into the running VM using the `vagrant ssh` command.

The VM can easily be stopped and deleted with the `vagrant destroy` command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html) for a more in depth explanation of available commands.


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
