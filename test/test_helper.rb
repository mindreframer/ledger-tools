require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)


$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.expand_path('../../lib/ledger/tools', __FILE__)

## for unit tests
#require 'mocha'
require 'minitest/autorun'
require 'minitest/spec'
