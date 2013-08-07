require 'bundler'
require 'pry'
Bundler.setup(:default, :test)


$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.expand_path('../../lib/ledger/tools', __FILE__)

## for unit tests
#require 'mocha'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'

def fixture(file)
  File.read("test/fixtures/#{file}")
end

## for fixtures
class String
  def deindent
    strip.gsub(/^ */, '')
  end

  def indent_to_least_space
    lines         = self.split("\n")
    min           = lines.map{|x|
      if x.strip == ""
        100
      else
        x.scan(/^\s*/).first.size
      end
    }.min
    shorter_lines = lines.map{|x| x[min..-1]}

    res = shorter_lines.join("\n")
    res
  end
end
