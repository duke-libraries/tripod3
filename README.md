tripod3
=======

Digital collections and repository interfaces for Duke University Libraries.

Getting Started with DDR-Public Development
===============

Included in this repository is a Vagrantfile and related shell script for setting up a standard Ubuntu 12.04 LTS 64-bit VM provisioned as a development environment for the [ddr-public project](https://github.com/duke-libraries/ddr-public).

NOTE: You may want to either destroy or rename any previous local copies of the tripod3 repository. This update changes the provisioning of the VM and you will need a new copy. The instructions assume you're starting anew. Also, if you already have the VM running and have started Jetty and/or the rails server you will run into a port collision when following these instructions.

To get started with this VM for developing DDR-Public:

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html)

3. Clone this [tripod3 git repository](https://github.com/duke-libraries/tripod3) to your workstation:

    ```
    $ git clone git@github.com:duke-libraries/tripod3.git
    ```

4. Clone the [ddr-public repository](https://github.com/duke-libraries/ddr-public) in the tripod3/ directory.

    NOTE: I think we will each need to clone our own copy of the ddr-hydra application so that the vagrant setup and our ddr-public development work can be managed separately in git.

    ```
    $ cd tripod
    $ git clone git@github.com:duke-libraries/ddr-public.git
    ```

5. Create your VM using Vagrant (this takes minutes):

    ```
    $ vagrant up
    ```

6. Connect to your Ubuntu VM:

    ```
    $ vagrant ssh
    ```

7. Change to the ddr-public application directory shared between the VM and your computer:

    ```
    $ cd /vagrant/ddr-public
    ```

8. Create a gemset for the project:
    
    ```
    $ rvm gemset create ddr-public
    ```

9. Create .ruby-version and .ruby-gemset setting files by running the following command:
    
    ```
    rvm --ruby-version use 2.1.5@ddr-public
    ```

10. There are a number of sample configuration files you will need to copy and rename for your development environment. In ddr-public/config copy and rename the following files to remove ".sample".

    ```
    log4r.yml.sample
    database.yml.sample
    role_map.yml.sample
    secrets.yml.sample
    jetty.yml.sample
    ```

    For example:
    ```
    $ cp log4r.yml.sample log4r.yml
    ```

11. In addition, you will need a number of configuration files that are not in the respository. I've shared these with you via Box in DDR-Public_Config_Files. They each belong in the following directory.

    ```
    local_env.yml --> /ddr-public/config/local_env.yml
    remote.rb --> /ddr-public/config/environments/remote.rb
    production.rb --> /ddr-public/config/environments/production.rb
    development.rb --> /ddr-public/config/environments/development.rb
    solr.yml --> /ddr-public/config/solr.yml
    fedora.yml --> /ddr-public/config/fedora.yml
    ```

12. Create your secret token by running the following command:

    ```
    rake secret
    ```

13. Copy the generated token from the command line into /ddr-public/config/local_env.yml following "SECRET_KEY_BASE:". It should look something like this:

    ```
    SECRET_KEY_BASE: sdfkljgh809g8fd09g8dfojglf
    ```

14. Install, configure, and start jetty by running the following commands. It will return the prompt to you eventually:

    ```
    $ rake jetty:clean
    $ rake jetty:config
    $ rake jetty:start
    ```

15. Run database migrations:
    
    ```
    $ rake db:migrate
    ```

16. Prepare and run the tests. The tests took about 7 minutes to run.

    ```
    $ rake db:test:prepare
    $ rake spec
    ```
17. Start the rails server.

    ```
    $ rails s
    ```

18. Start and web browser and check that you can access the DDR public interface at http://localhost:3000/. There is no connection to fedora or solr yet so searches will not return any results.


Getting Started with the Dive Into Hydra Tutorial
===============

Included in this repository is a Vagrantfile and related shell script for setting up a standard Ubuntu 12.04 LTS 64-bit VM provisioned to run the [Hydra application](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra).

To set up this VM for running Hydra:

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html)

3. Clone this [tripod3 git repository](https://github.com/duke-libraries/tripod3) to your workstation:

    ```
    $ git clone git@github.com:duke-libraries/tripod3.git
    ````

4. Create your VM using Vagrant (this takes minutes):

    ```
    $ cd tripod3
    $ vagrant up
    ```

5. Connect to your newly minted Ubuntu VM:

    ```
    $ vagrant ssh
    ```

6. Change to the hydra application directory shared between the VM and your computer:

    ```
    $ cd /vagrant/hydra-tripod3
    ```

7. Run bundler to install gem dependencies (this takes minutes):

    ```
    $ bundle install
    ```

8. Run database migrations:

    ```
    $ rake db:migrate
    ```

9. Setup Jetty locally (in the VM). Jetty is not included in the repository:

    ```
    $ rails g hydra:jetty
    ```

10. Start Jetty:

    ```
    $ rake jetty:start
    ```

11. Start the rails server:

    ```
    $ rails s
    ```

12. In your browser check to see that Hydra/Blacklight ([http://127.0.0.1:3000](http://127.0.0.1:3000)) and Solr ([http://127.0.0.1:8983/solr/](http://127.0.0.1:8983/solr/)) are running.

If you get an error when trying to connect to Solr it may be that Solr is still in the process of starting. Give it a minute or two and try again.

If there's still nothing happening on ports 3000 and/or 8983 check to make sure Vagrant hasn't changed the port assignments to avoid a collision. Check the output from the command "Vagrant up." For example:

```
==> default: Fixed port collision for 3000 => 3000. Now on port 2200.
==> default: Fixed port collision for 8983 => 8983. Now on port 2201.
```

For more information about using Vagrant see the [Getting Started](https://docs.vagrantup.com/v2/getting-started/) documentation, particularly the sections on [Teardown](https://docs.vagrantup.com/v2/getting-started/teardown.html) and [Rebuild](https://docs.vagrantup.com/v2/getting-started/rebuild.html).

