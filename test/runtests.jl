using Test
using ProxyInterface

# @forward
# --------

# taken from https://github.com/MikeInnes/Lazy.jl/blob/0de1643f37555396d615e825fb17b73edb0b5939/test/runtests.jl

# define structs for @forward macro testing below
struct Foo112 end
struct Bar112 f::Foo112 end

@testset "Forward macro" begin
    play(x::Foo112; y) = y                        # uses keyword arg
    play(x::Foo112, z) = z                        # uses regular arg
    play(x::Foo112, z1, z2; y) = y + z1 + z2      # uses both

    @forward Bar112.f play                        # forward `play` function to field `f`

    let f = Foo112(), b = Bar112(f)
        @test play(f, y = 1) === play(b, y = 1)
        @test play(f, 2) === play(b, 2)
        @test play(f, 2, 3, y = 1) === play(b, 2, 3, y = 1)
    end
end


# ProxyInterfaces
# ---------------

# TODO test ProxyInterfaces
