####  Module attributes in Elixir serve three purposes:

# 1. They serve to annotate the module, often with information to be used by the user or the VM.
# 2. They work as constants.
# 3. They work as a temporary module storage to be used during compilation.

### AS ANNOTATIONS
# Elixir brings the concept of module attributes from Erlang. For example:

defmodule MyServer do
  @moduledoc "My server code."
end

# In the example above, we are defining the module documentation by using the module attribute syntax.
# Elixir has a handful of reserved attributes. Here are a few of them, the most commonly used ones:

#* @moduledoc - provides documentation for the current module.
#* @doc - provides documentation for the function or macro that follows the attribute.
#* @spec - provides a typespec for the function that follows the attribute.
#* @behaviour - (notice the British spelling) used for specifying an OTP or user-defined behaviour.

#   Writing docs in elixir
#*  Using: Markdown with heredocs
#** https://hexdocs.pm/elixir/writing-documentation.html

### AS CONSTANTS
# Elixir developers often use module attributes when they wish to make a value more visible or reusable
# Ex
defmodule MyServer do
  @initial_state %{host: "127.0.0.1", port: 3456}
  IO.inspect @initial_state
end

# Note: do not add a newline between the attribute and its value,
# otherwise Elixir will assume you are reading the value, rather than setting it.

# Functions may be called when defining a module attribute:
# Ex
defmodule MyApp.Status do
  @service URI.parse("https://example.com")
  def status(email) do
    SomeHttpClient.get(@service)
  end
end

#** The function above will be called at compilation time and its return value, not
#   the function call itself, is what will be substituted in for the attribute.
#   So the above will effectively compile to this:
#
#   defmodule MyApp.Status do
#     def status(email) do
#       SomeHttpClient.get(%URI{
#         authority: "example.com",
#         host: "example.com",
#         port: 443,
#         scheme: "https"
#       })
#     end
#   end

#***
# This can be useful for pre-computing constant values, but it can also cause problems
# if you’re expecting the function to be called at runtime. For example, if you are reading
# a value from a database or an environment variable inside an attribute, be aware that it
# willread that value only at compilation time. Be careful, however: functions defined in
# the same moduleas the attribute itself cannot be called because they have not yet been
# compiled when the attribute is being defined.

# Every time an attribute is read inside a function, Elixir takes a snapshot of its current
# value. Therefore if you read the same attribute multiple times inside multiple functions,
# you may end-up making multiple copies of it. That’s usually not an issue, but if you are
# using functions to compute large module attributes, that can slow down compilation.
# The solution is to move the attribute to shared function. For example, instead of this:

def some_function, do: do_something_with(@example)
def another_function, do: do_something_else_with(@example)

# Prefer this:
def some_function, do: do_something_with(example())
def another_function, do: do_something_else_with(example())
defp example, do: @example


### Accumulating attributes
# Normally, repeating a module attribute will cause its value to be reassigned, but there are
# circumstances where you may want to configure the module attribute so that its values are accumulated:
# https://hexdocs.pm/elixir/Module.html#register_attribute/3
# Ex:
defmodule Foo do
  Module.register_attribute __MODULE__, :param, accumulate: true

  @param :foo
  @param :bar
  # here @param == [:bar, :foo]
end


### As temporary storage
# To see an example of using module attributes as storage, look no further than Elixir’s unit
# test framework called ExUnit. ExUnit uses module attributes for multiple different purposes:
# Ex:
defmodule MyTest do
  use ExUnit.Case, async: true

  @tag :external
  @tag os: :unix
  test "contacts external service" do
    # ...
  end
end

# In the example above, ExUnit stores the value of async: true in a module attribute to
# change how the module is compiled. Tags are also defined as accumulate: true attributes,
# and they store tags that can be used to setup and filter tests. For example, you can avoid
# running external tests on your machine because they are slow and dependent on other services,
# while they can still be enabled in your build system.

# In order to understand the underlying code, we’d need macros, so we will revisit
# this pattern in the meta-programming guide and learn how to use module attributes
# as storage to allow developers to create Domain Specific Languages (DSLs).
