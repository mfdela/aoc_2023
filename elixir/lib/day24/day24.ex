defmodule Aoc2023.Day24 do
  defmodule Point do
    defstruct [:px, :py, :pz, :vx, :vy, :vz]
  end

  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    points = etl_input(part)
    # I use only x and y
    case part do
      :ex1 -> find_intersections(points, 7, 27)
      _ -> find_intersections(points, 200_000_000_000_000, 400_000_000_000_000)
    end
  end

  def part2(part \\ :ex2) do
    etl_input(part)
    |> Enum.slice(0, 4)
    |> find_line()
    |> Enum.slice(0, 3)
    |> Enum.sum()
  end

  def find_intersections(points, min, max) do
    check_all_pairs(points, 0, min, max)
  end

  def check_all_pairs([_p1], num_int, _, _), do: num_int

  def check_all_pairs([p1 | rest], num_int, min, max) do
    intersections =
      for p2 <- rest, reduce: num_int do
        acc ->
          {x, y} = do_intersect(p1, p2)

          cond do
            {x, y} == {:inf, :inf} -> acc
            x >= min and x <= max and y >= min and y <= max -> acc + 1
            true -> acc
          end
      end

    check_all_pairs(rest, intersections, min, max)
  end

  def do_intersect(p1, p2) do
    # p1 x = px1 + vx1*t1  y = py1 + vy1*t1
    # p2 x = px2 + vx2*t2  y = py2 + vy2*t2
    # - vx1 * t1 + vx2 * t2 = px1 - px2
    # - vy1 * t1 + vy2 * t2 = py1 - py2
    # | -vx1   vx2 |   | t1 |   | px1 - px2 |
    # |            | * |    | = |           |
    # | -vy1   vy2 |   | t2 |   | py1 - py2 |
    #
    # | t1 |            | vy2   -vx2 |   | px1 - px2 |
    # |    | = 1/det *  |            | * |           |
    # | t2 |            | vy1   -vx1 |   | py1 - py2 |

    det = det(-p1.vx, p2.vx, -p1.vy, p2.vy)

    if det == 0 do
      {:inf, :inf}
    else
      t1 = (p2.vy * (p1.px - p2.px) - p2.vx * (p1.py - p2.py)) / det
      t2 = (p1.vy * (p1.px - p2.px) - p1.vx * (p1.py - p2.py)) / det

      cond do
        t1 < 0 or t2 < 0 -> {:inf, :inf}
        true -> {p1.px + t1 * p1.vx, p1.py + t1 * p1.vy}
      end
    end
  end

  def det(a, b, c, d), do: a * d - b * c

  def find_line([p0, p1, p2, p3]) do
    p01 = vector(p0, p1)
    p02 = vector(p0, p2)
    p03 = vector(p0, p3)

    a =
      [
        [-p01.vy, p01.vx, 0, p01.py, -p01.px, 0],
        [-p01.vz, 0, p01.vx, p01.pz, 0, -p01.px],
        [-p02.vy, p02.vx, 0, p02.py, -p02.px, 0],
        [-p02.vz, 0, p02.vx, p02.pz, 0, -p02.px],
        [-p03.vy, p03.vx, 0, p03.py, -p03.px, 0],
        [-p03.vz, 0, p03.vx, p03.pz, 0, -p03.px]
      ]

    b =
      [
        cross_product_xy(p0, p1),
        cross_product_xz(p0, p1),
        cross_product_xy(p0, p2),
        cross_product_xz(p0, p2),
        cross_product_xy(p0, p3),
        cross_product_xz(p0, p3)
      ]

    det = MatrixOperation.determinant(a)

    Enum.map(0..5, fn i ->
      ((substitute(a, b, i)
        |> MatrixOperation.determinant()) / det)
      |> round()
    end)
  end

  def time(p, t),
    do: %Point{
      px: p.px + t * p.vx,
      py: p.py + t * p.vy,
      pz: p.pz + t * p.vz
    }

  def vector(p1, p2),
    do: %Point{
      px: p2.px - p1.px,
      py: p2.py - p1.py,
      pz: p2.pz - p1.pz,
      vx: p2.vx - p1.vx,
      vy: p2.vy - p1.vy,
      vz: p2.vz - p1.vz
    }

  def cross_product_xy(p1, p2), do: p1.px * p1.vy - p1.py * p1.vx - p2.px * p2.vy + p2.py * p2.vx
  def cross_product_xz(p1, p2), do: p1.px * p1.vz - p1.pz * p1.vx - p2.px * p2.vz + p2.pz * p2.vx

  def substitute(a, b, index) do
    for {bj, j} <- Enum.with_index(b), reduce: a do
      acc ->
        aj = acc |> Enum.at(j) |> List.replace_at(index, bj)
        List.replace_at(acc, j, aj)
    end
  end

  def process(input) do
    input
    |> Enum.map(&String.split(&1, ~r{\s+@\s+}, trim: true))
    |> Enum.map(fn v ->
      Enum.map(v, fn w ->
        String.split(w, ~r{,\s+}, trim: true) |> Enum.map(&String.to_integer/1)
      end)
      |> List.flatten()
    end)
    |> Enum.reduce([], fn p, l ->
      l ++
        [
          %Point{
            px: Enum.at(p, 0),
            py: Enum.at(p, 1),
            pz: Enum.at(p, 2),
            vx: Enum.at(p, 3),
            vy: Enum.at(p, 4),
            vz: Enum.at(p, 5)
          }
        ]
    end)
  end
end
