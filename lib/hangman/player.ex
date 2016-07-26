defmodule Hangman.Player do

  @moduledoc """
  Simple ExActor GenServer module to implement Player.

  The module represents the highest player abstraction, 
  and could be thought of as a producer-consumer. 
  It sits in conjunction with other components between the Game and
  Reduction engines and the Player.handler - a consumer.

  Behind this GenServer lies the intermediary player components which 
  facilitate player game play.  Such as `Player.Action`, `Player.Human`, 
  `Player.Robot`, `Player.Generic`, `Player.FSM`, `Round`, `Strategy`.

  Internally the ExActor keeps a Player FSM as a state to manage 
  event transitions cleanly.

  The module is abstracted away from the specific type of player to focus mainly on
  feeding the Player FSM and returning the appropriate response to the `Player.Handler`.
  """

  use ExActor.GenServer
  require Logger

  alias Hangman.{Player}

  @name __MODULE__

  defstart start_link({player_name, player_type, display, game_pid, event_pid}) do

    true = is_binary(player_name)
    true = is_atom(player_type)
    true = is_boolean(display)
    true = is_pid(game_pid)
    true = is_pid(event_pid)

    args = {player_name, player_type, display, game_pid, event_pid}

    Logger.info "Starting Hangman Player Server"

    # create the FSM abstraction and then initalize it
    fsm = Player.FSM.new |> Player.FSM.initialize(args) 

    initial_state(fsm)
  end


  # The heart of the player server, the proceed request
  defcall proceed, state: fsm do

    # request the next state transition :proceed to player fsm
    {response, fsm} = fsm |> Player.FSM.proceed

    {response, fsm} = case response do
      # if there is no setup data required for the user e.g. [], 
      # as marked during robot guess setup, skip to guess
      {:setup, []} -> fsm |> Player.FSM.guess(nil)
      _ -> {response, fsm}
    end

    set_and_reply(fsm, response)
  end

  
  defcall guess(data), state: fsm do
    {response, fsm} = fsm |> Player.FSM.guess(data)
    set_and_reply(fsm, response)
  end


  defcast stop, do: stop_server(:normal)

end

