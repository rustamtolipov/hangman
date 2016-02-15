defmodule Hangman.FSM.Test do
	use ExUnit.Case

  alias Hangman.{Cache, Player, Player.FSM}

	test "synchronous player through 1 game test" do
		
		{:ok, _pid} = Hangman.Supervisor.start_link()

		player_name = "wall_e"
		secrets = ["cumulate"]

 	  IO.puts "\n1) Starting regular WALL-e \n"		

		game_pid = Cache.get_server(player_name, secrets)

    {:ok, player_fsm_pid} = 
      Player.Supervisor.start_child(game_pid, player_name, :robot)

		#:sys.trace(player_fsm_pid, true)

		{:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "-------E; score=1; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid) 

    assert "-----A-E; score=2; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)	    

    assert "-----ATE; score=3; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)
    
    assert "-----ATE; score=4; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "-----ATE; score=5; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "----LATE; score=6; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "C---LATE; score=7; status=KEEP_GUESSING" = reply

    {:game_keep_guessing, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "C-M-LATE; score=8; status=KEEP_GUESSING" = reply

    {:game_won, reply} = FSM.wall_e_guess(player_fsm_pid)

    assert "CUMULATE; score=8; status=GAME_WON" = reply

    {:game_over, reply} = FSM.wall_e_guess(player_fsm_pid)

 	  assert "Game Over! Average Score: 8.0, # Games: 1, Scores:  (CUMULATE: 8)" = reply

    {:game_reset, reply} = FSM.wall_e_guess(player_fsm_pid)

    IO.puts "Game Over! Average Score: 8.0, # Games: 1, Scores:  (CUMULATE: 8)"

    IO.puts "Asserts successfully passed, #{reply}"

 	  FSM.stop(player_fsm_pid)


 	  # Game 2 -- ASYNC ROBOT!! turbo wall_e

 	  IO.puts "\n2) Starting turbo WALL-e \n"
		player_name = "turbo wall_e"
 	  
		secrets = ["cumulate"]

		game_pid = Cache.get_server(player_name, secrets)

    {:ok, player_fsm_pid} = 
      Player.Supervisor.start_child(game_pid, player_name, :robot)

 	  IO.puts "\nturbo WALL-e....guessing \n"

		#:sys.trace(player_fsm_pid, true)

		:ok = FSM.turbo_wall_e_guess(player_fsm_pid)

		# sleep for 2 seconds :)
		receive do
			after 2000 -> nil
		end

		{_, reply} = FSM.sync_status(player_fsm_pid)

		IO.puts "\nturbo WALL-e status: #{reply}"

		# Game 3 -- HUMAN!! socrates

 	  IO.puts "\n3) Starting Socrates human guessing player with 2 games \n"		

		player_name = "socrates"
 	  
		secrets = ["cumulate", "avocado"]

		game_pid = Cache.get_server(player_name, secrets)			

    {:ok, player_fsm_pid} = 
      Player.Supervisor.start_child(game_pid, player_name, :human)

		#:sys.trace(player_fsm_pid, true)

		reply = FSM.socrates_proceed(player_fsm_pid)

		IO.puts "Game 1: #{reply}"			

		reply = FSM.socrates_guess(player_fsm_pid, "e")

		IO.puts "Game 1: #{reply}"	

		reply = FSM.socrates_guess(player_fsm_pid, "a")

		IO.puts "Game 1: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "t")

		IO.puts "Game 1: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "o")

		IO.puts "Game 1: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "i")

		IO.puts "Game 1: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "l")

		IO.puts "Game 1: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "c")

		IO.puts "Game 1: #{reply}"

		assert "Player socrates, Round 8, C---LATE; score=7; status=KEEP_GUESSING. 3 weighted letter choices :  u:2 m*:1 p:1 (* robot choice)" 
			= reply

		reply = FSM.socrates_guess(player_fsm_pid, "m")

		assert "Player socrates, Round 9: Last word left: cumulate" = reply

		reply = FSM.socrates_win(player_fsm_pid)

		IO.puts "Game 1: #{reply}\n"

		reply = FSM.socrates_proceed(player_fsm_pid)

		IO.puts "Game 2: #{reply}"	

		reply = FSM.socrates_guess(player_fsm_pid, "e")

		IO.puts "Game 2: #{reply}"		

		reply = FSM.socrates_guess(player_fsm_pid, "a")

		IO.puts "Game 2: #{reply}"		

		reply = FSM.socrates_guess(player_fsm_pid, "s")

		IO.puts "Game 2: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "r")

		IO.puts "Game 2: #{reply}"

		reply = FSM.socrates_guess(player_fsm_pid, "i")

		IO.puts "Game 2: #{reply}"	

		reply = FSM.socrates_guess(player_fsm_pid, "d")

		IO.puts "Game 2: #{reply}"

		reply = FSM.socrates_win(player_fsm_pid)

		IO.puts "Game 2: #{reply}"

		reply = FSM.socrates_proceed(player_fsm_pid)

		IO.puts "Game 2: #{reply}"

	end
end

