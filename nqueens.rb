require './solver.rb'

def main(argv)
  if argv.length < 2
    puts 'usage: \n' +
             'NQueens queens(1 ... 30) parallel(true or false)'
    return -1
  end

  #get the arguments
  n = argv[0].to_i
  if n < 0 || 30 < n
    n = 0
  end
  puts 'queens  : ' + n.to_s()

  parallel = false
  if argv.length >= 2
    case argv[1].class == String ? argv[1].downcase : argv[1]
      when 'true', 'True'
        parallel = true
      when 'false', 'False'
        parallel = false
    end
  end
  puts 'parallel: ' + parallel.to_s()

  #start
  start = Time.now()

  #solve
  center = n >> 1
  solvers = []
  solver_threads = []

  answer = 0
  for x in 0..center - 1
    #left half
    row = 1 << x
    left = row << 1
    right = row >> 1

    s = Solver.new(row, left, right, n, 1, 0)
    if parallel
      t = Thread.new(s) do |r|
        r.run()
      end
      solver_threads.push(t)
    else
      s.run()
    end
    solvers.push(s)
  end

  if n % 2 == 1
    #center(if N is odd)
    row = 1 << center
    left = row << 1
    right = row >> 1

    solver_remain = Solver.new(row, left, right, n, 1, 0)
    if parallel
      solver_remain_thread = Thread.new(solver_remain) do |r|
        r.run()
      end
    else
      solver_remain.run()
    end
  end

  #join
  for x in 0..center - 1
    if parallel
      solver_threads[x].join()
    end
    answer += solvers[x].get_new_answer()
  end
  answer *= 2

  if n % 2 == 1
    if parallel
      solver_remain_thread.join()
    end
    answer += solver_remain.get_new_answer()
  end

  #finished
  elapse = Time.now() - start

  #solved
  puts 'answers : ' + answer.to_s()
  puts 'time    : ' + elapse.to_s() + '[s]'
end

if __FILE__ == $0
  main(ARGV)
end
