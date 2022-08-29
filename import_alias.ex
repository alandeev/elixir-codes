#### RESUME
# Alias the module so it can be called as Bar instead of Foo.Bar
alias Foo.Bar, as: Bar

# Require the module in order to use its macros
require Foo

# Import functions from Foo so they can be called without the `Foo.` prefix
import Foo

# Invokes the custom code defined in Foo as an extension point
use Foo

# We are going to explore them in detail now. Keep in mind the
# first three are called directives because they have lexical scope,
# while use is a common extension point that allows the used module to inject code.

#### ALIAS
# allows you to set up aliases for any given module name.
# [ lexically scoped ]

# An alias in Elixir is a capitalized identifier (like String, Keyword, etc)
# which is converted to an atom during compilation. For instance, the
# String alias translates by default to the atom :"Elixir.String":
# Ex
is_atom(String) # true
to_string(String) # "Elixir.String"
:"Elixir.String" == String # true

#* Aliases expand to atoms because in the Erlang VM (and consequently Elixir)
# modules are always represented by atoms:
# Ex
List.flatten([1, [2], 3]) # [1, 2, 3]
:"Elixir.List".flatten([1, [2], 3]) # [1, 2, 3]

defmodule Stats do
  alias Math.List, as: List
  # or -> alias Math.list
  # In the remaining module definition List expands to Math.List.
end

#* That’s the mechanism we use to call Erlang modules:
:lists.flatten([1, [2], 3]) # [1, 2, 3]

#* Note: All modules defined in Elixir are defined inside the main Elixir namespace, such as Elixir.String.
# However, for convenience, you can omit “Elixir.” when referencing them

#### IMPORT
# We use import whener we want to access functions or macros from other --
# modules without using the fully-qualified name. Note we can only import --
# public functions, as private functions are never accessible externally.
# [lexically scoped]

# only: [] is optional, it's usage is recommneded in order to avoid importing all
# the functions of a given module inside current scope. :expect cold also be given as an
# option in order to import everything in a module expect a list of functions
# Ex: import List, expect: [duplicate: 2] -> all will be imported, but duplicated does not.
import List, only: [duplicate: 2]
duplicate(:ok, 2) # [:ok, :ok]

#* Note imports are generally discouraged in the language.
# When working on your own code, prefer alias to import.

### MODULE NESTING

defmodule Foo do
  defmodule Bar do
  end
end

# The example above will define two modules: Foo and Foo.Bar. The second can
# be accessed as Bar inside Foo as long as they are in the same lexical scope.

# If, later, the Bar module is moved outside the Foo module definition, it must be
# referenced by its full name (Foo.Bar) or an alias must be set using the alias
# directive discussed above.

#* Note: in Elixir, you don’t have to define the Foo module before being able to
# define the Foo.Bar module, as they are effectively independent. The above could also be written as:

defmodule Foo.Bar do
end

defmodule Foo do
  alias Foo.Bar
  # Can still access it as `Bar`
end

#** As we will see in later chapters, aliases also play a crucial
# role in macros, to guarantee they are hygienic.

#### Multi alias/import/require/use

# It is possible to alias, import or require multiple modules at once. This is particularly useful
# once we start nesting modules, which is very common when building Elixir applications. For example,
# imagine you have an application where all modules are nested under MyApp, you can alias the modules
# MyApp.Foo, MyApp.Bar and MyApp.Baz at once as follows:

alias MyApp.{Foo, Bar, Baz}
