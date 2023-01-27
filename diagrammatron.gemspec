# frozen_string_literal: true

require 'rake'

Gem::Specification.new do |s|
  s.name        = 'diagrammatron'
  s.version     = '0.3.0'
  s.summary     = 'Generates diagrams from input graph.'
  s.description = %q(
Generates diagrams in SVG format from input material. Split into multiple
programs that each perform one stage.
)
  s.authors     = [ 'Ismo Kärkkäinen' ]
  s.email       = 'ismokarkkainen@icloud.com'
  s.files       = FileList[ 'lib/common.rb', 'LICENSE.txt', 'template/*.yaml', 'template/*.erb' ]
  s.executables << 'diagrammatron-get'
  s.executables << 'diagrammatron-edges'
  s.executables << 'diagrammatron-nodes'
  s.executables << 'diagrammatron-place'
  s.executables << 'diagrammatron-prune'
  s.executables << 'diagrammatron-render'
  s.executables << 'diagrammatron-template'
  s.executables << 'dot_json2diagrammatron'
  s.homepage    = 'https://xn--ismo-krkkinen-gfbd.fi/diagrammatron/index.html'
  s.license     = 'UPL-1.0'
  s.required_ruby_version = '>= 2.7.0'
end
