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
        0.8,
        0.6,
        0.4
      ],
      bars: []
    }

    main_bar =
      create_bar(1, 0.0, all_available_plates)
      |> load_bar(input_weight)

    padding = input_weight * 0.05

    percent_bars =
      initial_state.percents
      |> Enum.map(fn value ->
        create_bar(value, padding, determine_available_warmup_plates(input_weight))
        |> load_bar(value * input_weight)
      end)

    %{initial_state | bars: Enum.reverse([main_bar | percent_bars])}
  end

  def determine_available_warmup_plates(total_weight) do
    all_available_plates
    |> Enum.filter(fn plate ->
      total_weight * 0.049 < plate.weight || plate.weight === 45
    end)
  end

  def all_available_plates do
    [
      %{weight: 45, class: "h-full"},
      %{weight: 25, class: "h-3/4"},
      %{weight: 10, class: "h-1/2 text-sm"},
      %{weight: 5, class: "h-1/3"},
      %{weight: 2.5, class: "h-1/4 w-4 text-xs overflow-visible break-all"}
    ]
  end

  def create_bar(percent, padding, available_plates) do
    %{
      remaining_weight: 0,
      percent: percent,
      plates: [],
      barred_weight: 0,
      available_plates: available_plates,
      current_plate: nil,
      padding: padding
    }
  end

  defp get_plate_weight(total_weight)
       when total_weight > 45,
       do: (total_weight - 45) / 2

  defp get_plate_weight(_), do: 0

  def load_bar(bar = %{available_plates: [first | rest]}, total_weight) do
    plate_weight = get_plate_weight(total_weight)

    %{
      bar
      | remaining_weight: plate_weight,
        current_plate: first,
        available_plates: rest
    }
    |> load_bar()
  end

  def load_bar(bar = %{remaining_weight: 0}), do: bar

  def load_bar(bar = %{available_plates: []})
      when bar.remaining_weight + bar.padding < bar.current_plate.weight,
      do: bar

  def load_bar(
        bar = %{
          padding: padding,
          plates: plates,
          remaining_weight: remaining_weight,
          current_plate: current_plate,
          available_plates: available_plates
        }
      ) do
    if current_plate.weight <= remaining_weight + padding do
      load_bar(%{
        bar
        | remaining_weight: remaining_weight - current_plate.weight,
          plates: plates ++ [current_plate],
          barred_weight: bar.barred_weight + current_plate.weight
      })
    else
      [first | second] = available_plates

      load_bar(%{bar | available_plates: second, current_plate: first})
    end
  end
end
