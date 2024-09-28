require "bundler/setup"
Bundler.require
require "stringio"
template = <<~ERB
  <div>
    <% for i in 1..count %>
      <p><%= i %></p>
    <% end %>
  <div>
ERB

class PhlexTemplate < Phlex::HTML
  def initialize(count:)
    @count = count
  end

  def template
    div {
      for i in 1..@count do
        p { i }
      end
    }
  end
end

erb = ERB.new(template)

Benchmark.ips do |x|
  x.warmup { 5 }
  x.time { 5 }

  x.report("phlex") do
    buffer = StringIO.new
    count = 250
    PhlexTemplate.new(count: count).call(buffer)
  end

  x.report("erb") do
    buffer = StringIO.new
    count = 250
    buffer.write(erb.result(binding))
  end

  x.compare!
end
