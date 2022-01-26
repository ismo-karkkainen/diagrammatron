# frozen_string_literal: true

# Copyright © 2021, 2022 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

def aargh(message, return_value = nil)
  message = (message.map &(:to_s)).join("\n") if message.is_a? Array
  $stderr.puts message
  return_value
end

def load_source(input)
  YAML.safe_load(input.nil? ? $stdin : File.read(input))
rescue Errno::ENOENT
  aargh "Could not load #{input || 'stdin'}"
rescue StandardError => e
  aargh "#{e}\nFailed to read #{input || 'stdin'}"
end

def load_source_hash(input)
  src = load_source(input)
  unless src.nil?
    return aargh('Input is not a mapping.') unless src.is_a? Hash
  end
  src
end

def dump_result(output, doc, error_return)
  if output.nil?
    $stdout.puts doc
  else
    fp = Pathname.new output
    fp.open('w') do |f|
      f.puts doc
    end
  end
  0
rescue StandardError => e
  aargh([ e, "Failed to write output: #{output || 'stdout'}" ], error_return)
end
