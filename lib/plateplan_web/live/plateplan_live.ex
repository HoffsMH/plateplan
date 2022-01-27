defmodule PlateplanWeb.PlateplanLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  def mount(params, stuff, socket) do
    state = Plateplan.start(225)

    {:ok, assign(socket, :state, state)}
  end

  def handle_event("update", %{"inputs" => %{ "input_weight" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("update", value, socket) do

    new_state = value
    |> get_in(["inputs", "input_weight"])
    |> String.to_integer()
    |> Plateplan.start()

    {:noreply, assign(socket, :state, new_state)}
  end
end
