# The following provisioning script was adapted from dan entous
# Found on GitHub https://github.com/dan-nl/blacklight-vagrant

# The MIT License (MIT)

# Copyright (c) 2014 dan entous

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#!/bin/bash --login

#
# environment vars
#
# export BLACKLIGHT_APPLICATION_DIR=/vagrant/blacklight

#
# update apt-get
#
echo
echo 'updating apt-get'
echo '----------------'
apt-get update > /dev/null
echo 'apt-get updated'
echo


#
# check for unzip
#
echo
echo 'check for unzip'
echo '---------------'
if type -p unzip > /dev/null; then
    echo 'unzip already installed'
else
    echo 'installing unzip'
    apt-get install unzip -y
fi
echo


#
# check for curl
#
echo
echo 'check for curl'
echo '--------------'
if type -p curl > /dev/null; then
    echo 'curl already installed'
else
    echo 'installing curl'
    apt-get install curl -y
fi
echo


#
# check for nodejs
#
echo
echo 'check for nodejs v0.6.12'
echo '------------------------'
node_version="$(node -v 2>&1)"
if echo $node_version 2>&1 | grep -q 'v0.6.12'; then
    echo 'nodejs v0.6.12 already installed'
else
    echo 'installing nodejs'
    apt-get install nodejs -y
fi
echo


#
# check for git
#
echo
echo 'check for git 1.7.x'
echo '-------------------'
git_version="$(git --version 2>&1)"
if echo $git_version 2>&1 | grep -q 'git version 1.7'; then
    echo 'git already installed'
else
    echo 'installing git'
    apt-get install git -y
fi
echo


#
# check for java
#
echo
echo 'check for java jre 7'
echo '--------------------'
java_version="$(java -version 2>&1)"
if echo $java_version 2>&1 | grep -q 'java version "1.7'; then
    echo 'java jre 7 already installed'
else
    echo 'installing openjdk-7-jre-headless'
    apt-get install openjdk-7-jre-headless -y
fi
echo


#
# run sub-scripts as vagrant user
#
# su -c "/vagrant/shell-scripts/rvm.sh" vagrant
# su -c "/vagrant/shell-scripts/blacklight.sh" vagrant

#
# check for rvm
# Installing required packages: gawk, g++, libyaml-dev, libsqlite3-dev,
# sqlite3, autoconf, libgdbm-dev, libncurses5-dev, automake, libtool,
# bison, pkg-config, libffi-dev
#
echo
echo 'check for rvm'
echo '-------------'
cd
if [ -e /home/vagrant/.rvm/scripts/rvm ]; then
    echo 'rvm already installed'
    source /home/vagrant/.rvm/scripts/rvm
else
    echo 'installing rvm'
    su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3'
    su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s $1'
    su - vagrant -c 'source /usr/local/rvm/scripts/rvm'
    su - vagrant -c 'rvm requirements'
fi
echo


#
# check for ruby 2.1.5
#
echo
echo 'check for ruby 2.1.5'
echo '--------------------'
ruby_version="$(rvm list 2>&1)"
if echo $ruby_version | grep -q 'ruby-2.1.5'; then
    echo 'ruby 2.1.5 already installed'
else
    echo 'installing ruby 2.1.5'
    su - vagrant -c 'rvm install 2.1.5'
fi
echo


#
# check for gemset tripod3
#
echo
echo 'creating gemset tripod3'
echo '---------------------------'
# su - vagrant -c 'rvm use ruby-2.1.5@tripod3 --ruby-version --create'
su - vagrant -c 'rvm use ruby-2.1.5@tripod3 --create'
echo


# make sure rvm is available as a function
#source /usr/local/rvm/scripts/rvm

#
# check for rails
#
echo
echo 'check for Rails 4.1.8'
echo '---------------------'
rvm ruby-2.1.5@tripod3 2>&1
rails_version="$(rails -v 2>&1)"
if echo $rails_version 2>&1 | grep -q 'Rails 4.1.8'; then
    echo 'rails Rails 4.1.8 already installed'
else
    echo 'installing Rails 4.1.8'
    su - vagrant -c 'gem install rails -v 4.1.8 --no-ri --no-rdoc'
fi
echo

#
# check for application directory
#
# echo
# echo 'check for application directory'
# echo '-------------------------------'
# if [ -d $BLACKLIGHT_APPLICATION_DIR ]; then
#     echo 'application directory exits'
# else
#     echo 'creating application directory'
#     mkdir $BLACKLIGHT_APPLICATION_DIR

#     cd $BLACKLIGHT_APPLICATION_DIR
#     echo 'installing blacklight'
#     rails new . -m https://raw.github.com/projectblacklight/blacklight/master/template.demo.rb
# fi
echo
