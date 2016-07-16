defmodule Hangman.Player.Generic do
  
  @moduledoc """
  Provides Generic player routine implementations used by
  the Player Action protocol
  """
  
  def init(name, game_pid, event_pid) when is_binary(name) 
      and is_bool(display) and is_pid(game_pid) and is_pid(event_pid) do
    
    round = %Round{ id: name, pid: self(), 
                    game_pid: game_pid, event_pid: event_pid }    
  end

  def start(%Round{} = round, type) do
    round = Round.start(round)
    strategy = Strategy.new(type)

    {round, strategy}
  end

  def transition(%Round{} = round) do
    round = Round.transition(round)
    status = Round.status(round)

    {round, status}
  end

end
