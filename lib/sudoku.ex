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

  def full?(%Sudoku{size: size} = sudoku) do
    for r <- 0..size - 1,
        c <- 0..size - 1 do
      {r, c}
    end
    |> Enum.all?(fn {r, c} -> get(sudoku, r, c) != 0 end)
  end

# def solucao_sudoku():
# 1. Se estiver com tudo preenchido, imprima a solução e termine execução.
# 2. Apague todas as pencil marks do que não for possível por conta de linhas/colunas/grupos já preenchidos.
# 3. Se tiver casa não preenchida e sem nenhuma possibilidade, saia da rotina.
# 4. Escolha uma casa qualquer. Para cada possibilidade (das pencil marks) da casa escolhida:
# 4.1. preencha a casa com a possibilidade.
# 4.2. chame solucao_sudoku() recursivamente.

  def get_pencil_marks(%Sudoku{size: size} = sudoku) do
    for r <- 0..size - 1,
        c <- 0..size - 1,
        v <- 1..size,
        valid_put?(sudoku, r, c, v), do: {r, c, v}
  end

  def solve(%Sudoku{} = sudoku, pencil_marks \\ nil, first_sudoku \\ nil, first_mark \\ nil) do
    cond do
      full?(sudoku) ->
        IO.puts("full sudoku")
        sudoku

      pencil_marks == nil ->
        # first run: build first pencil_marks, store first sudoku and firstmark called
        IO.puts("pencil marks == nil")
        pencil_marks = get_pencil_marks(sudoku)
        IO.inspect(pencil_marks, label: "cold run pencil marks", limit: 2000)
        IO.gets("waiting...")
        first_sudoku = sudoku
        first_mark = List.first(pencil_marks)
        solve(sudoku, pencil_marks, first_sudoku, first_mark)

      pencil_marks == [] ->
        # end of one run
        IO.puts("pencil marks == []")
        IO.inspect(first_sudoku, label: "first sudoku")
        IO.gets("waiting...")

        new_pencil_marks = get_pencil_marks(first_sudoku) |> Enum.reject(fn m -> m == first_mark end)
        IO.inspect(new_pencil_marks, label: "new first mark")
        IO.gets("waiting...")

        {first_r, first_c, _} = first_mark
        put(first_sudoku, first_r, first_c, 0)
        |> solve(new_pencil_marks, first_sudoku, new_pencil_marks)

      true ->
        IO.puts("true")
        [head | tail] = pencil_marks

        {first_r, first_c, first_v} = head
        IO.puts("Writing: row = #{first_r}, col = #{first_c}, value = #{first_v}")
        new_sudoku = put(sudoku, first_r, first_c, first_v)
        print(new_sudoku)
        IO.gets("waiting...")

        # Update remaining pencil marks, considering the new input
        new_pencil_marks = Enum.filter(tail, fn {r, c, v} -> valid_put?(new_sudoku, r, c, v) end)
        IO.inspect(new_pencil_marks, label: "inside run renewed pencil marks", limit: 2000)
        IO.gets("waiting...")

        solve(new_sudoku, new_pencil_marks, first_sudoku, first_mark)
    end
  end

  def print(%Sudoku{board: board, size: size}) do
    board
    |> Tuple.to_list()
    |> Enum.chunk_every(size)
    |> Enum.map(fn l -> Enum.join(l, ", ") |> IO.puts() end)
  end

  def s() do
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
  def s0() do
    %Sudoku{
      board: {
        7, 4, 3, 9, 5, 1, 6, 8, 2,
        1, 6, 2, 4, 8, 7, 3, 9, 5,
        9, 5, 8, 6, 3, 2, 7, 1, 4,
        2, 1, 9, 8, 7, 3, 5, 4, 6,
        3, 7, 4, 5, 6, 9, 1, 2, 8,
        5, 8, 6, 1, 2, 4, 9, 7, 3,
        4, 9, 5, 2, 1, 6, 8, 3, 7,
        8, 2, 7, 3, 9, 5, 4, 6, 1,
        6, 3, 1, 7, 4, 8, 2, 5, 9},
        grid_size: 3,
        size: 9
    }
  end
end
