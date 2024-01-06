defmodule Aoc2023.Day20 do
  defmodule Module do
    defstruct [:inputs, :outputs, :type, :state]
  end

  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    initial_state =
      etl_input(part)
      |> process_input()

    {_m, count} =
      for i <- 1..1000, reduce: {initial_state, %{:low => 0, :high => 0}} do
        acc ->
          {s, c} = acc
          propagate_signal([{"button", :low, "broadcaster"}], s, &update_global_count/4, c, i)
      end

    Enum.reduce(count, 1, fn {_, v}, acc -> acc * v end)
  end

  def part2(part \\ :ex2) do
    initial_state =
      etl_input(part)
      |> process_input()

    [rx_input] = Enum.filter(Map.keys(initial_state), &(initial_state[&1].outputs == ["rx"]))
    result = initial_state[rx_input].state |> Enum.map(fn {k, _v} -> {k, 0} end) |> Map.new()

    cycle(initial_state, 1, rx_input, result, false)
    |> Map.values()
    |> list_lcm()
  end

  def process(input) do
    for l <- input, reduce: %{} do
      acc ->
        [input_module, output_modules] =
          String.split(l, " -> ", trim: true)

        {module, type, state} =
          case input_module do
            <<"%"::binary, name::binary>> -> {name, "flip-flop", :off}
            <<"&"::binary, name::binary>> -> {name, "conjunction", %{}}
            "broadcaster" -> {"broadcaster", "broadcast", nil}
          end

        Map.put(acc, module, %Aoc2023.Day20.Module{
          outputs: String.split(output_modules, ", ", trim: true),
          type: type,
          state: state
        })
    end
  end

  def process_input(map) do
    for module <- Map.keys(map), reduce: map do
      acc ->
        inputs =
          Enum.reduce(map, [], fn {k, v}, inneracc ->
            cond do
              k != module and module in v.outputs -> inneracc ++ [k]
              true -> inneracc
            end
          end)

        Map.update(acc, module, nil, fn v ->
          if v.type == "conjunction" do
            %{
              v
              | inputs: inputs,
                state: Enum.zip(inputs, List.duplicate(:low, length(inputs))) |> Map.new()
            }
          else
            %{v | inputs: inputs}
          end
        end)
    end
  end

  def update_global_count(_state, result, signal, _i),
    do: Map.update(result, signal, 0, &(&1 + 1))

  def rx_inputs_high(state, result, _signal, i) do
    [rx_input] = Enum.filter(Map.keys(state), &(state[&1].outputs == ["rx"]))

    for {input, state_signal} <- state[rx_input].state, reduce: result do
      acc ->
        cond do
          acc[input] == 0 and state_signal == :high ->
            Map.put(acc, input, i)

          true ->
            acc
        end
    end
  end

  def propagate_signal([], global_state, _fun, result, _i), do: {global_state, result}

  def propagate_signal([{from_module, signal, module} | rest_queue], global_state, fun, result, i)
      when is_map_key(global_state, module) do
    # |> IO.inspect()
    {out_signal, new_state} =
      update_state(from_module, signal, global_state[module].type, global_state[module].state)

    new_global_state = Map.update!(global_state, module, fn v -> %{v | state: new_state} end)

    add_queue =
      case out_signal do
        nil -> []
        _ -> global_state[module].outputs |> Enum.map(&{module, out_signal, &1})
      end

    update_result = fun.(new_global_state, result, signal, i)
    propagate_signal(rest_queue ++ add_queue, new_global_state, fun, update_result, i)
  end

  def propagate_signal([{_, signal, _} | rest_queue], global_state, fun, result, i) do
    update_result = fun.(global_state, result, signal, i)
    propagate_signal(rest_queue, global_state, fun, update_result, i)
  end

  def update_state(_from_module, signal, "broadcast", state), do: {signal, state}

  def update_state(_from_module, :high, "flip-flop", state), do: {nil, state}

  def update_state(_from_module, :low, "flip-flop", state) do
    case state do
      :off -> {:high, :on}
      :on -> {:low, :off}
    end
  end

  def update_state(from_module, :high, "conjunction", state) do
    new_state = Map.put(state, from_module, :high)

    cond do
      Map.values(new_state) |> Enum.all?(&(&1 == :high)) -> {:low, new_state}
      true -> {:high, new_state}
    end
  end

  def update_state(from_module, :low, "conjunction", state),
    do: {:high, Map.put(state, from_module, :low)}

  def cycle(_global_state, _count, _rx_input, result, true), do: result

  def cycle(global_state, count, rx_input, result, false) do
    {s, r} =
      propagate_signal(
        [{"button", :low, "broadcaster"}],
        global_state,
        &rx_inputs_high/4,
        result,
        count
      )

    f = Enum.count(r, fn {_k, v} -> v > 0 end) == Enum.count(r)
    cycle(s, count + 1, rx_input, r, f)
  end

  def list_lcm([a, b]), do: Aoc2023.lcm(a, b)

  def list_lcm([a, b | rest]) do
    k = Aoc2023.lcm(a, b)
    list_lcm([k | rest])
  end
end
