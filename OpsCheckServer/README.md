OpsCheck
========

The OpsCheck is a set of tool that tracks application release. Users are able to set which
 particular application version is still able to run with their current system.
The tool has two components:
- Server: automatically collects information about new app versions


* Server
We are using rvm with ruby 2.0.0 and Rails 4
- Bundle Install
- Edit database.yml to match your MySql configuration
- rake db:create
- rake db:migrate
- rails s

Enjoy it


