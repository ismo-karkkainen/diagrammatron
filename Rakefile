# frozen_string_literal: true

task default: [ :install ]

desc 'Install programs to PREFIX/bin.'
task :install do
  prefix = ENV.fetch('PREFIX', '/usr/local')
  target = File.join(prefix, 'bin')
  puts "Using PREFIX #{prefix} to install to #{target}."
  abort("Target #{target} is not a directory.") unless File.directory? target
  [ 'nodes', 'edges', 'place', 'prune', 'render', 'template' ].each do |suffix|
    install("diagrammatron-#{suffix}", target)
  end
  install('dot_json2diagrammatron', target)
end

desc 'Test.'
task test: %i[testnodes testedges testplace testprune testrender testtemplate] do
end

desc 'Test nodes.'
task :testnodes do
  sh './runtest.sh nodes'
end

desc 'Test edges.'
task :testedges do
  sh './runtest.sh edges'
end

desc 'Test place.'
task :testplace do
  sh './runtest.sh place'
end

desc 'Test prune.'
task :testprune do
  sh './runtest.sh prune'
end

desc 'Test render.'
task :testrender do
  sh './runtest.sh render'
end

desc 'Test template.'
task :testtemplate do
  sh './runtest.sh template'
end
