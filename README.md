# Docker support for Mina

You can use mina now to deploy docker servers.

## Installation

Add this line to your application's Gemfile:

    gem 'mina-docker'

Or install it yourself as:

    $ gem install mina-docker

## Usage

Load the tasks:

```ruby
require 'mina/docker'
```

Config

```ruby
set :docker_compose_file, 'docker-compose.yml'
set :docker_image, 'xxxxx'
set :docker_hub, 'xxxxxx'
```

Setup it

    $ bundle exec mina docker_compose:setup 

Deploy it!

    $ bundle exec mina docker_compose:deploy

