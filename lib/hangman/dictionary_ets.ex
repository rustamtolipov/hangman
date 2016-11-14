defmodule Hangman.Dictionary.ETS do
  @moduledoc """
  Module provides access to a dictionary word cache powered by `ETS`. 
  Provides lookup routines to access `words`, `tallys`, and `random` words.
  Handles all ETS specific operations while `Dictionary` serves
  as a wrapper.

  `Dictionary.ETS` loads the dictionary words into `words` and stores them
  into `ETS` via `Dictionary.Ingestion`.  Upon startup, letter frequency 
  `tallies` are computed and stored compactly into `ETS`. Words identified as 
  `random` are tagged and stored as well.
  """

  alias Hangman.{Words, Counter, Dictionary}
  require Logger

  @ets_table_name :dictionary_table

  # Used to insert the word lists and frequency counter tallies, 
  # indexed by word length e.g. 2..28, for both the normal and big 
  # dictionary file sizes
  @possible_length_keys MapSet.new(Dictionary.key_range)

  # Use for admin of random words extract 
  @ets_random_words_key :random_hangman_words
  @random_words_per_list 20
  @min_random_word_length 5
  @max_random_word_length 15


  @spec new :: atom
  def new, do: :ets.new(@ets_table_name, [:bag, :named_table, :public])

  @spec table_name :: :dictionary_table
  def table_name, do: @ets_table_name


  @doc """
  Runs the dictionary ingestion process, loading the data into ETS
  """

  @spec setup(Keyword.t) :: :ok
  def setup(args) do

    case :ets.info(@ets_table_name) do
      :undefined -> Dictionary.Ingestion.run(args)
      _ -> raise HangmanError, "cache already setup!"
    end

    :ok
  end


  # READ

  @doc """
  Get has three modes: `:random`, `:counter`, `:words`

  :random -
  Retrieves all words tagged as random upon startup,
  then randomly chooses count words from this set, and returns
  the shuffled words result.

  :counter - 
  Retrieves dictionary tally counter given word length key

  :words -
  Retrieves words given word length key
  """

  @spec get(:random | :counter | :words, pos_integer) :: 
  [String.t] | Counter.t | Words.t | no_return

  def get(:random, count) 
  when is_integer(count) and count > 0 do

    if count > Dictionary.max_random_words_request do
      raise HangmanError, "requested random words exceeds limit"
    end

    if :ets.info(@ets_table_name) == :undefined do
      raise HangmanError, "table not loaded yet"
    end

    # we use a module constant since the key doesn't change
    ets_key = @ets_random_words_key
      
    fn_reduce_random_words = fn
      {^ets_key, ets_value}, acc ->
        # NOTE: value first and acc second is orders of magnitude faster
        # then reversed
        List.flatten(ets_value, acc)
      _, acc -> acc 
    end

    # Since we are using a bag type, aggregate all random word key values
    randoms = :ets.foldl(fn_reduce_random_words, [], @ets_table_name)


    # double-check the randoms list is unique
    ^randoms = randoms |> Enum.uniq 

    # seed random number generator with random seed

    # crypto method apparently produces genuinely random bytes 
    # w/o unintended side effects
    << a :: 32, b :: 32, c :: 32 >> = :crypto.strong_rand_bytes(12)
    r_seed = {a, b, c}

    _ = :rand.seed(:exsplus, r_seed)
    _ = :rand.seed(:exsplus, r_seed)

    # Note: Its not necessary to seed the random item generator but 
    # doing so ensures our results are really random

    # Let's pad the count value with count + count/10
    # just in case we happen to pull the same random number twice in Enum.random
    # We're assuming there is less than a 10% chance of getting the same random number

    padded_count = count + div(count, 10)

    # Using list comp to retrieve the list of count random words
    randoms = for _x <- 1..padded_count do Enum.random(randoms) end

    # Ensure the list has unique words, shuffle and grab the first "count"
    randoms |> Enum.uniq |> Enum.shuffle |> Enum.take(count)

  end


  def get(:counter, length_key) 
  when is_number(length_key) and length_key > 0 do

    if :ets.info(@ets_table_name) == :undefined do
      raise HangmanError, "table not loaded yet"
    end

    # validate that the key is within our valid set
    case Enum.any?(@possible_length_keys, fn x -> x == length_key end) do
      true -> 
        ets_key = key(:counter, length_key)
        
        # Grab the matching tally counter -- not sure if match_object or lookup is faster
        case :ets.match_object(@ets_table_name, {ets_key, :_}) do
          [] -> raise HangmanError, "counter not found for key: #{length_key}"
          [{_key, ets_value}] -> 
            _counter = :erlang.binary_to_term(ets_value)
        end
      false -> raise HangmanError, "key not in set of possible keys!"
    end
  end

  
  def get(:words, length_key) do

    if :ets.info(@ets_table_name) == :undefined do
      raise HangmanError, "table not loaded yet"
    end

    # create words key given length
    ets_key = key(:words, length_key)
      
    fn_reduce_words = fn
      {^ets_key, ets_value}, acc ->
      # we pin to specified ets {words, length} key
        Words.add(acc, ets_value) 
      _, acc -> acc 
    end

    # since we are using the bag type, aggregate all words value given 
    # the same words_key reduce into a single Words type
    _words = :ets.foldl(fn_reduce_words, Words.new(length_key), @ets_table_name)
  end

  # UPDATE


  @doc """
  Put function inserts data into the ETS via three modes: words, random, counter

  :words - 
  For each words list, insert into ets

  :random - 
  For each list of words and length key, within valid
  length key sizes, extract @random_words_per_list count words,
  dedup extracted set and insert into ets

  :counter -
  Inserts verified counter structure into ets

  Example key is {:counter, 8}
  Example {length, counter} is: {8,
      %Counter{entries: %{"a" => 14490, "b" => 4485, "c" => 7815,
      "d" => 8046, "e" => 19600, "f" => 2897, "g" => 6009, "h" => 5111,
      "i" => 15530, "j" => 384, "k" => 2628, "l" => 11026, "m" => 5793,
      "n" => 12186, "o" => 11462, "p" => 5763, "q" => 422, "r" => 14211,
      "s" => 16560, "t" => 11870, "u" => 7377, "v" => 2156, "w" => 2313,
      "x" => 662, "y" => 3395, "z" => 783}}}
  
  """

  @spec put(:words | :random | :counter, atom, 
            {pos_integer, [String.t] | Counter.t}) :: :ok | no_return
  
  def put(:words, table_name, {k, list})
  when is_list(list) and is_binary(hd(list)) do

    ets_key = key(:words, k)
    
    # record actual words size
    words_size = Kernel.length(list)

    # convert words into binary for compactness
    bin_words = :erlang.term_to_binary(list) 
    ets_value = {bin_words, words_size}

    case :ets.insert(table_name, {ets_key, ets_value}) do
      true -> :ok
    end

  end


  def put(:random, table_name, {length, words_list}) do
    cond do
      length >= @min_random_word_length and length <= @max_random_word_length ->
        # seed random number generator with random seed
        << a :: 32, b :: 32, c :: 32 >> = :crypto.strong_rand_bytes(12)
        r_seed = {a, b, c}
        
        _ = :rand.seed(:exsplus, r_seed)
        _ = :rand.seed(:exsplus, r_seed)
      
        # Grab @random_words_per_list random words
      
        rand = for _x <- 1..@random_words_per_list do 
          Enum.random(words_list) 
        end
      
        # Remove duplicate random words
        random_words = rand |> Enum.sort |> Enum.dedup

        case :ets.insert(table_name, {@ets_random_words_key, random_words}) do
          true -> :ok
        end

        #Logger.debug "hangman random words, length_key #{length}: #{inspect random_words}"

      true -> nil
    end

    :ok
  end


  def put(:counter, _table_name, {0, nil}), do: :ok

  def put(:counter, table_name, {length, %Counter{} = counter}) do

    _ = Logger.debug "Dictionary.ETS.put, table is #{table_name} length is #{length}, counter is #{inspect counter}"

    ets_key = key(:counter, length)
    ets_value = :erlang.term_to_binary(counter)

    case :ets.insert(table_name, {ets_key, ets_value}) do
      true -> :ok
    end
  end


  @doc "Loads ets into memory via ets file"
  @spec load(binary) :: :dictionary_table | no_return
  def load(path) when is_binary(path) do

    _ = Logger.debug("Loading ets table from file")

    path = path |> String.to_charlist

    case :ets.file2tab(path, [verify: true]) do
      {:ok, @ets_table_name} -> @ets_table_name
      error -> raise HangmanError, "Unable to load table #{inspect error}"
    end
  end


  @doc "Dumps ets table into an ets file"
  @spec dump(atom, binary) :: :ok | no_return
  def dump(table, path) when is_atom(table) and is_binary(path) do
    _ = Logger.debug("Dumping ets table to file")

    path = path |> String.to_charlist

    case :ets.tab2file(table, path) do
      :ok -> :ok
      error -> raise HangmanError, "Unable to dump ets table #{inspect error}"
    end
  end

  # Simple helpers to generate tuple keys for ets based on word length size
  @spec key(:words, pos_integer) :: {atom, pos_integer}
  defp key(:words, length_key) do
    true = Enum.any?(@possible_length_keys, fn x -> x == length_key end)
    _ets_key = {:words, length_key}
  end


  @spec key(:counter, pos_integer) :: {atom, pos_integer}
  defp key(:counter, length_key) do
    true = Enum.any?(@possible_length_keys, fn x -> x == length_key end)
    _ets_key = {:counter, length_key}
  end

end
