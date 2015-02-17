tripod3
=======

Digital collections and repository interfaces for Duke University Libraries.

Included in this repository is a Vagrantfile and related shell script for setting up a standard Ubuntu 12.04 LTS 64-bit VM provisioned as a development environment for the [ddr-public](https://github.com/duke-libraries/ddr-public) and the [dul-hydra](https://github.com/duke-libraries/dul-hydra) projects.

NOTE: If you already have a copy of this VM installed or running you should shut down the VM and reprovision using the latest Vagrantfile. You can then skip to Step 6 under "Getting Started with DDR-Public."

```
cd tripod3
vagrant halt
git fetch
git pull --rebase
vagrant reload --provision
```

Getting Started with DDR-Public
===============

To get started with this VM for developing DDR-Public:

1. If it is not already installed, download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

2. If it is not already installed, download and install [Vagrant](https://www.vagrantup.com/downloads.html)

3. If you do have not already done so, clone this [tripod3 git repository](https://github.com/duke-libraries/tripod3) to your workstation:

    ```
    $ git clone git@github.com:duke-libraries/tripod3.git
    ```

4. Clone the [ddr-public git repository](https://github.com/duke-libraries/ddr-public) in the tripod3/ directory.

    NOTE: I think we will each need to clone our own copy of the ddr-public application so that the vagrant setup and our ddr-public development work can be managed separately in git.

    ```
    $ cd tripod3
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

10. There are a number of sample configuration files you will need to copy and rename for your development environment. In ddr-public/config copy and rename the following files to remove ".sample". These are located in /config

    ```
    log4r.yml.sample
    database.yml.sample
    role_map.yml.sample
    secrets.yml.sample
    jetty.yml.sample
    ```

    For example:
    ```
    $ cd config/
    $ cp log4r.yml.sample log4r.yml
    ```

11. In addition, you will need a number of configuration files that are not in the respository. I've shared these with you via Box in DDR-Public_Config_Files. They belong in the following locations.

    ```
    local_env.yml --> /ddr-public/config/local_env.yml
    fedora.yml --> /ddr-public/config/fedora.yml
    solr.yml --> /ddr-public/config/solr.yml
    remote.rb --> /ddr-public/config/environments/remote.rb
    production.rb --> /ddr-public/config/environments/production.rb
    development.rb --> /ddr-public/config/environments/development.rb
    ```

12. In the ddr-public directory run Bundler to install gem dependencies:

    ```
    $ bundle install
    ```

13. Create your secret token by running the following command:

    ```
    $ rake secret
    ```

14. Copy the generated token from the command line into /ddr-public/config/local_env.yml following "SECRET_KEY_BASE:". It should look something like this:

    ```
    SECRET_KEY_BASE: sdfkljgh809g8fd09g8dfojglf
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

17. Start the Rails server in ddr-public on port 3001. This is important so that dul-hydra can run on port 3000 in the next section.

    ```
    $ rails s --port 3001
    ```

18. You should be able to access the public interface in a browser [http://localhost:3001](http://localhost:3001/).


Getting Started with DUL-Hydra
===============

1. Clone the dul-hydra repository in tripod3

    ```
    $ cd tripod3
    $ git clone git@github.com:duke-libraries/dul-hydra.git
    ```

2. Change to the dul-hydra directory and create a gemset for the project.

    ```
    $ cd dul-hydra
    $ rvm gemset create dul-hydra
    $ rvm --ruby-version use 2.1.5@dul-hydra

3. Run Bundler to install dependencies.

    ```
    $ bundle install
    ```

4. Copy the configuration files from the Box directory, DUL-Hydra_Config_Files, into the following locations.

    ```
    tripod3/dul-hydra/config/
        folder_ingest.yml
        role_map.yml
        local_env.yml
        fedora.yml
        database.yml
        log4r_fixity_check.yml
        redis.yml
        resque-pool.yml
        solr.yml
        jetty.yml
        log4r_batch_processor.yml
    tripod3/dul-hydra/config/environments/
        development.rb
        test.rb
        production.rb
    ```

5. Make a copy and rename the log4r.yml.sample file in the config directory.
    
    ```
    $ cp config/log4r.yml.sample config/log4r.yml
    ```

6. Run database migrations.

    ```
    $ rake db:migrate
    ```

7. Start resque-pool.

    ```
    $ resque-pool --daemon --environment development
    ```

8. Create a user account for yourself in the Rails console. Replace my email, password, and username with your own.
    
    ```
    $ rails c
    > User.create(email:'cory.lown@duke.edu',password:'password',username:'cory.lown@duke.edu')
    > exit
    ```

9. In dul-hydra/config/role_map.yml replace all instances of my username "cory.lown@duke.edu" with the username you defined in the previous step.

10. In config/folder_ingest.yml replace cory.lown@duke.edu with your username.

11. Install and start Jetty.

    ```
    $ rake jetty:clean
    $ rake jetty:config
    $ rake jetty:start
    ```
12. Start the Rails server for dul-hydra on port 3000.

    ```
    $ rails s --port 3000
    ```

13. You should be able to access the staff interface at [http://localhost:3000/](http://localhost:3000/).

14. Log in using your credentials.


Ingest the Michael Francis Blake Photographs
===============

1. Copy the Blake images to your workstation.

    ```
    $ cd tripod3/TUCASI_CIFS2/dpc-archive/Archived_NoAccess
    $ scp -r USERNAME@repository-dev-01.lib.duke.edu:/nas/TUCASI_CIFS2/dpc-archive/Archived_NoAccess/_in_repository/na_MFB .
    ```

2. Copy the checksum file to your worksation.

    ```
    $ cd tripod3/fixity/fedora_ingest
    $ scp USERNAME@repository-dev-01.lib.duke.edu:/srv/fixity/fedora_ingest/na_MFB.txt .
    ```

3. Change the name of the file you just downloaded from na_MFB.txt to na_MFB-TUCASI_CIFS2-sha256.txt to match the checksum file naming conventions now expected by the folder ingest process.

4. In the file named na_MFB-TUCASI_CIFS2-sha256.txt Find and replace /nas/ with /vagrant/

5. Copy the METS files to your workstation.

    ```
    $ cd tripod3/METS
    $ scp -r cl334@repository-dev-01.lib.duke.edu:/nas/TUCASI_CIFS5/access/images/static/xml/mets/blake .
    ```

6. Log into the staff interface (http://localhost:3000/)[http://localhost:3000/] using the credentials you set up.

7. Within the staff interface select "New" > "Collection"

8. In the title field put "Michael Francis Blake Photographs" and then select "Create Collection."

9. Note the PID in the URL. You will need it later. It looks like "changeme:NNN" where NNN is a number.

10. Select "DC Terms" > "identifier" and then add the "blake" in the identifier field. Click "Update Collection" to save the changes.

11. Select "Default Permissions" > "Modify" and then add "Public" to "Read Access" and add "creator" to "Edit." Then click "Save" and click "OK" at the prompt.

12. Select "New" > "Folder Ingest" and then put "na_MFB" in the "Folder Sub-Path" field. Select the Collection you just created under "Collection." Click on "Scan Folder."

13. If everything looks OK on the summary screen select "Create Ingest Batch."

14. Click "Process" to being the ingest. You will have to refresh the page to see the progress. This will take a while. And the process may fail and need to be restarted.

15. Once the ingest is complete run the following rake task.

    ```
    $ rake dul_hydra:batch:fixity_check
    ```

16.  Then ingest the metadata using the following command. Replace my BATCH_USER id with the username you set up. Replace changeme:NNN with the PID you noted in step 9.

    ```
    rake dul_hydra:batch:mets_folder FOLDER=/vagrant/METS/blake COLLECTION=changeme:NNN BATCH_USER=cory.lown@duke.edu
    ```

17. Publish the collection by running the following in the Rails console.

    ```
    $ rails c
    > col = Collection.find("changeme:1")
    > col.publish!
    > col.items.each {|i| i.publish! }
    > col.items.each { |i| i.components.each { |c| c.publish! }}
    > exit
    ```

18. Generate thumbnails by running the following rake task. Replace changeme:NNN with the PID you noted in step 9.

    ```
    $ rake dul_hydra:batch:thumbnails COLLECTION_PID=changeme:NNN
    ```

19. You should now be able to browse the Blake collection in both the ddr-public and dul-hydra applications.
