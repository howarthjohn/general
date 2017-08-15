#!/usr/bin/env ruby
#
# munin-graphite.rb
# 
# A Munin-Node to Graphite bridge
# Grabs data from munin-nodes based on the config files in
# /etc/munin/munin-conf.d/
# and forwards them every 10 seconds to Graphite 
#
# Author: Paul O'Connor (paul.oconnor@swrve.com)
#

require 'socket'
require 'timeout'

class Munin
  def initialize(host)
    # host='localhost'
    port=4949
    @munin = TCPSocket.new(host, port)
    @munin.gets
  end
  
  def get_response(cmd)
    @munin.puts(cmd)
    stop = false 
    response = Array.new
    while stop == false
      line = @munin.gets
      line.chomp!
      if line == '.'
        stop = true
      else
        response << line 
        stop = true if cmd == "list"
      end
    end
    response
  end
  
  def close
    @munin.close
  end
end

class Carbon
  def initialize()
    # host='monitor.swrve.com'
    host='10.176.234.191'
    port=2003
    @carbon = UDPSocket.new()
    #@carbon = UDPSocket.bind(host, port)
  end
  
  def send(msg)
    #@carbon.puts(msg)
    @carbon.send(msg, 0, 'monitor.swrve.com', 2003)
  end
  
  def close
    @carbon.close
  end
end

def get_data(host)
  begin
    timeout(30) do
      munin = Munin.new(host)
      all_metrics = Array.new
      munin.get_response("nodes").each do |node|
        metric_base = 'munin.'
        metric_base << node.split(".").reverse.join(".")
        # puts "Doing #{@metric_base}" 
        munin.get_response("list")[0].split(" ").each do |metric|
          # puts "Grabbing #{metric}"
          mname = "#{metric_base}"
          has_category = false
          base = false
          munin.get_response("config #{metric}").each do |configline|
            if configline =~ /graph_category (.+)/
              mname << ".#{$1}"
              has_category = true
            end
            if configline =~ /graph_args.+--base (\d+)/
               base = $1
            end
          end
          mname << ".other" unless has_category
          munin.get_response("fetch #{metric}").each do |line|
            line =~ /^(.+)\.value\s+(.+)$/
            field = $1
            value = $2
            #if value.to_i > 0
              all_metrics << "#{mname}.#{metric}.#{field} #{value} #{Time.now.to_i}"
            #end
          end
        end
      end
      munin.close
      push_data(all_metrics)
    end
    rescue Timeout::Error
      puts "Timed out #{host}"
    end
end

def push_data(all_metrics)
  carbon = Carbon.new()
  all_metrics.each do |m|
    # puts "Sending #{m}"
    @count += 1
    carbon.send(m)
  end
  carbon.close
end

while true
  metric_base = "munin."
  @count = 0
  threads = []

  Dir.glob('/etc/munin/munin-conf.d/*.conf') do |conf_file|
    if not conf_file.include? 'eel'
      host = ''
      threads << Thread.new(conf_file) { 
        data = File.open(conf_file).read
         # puts "#{conf_file}"
        host = ''
        data.each_line do |line|
          if line =~ /.+address (.*)/
            host = $1
          end
        end
        get_data(host)
      }
    end
  end
  
  threads.each { |aThread|  aThread.join }
  puts "#{@count} metrics sent"
  @count = 0
  sleep 10
end