# keyword list

# true
[{:trim, true}] = [trim: true]

String.split("1  2  3", " ", trim: true)

# list works with linear performance, does not use it to find key/value data. In this case, use Maps ( go to ).

n = 1

%{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}

# updating Maps
map = %{:a => 1, 2 => :b}

newMap = %{map | 2 => "modified"}
IO.inspect(newMap)

# you can access atoms easily with Maps
IO.puts("Atom value: #{newMap.a}")

# %{map | :c => 3}
# ** (KeyError) key :c not found in: %{2 => :b, :a => 1}

# Conditions with Maps
if true, do: "This will be seen", else: "This won't"

## Nested data structures ##

# KeywordList[Map]
users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]

# manipulating maps/list
newUsers = put_in(users[:john].age, 31)

# same action, but works with function that define how update data.
newUsersUpdatedWithoutLanguageCloujuse =
  update_in(newUsers[:mary].languages, fn languages ->
    List.delete(languages, "Clojure")
  end)

IO.inspect(newUsersUpdatedWithoutLanguageCloujuse)
