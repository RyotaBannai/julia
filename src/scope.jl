b = "outer b val"
function looksOuter(x, a = b, b = 1)
    # When `a` is not given, the variable `a` doesn't refer to `b` but `b` from outer scope sintead.
    """ looksOuter(1) # outer b val"""
    println("ok")
end

# you can `reuse` variable from `outer scope` in loop
function f_using_outer_val()
    i = 0
    for outer i = 1:3
        # empty
    end
    return i
end
