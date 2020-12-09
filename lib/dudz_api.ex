defmodule DudzApi do
  def check(url, random_sudoku_size, random_sudoku_non_empty_cells) do

    # Generating random sudoku according to parameters
    IO.puts("Sudoku aleatório gerado (tamanho=#{random_sudoku_size}x#{random_sudoku_size}, células_não_nulas=#{random_sudoku_non_empty_cells}):")
    random_sudoku = Sudoku.random(random_sudoku_size, random_sudoku_non_empty_cells)
    Sudoku.print(random_sudoku)

    # Preparing query string
    %Sudoku{board: board} = random_sudoku
    query_string = board |> Tuple.to_list() |> Enum.join("")

    # Sending "get" request
    IO.puts("\nEnviando puzzle para #{url}...")
    HTTPoison.start
    response = HTTPoison.get! url, [], params: %{q: query_string}

    # Decoding response body to obtain "solucao"
    {:ok, %{"solucao" => solution_string}} = response.body |> Poison.decode()

    # Bulding compatible struct and printing giving solution
    board = solution_string |> String.graphemes() |> Enum.map(fn s -> String.to_integer(s) end) |> List.to_tuple()

    # Printing solution given
    IO.puts("\nResposta recebida...")
    solution_given = %Sudoku{board: board, grid_size: trunc(:math.sqrt(random_sudoku_size)), size: random_sudoku_size}
    Sudoku.print(solution_given)

    # Validating solution given
    if Sudoku.valid_sudoku?(solution_given) do
      IO.puts("\nResposta correta!")
    else
      IO.puts("\nResposta incorreta!")
    end
  end

  def run() do
      Enum.map(1..100, fn _x ->
        spawn(fn -> check("https://dudz.com.br/cgi-bin/sudoku.cgi", 9, 10) end)
      end)
  end
end
