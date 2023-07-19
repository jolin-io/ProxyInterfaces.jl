ProxyInterfaces
===============

[![Build Status](https://github.com/jolin-io/ProxyInterfaces.jl/workflows/CI/badge.svg)](https://github.com/jolin-io/ProxyInterfaces.jl/actions/workflows/ci.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jolin-io/ProxyInterfaces.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jolin-io/ProxyInterfaces.jl)

Install/use it like
```julia
using ProxyInterfaces
```

It gives you access to macros which define standard interfaces for your custom proxy type. Currently, the following interfaces are supported:
* iterator ([implementation](src/iterator.jl), [tests](test/iterator.jl))
* indexing ([implementation](src/indexing.jl), [tests](test/indexing.jl))
* indexing_mutable ([implementation](src/indexing.jl), [tests](test/indexing.jl))
* array ([implementation](src/array.jl), [tests](test/array.jl))
* array_mutable ([implementation](src/array.jl), [tests](test/array.jl))
* dict ([implementation](src/dict.jl), [tests](test/dict.jl))
* dict_mutable ([implementation](src/dict.jl), [tests](test/dict.jl))

In addition it also exports the famous `@forward MyWrapper.myfield func1, func2, func3` helper, for quick method
forwarding to a struct field.


Usage
-----

Let's take an example proxy type. A proxy type is understood as a type which wraps another type.
```julia
struct DictProxy{K, V}
  dict::Dict{K, V}
end
```
In this case it only wraps the standard dict with an additional Tag, namely the Type `DictProxy` itself.

You can now define standard dict functionality for your proxy with the following three lines
```julia
ProxyInterfaces.dict(::Type{DictProxy{K,V}}) where {K, V} = Dict{K, V}
ProxyInterfaces.dict(p::DictProxy) = p.dict
ProxyInterfaces.@dict DictProxy
```

With this you can now use standard dict syntax for your DictProxy
```julia
d = DictProxy(Dict(:a => 1, :b => c))
d[:a]  # 1
keys(d) # [:a, :b]
values(d) # [1, 2]
haskey(d, :b) # true
# d[:c] = 5  # WONT'T WORK because this is the immutable interface. use `ProxyInterfaces.dict_mutable` and it will work
```

Only these three steps are needed for every ProxyInterfaces `respectivename`:
* overwrite `ProxyInterfaces.respectivename(::Type{YourProxyType})` to define how the proxy TYPE maps to the original type
* overwrite `ProxyInterfaces.respectivename(p::YourProxyType)` to extract the underlying original out of the given proxy instance
* call `ProxyInterfaces.@respectivename`


Contributing
------------

Help is highly appreciated. There are many interfaces in Julia which are defined by documentation rather than code. This package `ProxyInterfaces` can work as a code reference.

In case you are missing a standard interface or a concrete function for an already supported interface, please open an issue. Pull request are also highly welcome.
