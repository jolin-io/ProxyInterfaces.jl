function iterator end
macro iterator(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.iterate(p::$ProxyType) = Base.iterate(ProxyInterfaces.iterator(p))
    Base.iterate(p::$ProxyType, state) = Base.iterate(ProxyInterfaces.iterator(p), state)
    Base.IteratorSize(T::Type{<:$ProxyType}) = Base.IteratorSize(ProxyInterfaces.iterator(T))
    Base.IteratorEltype(T::Type{<:$ProxyType}) = Base.IteratorEltype(ProxyInterfaces.iterator(T))
    Base.eltype(T::Type{<:$ProxyType}) = Base.eltype(ProxyInterfaces.iterator(T))
    Base.length(p::$ProxyType) = Base.length(ProxyInterfaces.iterator(p))
    Base.size(p::$ProxyType) = Base.size(ProxyInterfaces.iterator(p))
    Base.size(p::$ProxyType, d) = Base.size(ProxyInterfaces.iterator(p), d)
    Base.axes(p::$ProxyType) = Base.axes(ProxyInterfaces.iterator(p))  # analog to Base.Generator
    Base.ndims(p::$ProxyType) = Base.ndims(ProxyInterfaces.iterator(p))
    # TODO in a version 2.x maybe do not include foreach, as it already has a fallback for iterators
    # TODO in a version 2.x maybe do not include map, as not every iterator supports map
    # we include foreach to iterator, as it directly corresponds to a for loop
    Base.foreach(f, p::$ProxyType) = Base.foreach(f, ProxyInterfaces.iterator(p))
    Base.map(f, p::$ProxyType) = $ProxyType(Base.map(f, ProxyInterfaces.iterator(p)))
  end
end
