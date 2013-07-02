class Solver
  def initialize(row, left, right, n, y, answer)
    @row = row
    @left = left
    @right = right
    @n = n
    @y = y
    @answer = answer
    @new_answer = 0
  end

  def get_new_answer()
    return @new_answer
  end

  def run()
    @new_answer = solve_inner(@row, @left, @right, @n, @y, @answer)
  end

  def solve_inner(row, left, right, n, y, answer)
    if (y == n)
      #found the answer
      return answer + 1
    end

    field = ((1 << n) - 1) & ~(left | row | right)
    while field != 0
      xb = -field & field
      field = field & ~xb

      n_row = row | xb
      n_left = (left | xb) << 1
      n_right = (right | xb) >> 1

      #find the next line
      answer = solve_inner(n_row, n_left, n_right, n, y + 1, answer)
    end

    return answer;
  end
end

