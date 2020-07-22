using Test
using ProxyInterfaces
using Suppressor

# ProxyInterfaces.@iterator
# ----------------------

struct MyIterator{T}
  value::T
end

ProxyInterfaces.iterator(::Type{MyIterator{T}}) where T = T
ProxyInterfaces.iterator(myiterator::MyIterator) = myiterator.value
ProxyInterfaces.@iterator MyIterator


myiterator = MyIterator([11,22,33])
# WARNING  == is intentionally not overwritten in order to enable the use of this proxy next to something else
# hence the default == applies, which compares by ref, and not by content.
@test !(myiterator == MyIterator([11, 22, 33]))
@test 22 in myiterator  # works via iterator interface
@test Base.IteratorEltype(myiterator) isa Base.HasEltype
@test eltype(myiterator) == Int
@test Base.IteratorSize(myiterator) isa Base.HasShape
@test length(myiterator) == 3
@test size(myiterator) == (3,)
@test axes(myiterator) == axes(myiterator.value)
@test ndims(myiterator) == 1

@test first(myiterator) == 11
@test_throws MethodError last(myiterator) == 33

@test isempty(MyIterator([]))

@test @capture_out(foreach(print, myiterator)) == "112233"
@test map(x -> x+2, myiterator).value == map(x -> x+2, myiterator.value)


# no mutable functionality is defined
@test_throws MethodError myiterator[2] = 2
@test_throws MethodError empty!(myiterator)
@test_throws MethodError fill!(myiterator, 0)
