module ProxyInterface
using Compat

function iterator end
macro iterator(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.iterate(p::$ProxyType) = Base.iterate(ProxyInterface.iterator(p))
    Base.iterate(p::$ProxyType, state) = Base.iterate(ProxyInterface.iterator(p), state)
    Base.IteratorSize(A::Type{<:$ProxyType}) = Base.IteratorSize(ProxyInterface.iterator(A))
    Base.IteratorEltype(A::Type{<:$ProxyType}) = Base.IteratorEltype(ProxyInterface.iterator(A))
    Base.eltype(p::$ProxyType) = Base.eltype(ProxyInterface.iterator(p))
    Base.length(p::$ProxyType) = Base.length(ProxyInterface.iterator(p))
    Base.size(p::$ProxyType) = Base.size(ProxyInterface.iterator(p))
    Base.size(p::$ProxyType, d) = Base.size(ProxyInterface.iterator(p), d)
    Base.axes(p::$ProxyType) = Base.axes(ProxyInterface.iterator(p))  # analog to Base.Generator
    Base.ndims(p::$ProxyType) = Base.ndims(ProxyInterface.iterator(p))
    # we include foreach to iterator, as it directly corresponds to a for loop
    Base.foreach(f, p::$ProxyType) = Base.foreach(f, ProxyInterface.iterator(p))
    # we don't include Base.map, as it requires constructing the Proxy, which we don't know how to do it
  end
end

function indexing end
macro indexing(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterface.indexing(p), args...)
    Base.firstindex(p::$ProxyType) = Base.firstindex(ProxyInterface.indexing(p))
    Base.lastindex(p::$ProxyType)	= Base.lastindex(ProxyInterface.indexing(p))
  end
end
macro indexing_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @indexing($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterface.indexing(p), args...)
  end
end


function array end
macro array(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.size(p::$ProxyType) = Base.size(ProxyInterface.array(p))
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterface.array(p), args...)
    Base.firstindex(p::$ProxyType) = Base.firstindex(ProxyInterface.array(p))
    Base.lastindex(p::$ProxyType)	= Base.lastindex(ProxyInterface.array(p))
    # optional
    Base.IndexStyle(A::Type{<:$ProxyType}) = Base.IndexStyle(ProxyInterface.array(A))
    Base.length(p::$ProxyType) = Base.length(ProxyInterface.array(p))
    Base.similar(p::$ProxyType, args...) = Base.similar(ProxyInterface.array(p), args...)
    # non-traditional
    Base.axes(p::$ProxyType) = Base.axes(ProxyInterface.array(p))
    # strides
    Base.strides(p::$ProxyType, args...) = Base.strides(ProxyInterface.array(p), args...)
    Base.unsafe_convert(p::$ProxyType, args...) = Base.strides(ProxyInterface.array(p), args...)
    Base.unsafe_convert(t::Type{Ptr{T}}, p::$ProxyType) where T = Base.unsafe_convert(t, ProxyInterface.array(p))
    # extra
    Base.in(a, p::$ProxyType) = Base.in(a, ProxyInterface.array(p))
  end
end

macro array_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @array($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterface.array(p), args...)
    Base.empty!(p::$ProxyType) = Base.empty!(ProxyInterface.array(p))
  end
end

function dict end
macro dict(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterface.dict(p), args...)
    Base.length(p::$ProxyType) = Base.length(ProxyInterface.dict(p))
    Base.in(a, p::$ProxyType) = Base.in(a, ProxyInterface.dict(p))
    Base.haskey(p::$ProxyType, key) = Base.haskey(ProxyInterface.dict(p), key)
    Base.keys(p::$ProxyType) = Base.keys(ProxyInterface.dict(p))
    Base.values(p::$ProxyType) = Base.values(ProxyInterface.dict(p))
  end
end

macro dict_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @dict($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterface.dict(p), args...)
    Base.empty!(p::$ProxyType) = Base.empty!(ProxyInterface.dict(p))
  end
end
end # module
