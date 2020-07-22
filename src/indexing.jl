function indexing end
macro indexing(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterfaces.indexing(p), args...)
    Base.firstindex(p::$ProxyType) = Base.firstindex(ProxyInterfaces.indexing(p))
    Base.lastindex(p::$ProxyType)	= Base.lastindex(ProxyInterfaces.indexing(p))
  end
end
macro indexing_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @indexing($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterfaces.indexing(p), args...)
  end
end
