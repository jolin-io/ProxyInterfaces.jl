using Test
using ProxyInterfaces

# ProxyInterfaces.@dict
# ---------------------

struct MyDict{T}
  value::T
end

ProxyInterfaces.dict(::Type{MyDict{T}}) where T = T
ProxyInterfaces.dict(mydict::MyDict) = mydict.value
ProxyInterfaces.@dict MyDict

mydict = MyDict(Dict(:a => 4))

@test mydict[:a] == 4
@test length(mydict) == 1
@test (:a => 4) in mydict
@test haskey(mydict, :a)
@test !haskey(mydict, :b)
@test collect(values(mydict)) == [4]
@test collect(keys(mydict)) == [:a]

@test mydict.value == Dict(:a => 4)
@test merge(
  MyDict(Dict(:a => 4, :b => 5)),
  MyDict(Dict(:b => 32, :c => "hi"))
).value == Dict(:a => 4, :b => 32, :c => "hi")

@test_throws MethodError mydict[:b] = 42
@test_throws MethodError empty!(mydict)


# ProxyInterfaces.@dict_mutable
# -----------------------------

struct MyMutableDict{T}
  value::T
end

ProxyInterfaces.dict(::Type{MyMutableDict{T}}) where T = T
ProxyInterfaces.dict(mydict::MyMutableDict) = mydict.value
ProxyInterfaces.@dict_mutable MyMutableDict

mydict_mutable = MyMutableDict(Dict(:a => 4))
mydict_mutable[:b] = 42
@test mydict_mutable[:b] == 42

empty!(mydict_mutable)
@test mydict_mutable.value == Dict()
