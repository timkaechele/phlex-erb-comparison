require "bundler/setup"
Bundler.require
require "stringio"
template = <<~ERB
  <div>
    <h1><%= title %></h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  <div>
ERB

class PhlexTemplate < Phlex::HTML
  def initialize(title:)
    @title = title
  end

  def template
    div {
      h1 { @title }
      p { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
    }
  end
end

title = "Hello, world."
erb = ERB.new(template)

Benchmark.ips do |x|
  x.warmup { 5 }
  x.time { 5 }

  x.report("phlex") do
    buffer = StringIO.new
    PhlexTemplate.new(title: title).call(buffer)
  end

  x.report("erb") do
    buffer = StringIO.new
    buffer.write(erb.result(binding))
  end

  x.compare!
end
