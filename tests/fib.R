library(RCIndex)
f = system.file("exampleCode", "fib.c", package = "RCIndex")
funs = RCIndex::getFunctions(f)
fib = funs$fib
as(fib@returnType, "character")


fib@params$n$language
fib@params$n$kind

