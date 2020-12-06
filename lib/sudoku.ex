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
      row < 0 or col < 0 or row >= size or col >= size or value < 0 or value > size ->
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
      Enum.any?(0..size - 1, fn c -> get(sudoku, row, c) == value end) ->
        false

      # column validation
      Enum.any?(0..size - 1, fn r -> get(sudoku, r, col) == value end) ->
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
        |> Enum.all?(fn {r, c} -> get(sudoku, r, c) != value end)
    end
  end

  def full?(%Sudoku{board: board}) do
    board
    |> Tuple.to_list()
    |> Enum.all?(fn e -> e != 0 end)
  end
  def next_blank(%Sudoku{size: size} = sudoku, row, col) do
    position = size * row + col

    for r <- 0..size - 1,
        c <- 0..size - 1 do
        {r, c}
    end
    |> Enum.filter(fn {r, c} -> size * r + c > position end)
    |> Enum.find(nil, fn {r, c} -> get(sudoku, r, c) == 0 end)
  end

  def previous_blank(%Sudoku{size: size} = first_sudoku, row, col) do
    position = size * row + col

    for r <- 0..size - 1,
        c <- 0..size - 1 do
        {r, c}
    end
    |> Enum.filter(fn {r, c} -> size * r + c < position end)
    |> Enum.reverse()
    |> Enum.find(nil, fn {r, c} -> get(first_sudoku, r, c) == 0 end)
  end

  def solve(%Sudoku{} = sudoku) do
    IO.puts("Solving:")
    sudoku
    |> print()
    |> solve(0, 0, 1, sudoku)
  end

  def solve(%Sudoku{size: size} = sudoku, row, col, value, first_sudoku) do

    cond do
      value > size ->
        # Insertion failed (tried all values)!
        # Update sudoku removing previous insertion, and solve for next value

        {previous_row, previous_col} = previous_blank(first_sudoku, row, col)
        previous_cell_value = get(sudoku, previous_row, previous_col)

        sudoku
        |> put(previous_row, previous_col, 0)
        |> solve(previous_row, previous_col, previous_cell_value + 1, first_sudoku)

      valid_put?(sudoku, row, col, value) ->
        # Temporally accepted insertion
        # Update sudoku with new insertion, and solve for next value
        if next_blank(sudoku, row, col) != nil do
          {next_row, next_col} = next_blank(sudoku, row, col)
          put(sudoku, row, col, value)
          |> solve(next_row, next_col, 1, first_sudoku)
        else
          IO.puts("Solution:")
          put(sudoku, row, col, value)
          |>print(false)
        end

      true ->
        # Insertion not accepted
        # Update sudoku with new insertion try for this coordinate, and solve for next value
        put(sudoku, row, col, 0)
        |> solve(row, col, value + 1, first_sudoku)
    end
  end

  def print(%Sudoku{board: board, grid_size: grid_size, size: size} = sudoku, return_board? \\ true) do
    for x <- 1..size * size do
      {x, elem(board, x - 1)}
    end
    |> Enum.map(fn {x, y} ->
      cond do
        rem(x, grid_size) == 0 and rem(x, grid_size * grid_size) != 0 ->
          IO.write("#{y} |")
        rem(x, grid_size * grid_size) == 0 and rem(x, grid_size * grid_size * grid_size) != 0 ->
          IO.write("#{y}\n")
        rem(x, grid_size * grid_size * grid_size) == 0 and x != grid_size * grid_size * grid_size * grid_size ->
          IO.write("#{y}\n")
          IO.puts(
            String.duplicate("-", grid_size * 2) <>
            String.duplicate("+" <> String.duplicate("-", grid_size * 2), grid_size - 1))
        true ->
          IO.write("#{y} ")
        end
    end)
    #IO.gets("Press <ENTER> to continue.")

    if return_board?, do: sudoku
  end

  def easy_board() do
    %Sudoku{
      board: {
        0, 0, 3, 6, 0, 0, 4, 0, 0,
        6, 0, 0, 0, 8, 0, 0, 2, 0,
        0, 9, 0, 0, 0, 5, 0, 0, 7,
        0, 0, 4, 0, 3, 0, 0, 0, 0,
        0, 0, 0, 2, 0, 0, 6, 0, 0,
        2, 0, 0, 0, 0, 7, 0, 0, 5,
        7, 0, 0, 0, 0, 0, 0, 1, 0,
        0, 0, 6, 8, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 9, 2, 0, 0},
      grid_size: 3,
      size: 9
    }
  end
  def hard_board() do
    %Sudoku{
      board: {
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 3, 0, 8, 5,
        0, 0, 1, 0, 2, 0, 0, 0, 0,
        0, 0, 0, 5, 0, 7, 0, 0, 0,
        0, 0, 4, 0, 0, 0, 1, 0, 0,
        0, 9, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 0, 0, 0, 7, 3,
        0, 0, 2, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 4, 0, 0, 0, 9},
      grid_size: 3,
      size: 9
    }
  end
end
