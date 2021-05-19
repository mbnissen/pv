defmodule PvWeb.PostLive.PostShow do
  use PvWeb, :live_view

  alias Pv.Posts
  alias Pv.Posts.Comment

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    socket = assign_defaults(session, socket)

    post = Posts.get_post_by_slug(slug)

    {:ok,
     socket
     |> assign(changeset: Posts.change_comment(%Comment{}))
     |> assign(post: post)
     |> assign(comments: Posts.list_post_comments(post.id))}
  end

  @impl true
  def handle_event("save", %{"comment" => comment_params}, socket) do
    case Posts.create_comment(socket.assigns.current_user, socket.assigns.post, comment_params) do
      {:ok, comment} ->
        {:noreply,
         socket
         |> assign(comments: socket.assigns.comments ++ [comment])
         |> assign(changeset: Posts.change_comment(%Comment{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
