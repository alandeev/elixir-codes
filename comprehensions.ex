#### RESUME
# In Elixir, it is common to loop over an Enumerable, often filtering out some
# results and mapping values into another list. Comprehensions are syntactic
# sugar for such constructs: they group those common tasks into the for special form.

# For example, we can map a list of integers into their squared values:
# Ex:
for n <- [1, 2, 3, 4], do: n * n # [1, 4, 9, 16]

# A comprehension is made of three parts: generators, filters, and collectables.

### Generators and filters
# In the expression above, n <- [1, 2, 3, 4] is the generator. It is literally
# generating values to be used in the comprehension. Any enumerable can be passed
# on the right-hand side of the generator expression:
for n <- 1..4, do: n * n # [1, 4, 9, 16]

# Generator expressions also support pattern matching on their left-hand side; all non-matching
# patterns are ignored. Imagine that, instead of a range, we have a keyword list where the key
# is the atom :good or :bad and we only want to compute the square of the :good values:

values = [good: 1, good: 2, bad: 3, good: 4]
for {:good, n} <- values, do: n * n # [1, 4, 16]

# Alternatively to pattern matching, filters can be used to select some particular elements.
# For example, we can select the multiples of 3 and discard all others:
for n <- 0..5, rem(n, 3) == 0, do: n * n # [0, 9]

#* Comprehensions discard all elements for which the filter
# expression returns false or nil; all other values are selected.

# Comprehensions generally provide a much more concise representation than using the equivalent
# functions from the Enum and Stream modules. Furthermore, comprehensions also allow multiple
# generators and filters to be given. Here is an example that receives a list of directories
# and gets the size of each file in those directories:
# Ex:
dirs = ['/home/mikey', '/home/james']

for dir <- dirs,
    file <- File.ls!(dir),
    path = Path.join(dir, file),
    File.regular?(path) do
  File.stat!(path).size
end
#*(Alan)*: It's works as "with", you can add multiples filters and if all match correctly, it returns file.size

# Multiple generators can also be used to calculate the cartesian product of two lists:
# Ex:
for i <- [:a, :b, :c], j <- [1, 2], do: {i, j} # [a: 1, a: 2, b: 1, b: 2, c: 1, c: 2]

#* Finally, keep in mind that variable assignments inside the comprehension, be it in
#  generators, filters or inside the block, are not reflected outside of the comprehension.

### The :into option
# In the examples above, all the comprehensions returned lists as their result. However, the result of
# a comprehension can be inserted into different data structures by passing the :into option to the comprehension.

# For example, a bitstring generator can be used with the :into option in order to easily remove all spaces in a string:
# Ex:
for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>  # "helloworld" -> ""
for <<c <- " hello world " >>, c != ?\s, into: [], do: <<c>> # ["h","e","l","l","o","w","o","r","l","d"] - []

# Sets, maps, and other dictionaries can also be given to the :into option. In general,
# :into accepts any structure that implements the Collectable protocol.

# A common use case of :into can be transforming values in a map:
for {key, val} <- %{"a" => 1, "b" => 2}, into: %{}, do: {key, val * val} # %{"a" => 1, "b" => 4}

# Let’s make another example using streams. Since the IO module provides streams
# (that are both Enumerables and Collectables), an echo terminal that echoes back
# the upcased version of whatever is typed can be implemented using comprehensions:
stream = IO.stream(:stdio, :line)
for line <- stream, into: stream do
  String.upcase(line) <> "\n"
end

# Now type any string into the terminal and you will see that the same value will be
# printed in upper-case. Unfortunately, this example also got your IEx shell stuck in
# the comprehension, so you will need to hit Ctrl+C twice to get out of it. :)

## Other options

# Comprehensions support other options, such as :reduce and :uniq. Here are additional
# resources to learn more about comprehensions:
# https://hexdocs.pm/elixir/Kernel.SpecialForms.html#for/1
# https://www.mitchellhanberg.com/the-comprehensive-guide-to-elixirs-for-comprehension/



#***** I Stop learn in "Stream example" ******#

###### I NEED CONTINUE LEARNING TOPICS ######
# Bitstring generators
