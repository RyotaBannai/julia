using PartialFunctions

struct MyRational{T<:Integer} <: Real
    num::T
    den::T
    function MyRational{T}(num::T, den::T) where {T<:Integer}
        if num == 0 && den == 0
            error("invalid ratioanl: 0//0")
        end
        g = gcd(den, num)
        num = div(num, g)
        den = div(den, g)
        new(num, den)
    end
end

MyRational(n::T, d::T) where {T<:Integer} = MyRational{T}(n, d)
MyRational(n::Integer, d::Integer) = MyRational(promote(n, d)...)
MyRational(n::Integer) = MyRational(n, one(d))
⊘(n::Integer, d::Integer) = MyRational(n, d)
⊘(x::MyRational, y::Integer) = x.num ⊘ (x.den * y)
⊘(x::Integer, y::MyRational) = (y.den * x) ⊘ y.num
⊘(x::Complex, y::Real) = complex(real(x) ⊘ y, imag(x) ⊘ y)
⊘(x::Real, y::Complex) = (x * y') ⊘ real(y * y')
function ⊘(x::Complex, y::Complex)
    xy = x * y'
    yy = real(y * y')
    complex(real(xy) ⊘ yy, imag(xy) ⊘ yy)
end
