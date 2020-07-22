using Test
using ProxyInterfaces


# ProxyInterfaces.@indexing
# ----------------------

struct MyIndexing{T}
  value::T
end

ProxyInterfaces.indexing(::Type{MyIndexing{T}}) where T = T
ProxyInterfaces.indexing(myindexing::MyIndexing) = myindexing.value
ProxyInterfaces.@indexing MyIndexing


myindexing = MyIndexing([11,22,33])
# WARNING  == is intentionally not overwritten in order to enable the use of this proxy next to something else
# hence the default == applies, which compares by ref, and not by content.
@test !(myindexing == MyIndexing([11, 22, 33]))
@test myindexing[1] == 11
@test myindexing[end] == 33
@test firstindex(myindexing) == 1
@test lastindex(myindexing) == 3


# no mutable functionality is defined
@test_throws MethodError myindexing[2] = 2
@test_throws MethodError empty!(myindexing)
@test_throws MethodError fill!(myindexing, 0)

# no other methods
@test_throws MethodError 22 in myindexing
@test_throws MethodError length(myindexing) == 3
@test_throws MethodError size(myindexing) == (3,)


# ProxyInterfaces.@indexing_mutable
# ------------------------------

struct MyMutableIndexing{T}
  value::T
end

ProxyInterfaces.indexing(::Type{MyMutableIndexing{T}}) where T = T
ProxyInterfaces.indexing(myindexing::MyMutableIndexing) = myindexing.value
ProxyInterfaces.@indexing_mutable MyMutableIndexing


myindexing_mutable = MyMutableIndexing([12, 13])
myindexing_mutable[2] = 44
@test myindexing_mutable[2] == 44
