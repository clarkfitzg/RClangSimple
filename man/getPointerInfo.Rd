\name{getPointerInfo}
\alias{getPointerInfo}
\alias{getPointerDepth}
\title{Get information about a libclang pointer type}
\description{
  These functions compute information about a pointer \code{CXType}.
}
\usage{
getPointerInfo(type)
getPointerDepth(type, kind = getTypeKind(type))
}

\arguments{
  \item{type}{the \code{CXType} object being queried}
  \item{kind}{the kind of the type obtained by \code{type$kind} or \code{getTypeKind(type)}}
}
\value{
  \code{getPointerInfo} returns a  list with two elements:
  \item{\code{depth}}{the number of indirections for the pointer to a
    non-pointer type, i.e. the number of \code{*} in the corresponding C
    declaration.}
  \item{\code{baseType}}{the type of the element ultimately being
    pointed to}
}
\references{
 libclang \url{http://clang.llvm.org/doxygen/group__CINDEX.html}
}
\author{
Duncan Temple Lang
}
%\seealso{}
%\examples{}
\keyword{programming}
\keyword{interface}
