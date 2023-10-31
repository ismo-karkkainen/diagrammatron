# frozen_string_literal: true

# Copyright © 2023 Ismo Kärkkäinen
# Licensed under Universal Permissive License. See LICENSE.txt.

require_relative '../lib/common'
require 'ostruct'
require 'set'

def split_expression_string(expression_string)
  out = []
  remaining = expression_string.lstrip
  until remaining.empty?
    item, sep, rest = remaining.partition(/[\s+-]/)
    out << item unless item.empty?
    sep.strip!
    unless sep.empty?
      out << :plus if sep == '+'
      out << :minus if sep == '-'
    end
    remaining = rest.lstrip
  end
  out
end

def identifier?(item)
  item.is_a?(String)
end

def expression_array_errors(expression_array)
  errors = []
  previous_item_type = :symbol
  unless expression_array.empty?
    errors << 'Expression must start with an identifier' unless identifier?(expression_array.first)
    errors << 'Expression must end with an identifier' unless identifier?(expression_array.last)
  end
  expression_array.each_with_index do |item, index|
    current_item_type = identifier?(item) ? :identifier : :symbol
    if current_item_type == previous_item_type
      errors << "Invalid item '#{item}' at index #{index}. Expected #{current_item_type == :identifier ? 'operator' : 'identifier'}."
    end
    previous_item_type = current_item_type
  end
  errors.empty? ? nil : errors
end

def check_rules(r, filename)
  ok = true
  c = {}
  r.fetch('sets', []).each do |setrules|
    name = setrules.delete('name')
    if c.key?(name)
      aargh("#{filename} duplicate set name: #{name}")
      ok = false
      next
    end
    cats = {}
    %i[any nodes edges].each do |category|
      fr = {}
      setrules.fetch(category.to_s, []).each do |fieldrules|
        frn = fieldrules['name']
        res = fr.fetch(frn, [])
        res.concat(fieldrules['rules'].map { |str| Regexp.new(str) })
        fr[frn] = res
      rescue StandardError => e
        aargh("#{filename} #{name} #{category} #{frn} rule error:\n#{e}")
        ok = false
      end
      cats[category] = fr
    end
    c[name] = cats
  end
  r['sets'] = c
  c = {}
  r.fetch('expressions', []).each do |ne|
    name = ne.delete('name')
    if c.key?(name)
      aargh("#{filename} duplicate expression name: #{name}")
      ok = false
      next
    end
    ea = split_expression_string(ne['expression'])
    errs = expression_array_errors(ea)
    unless errs.nil?
      aargh("#{filename} expressions #{name}:\n#{errs.join("\n")}")
      ok = false
    end
    c[name] = ea
  end
  r['expressions'] = c
  ok
end

# Values in any are used if there is no existing value.
def merge_any(r)
  r.fetch('sets', {}).each_value do |rules|
    any = rules.delete(:any)
    next if any.nil?
    %i[edges nodes].each do |category|
      c = rules.fetch(category, {})
      any.each do |field, patterns|
        next if c.key?(field)
        c[field] = patterns
      end
      rules[category] = c
    end
  end
end

# sets:
#   name:
#     nodes/edges: # Merge here.
#       name: []
# expressions: # Merge here.
#   name: string

def merge_rules(full, overwriting)
  full['expressions'] = {} unless full.key? 'expressions'
  full['expressions'].merge!(overwriting.fetch('expressions', {}))
  sets = full.fetch('sets', {})
  ow = overwriting.fetch('sets', {})
  sets.each do |name, rules|
    %i[nodes edges].each do |category|
      m = ow.dig(name, category)
      next if m.nil?
      rules[category] = {} unless rules.key? category
      rules[category].merge!(m)
    end
  end
  sets.merge!(ow) { |_key, merged, _used| merged } # Adds new sets.
  full['sets'] = sets
end

def match_item(item, rules)
  rules.each do |field, patterns|
    vals = item.fetch(field, nil)
    next if vals.nil?
    vals = [ vals ] unless vals.is_a?(Array)
    patterns.each do |p|
      vals.each do |v|
        next unless v.is_a?(String)
        return true if p.match?(v)
      end
    end
  end
  false
end
