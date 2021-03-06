defmodule Hangman.Reduction.Engine.Pool do
  @moduledoc """
  Module is a `Supervisor` that supervises a `pool` of 
  word `Reduction.Engine` workers
  """

  use Supervisor
  alias Hangman.Reduction

  # `Supervisor` start link wrapper function. Accepts `pool` size argument.

  # @spec start_link(pos_integer) :: Supervisor.on_start
  def start_link(pool_size) do
    Supervisor.start_link(__MODULE__, pool_size)
  end

  @doc """
  For each `worker` in `pool`, creates a reducer worker process
  `specification` to be supervised.
  """

  @callback init(pool_size :: pos_integer) :: {:ok, tuple}
  def init(pool_size) do
    processes =
      for worker_id <- 1..pool_size do
        # Create worker spec for each value
        worker(
          Reduction.Engine.Worker,
          [worker_id],
          id: {:reduction_engine_worker, worker_id}
        )
      end

    # Supervise each of above defined workers
    supervise(processes, strategy: :one_for_one)
  end
end
