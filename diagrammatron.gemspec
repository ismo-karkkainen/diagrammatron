Gem::Specification.new do |s|
  s.name        = 'diagrammatron'
  s.version     = '0.1.1'
  s.date        = '2021-09-23'
  s.summary     = 'Generates diagrams from input graph.'
  s.description = %q(
Generates diagrams in SVG format from input material. Split into multiple
programs that each perform one stage.

Source: https://github.com/ismo-karkkainen/diagrammatron

Licensed under Universal Permissive License, see LICENSE.txt.
)
  s.authors     = [ 'Ismo Kärkkäinen' ]
  s.email       = 'ismokarkkainen@icloud.com'
  s.files       = [ 'lib/common.rb', 'LICENSE.txt' ]
  s.executables << 'diagrammatron-edges'
  s.executables << 'diagrammatron-nodes'
  s.executables << 'diagrammatron-place'
  s.executables << 'diagrammatron-prune'
  s.executables << 'diagrammatron-render'
  s.executables << 'diagrammatron-template'
  s.executables << 'dot_json2diagrammatron'
  s.homepage    = 'http://xn--ismo-krkkinen-gfbd.fi/diagrammatron/index.html'
  s.license     = 'UPL-1.0'
end
