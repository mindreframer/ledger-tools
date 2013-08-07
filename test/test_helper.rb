require 'rubygems'
require 'bundler'
#Bundler.setup(:default, :test)
Bundler.setup(:default)


$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.expand_path('../../lib/ledger/tools', __FILE__)

## for unit tests
#require 'mocha'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'

## for fixtures
class String
  def deindent
    strip.gsub(/^ */, '')
  end

  def indent_to_least_space
    require 'pry'
    binding.pry
    puts "****** INDENTING #{self}"
    lines         = self.split("\n")
    min           = lines.map{|x| x.scan(/^\s*/).first.size}.min
    shorter_lines = lines.map{|x| x[min..-1]}

    res = shorter_lines.join("\n")
    puts "******* REMOVED #{min} spaces"
    res
  end
end
