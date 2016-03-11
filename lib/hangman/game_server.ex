defmodule Game.Server do
	use GenServer
  
  require Logger
	
	@moduledoc """
  Module implements `Hangman` `Game` server using `GenServer`.
  Wraps `Game` abstraction as server state.  Runs 
  each `game` or set of `games` sequentially

	Interacts with client `player` through public interface and
	maintains `game` state
	"""
  
  @type id :: String.t
  
	@vsn "0"
	@name __MODULE__

	@max_wrong 5
  
	#####
	# External API
  
  
	@doc """
	Start public interface method with `secret(s)`
	"""
  
  @spec start_link(String.t, (String.t | [String.t]), 
                   pos_integer) :: {:ok, pid}
	def start_link(player_name, secret, max_wrong \\ @max_wrong) do
		Logger.info "Starting Hangman Game Server"
		args = Game.load(player_name, secret, max_wrong)
		options = [name: via_tuple(player_name)] #,  debug: [:trace]]
    
		GenServer.start_link(@name, args, options)
	end
  
  @doc """
  Routine returns game server `pid` from process registry using `gproc`
  If not found, returns `:undefined`
  """
  
  @spec whereis(id) :: pid | :atom
	def whereis(id_key) do
    :gproc.whereis_name({:n, :l, {:hangman_server, id_key}})
	end
  
  # Used to register / lookup process in process registry via gproc
  @spec via_tuple(id) :: tuple
	defp via_tuple(id_key) do
		{:via, :gproc, {:n, :l, {:hangman_server, id_key}}}
	end
  
  @doc """
  Loads new `game` into server process. 
  Used primarily by `Game.Pid.Cache`
  """
  
  @spec load(pid, id, (String.t | [String.t]), pos_integer) :: :ok
	def load(game_pid, id_key, secret, max_wrong \\ @max_wrong)
  
	def load(game_pid, id_key, secret, max_wrong) when is_binary(secret) do
		GenServer.cast game_pid, {:load_game, id_key, secret, max_wrong}
	end
  
	def load(game_pid, id_key, secrets, max_wrong) when is_list(secrets) do
		GenServer.cast game_pid, {:load_games, id_key, secrets, max_wrong}
	end
  
  @doc """
  Issues guess `letter` or `word` request, returns guess `result`

  Internally, runs `guess` against game `secret`. Updates `Hangman` pattern, status, and
  other game recordkeeping structures.

  Guesses follow two types

    * `{:guess_letter, letter}` - 	If correct, 
    returns the `:correct_letter` data tuple along with game info
	  otherwise, returns the `:incorrect_letter` data tuple along with game info

    * `{:guess_word, word}` - 	If correct, returns 
    the `:correct_word` data tuple along with game info
	  If incorrect, returns the :incorrect_word data tuple with game info
	  
  """
  
  @spec guess(pid, Guess.t) :: tuple
	def guess(game_pid, {:guess_letter, letter})
  when is_binary(letter) do
		GenServer.call game_pid, {:guess_letter, letter}
	end
    
	def guess(game_pid, {:guess_word, word})
  when is_binary(word) do
		GenServer.call game_pid, {:guess_word, word}
	end
  
  @doc """
  Retrieves `Game` status data
  """
  
  @spec status(pid) :: tuple
	def status(game_pid) do
		GenServer.call game_pid, :game_status
	end
  
  @doc """
  Retrieves `Game` secret length
  """
  
  @spec secret_length(pid) :: tuple
	def secret_length(game_pid) do
		GenServer.call game_pid, :secret_length
	end
  
  '''
	def another_game(secret, max_wrong \\ 5) when is_binary(secret) do
	GenServer.cast @name, {:another_game, secret, max_wrong}
	end
  '''
  
  @doc """
  Issues request to stop `GenServer`
  """
  
  @spec stop(pid) :: tuple
	def stop(game_pid) do
		GenServer.call game_pid, :stop
	end
  
	#####
	# GenServer implementation
  
  @docp """
  GenServer callback to initalize server process
  """
  
  #@callback init(Game.t) :: tuple
	def init(game) do
		{:ok, game}
	end
  
	@docp """
	Loads a new `Game`
	"""
  
#  @callback handle_cast(tuple, Game.t) :: tuple
	def handle_cast({:load_game, id_key, secret, max_wrong}, _game) do
		game = Game.load(id_key, secret, max_wrong)
    
		{:noreply, game}
	end
  
	@docp """
	Loads a set of games
	"""
  
#  @callback handle_cast(tuple, Game.t) :: tuple  
	def handle_cast({:load_games, id_key, secret, max_wrong}, _game) do
		game = Game.load(id_key, secret, max_wrong)
		
		{ :noreply, game }
	end
  
  
	@docp """
	{:guess_letter, letter}
	Guess the specified letter and update the pattern state accordingly

  Returns result data tuple
	"""
  
#  @callback handle_call(Guess.t, tuple, Game.t) :: tuple
	def handle_call(guess = {:guess_letter, _letter}, _from, 
                  game) do
    
    {game, result} = Game.guess(game, guess)
    
		{ :reply, result, game }
	end
  
	@docp """
	{:guess_word, word}
	Guess the specified word and update the pattern state accordingly
  
  Returns result data tuple
	"""
  
#  @callback handle_call(Guess.t, tuple, Game.t) :: tuple
	def handle_call(guess = {:guess_word, _word}, _from, 
                  game) do
    
    {game, result} = Game.guess(game, guess)
		{ :reply, result, game }
	end
  
	@docp """
	Returns the game status text
	"""

#  @callback handle_call(:atom, tuple, Game.t) :: tuple
	def handle_call(:game_status, _from, game) do
		{ :reply, Game.status(game), game }
	end
  
	@docp """
	Returns the hangman secret length
	"""
  
#  @callback handle_call(:atom, tuple, Game.t) :: tuple
	def handle_call(:secret_length, _from, game) do
		{_, _, status_text} = Game.status(game)
		length = String.length(game.secret)
    
		# Let's piggyback the round status text with the secret length value
    
		{ :reply, {game.id, :secret_length, length, status_text}, game }
	end
  
	@docp """
	Stops the server is a normal graceful way
	"""
  
#  @callback handle_call(:atom, tuple, Game.t) :: tuple
	def handle_call(:stop, _from, game) do
		{ :stop, :normal, {:ok, game.id}, game }
	end
  
  
  _ = """
  def handle_cast({:another_game, secret, max_wrong}, game) do
  
  # Reset the game state for use for another game by client
  pattern = String.duplicate(@mystery_letter, String.length(secret))
  
  game = %Game{secret: String.upcase(secret), max_wrong: max_wrong, pattern: pattern}
  
  game = %Game{ game | correct_letters: MapSet.new, 
  incorrect_letters: MapSet.new, 
  incorrect_words: MapSet.new}
  
  { :noreply, game }
  
  end
  """
  
  '''
  @docp "Used for debugging purposes, returns game data of server process"
  @spec format_status(term, [...]) :: [...]
	defp format_status(_reason, [ _pdict, game ]) do
		[data: [{'State', "The current hangman server state is {inspect game} and {Game.status(game)}"}]]
	end
  '''
  
	@docp """
	Terminates the `game` server
	No special cleanup other than refreshing the state
	"""
  
#  @callback terminate(term, term) :: :ok
	def terminate(_reason, _state) do
		Logger.info "Terminating Hangman Game Server"
		:ok
	end
  
end
