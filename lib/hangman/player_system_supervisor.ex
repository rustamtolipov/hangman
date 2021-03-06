defmodule Hangman.Player.System.Supervisor do
  @moduledoc false

  '''
  Module supervises all components necessary for player and 
  strategic player game play including dictionary cache server,
  word pass server, reduction engine, pass writer, 
  and player events and fsm supervisor

  Module is a third line supervisor as it supervises a
  second-line supervisor.
  '''

  use Supervisor
  import Supervisor.Spec
  alias Hangman.{Dictionary, Pass, Reduction}
  require Logger

  @doc """
  Supervisor start and link wrapper function
  """

  @spec start_link(Keyword.t()) :: Supervisor.on_start()
  def start_link(args) do
    _ = Logger.debug("Starting Hangman Player System Supervisor," <> " args: #{inspect(args)}")

    Supervisor.start_link(__MODULE__, args)
  end

  @doc """
  Specifies worker children specifications.  
  These consist of a mix of workers and supervisors.  
  Deploys a strategy of rest for one as these
  process trees are dependant on each other
  and not mutually exclusive
  """

  @callback init(Keyword.t()) :: {:ok, tuple}
  def init(args) do
    children = [
      worker(Dictionary.Cache, [args]),
      worker(Pass.Cache, []),
      worker(Pass.Cache.Writer, []),
      supervisor(Reduction.Engine, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
