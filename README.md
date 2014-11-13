tripod3
=======

Digital collections and repository interfaces for Duke University Libraries.

Getting Started
===============

Included in this repository is a Vagrantfile and related shell script for setting up a standard Ubuntu 12.04 LTS 64-bit VM provisioned to run the [Hydra application](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra).

To set up this VM for running Blacklight:

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html)

3. Clone this [tripod3 git repository](https://github.com/duke-libraries/tripod3) to your workstation:

    ```
    $ git clone git@github.com:duke-libraries/tripod3.git
    ```

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

9. Setup Jetty locally (in the VM) as this is not included in the repository:

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

12. In your browser check to see that Blacklight ([http://127.0.0.1:3000](http://127.0.0.1:3000)) and Solr ([http://127.0.0.1:8983/solr/](http://127.0.0.1:8983/solr/)) are running.

If nothing's happening on the ports you're expecting check to make sure Vagrant hasn't changed the ports because of a collision. Check the output from Vagrant up. For example:

    ```
    ==> default: Fixed port collision for 3000 => 3000. Now on port 2200.
    ==> default: Fixed port collision for 8983 => 8983. Now on port 2201.
    ```

For more information about using Vagrant see the [Getting Started](https://docs.vagrantup.com/v2/getting-started/) documentation, particularly the sections on [Teardown](https://docs.vagrantup.com/v2/getting-started/teardown.html) and [Rebuild](https://docs.vagrantup.com/v2/getting-started/rebuild.html).



 


