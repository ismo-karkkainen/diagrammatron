# frozen_string_literal: true

task default: [ :install ]

desc 'Clean.'
task :clean do
  `rm -f diagrammatron-*.gem`
end

desc 'Build gem.'
task gem: [:clean] do
  `gem build diagrammatron.gemspec`
end

desc 'Build and install gem.'
task install: [:gem] do
  `gem install diagrammatron-*.gem`
end

desc 'Test.'
task test: %i[testcommon testnodes testedges testplace testprune testrender testtemplate testget] do
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

desc 'Test get.'
task :testget do
  sh './runtest.sh get'
end

desc 'Test common library.'
task :testcommon do
  sh './runtest.sh common'
end
