Ensurable
=========

FYI this is very alpha software, also it's not meant to be used in production. It just noops in production.

Use Case
-------

With Bundler we now have a great way of defining our gem deps and ensuring that all devs/machines are using the same set of gems, same versions, and all.

This gem attempts to do something similar for system deps (like development tools, software an app depends on, databases, etc.). 

Usually this isn't really an issue because these kinds of tools aren't developed as quickly as rubygems are, however I have run into issues like this. If a coworker of mine is using Redis 1.x and I am using Redis 2.x we will see subtle differences in our output. This gem aims to make sure stuff like this can't happen.

Installation
-----------

    gem i ensurable

In your Gemfile:
    
    gem 'ensurable', :group => [:development, :test]

If you're using Rails you'll want to include this in your application.rb before the `require 'rails/all'`. This makes sure that this gem gets executed as early as possible and is able to ensure things before your app cries that it needs Msyql or Redis or something.

    # config/application.rb
    require File.expand_path('../boot', __FILE__)

    require 'ensurable/now'
    require 'rails/all'

Otherwise if you're using Bundler you'll want to `require 'ensurable/now'` before Bundler.require for best results.

Usage
-----

Ensurable provides a DSL for defining your apps system deps. Stick this in a file called `ensure.rb` in the root of your application.

    # ensure.rb
    installed 'git'
    installed 'imagemagick'

    running 'redis'

The `installed` method ensures that the given program is installed locally on the system. The `running` method ensures that the given program is currently running on the local system.

There's no magic here, ie. this gem doesn't try to guess what it means for a program to be installed or running. There is a class inside the gem for each of these deps that knows how to check these things.

Currently git and redis are the only supported deps. More are planned as needed.

Roadmap/TODO
-------

* Allow passing of version numbers when defining ensurables. eg. installed 'git', '> 1.7' 
* Add another method to the Ensurable::#{program} API that lets users know how to install missing deps.
* Nicer error message when there's a missing dep. The default exception raised text is ugly.

Contributing
-----------

Just fork it and send a pull request.

License
------

MIT

