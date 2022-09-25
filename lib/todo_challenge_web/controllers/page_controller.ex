defmodule TodoChallengeWeb.PageController do
  use TodoChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
