!SLIDE quote

# Concepts

!SLIDE

## Where did all my performance go?

!SLIDE

## Metrics

!SLIDE

## Rails

!SLIDE

```bash
Started GET "/" for 127.0.0.1 at 2012-06-05 16:21:03 -0700
Processing by HomeController#index as HTML
  Post Load (0.1ms)  SELECT "posts".* FROM "posts"
  User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
  Rendered posts/_post.html.haml (64.2ms)
  Rendered home/index.html.haml within layouts/application (70.0ms)
  Rendered layouts/_navigation.html.haml (8.6ms)
  Rendered layouts/_messages.html.haml (1.3ms)
Completed 200 OK in 226ms (Views: 164.1ms | ActiveRecord: 3.0ms)
```

!SLIDE

## SQL Caching

```bash
Post Load (0.1ms)  SELECT "posts".* FROM "posts"
User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
CACHE (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
```

!SLIDE

## Views and ActiveRecord

```bash
  # ...
  Rendered posts/_post.html.haml (64.2ms)
  Rendered home/index.html.haml within layouts/application (70.0ms)
  Rendered layouts/_navigation.html.haml (8.6ms)
  Rendered layouts/_messages.html.haml (1.3ms)
Completed 200 OK in 226ms (Views: 164.1ms | ActiveRecord: 3.0ms)
```

!SLIDE quote

## benchmark

```ruby
require 'benchmark'

n = 50000
Benchmark.bm do |x|
  x.report { for i in 1..n; a = "1"; end }
  x.report { n.times do   ; a = "1"; end }
  x.report { 1.upto(n) do ; a = "1"; end }
end

```

!SLIDE

```bash
The result:
    user     system      total        real
1.033333   0.016667   1.016667 (  0.492106)
1.483333   0.000000   1.483333 (  0.694605)
1.516667   0.000000   1.516667 (  0.711077)
```

!SLIDE quote

## Profiling Code

[ruby-prof](https://github.com/rdp/ruby-prof)

!SLIDE

```bash
  %total   %self     total      self      wait     child            calls    Name
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1      BasicObject#instance_eval
  33.25%   2.63%      0.00      0.00      0.00      0.00                1      Battleship#shoot
                      0.00      0.00      0.00      0.00              1/2      Enumerable#find
                      0.00      0.00      0.00      0.00              1/1      Hash#empty?
                      0.00      0.00      0.00      0.00              1/1      Battleship#game_is_over?
--------------------------------------------------------------------------------
```

!SLIDE

```ruby
require 'ruby-prof'

# Profile the code
RubyProf.start
# ...
# code to profile
# ...
result = RubyProf.stop

# Print a flat profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

!SLIDE quote

## Profiling Code

[rspec-prof](https://github.com/sinisterchipmunk/rspec-prof)

!SLIDE

## Profiling Tests

```ruby
describe Battleship do

  before do
    subject.add_player 'frank'
    subject.add_player 'ivan'
    subject.place_ship 'frank', :tugboat, :horizontal, 1, 1
    subject.place_ship 'ivan', :carrier, :vertical, 1, 1
  end

  profile :file => STDOUT, :printer => :graph do

    it "should perform" do
      subject.shoot 'frank', 1, 1
    end

  end

end
```

!SLIDE bullets

## measure_mode

* process_time
* wall_time
* cpu_time
* allocations
* memory

!SLIDE bullets

## printer

* flat
* graph
* graph_html
* call_tree

!SLIDE quote

:measure_mode => 'process_time'

:printer => :graph

!SLIDE

## New Relic

```ruby
gem 'newrelic_rpm'
```

!SLIDE




