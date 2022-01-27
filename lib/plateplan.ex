defmodule Plateplan do
  @moduledoc """
  Plateplan keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def start(input_weight) do
    initial_state = %{
      input_weight: input_weight,
      percents: [
        %{ value: 0.8, tolerance: 5},
        %{ value: 0.6, tolerance: 5},
        %{ value: 0.4, tolerance: 20},
      ],
      bars: []
    }
    main_bar = create_bar(1, 0, all_available_plates)
    |> load_bar(input_weight)

    percent_bars = initial_state.percents
    |> Enum.map(fn %{value: value, tolerance: tolerance} ->
      if value <= 0.4 do
        create_bar(value, tolerance, first_warmup_available_plates)
        |> load_bar(value * input_weight)
      else
        create_bar(value, tolerance, warmup_available_plates)
        |> load_bar(value * input_weight)
      end
    end)

    %{initial_state|
      bars: Enum.reverse([main_bar | percent_bars])
    }
  end

  def all_available_plates do
    [
      %{ weight: 45, class: "h-full" },
      %{ weight: 25, class: "h-3/4" },
      %{ weight: 10, class: "h-1/2 text-sm" },
      %{ weight: 5, class: "h-1/3" },
      %{ weight: 2.5, class: "h-1/4 w-4 text-xs overflow-visible break-all" }
    ]
  end

  def warmup_available_plates do
    [
      %{ weight: 45, class: "h-full" },
      %{ weight: 25, class: "h-3/4" },
      %{ weight: 10, class: "h-1/2 text-sm" }
    ]
  end

  def first_warmup_available_plates do
    [
      %{ weight: 45, class: "h-full" },
      %{ weight: 25, class: "h-3/4" },
    ]
  end

  def create_bar(percent, tolerance, available_plates) do
    %{
      remaining_weight: 0,
      percent: percent,
      plates: [],
      barred_weight: 0,
      available_plates: available_plates,
      current_plate: nil,
      tolerance: tolerance,
    }
  end

  defp get_plate_weight(total_weight) when total_weight > 45 do
    (total_weight - 45) /2
  end

  defp get_plate_weight(_) do
    0
  end

  def load_bar(bar, total_weight) do
    plate_weight = get_plate_weight(total_weight)

    %{
      bar |
      remaining_weight: plate_weight
    }
    |> load_bar()
  end

  def load_bar(bar = %{ available_plates: [ first | rest ], current_plate: nil }) do
    load_bar(%{ bar| current_plate: first, available_plates: rest })
  end

  def load_bar(bar) when  bar.remaining_weight < bar.current_plate.weight and length(bar.available_plates) < 1 do
    bar
  end

  def load_bar(bar = %{ plates: plates, remaining_weight: remaining_weight, tolerance: tolerance, current_plate: current_plate, available_plates: available_plates }) do

    if current_plate.weight <= (tolerance + remaining_weight) do
      load_bar(%{ bar |
        remaining_weight: remaining_weight - current_plate.weight,
        tolerance: tolerance,
        current_plate: current_plate,
        plates: plates ++ [current_plate],
        barred_weight: bar.barred_weight + current_plate.weight
      })
    else
      [first | second] = available_plates

      load_bar(%{ bar |
        available_plates: second,
        current_plate: first
      })
    end
  end
end
