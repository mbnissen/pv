# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pv.Repo.insert!(%Pv.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Pv.Posts
alias Pv.Accounts

{:ok, user} =
  Accounts.register_user(%{
    "email" => "test@test.dk",
    "full_name" => "Morten Nissen",
    "apartment_number" => 18,
    "password" => "test"
  })

Enum.each(0..99, fn _x ->
  Posts.create_post(
    %{
      "title" => "Lorem Ipsum",
      "description" =>
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut faucibus metus et dolor volutpat maximus. In luctus odio sed convallis auctor. In hac habitasse platea dictumst. In hac habitasse platea dictumst. Nunc rutrum volutpat purus, ac semper nunc condimentum eget. Morbi dictum dui quis nisi pharetra posuere. Suspendisse vestibulum urna et dapibus mattis. Donec nunc odio, maximus malesuada sodales eu, elementum vel ipsum. Donec ac magna nec ante interdum commodo iaculis sollicitudin ex. Integer aliquam rhoncus velit, quis accumsan nisi egestas eget."
    },
    user
  )
end)
