local f = Const("f")
local a = Const("a")
print(mk_explicit(f)(a))
assert(is_explicit(mk_explicit(f)))
assert(not is_explicit(f))
assert(get_explicit_arg(mk_explicit(f)) == f)
check_error(function() get_explicit_arg(f) end)
