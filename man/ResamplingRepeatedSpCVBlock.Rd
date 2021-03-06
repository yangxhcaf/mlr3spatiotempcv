% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ResamplingRepeatedSpCVBlock.R
\name{ResamplingRepeatedSpCVBlock}
\alias{ResamplingRepeatedSpCVBlock}
\title{Repeated Spatial Cross Validation Resampling}
\description{
Spatial Block Cross validation implemented by the \code{blockCV}
package.
}
\details{
By default \code{\link[blockCV:spatialBlock]{blockCV::spatialBlock()}} does not allow the creation of multiple
repetitions. \code{mlr3spatiotempcv} adds support for this when using the \code{range}
argument for fold creation. When supplying a vector of \code{length(repeats)} for
argument \code{range}, these different settings will be used to create folds which
differ among the repetitions.

Multiple repetitions are not possible when using the "row & cols" approach
because the created folds will always be the same.
}
\examples{
library(mlr3)
task = tsk("diplodia")

# Instantiate Resampling
rrcv = rsmp("repeated-spcv-block",
  folds = 3, repeats = 2,
  range = c(1000, 1500))
rrcv$instantiate(task)

# Individual sets:
rrcv$iters
rrcv$folds(1:6)
rrcv$repeats(1:6)

# Individual sets:
rrcv$train_set(1)
rrcv$test_set(1)
intersect(rrcv$train_set(1), rrcv$test_set(1))

# Internal storage:
rrcv$instance # table
}
\references{
\cite{mlr3spatiotempcv}{valavi2018}
}
\section{Super class}{
\code{\link[mlr3:Resampling]{mlr3::Resampling}} -> \code{ResamplingRepeatedSpCVBlock}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{iters}}{\code{integer(1)}\cr
Returns the number of resampling iterations, depending on the
values stored in the \code{param_set}.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{ResamplingRepeatedSpCVBlock$new()}}
\item \href{#method-folds}{\code{ResamplingRepeatedSpCVBlock$folds()}}
\item \href{#method-repeats}{\code{ResamplingRepeatedSpCVBlock$repeats()}}
\item \href{#method-instantiate}{\code{ResamplingRepeatedSpCVBlock$instantiate()}}
\item \href{#method-clone}{\code{ResamplingRepeatedSpCVBlock$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="format">}\href{../../mlr3/html/Resampling.html#method-format}{\code{mlr3::Resampling$format()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="help">}\href{../../mlr3/html/Resampling.html#method-help}{\code{mlr3::Resampling$help()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="print">}\href{../../mlr3/html/Resampling.html#method-print}{\code{mlr3::Resampling$print()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="test_set">}\href{../../mlr3/html/Resampling.html#method-test_set}{\code{mlr3::Resampling$test_set()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="train_set">}\href{../../mlr3/html/Resampling.html#method-train_set}{\code{mlr3::Resampling$train_set()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Create an "coordinate-based" repeated resampling instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVBlock$new(id = "repeated-spcv-block")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{\code{character(1)}\cr
Identifier for the resampling strategy.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-folds"></a>}}
\if{latex}{\out{\hypertarget{method-folds}{}}}
\subsection{Method \code{folds()}}{
Translates iteration numbers to fold number.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVBlock$folds(iters)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{iters}}{\code{integer()}\cr
Iteration number.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-repeats"></a>}}
\if{latex}{\out{\hypertarget{method-repeats}{}}}
\subsection{Method \code{repeats()}}{
Translates iteration numbers to repetition number.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVBlock$repeats(iters)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{iters}}{\code{integer()}\cr
Iteration number.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-instantiate"></a>}}
\if{latex}{\out{\hypertarget{method-instantiate}{}}}
\subsection{Method \code{instantiate()}}{
Materializes fixed training and test splits for a given task.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVBlock$instantiate(task)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task}}{\link{Task}\cr
A task to instantiate.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVBlock$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
