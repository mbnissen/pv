defmodule Pv.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pv.Posts.Slugger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :description, :string
    field :total_comments, :integer
    field :total_likes, :integer
    field :title, :string
    field :slug, :string
    belongs_to :user, Pv.Accounts.User
    has_many :comments, Pv.Posts.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, title} -> put_change(changeset, :slug, Slugger.slugify(title))
      :error -> changeset
    end
  end
end
