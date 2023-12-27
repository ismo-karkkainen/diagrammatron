# frozen_string_literal: true

require 'rubocop/rake_task'

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
task test: %i[testcommon testsubset testsubsets testnodes testedges testplace testprune testrender testtemplate testget testcopy] do
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

desc 'Test copy.'
task :testcopy do
  sh './runtest.sh copy'
end

desc 'Test common library.'
task :testcommon do
  sh './runtest.sh common'
end

desc 'Test subsets library.'
task :testsubsets do
  sh './runtest.sh subsets'
end

desc 'Test subset.'
task :testsubset do
  sh './runtest.sh subset'
end

desc 'Lint using Rubocop'
RuboCop::RakeTask.new(:lint) do |t|
  t.patterns = [ 'bin', 'lib', 'diagrammatron.gemspec' ]
end
