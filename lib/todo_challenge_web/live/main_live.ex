defmodule TodoChallengeWeb.MainLive do
  use TodoChallengeWeb, :live_view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, [todos: [], last_index: 0])}
  end

  def handle_event("save", %{"todo" => todo}, socket) do
    new_index = socket.assigns.last_index + 1
    {:noreply, assign(socket,
      todos:  socket.assigns.todos ++ [%{
        id: new_index,
        title: todo["title"],
        done: false}],
      last_index: new_index

   )}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    id = String.to_integer(id)
    {:noreply, assign(socket, :todos, socket.assigns.todos |> Enum.filter(fn todo -> todo.id != id end))}
  end
end
