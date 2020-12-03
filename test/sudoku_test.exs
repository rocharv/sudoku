defmodule SudokuTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  doctest Sudoku

  setup do
    # Testing boards
    {:ok,
      board_new:
        %Sudoku{
          board: {
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0},
            grid_size: 3,
            size: 9
        },
      board0:
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
        },
      board1:
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
        },
      board1_put:
        %Sudoku{
          board: {
            0, 0, 3, 6, 0, 0, 4, 0, 0,
            6, 0, 0, 0, 8, 0, 0, 2, 0,
            0, 9, 0, 0, 0, 5, 0, 0, 7,
            0, 0, 4, 0, 3, 0, 0, 0, 0,
            0, 0, 0, 2, 4, 0, 6, 0, 0,
            2, 0, 0, 0, 0, 7, 0, 0, 5,
            7, 0, 0, 0, 0, 0, 0, 1, 0,
            0, 0, 6, 8, 0, 0, 0, 0, 0,
            0, 1, 0, 0, 0, 9, 2, 0, 0},
          grid_size: 3,
          size: 9
        },
      board2:
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
    }
  end

  test "Sudoku new function test", context do
    assert Sudoku.new(%Sudoku{size: 9}) == context[:board_new]
  end

  test "Sudoku get function test", context do
    assert Sudoku.get(context[:board0], 0, 0) == 7
    assert Sudoku.get(context[:board0], 0, 1) == 4
    assert Sudoku.get(context[:board0], 0, 7) == 8
    assert Sudoku.get(context[:board0], 0, 8) == 2
    assert Sudoku.get(context[:board0], 4, 4) == 6
    assert Sudoku.get(context[:board0], 8, 0) == 6
    assert Sudoku.get(context[:board0], 8, 1) == 3
    assert Sudoku.get(context[:board0], 8, 7) == 5
    assert Sudoku.get(context[:board0], 8, 8) == 9

    assert_raise ArgumentError, fn ->
      Sudoku.get(context[:board0], 0, 9)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.get(context[:board0], 9, 0)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.get(context[:board0], 0, -1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.get(context[:board0], -1, 0)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.get(context[:board0], -1, -1)
    end
  end

  test "Sudoku put function test", context do
    assert Sudoku.put(context[:board1], 4, 4, 4) == context[:board1_put]

    assert_raise ArgumentError, fn ->
      Sudoku.put(context[:board0], 0, 9, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.put(context[:board0], 9, 0, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.put(context[:board0], 9, 9, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.put(context[:board0], 0, 0, 10)
    end
  end

  test "Sudoku valid_put? function test", context do
    assert Sudoku.valid_put?(context[:board1], 0, 0, 1) == true
    assert Sudoku.valid_put?(context[:board1], 0, 0, 2) == false
    assert Sudoku.valid_put?(context[:board1], 0, 0, 3) == false
    assert Sudoku.valid_put?(context[:board1], 0, 0, 4) == false
    assert Sudoku.valid_put?(context[:board1], 0, 0, 5) == true
    assert Sudoku.valid_put?(context[:board1], 0, 0, 6) == false
    assert Sudoku.valid_put?(context[:board1], 0, 0, 7) == false
    assert Sudoku.valid_put?(context[:board1], 0, 0, 8) == true
    assert Sudoku.valid_put?(context[:board1], 0, 0, 9) == false

    assert Sudoku.valid_put?(context[:board1], 4, 4, 1) == true
    assert Sudoku.valid_put?(context[:board1], 4, 4, 2) == false
    assert Sudoku.valid_put?(context[:board1], 4, 4, 3) == false
    assert Sudoku.valid_put?(context[:board1], 4, 4, 4) == true
    assert Sudoku.valid_put?(context[:board1], 4, 4, 5) == true
    assert Sudoku.valid_put?(context[:board1], 4, 4, 6) == false
    assert Sudoku.valid_put?(context[:board1], 4, 4, 7) == false
    assert Sudoku.valid_put?(context[:board1], 4, 4, 8) == false
    assert Sudoku.valid_put?(context[:board1], 4, 4, 9) == true

    assert Sudoku.valid_put?(context[:board1], 6, 2, 3) == false
    assert Sudoku.valid_put?(context[:board1], 6, 4, 7) == false

    assert_raise ArgumentError, fn ->
      Sudoku.valid_put?(context[:board1], 0, 9, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.valid_put?(context[:board1], 9, 0, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.valid_put?(context[:board1], 9, 9, 1)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.valid_put?(context[:board1], 0, 0, 10)
    end
    assert_raise ArgumentError, fn ->
      Sudoku.valid_put?(context[:board1], 0, 0, 0)
    end
  end

  test "Sudoku print function test", context do
    assert capture_io(fn -> Sudoku.print(context[:board0]) end) ==
      ~s"""
      7, 4, 3, 9, 5, 1, 6, 8, 2
      1, 6, 2, 4, 8, 7, 3, 9, 5
      9, 5, 8, 6, 3, 2, 7, 1, 4
      2, 1, 9, 8, 7, 3, 5, 4, 6
      3, 7, 4, 5, 6, 9, 1, 2, 8
      5, 8, 6, 1, 2, 4, 9, 7, 3
      4, 9, 5, 2, 1, 6, 8, 3, 7
      8, 2, 7, 3, 9, 5, 4, 6, 1
      6, 3, 1, 7, 4, 8, 2, 5, 9
      """
  end
end
