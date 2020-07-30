using Test
using ProxyInterfaces


# ProxyInterfaces.@array
# ----------------------

struct MyArray{T}
  value::T
end

ProxyInterfaces.array(::Type{MyArray{T}}) where T = T
ProxyInterfaces.array(myarray::MyArray) = myarray.value
ProxyInterfaces.@array MyArray


myarray = MyArray([11,22,33])
@test myarray.value == [11, 22, 33]
@test 22 in myarray
@test eltype(myarray) == Int
@test length(myarray) == 3
@test size(myarray) == (3,)
@test size(myarray, 1) == 3
@test myarray[1] == 11
@test myarray[end] == 33
@test firstindex(myarray) == 1

@test IndexStyle(typeof(myarray)) == IndexStyle(typeof(myarray.value))

sim1 = similar(myarray, Float32)
sim2 = MyArray(similar(myarray.value, Float32))
@test length(sim1) == length(sim2)
@test eltype(sim1) == eltype(sim2)

@test axes(myarray) == axes(myarray.value)
@test strides(myarray) == strides(myarray.value)

@test isempty(MyArray([]))

# no mutable functionality is defined
@test_throws MethodError myarray[2] = 2
@test_throws MethodError empty!(myarray)
@test_throws MethodError fill!(myarray, 0)


# ProxyInterfaces.@array_mutable
# ------------------------------

struct MyMutableArray{T}
  value::T
end

ProxyInterfaces.array(::Type{MyMutableArray{T}}) where T = T
ProxyInterfaces.array(myarray::MyMutableArray) = myarray.value
ProxyInterfaces.@array_mutable MyMutableArray


myarray_mutable = MyMutableArray([12, 13])
myarray_mutable[2] = 44
@test myarray_mutable[2] == 44

empty!(myarray_mutable)
@test isempty(myarray_mutable)
@test fill!(similar(myarray_mutable, Float32), 0).value == fill!(similar(myarray_mutable.value, Float32), 0)
