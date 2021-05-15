defmodule Pv.Repo.Migrations.AddToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string
      add :apartment_number, :integer
    end

  end
end
