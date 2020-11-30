defmodule Sudoku do
  defstruct board: {}, grid_size: 0, size: 0

  def new (%Sudoku{size: size} = sudoku) do
    board = Tuple.duplicate(0, size * size)
    grid_size = trunc(:math.sqrt(size))
    %Sudoku{sudoku | board: board, grid_size: grid_size}
  end

  def get(%Sudoku{board: board, size: size}, row, col) do
    cond do
      row < 0 or col < 0 or row >= size or col >= size ->
        raise ArgumentError, message: "invalid row and/or column argument"

      true ->
        elem(board, row * size + col)
    end
  end

  def put(%Sudoku{board: board, size: size} = sudoku, row, col, value) do
    cond do
      row < 0 or col < 0 or row >= size or col >= size or value < 1 or value > size ->
        raise ArgumentError, message: "invalid row, column and/or value argument"

      true ->
        new_board = put_elem(board, row * size + col, value)
        %Sudoku{sudoku | board: new_board}
    end
  end

  def valid_put?(%Sudoku{grid_size: grid_size, size: size} = sudoku, row, col, value) do
    cond do
      # invalid value
      value < 1 or value > size ->
        raise ArgumentError, message: "invalid row and/or column argument"

      # non-empty cell
      get(sudoku, row, col) != 0 ->
        false

      # row validation
      Enum.any?(1..size - 1, fn c -> get(sudoku, row, c) == value end) ->
        false

      # column validation
      Enum.any?(1..size - 1, fn r -> get(sudoku, r, col) == value end) ->
        false

      # grid validation
      true ->
        grid_fst_row = div(row, grid_size) * grid_size
        grid_lst_row = grid_fst_row + grid_size - 1
        grid_fst_col = div(col, grid_size) * grid_size
        grid_lst_col = grid_fst_col + grid_size - 1

        for r <- grid_fst_row..grid_lst_row,
            c <- grid_fst_col..grid_lst_col do
              {r, c}
            end
        |> Enum.any?(fn {r, c} -> get(sudoku, r, c) == value end)
        |> Kernel.not
    end
  end

  def full?(%Sudoku{size: size} = board) do
    for r <- 0..size - 1,
        c <- 0..size - 1 do
      {r, c}
    end
    |> Enum.all?(fn {r, c} -> get(board, r, c) != 0 end)
  end

  def print(%Sudoku{board: board, size: size}) do
    board
    |> Tuple.to_list()
    |> Enum.chunk_every(size)
    |> Enum.map(fn l -> Enum.join(l, ", ") |> IO.puts() end)
  end
end
