defmodule Hangman.Player.Group.Supervisor do
	use Supervisor

  @moduledoc """
  Module is a second line supervisor as it supervises
  two first-line supervisors.

  Module supervises those player supervisors which dynamically
  start workers, namely player supervisor and player events supervisor
  """

  require Logger

  import Supervisor.Spec

	@name __MODULE__

  @doc """
  Supervisor start and link wrapper function
  """

  @spec start_link :: Supervisor.on_start
	def start_link do
    args = {}

		Logger.info "Starting Hangman Player Group Supervisor," <> 
      " args: #{inspect args}"

    Supervisor.start_link(@name, args)
	end

  @doc """
  Specifies worker supervisor specifications.  
  Deploys a strategy of rest for one
  """
  
  @callback init(term) :: {:ok, tuple}
	def init(_) do

    children = [
      supervisor(Hangman.Player.Supervisor, []),
      supervisor(Hangman.Player.Events.Supervisor, [])
    ]

		supervise(children, strategy: :rest_for_one)
	end

end