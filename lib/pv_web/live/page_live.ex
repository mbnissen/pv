defmodule PvWeb.PageLive do
  use PvWeb, :live_view

  alias Pv.Accounts
  alias Pv.Accounts.User
  alias Pv.Posts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    changeset = Accounts.change_user_registration(%User{})
    posts = Posts.list_posts()

    {:ok,
     socket
     |> assign(changeset: changeset)
     |> assign(posts: posts)
     |> assign(trigger_submit: false)}
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
