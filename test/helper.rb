require 'rubygems'
require 'minitest/autorun'
require 'mocha'

require File.dirname(__FILE__) + "/../lib/ensurable"

module Rails
  class << self
    attr_accessor :env
  end
end


