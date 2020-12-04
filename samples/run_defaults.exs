Benchee.run(
  %{
    "easy_board" => fn ->Sudoku.solve(Sudoku.easy_board()) end,
    "hard_board" => fn ->Sudoku.solve(Sudoku.hard_board()) end
  }
)
