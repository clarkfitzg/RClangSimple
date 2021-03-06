library(RCIndex)

if(FALSE) {
tu = createTU("../exampleCode/mutateArg.c")
r = getRoutines(tu, getFileName(tu))

v = genMutatesCollector(names(r$foo@params))
visitCursor(r$foo, v$update)
}
run = function(id) {
  v = genMutatesCollector(names(r[[id]]@params))
  visitCursor(r[[id]], v$update)
  v$vars()
}


genMutatesCollector =
function(paramNames)  
{
    inAssignment = FALSE
    modifiedVars = character()
    calls = character()
    
    update =
      function(cur, parent)  {
        k = cur$kind
        if(k == CXCursor_BinaryOperator && "=" %in% (toks <- getCursorTokens(cur)) ) 
          processLHS(cur[[1]])

        CXChildVisit_Recurse
      }

    processLHS = function(cur) {
      k = cur$kind

      id = if(k == CXCursor_ArraySubscriptExpr) { # x[i], y[x[i]], x[foo()]
             processLHS(cur[[2]])
             getName(cur[[1]])
           } else if(k == CXCursor_UnaryOperator){
             if(cur[[1]]$kind == CXCursor_ParenExpr)
               return(processLHS(cur[[1]][[1]]))
             else if(cur[[1]]$kind == CXCursor_DeclRefExpr)
               getName(cur[[1]])
             else if(cur[[1]]$kind == CXCursor_CallExpr)
                 calls <<- c(calls, getName(cur[[1]]))
           } else if(k == CXCursor_FirstExpr || k == CXCursor_DeclRefExpr) {  # recursively from *( x + i) with x and again with i
             getName(cur)
           } else if(k == CXCursor_BinaryOperator) { # x + i arising in *(x + i)
             return(sapply(children(cur), processLHS))
           } else if(k == CXCursor_CallExpr)
                 return(calls <<- c(calls, getName(cur)))
      
      if(!is.null(id) && id %in% paramNames)
          modifiedVars <<- c(modifiedVars, id)
    }

    list(update = update, vars = function() list(changed = modifiedVars, calls = calls)  )
  }






genParamsCollector =
function(namesOnly = FALSE)
{
   params = if(namesOnly) character() else list()
   update = function(cur, kind) {
      k = cur$kind
      if(k == CXCursor_ParmDecl) {
        n = length(params) + 1
        if(namesOnly)
          params <<- c(params, getName(cur))
        else {
          params[[ n ]] <<- cur
          names(params)[n] <<- getName(cur)
        }
      }

      CXChildVisit_Recurse
   }

   list(update = update, params = function() params)
}

getParameters =
function(r, visitor = genParamsCollector(namesOnly), namesOnly = FALSE)
{
   visitTU(r, visitor$update, clone = !namesOnly)
   visitor@params()
}
