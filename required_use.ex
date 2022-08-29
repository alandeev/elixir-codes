#### REQUIRE
#* Provides macros as a mechanism for meta-programming ( writing code that generates code).
# Macros are expanded at compile time.
# [ lexically scoped ]

# Integer.is_odd(3) - function Integer.is_odd/1 is undefined

require Integer
Integer.is_odd(3) # true

#### USE
# The use macro is frequently used as an extension point. This means that, when you use a
# module FooBar, you allow that module to inject any code in the current module, such as
# importing itself or other modules, defining new functions, setting a module state, etc.

# defmodule AssertionTest do
#   use ExUnit.Case, async: true

#   test "always pass" do
#     assert true
#   end
# end

#* Behind the scenes, use requires the given module and then calls the __using__/1 callback on
# it allowing the module to inject some code into the current context. Some modules (for example,
# the above ExUnit.Case, but also Supervisor and GenServer) use this mechanism to populate your
# module with some basic behaviour, which your module is intended to override or complete.

#* Before compile *#
# defmodule Example do
#   use Feature, option: :value
# end

#* Compiled code *#
# defmodule Example do
#   require Feature
#   Feature.__using__(option: :value)
# end

#* Since use allows any code to run, we can’t really know the side-effects of using a
# module without reading its documentation. Therefore use this function with care and only
# if strictly required. Don’t use use where an import or alias would do.
