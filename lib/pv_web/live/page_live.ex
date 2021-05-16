defmodule PvWeb.PageLive do
  use PvWeb, :live_view

  alias Pv.Accounts
  alias Pv.Accounts.User
  alias Pv.Posts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    changeset = Accounts.change_user_registration(%User{})
    total_posts = Posts.get_total_count()

    {:ok,
     socket
     |> assign(page: 1, per_page: 15, total_posts: total_posts)
     |> assign_posts()
     |> assign(changeset: changeset)
     |> assign(trigger_submit: false), temporary_assigns: [posts: []]}
  end

  defp assign_posts(socket) do
    socket
    |> assign(
      posts:
        Posts.list_posts(
          page: socket.assigns.page,
          per_page: socket.assigns.per_page
        )
    )
  end

  @impl true
  def handle_event("load-more-posts", _, socket) do
    {:noreply, socket |> load_posts}
  end

  defp load_posts(socket) do
    total_posts = socket.assigns.total_posts
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    total_pages = ceil(total_posts / per_page)

    if page == total_pages do
      socket
    else
      socket
      |> update(:page, &(&1 + 1))
      |> assign_posts()
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> User.registration_changeset(user_params)
      |> Map.put(:action, :validate)

    :timer.sleep(9000)
    {:noreply, socket |> assign(changeset: changeset)}
  end

  def handle_event("save", _, socket) do
    {:noreply, assign(socket, trigger_submit: true)}
  end
end
