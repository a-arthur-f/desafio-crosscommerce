defmodule TodoChallengeWeb.MainLive do
  use TodoChallengeWeb, :live_view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, [todos: [], last_index: 0, sort_by: "all"])}
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

  def handle_event("restoreTodos", %{"last_index" => last_index}, socket)
  when not is_integer(last_index), do: {:noreply, socket}

  def handle_event("restoreTodos", %{"todos" => todos, "last_index" => last_index}, socket) do
    {:noreply, assign(socket, todos: todos, last_index: last_index)}
  end

  def handle_event("done", %{"id" => id}, socket) do
    index = socket.assigns.todos |> Enum.find_index(fn x -> to_string(x["id"]) == id end)
    updated_todos = socket.assigns.todos |>
    List.update_at(index, fn x -> Map.update!(x, "done", &(&1 = true)) end)
    socket = assign(socket, :todos, updated_todos)
    {:noreply, push_event(socket, "saveTodos", %{todos: socket.assigns})}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, :todos, socket.assigns.todos |> Enum.filter(fn x -> not x["done"] end))}
  end

  def filter_todo(todos, sort_by) do
    case sort_by do
      :all -> todos
      :completed -> todos |> Enum.filter(&(&1["done"]))
      :active -> todos |> Enum.filter(&(not &1["done"]))
    end
  end

  def handle_params(params, _uri, socket) do
    socket =
      case params["sort_by"] do
        "active" -> assign(socket, :sort_by, :active)
        "completed" -> assign(socket, :sort_by, :completed)
        _ -> assign(socket, :sort_by, :all)
      end
    {:noreply, socket}
  end
end
