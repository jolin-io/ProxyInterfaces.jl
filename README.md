ProxyInterfaces
===============

[![Build Status](https://github.com/schlichtanders/ProxyInterfaces.jl/workflows/CI/badge.svg)](https://github.com/schlichtanders/ProxyInterfaces.jl/actions)
[![Coverage](https://codecov.io/gh/schlichtanders/ProxyInterfaces.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/schlichtanders/ProxyInterfaces.jl)

Install it like
```julia
using Pkg
pkg"registry add https://github.com/JuliaRegistries/General"  # central julia registry
pkg"registry add https://github.com/schlichtanders/SchlichtandersJuliaRegistry.jl"  # custom registry
pkg"add ProxyInterfaces"
```

Load it like
``` julia
using ProxyInterfaces
```

It gives you access to macros which define standard interfaces for your custom proxy type. Currently, the following interfaces are supported:
* [iterator](test/iterator.jl)
* [indexing](test/indexing.jl)
* [indexing_mutable](test/indexing.jl)
* [array](test/array.jl)
* [array_mutable](test/array.jl)
* [dict](test/dict.jl)
* [dict_mutable](test/dict.jl)

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
ProxyInterface.dict(::Type{DictProxy{K,V}}) where {K, V} = Dict{K, V}
ProxyInterface.dict(p::DictProxy) = p.dict
ProxyInterface.@dict DictProxy
```

With this you can now use standard dict syntax for your DictProxy
```julia
d = DictProxy(Dict(:a => 1, :b => c))
d[:a]  # 1
keys(d) # [:a, :b]
values(d) # [1, 2]
haskey(d, :b) # true
# d[:c] = 5  # WONT'T WORK because this is the immutable interface. use `ProxyInterface.dict_mutable` and it will work
```

Only these three steps are needed for every ProxyInterface `respectivename`:
* overwrite `ProxyInterfaces.respectivename(::Type{YourProxyType})` to define how the proxy TYPE maps to the original type
* overwrite `ProxyInterfaces.respectivename(p::YourProxyType)` to extract the underlying original out of the given proxy instance
* call `ProxyInterfaces.@respectivename`


Contributing
------------

Help is highly appreciated. There are many interfaces in Julia which are defined by documentation rather than code. This package `ProxyInterfaces` can work as a code reference.

In case you are missing a standard interface or a concrete function for an already supported interface, please open an issue. Pull request are also highly welcome.
