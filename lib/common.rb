# frozen_string_literal: true

# Copyright © 2021-2023 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require 'json_schemer'
require 'yaml'
require 'set'


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
    return aargh("#{input} is not a simple mapping.") unless src.is_a? Hash
  end
  src
end

def list_schemas
  (Dir.entries(File.dirname(__FILE__)).select { |name| name.upcase.end_with?('.YAML') }).map { |name| name[0, name.size - 5] }
end

def load_schema(schema_name)
  YAML.safe_load_file(File.join(File.dirname(__FILE__), "#{schema_name}.yaml"))
end

def make_schemer(schema, reading)
  JSONSchemer.schema(JSON.generate(schema),
    meta_schema: 'https://json-schema.org/draft/2020-12/schema',
    insert_property_defaults: reading)
end

def load_verified(input, schema_name)
  src = load_source(input)
  unless src.nil?
    s = load_schema(schema_name)
    schemer = make_schemer(s, true)
    errs = schemer.validate(src).to_a
    unless errs.empty?
      aargh (errs.map { |e| e['error'] }).join("\n")
      src = nil
    end
  end
  src
rescue Errno::ENOENT
  aargh "Could not load #{schema_name}"
rescue StandardError => e
  aargh "Internal error: #{e}\n#{e.backtrace.join("\n")}\nFailed to read #{schema_name}"
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

def save_verified(output, doc, error_return, schema_name)
  s = load_schema(schema_name)
  schemer = make_schemer(s, false)
  errs = schemer.validate(doc).to_a
  unless errs.empty?
    aargh (errs.map { |e| e['error'] }).join("\n")
    return error_return
  end
  dump_result(output, YAML.dump(doc, line_width: 1_000_000), error_return)
end
