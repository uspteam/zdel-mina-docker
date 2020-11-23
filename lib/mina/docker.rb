def command_with_comment(code)
  comment code
  command code
end

set :docker_compose_file, 'docker-compose.yml'
set :docker_image, 'xxxxx'
set :docker_hub, 'xxxxxx'

namespace :docker do
  desc 'docker build image'
  task :build do
    run(:local) do
      command_with_comment %{docker build -t #{fetch(:docker_image)}:#{ENV.fetch('IMAGE_VERSION', 'latest')} -t #{fetch(:docker_image)}:latest ./}

      command_with_comment %{docker tag #{fetch(:docker_image)}:#{ENV.fetch('IMAGE_VERSION', 'latest')} #{fetch(:docker_hub)}#{fetch(:docker_image)}:#{ENV.fetch('IMAGE_VERSION', 'latest')}}
    end
  end

  desc 'docker push image'
  task :push do
    run(:local) do
      command_with_comment %{docker push #{fetch(:docker_hub)}#{fetch(:docker_image)}:#{ENV.fetch('IMAGE_VERSION', 'latest')}}
    end
  end
end

namespace :docker_compose do
  desc 'docker_compose pull images'
  task :pull do
    in_path(fetch(:deploy_to)) do
      command_with_comment %{docker-compose --file #{fetch(:docker_compose_file)} pull}
    end
  end

  desc 'docker_compose up'
  task :up do
    in_path(fetch(:deploy_to)) do
      command_with_comment %{docker-compose --file #{fetch(:docker_compose_file)} up -d}
    end
  end

  desc 'docker_compose restart'
  task :restart do
    in_path(fetch(:deploy_to)) do
      command_with_comment %{docker-compose --file #{fetch(:docker_compose_file)} restart}
    end
  end

  desc 'docker_compose status'
  task :status do
    in_path(fetch(:deploy_to)) do
      command_with_comment %{docker-compose --file #{fetch(:docker_compose_file)} ps}
    end
  end

  desc 'docker_compose run'
  task :run, [:command] do |t, args|
    in_path(fetch(:deploy_to)) do
      command_with_comment %{docker-compose --file #{fetch(:docker_compose_file)} run --rm -e RAILS_ENV=#{fetch(:rails_env)} app #{args.command}}
    end
  end

  desc 'docker_compose migrate'
  task :migrate do
    comment "Call migrate"

    invoke :'docker_compose:run', "bundle exec rake db:migrate"
  end

  desc 'docker_compose update_menus_and_permissions'
  task :update_menus_and_permissions => :remote_environment do
    comment "Update menus and permissions"

    invoke :'docker_compose:run', "bundle exec rake roles_and_permissions:update_menus"
    invoke :'docker_compose:run', "bundle exec rake roles_and_permissions:update_permissions"
  end

  desc 'docker_compose setup'
  task :setup do
    run(:remote) do
      command_with_comment %(mkdir -p "#{fetch(:deploy_to)}/log/")
      command_with_comment %(mkdir -p "#{fetch(:deploy_to)}/config")
    end

    run(:local) do
      command_with_comment "scp #{fetch(:docker_compose_file)} #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:deploy_to)}/#{fetch(:docker_compose_file)}"
    end
  end

  desc "Deploys the current version to the server."
  task :deploy do
    command_with_comment "export IMAGE_VERSION=#{ENV.fetch('IMAGE_VERSION', 'latest')}"

    invoke :'docker_compose:pull'
    invoke :'docker_compose:migrate'
    invoke :'docker_compose:update_menus_and_permissions'
    invoke :'docker_compose:up'
  end
end
