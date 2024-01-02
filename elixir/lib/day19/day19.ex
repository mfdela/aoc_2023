defmodule Aoc2023.Day19 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    {workflows, parts} = etl_input(part)

    for p <- parts, reduce: 0 do
      acc ->
        case map_reduce_wf(workflows, "in", p) do
          "A" -> acc + Enum.sum(p)
          _ -> acc
        end
    end
  end

  def part2(part \\ :ex2) do
    {workflows, _parts} = etl_input(part)
    comb = find_all_comb([], [], workflows, "in", workflows["in"])

    for l <- comb, reduce: [] do
      acc ->
        acc ++
          [
            for {var, op, amount} <- l,
                reduce: %{"x" => {1, 4000}, "m" => {1, 4000}, "s" => {1, 4000}, "a" => {1, 4000}} do
              acc ->
                {int_min, int_max} = acc[var]

                upd_int =
                  case op do
                    ">" -> {amount + 1, int_max}
                    ">=" -> {amount, int_max}
                    "<" -> {int_min, amount - 1}
                    "<=" -> {int_min, amount}
                  end

                Map.put(acc, var, upd_int)
            end
          ]
    end
    |> Enum.map(fn map ->
      Enum.reduce(map, 1, fn {_k, {int_min, int_max}}, acc -> acc * (int_max - int_min + 1) end)
    end)
    |> Enum.sum()
  end

  def process(input) do
    for l <- input, reduce: {%{}, MapSet.new()} do
      acc ->
        {workflow, parts} = acc

        cond do
          match =
              Regex.named_captures(~r/^(?<wf>\w+)\{(?<rules>.*)\}$/, l, capture: :all_but_first) ->
            {Map.put(workflow, match["wf"], String.split(match["rules"], ",")), parts}

          match =
              Regex.run(~r/^\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}$/, l, capture: :all_but_first) ->
            {workflow, MapSet.put(parts, Enum.map(match, &String.to_integer/1))}

          true ->
            acc
        end
    end
  end

  def map_reduce_wf(workflows, wf, p) do
    rules = workflows[wf]
    [x, m, a, s] = p

    target =
      Enum.reduce_while(rules, nil, fn r, jump ->
        rule_target = String.split(r, ":", trim: true)

        {valid, target} =
          case rule_target do
            [rule, target] ->
              {val, _} = Code.eval_string(rule, x: x, m: m, a: a, s: s)
              {val, target}

            [target] ->
              {true, target}
          end

        if valid do
          {:halt, target}
        else
          {:cont, jump}
        end
      end)

    cond do
      target == "R" or target == "A" -> target
      true -> map_reduce_wf(workflows, target, p)
    end
  end

  def find_all_comb(tree, current_branch, _workflows, "A", _rules), do: tree ++ [current_branch]
  def find_all_comb(tree, _current_branch, _workflows, "R", _rules), do: tree

  def find_all_comb(tree, current_branch, workflows, wf, [rule | rest_rules]) do
    rule_target = String.split(rule, ":", trim: true)

    case rule_target do
      [rule, target] ->
        [var, op, amount] = Regex.run(~r/^(\w)(<|>)(\d+)/, rule, capture: :all_but_first)

        find_all_comb(
          tree,
          current_branch ++ [{var, op, String.to_integer(amount)}],
          workflows,
          target,
          workflows[target]
        )
        |> find_all_comb(
          current_branch ++ [{var, negate(op), String.to_integer(amount)}],
          workflows,
          wf,
          rest_rules
        )

      ["A"] ->
        tree ++ [current_branch]

      ["R"] ->
        tree

      [target] ->
        find_all_comb(tree, current_branch, workflows, target, workflows[target])
    end
  end

  def negate(">"), do: "<="
  def negate("<"), do: ">="
end
