defmodule Barquinhos.Game do
  @moduledoc false

  @board_size {9, 9}

  defstruct turn: nil, players: [], status: :start, board_size: @board_size

  # TO-DO: use this alias:
  # Keeped commented because we doesn't use yet
  # alias Barquinhos.Game.{Board, Player, Ship}

  def new do
    %__MODULE__{}
  end

  def add_player(%__MODULE__{} = struct, player) do
    players = [player | struct.players]

    assigns(struct, :players, players)
  end

  def add_board_size(%__MODULE__{} = struct, x, y) do
    size = {x, y}

    assigns(struct, :board_size, size)
  end

  # TO-DO:
  # passing the parameters and an options
  # get each parameter using Keyword.fetch
  # here we need to register the current player shot and register this shot in the enemy board
  # this function it couldn't be necessary to implement this approach but
  # to keep the consistency of our public interface its high recommended
  def add_ship(%__MODULE__{} = struct, player_id, ship) do
    with %{false: other_players, true: [player]} <-
           Enum.group_by(struct.players, &(&1.id == player_id)) do
      # TO-DO: need a better interface to add and update these:
      ships = [ship | player.board.ships]
      board = assigns(player.board, :ships, ships)
      player = assigns(player, :board, board)

      players = [player | other_players]

      assigns(struct, :players, players)
    end
  end

  # TO-DO:
  # passing the parameters and an options
  # get each parameter using Keyword.fetch
  # here we need to register the current player shot and register this shot in the enemy board
  def attack(%__MODULE__{} = struct, player_id, shot) do
    with %{false: other_players, true: [player]} <-
           Enum.group_by(struct.players, &(&1.id == player_id)) do
      # TO-DO: need a better interface to add and update these:
      shots = [shot | player.board.shots]
      board = assigns(player.board, :shots, shots)
      player = assigns(player, :board, board)

      players = [player | other_players]

      assigns(struct, :players, players)
    end
  end

  defp assigns(attrs, key, value, default_value \\ nil) do
    Map.update(attrs, key, default_value, fn _ -> value end)
  end
end
