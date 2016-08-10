defmodule Hangman.Player.Events.Test do
  use ExUnit.Case, async: false

  alias Hangman.{Player, Event}

  setup_all do
    IO.puts "Player Events Test"
    :ok
  end

  test "inital events server setup" do

#    {:ok, _epid} = Event.Manager.start_link()

    key = "polarbear"

    # Get event server pid next
    {:ok, _lpid} = Player.Logger.Supervisor.start_child(key)
    {:ok, _apid} = Player.Alert.Supervisor.start_child(key, nil)

    Event.Manager.async_notify({:start, key, 1})
    Event.Manager.async_notify({:register, key, {1, 8}})

    payload = {{:guess_letter, "a"}, 1}
    Event.Manager.async_notify({:guess, key, payload})
                              
    payload = {1, 1, "my head is warm"}
    Event.Manager.async_notify({:status, key, payload})

    payload = {{:guess_letter, "f"}, 1}
    Event.Manager.async_notify({:guess, key, payload})

    payload = {1, 2, "three blind mice"}
    Event.Manager.async_notify({:status, key, payload})

    payload = {{:guess_letter, "e"}, 1}
    Event.Manager.async_notify({:guess, key, payload})

    payload = {1, 3, "geronimo it's snowing"}
    Event.Manager.async_notify({:status, key, payload})
    
    payload = {{:guess_letter, "h"}, 1}
    Event.Manager.async_notify({:guess, key, payload})

    payload = {1, 4, "equidistant points"}
    Event.Manager.async_notify({:status, key, payload})
    
    payload = {{:guess_letter, "l"}, 1}
    Event.Manager.async_notify({:guess, key, payload})

    payload = {1, 5, "invisible sun"}
    Event.Manager.async_notify({:status, key, payload})
    
    payload = {{:guess_letter, "k"}, 1}
    Event.Manager.async_notify({:guess, key, payload})

    payload = {1, 6, "folk songs"}
    Event.Manager.async_notify({:status, key, payload})
    
    payload = "game over summary goes here"
    Event.Manager.async_notify({:games_over, key, payload})
  end

end
