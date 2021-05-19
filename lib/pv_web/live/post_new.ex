defmodule PvWeb.PostLive.PostNew do
  use PvWeb, :live_view

  alias Pv.Posts.Post
  alias Pv.Posts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
     socket
     |> assign(page_title: "New Post")
     |> assign(changeset: Posts.change_post(%Post{}))}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      Posts.change_post(%Post{}, post_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(changeset: changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    case Posts.create_post(post_params, socket.assigns.current_user) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: Routes.page_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
