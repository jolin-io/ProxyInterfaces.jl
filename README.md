ProxyInterface
==============

Load it like
``` julia
import ProxyInterface
```

It gives you access to macros which define standard interfaces for your custom proxy type. Currently the following interfaces are supported:
* iterator
* indexing
* indexing_mutable
* array
* array_mutable
* dict
* dict_mutable

Let's take an example proxy type. A proxy type is understood as a type which wraps another type.
```julia
struct DictProxy{K, V}
  dict::Dict{K, V}
end
```
In this case it only wraps the standard dict with an additional Tag, namely the Type ``DictProxy`` itself.

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
# d[:c] = 5  # WONT'T WORK because this is the immutable interface. use ``ProxyInterface.dict_mutable`` and it will work
```

Only these three steps are needed for every ProxyInterface `respectivename`:
* overwrite ``ProxyInterface.respectivename(::Type{YourProxyType})`` to define how the proxy TYPE maps to the original type
* overwrite ``ProxyInterface.respectivename(p::YourProxyType)`` to extract the underlying original out of the given proxy instance
* call ``ProxyInterface.@respectivename``


Contributing
============

Help is highly appreciated. There are many interfaces in Julia which are defined by documentation rather than code. This package ``ProxyInterface`` can work as a code reference.

In case you are missing a standard interface or a concrete function for an already supported interface, please open an issue. Pull request are also highly welcome.
