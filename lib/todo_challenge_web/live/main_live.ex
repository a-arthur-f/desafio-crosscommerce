defmodule TodoChallengeWeb.MainLive do
  use TodoChallengeWeb, :live_view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, [todos: [], last_index: 0])}
  end

  def handle_event("save", %{"todo" => %{"title" => ""}}, socket), do: {:noreply, socket}

  def handle_event("save", %{"todo" => todo}, socket) do

    new_index = socket.assigns.last_index + 1
    socket = assign(socket,
      todos:  socket.assigns.todos ++ [%{
        "id" => new_index,
        "title" => todo["title"],
        "done" => false}],
      last_index: new_index

   )
    {:noreply, push_event(socket, "saveTodos", %{todos: socket.assigns})}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    id = String.to_integer(id)
    socket = assign(socket, :todos, socket.assigns.todos |> Enum.filter(fn todo -> todo["id"] != id end))
    {:noreply, push_event(socket, "saveTodos", %{todos: socket.assigns})}
  end

  def handle_event("restoreTodos", %{"todos" => nil}, socket), do: {:noreply, socket}

  def handle_event("restoreTodos", %{"last_index" => last_index}, socket) when not is_integer(last_index), do: {:noreply, socket}

  def handle_event("restoreTodos", %{"todos" => todos, "last_index" => last_index}, socket) do
    {:noreply, assign(socket, todos: todos, last_index: last_index)}
  end
end
