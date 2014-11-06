tripod3
=======

Digital collections and repository interfaces for Duke University Libraries.

Getting Started
===============

Included in this repository is a Vagrantfile and related shell scripts for setting up a standard Ubuntu 12.04 LTS 64-bit VM provisioned to run the [Blacklight quickstart application](https://github.com/projectblacklight/blacklight/wiki/Quickstart#creating-a-new-application-the-hard-way).

To set up this VM for running Blacklight:

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html)

3. Clone this [tripod3 git repository](https://github.com/duke-libraries/tripod3) to your workstation:

    ```
    $ git clone https://github.com/duke-libraries/tripod3.git
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

6. Change to the directory shared between the VM and your computer:

    ```
    $ cd /vagrant
    ```

7. Setup Blacklight by following the "Hard Way" instructions on the [Blacklight Quickstart page](https://github.com/projectblacklight/blacklight/wiki/Quickstart#creating-a-new-application-the-hard-way).

8. In your browser check to see that Blacklight ([http://127.0.0.1:3000](http://127.0.0.1:3000)) and Solr ([http://127.0.0.1:8983/solr/](http://127.0.0.1:8983/solr/)) are running. Note that if you already have something running on those ports Vagrant will pick a different port which you should be able to find in the output from running "vagrant up."


For more information about using Vagrant see the [Getting Started](https://docs.vagrantup.com/v2/getting-started/) documentation, particularly the sections on [Teardown](https://docs.vagrantup.com/v2/getting-started/teardown.html) and [Rebuild](https://docs.vagrantup.com/v2/getting-started/rebuild.html).
