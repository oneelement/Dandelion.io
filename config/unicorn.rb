#root = "/home/oliver/Documents/Rails/One-Element-Mongo"
root = "/home/apps/One-Element-Mongo"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.ripplex.sock"
worker_processes 2
timeout 30