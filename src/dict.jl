function dict end
macro dict(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterfaces.dict(p), args...)
    Base.length(p::$ProxyType) = Base.length(ProxyInterfaces.dict(p))
    Base.in(a, p::$ProxyType) = Base.in(a, ProxyInterfaces.dict(p))
    Base.haskey(p::$ProxyType, key) = Base.haskey(ProxyInterfaces.dict(p), key)
    Base.keys(p::$ProxyType) = Base.keys(ProxyInterfaces.dict(p))
    Base.values(p::$ProxyType) = Base.values(ProxyInterfaces.dict(p))
    Base.merge(p1::$ProxyType, p2::$ProxyType) = $ProxyType(Base.merge(
      ProxyInterfaces.dict(p1), ProxyInterfaces.dict(p2)))
  end
end

macro dict_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @dict($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterfaces.dict(p), args...)
    Base.empty!(p::$ProxyType) = Base.empty!(ProxyInterfaces.dict(p))
  end
end
