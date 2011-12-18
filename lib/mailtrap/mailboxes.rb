#require 'rubygems'
#require 'rspec'
#require File.join(File.dirname(__FILE__), %w[ log_parser ])

class Mailtrap
  class Mailboxes

    def initialize(filename)
      @queues = {}
      Mailtrap::LogParser.parse(filename).each do |email|
        email.destinations.each do |dest|
          @queues[dest] = [] if @queues[dest].nil?
          @queues[dest].push email
        end
      end

    end

    def accounts
      return @queues.keys
    end
  end
end
