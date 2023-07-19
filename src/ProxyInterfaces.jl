module ProxyInterfaces
export @forward

"""
    @forward T.x functions...
Define methods for `functions` on type `T`, which call the relevant function
on the field `x`.

# Example

```julia
struct Wrapper
    x
end
@forward Wrapper.x  Base.sqrt                                  # now sqrt(Wrapper(4.0)) == 2.0
@forward Wrapper.x  Base.length, Base.getindex, Base.iterate   # several forwarded functions are put in a tuple
@forward Wrapper.x (Base.length, Base.getindex, Base.iterate)  # equivalent to above
```
"""
macro forward(ex, fs)
  check = ex isa Expr && ex.head == :. && ex.args[1] isa Symbol && ex.args[2] isa QuoteNode
  check || error("Syntax: @forward T.x f, g, h")
  T = esc(ex.args[1])
  field = ex.args[2].value  # no escape needed for . syntax
  fs = (fs isa Expr && fs.head == :tuple) ? map(esc, fs.args) : [esc(fs)]
  :($([:($f(x::$T, args...; kwargs...) = (Base.@_inline_meta; $f(x.$field, args...; kwargs...)))
       for f in fs]...);
    nothing)
end

include("iterator.jl")
include("indexing.jl")
include("array.jl")  # depends on @iterator
include("dict.jl")  # depends on @iterator

end # module
