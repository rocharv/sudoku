defmodule Sudoku.Board do
  defstruct data: {}, grid_size: 0, size: {}

  def new (%Sudoku.Board{size: {rows, cols}} = board) do
    data = Tuple.duplicate(0, rows * cols)
    %Sudoku.Board{board | data: data}
  end

  def get(%Sudoku.Board{data: data, size: {_, board_cols}}, row, col) do
    elem(data, (row - 1) * board_cols + col - 1)
  end

  def put(%Sudoku.Board{data: data, size: {_, board_cols}} = board, row, col, value) do
    new_data = put_elem(data, (row - 1) * board_cols + col - 1, value)
    %Sudoku.Board{board | data: new_data}
  end

  def full?(%Sudoku.Board{size: {board_rows, board_cols}} = board) do
    for r <- 1..board_rows,
        c <- 1..board_cols do
      {r, c}
    end
    |> Enum.find(false, fn {r, c} -> get(board, r, c) == 0 end) == false
  end

  def valid_put?(%Sudoku.Board{grid_size: grid_size, size: {board_rows, board_cols}} = board, row, col, value) do
    cond do
      # non-empty
      get(board, row, col) != 0 ->
        false

      # row validation
      Enum.any?(1..board_cols, fn c -> get(board, row, c) == value end) ->
        false

      # column validation
      Enum.any?(1..board_rows, fn r -> get(board, r, col) == value end) ->
        false

      # grid validation
      true ->
        grid_fst_row = div(row - 1, grid_size) * grid_size + 1
        grid_lst_row = grid_fst_row + grid_size - 1
        grid_fst_col = div(col - 1, grid_size) * grid_size + 1
        grid_lst_col = grid_fst_col + grid_size - 1

        for r <- grid_fst_row..grid_lst_row,
            c <- grid_fst_col..grid_lst_col do
              {r, c}
            end
        |> Enum.find(false, fn {r, c} -> get(board, r, c) == value end) == false
    end
  end

  def solve(%Sudoku.Board{size: {board_rows, board_cols}} = board) do
    cond do
      full?(board) ->
        board

      true ->
        insertion =
          for r <- 1..board_rows,
              c <- 1..board_cols, v <- 1..9 do
            {r, c, v}
          end
          |> Enum.find(nil, fn {r, c, v} -> valid_put?(board, r, c, v) end)

        if insertion != nil do
          {r, c, v} = insertion
          IO.inspect(insertion)
          put(board, r, c, v)
          |> solve()
        else
          board
        end
    end
  end

  def print(%Sudoku.Board{data: data, size: {_, board_cols}}) do
    data
    |> Tuple.to_list()
    |> Enum.chunk_every(board_cols)
    |> Enum.map(fn l -> Enum.join(l, ", ") |> IO.puts() end)
  end
end
