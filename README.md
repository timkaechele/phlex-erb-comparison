# Phlex 1.x vs ERB performance comparison

This is a basic performance comparison of phlex and erb.

## Hello World

It's really what it says on the label.

It renders a h1 tag with templatized content and a static p tag.

```html
<div>
  <h1><%= title %></h1>
  <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<div>
```

```ruby
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
```

Results:

```sh
ruby 3.3.4 (2024-07-09 revision be1089c8ec) [arm64-darwin23]
Warming up --------------------------------------
               phlex    23.340k i/100ms
                 erb     6.860k i/100ms
Calculating -------------------------------------
               phlex    235.297k (± 1.2%) i/s    (4.25 μs/i) -      1.190M in   5.059632s
                 erb     69.086k (± 0.3%) i/s   (14.47 μs/i) -    349.860k in   5.064182s

Comparison:
               phlex:   235296.7 i/s
                 erb:    69085.6 i/s - 3.41x  slower
```

## For loop

In this example we render a div tag with a variable number of p tags

```html
<div>
  <% for i in 1..count %>
    <p><%= i %></p>
  <% end %>
<div>
```

```ruby
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
```

Results:

```
ruby 3.3.4 (2024-07-09 revision be1089c8ec) [arm64-darwin23]
Warming up --------------------------------------
               phlex   513.000 i/100ms
                 erb     1.597k i/100ms
Calculating -------------------------------------
               phlex      5.103k (± 0.2%) i/s  (195.96 μs/i) -     25.650k in   5.026296s
                 erb     15.889k (± 0.4%) i/s   (62.94 μs/i) -     79.850k in   5.025521s

Comparison:
                 erb:    15889.2 i/s
               phlex:     5103.2 i/s - 3.11x  slower
```
