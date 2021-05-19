defmodule Pv.Posts do
  @moduledoc """
  The Posts context.
  """

  alias Pv.Accounts.User

  import Ecto.Query, warn: false
  alias Pv.Repo

  alias Pv.Posts.Post
  alias Pv.Posts.Comment

  def list_posts(page: page, per_page: per_page) do
    Post
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_total_count() do
    Repo.one(from p in Post, select: count(p.id))
  end

  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
  end

  def get_post_by_slug(slug) do
    slug = String.downcase(slug)

    Repo.get_by(Post, slug: slug)
    |> Repo.preload(:user)
  end

  def create_post(attrs \\ %{}, user) do
    post = Ecto.build_assoc(user, :posts)

    changeset = Post.changeset(post, attrs)
    update_posts_count = from(u in User, where: u.id == ^user.id)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:update_posts_count, update_posts_count, inc: [posts_count: 1])
    |> Ecto.Multi.insert(:post, changeset)
    |> Repo.transaction()
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def list_post_comments(post_id) do
    Comment
    |> where(post_id: ^post_id)
    |> Repo.all()
  end

  def create_comment(user, post, attrs \\ %{}) do
    update_total_comments = post.__struct__ |> where(id: ^post.id)
    comment_attrs = %Comment{} |> Comment.changeset(attrs)

    comment =
      comment_attrs
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Ecto.Changeset.put_assoc(:post, post)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:update_total_comments, update_total_comments,
      inc: [total_comments: 1]
    )
    |> Ecto.Multi.insert(:comment, comment)
    |> Repo.transaction()
    |> case do
      {:ok, %{comment: comment}} ->
        {:ok, comment}

      {:error, :comment, %Ecto.Changeset{} = changeset, _} ->
        {:error, changeset}
    end
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
