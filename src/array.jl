function array end


macro array(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    # array includes iterator by default, as this will almost always be what is expected
    ProxyInterfaces.iterator(p::$ProxyType) = array(p)
    ProxyInterfaces.iterator(p::Type{<:$ProxyType}) = array(p)
    @iterator($ProxyType)
    
    Base.size(p::$ProxyType) = Base.size(ProxyInterfaces.array(p))
    Base.size(p::$ProxyType, d) = Base.size(ProxyInterfaces.array(p), d)
    Base.getindex(p::$ProxyType, args...)	= Base.getindex(ProxyInterfaces.array(p), args...)
    Base.firstindex(p::$ProxyType) = Base.firstindex(ProxyInterfaces.array(p))
    Base.lastindex(p::$ProxyType)	= Base.lastindex(ProxyInterfaces.array(p))
    # optional
    Base.IndexStyle(T::Type{<:$ProxyType}) = Base.IndexStyle(ProxyInterfaces.array(T))
    Base.length(p::$ProxyType) = Base.length(ProxyInterfaces.array(p))
    Base.similar(p::$ProxyType, args...) = $ProxyType(Base.similar(ProxyInterfaces.array(p), args...))
    # non-traditional
    Base.axes(p::$ProxyType) = Base.axes(ProxyInterfaces.array(p))
    # strides
    Base.strides(p::$ProxyType, args...) = Base.strides(ProxyInterfaces.array(p), args...)
    # extra
    Base.isempty(p::$ProxyType) = Base.isempty(ProxyInterfaces.array(p))
    Base.in(a, p::$ProxyType) = Base.in(a, ProxyInterfaces.array(p))
  end
end

macro array_mutable(ProxyType)
  ProxyType = esc(ProxyType)
  quote
    @array($ProxyType)
    Base.setindex!(p::$ProxyType, args...) = Base.setindex!(ProxyInterfaces.array(p), args...)
    Base.empty!(p::$ProxyType) = Base.empty!(ProxyInterfaces.array(p))
    Base.fill!(p::$ProxyType, x) = $ProxyType(Base.fill!(ProxyInterfaces.array(p), x))
  end
end
