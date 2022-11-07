require 'benchmark'

Dir.chdir('../black_thursday_spec_harness'){
  time_all = 0

  time = Benchmark.measure {
    system('bundle exec rspec spec/iteration_1_spec.rb')
  }
  time_1 = time.real
  time_all += time.real

  time = Benchmark.measure {
    system('bundle exec rspec spec/iteration_2_spec.rb')
  }
  time_2 = time.real
  time_all += time.real

  time = Benchmark.measure {
    system('bundle exec rspec spec/iteration_3_spec.rb')
  }
  time_3 = time.real
  time_all += time.real

  time = Benchmark.measure {
    system('bundle exec rspec spec/iteration_4_spec.rb')
  }
  time_4 = time.real
  time_all += time.real

  time = Benchmark.measure {
    system('bundle exec rspec spec/iteration_5_spec.rb')
  }
  time_5 = time.real
  time_all += time.real

  # time = Benchmark.measure {
  #   system('bundle exec rake spec')
  # }
  # puts "Total: #{time.real}"
  # all = time.real

  puts "Iteration \#1: #{time_1}"
  puts "Iteration \#2: #{time_2}"
  puts "Iteration \#3: #{time_3}"
  puts "Iteration \#4: #{time_4}"
  puts "Iteration \#5: #{time_5}"
  puts "Total Iterations: #{time_all}"
  # puts "Total: #{all}"
}
