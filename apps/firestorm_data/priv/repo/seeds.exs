# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

IO.puts("seeding")
FirestormData.Seed.call()
