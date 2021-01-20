task :default => [ :install ]

desc 'Install programs to PREFIX/bin.'
task :install do
  prefix = ENV.fetch('PREFIX', '/usr/local')
  target = File.join(prefix, 'bin')
  puts "Using PREFIX #{prefix} to install to #{target}."
  abort("Target #{target} is not a directory.") unless File.directory? target
  [ 'diagrammatron-nodes', 'diagrammatron-edges', 'diagrammatron-render' ].each do |exe|
    puts "Installing #{exe}."
    %x(sudo install #{exe} #{prefix}/bin/)
  end
end

desc 'Test.'
task :test => [ :testnodes, :testedges ] do
end

desc 'Test nodes.'
task :testnodes do
  sh './runtest.sh nodes'
end

desc 'Test edges.'
task :testedges do
  sh './runtest.sh edges'
end
