PLSRegressor.jl
======

A Partial Least Squares Regressor package. Contains PLS1, PLS2 and Kernel PLS2 NIPALS algorithms.
Can be used mainly for regression. However, for classification task, binarizing targets and then obtaining multiple targets, you can apply KPLS.


| **PackageEvaluator**            | **Build Status**                          |
|:-------------------------------:|:-----------------------------------------:|
| [![][pkg-0.6-img]][pkg-0.6-url] | [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

[travis-img]: https://travis-ci.org/lalvim/PLSRegressor.jl.svg?branch=master
[travis-url]: https://travis-ci.org/lalvim/PLSRegressor.jl

[codecov-img]: http://codecov.io/github/lalvim/PLSRegressor.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/lalvim/PLSRegressor.jl?branch=master

[issues-url]: https://github.com/lalvim/PLSRegressor.jl/issues

[pkg-0.6-img]: http://pkg.julialang.org/badges/PLSRegressor_0.6.svg
[pkg-0.6-url]: http://pkg.julialang.org/?pkg=PLSRegressor&ver=0.6
[pkg-0.7-img]: http://pkg.julialang.org/badges/PLSRegressor_0.7.svg
[pkg-0.7-url]: http://pkg.julialang.org/?pkg=PLSRegressor&ver=0.7

Install
=======

    Pkg.add("PLSRegressor") # or ] add PLSRegressor

Using
=====

    using PLSRegressor

Example (MLJ)
========

    using MLJ
    using MLJBase

    import PLSRegressor: PLS
    import RDatasets


    data = RDatasets.dataset("datasets", "longley");

    y, X = unpack(data, ==(:GNP), colname -> true);

    # algorothm
    pls_model      = PLS(n_factors=3,centralize=true,copy_data=true,rng=42)

    # associating algo. and data
    pls_machine    = MLJ.machine(pls_model, X, y)

    # evaluate you regressor using cross validation
    MLJ.evaluate!(pls_machine, resampling=CV(shuffle=true), measure=[mae], verbosity=0)


    # you can use hould out
    train, test    = MLJ.partition(eachindex(y), 0.7, shuffle=true); 

    MLJ.fit!(pls_machine, rows=train)

    yhat = MLJ.predict(pls_machine, rows=test);

    MLJ.mae(yhat, y[test]) |> mean



What is Implemented
======
* A fast linear algorithm for single targets (PLS1 - NIPALS)
* A linear algorithm for multiple targets (PLS2 - NIPALS)
* A non linear algorithm for multiple targets (Kernel PLS2 - NIPALS)


Method Description 
=======

* PLS - PLS MLJ model (identidies PLS1 or PLS2)
    * nfactors::Int = 10 - The number of latent variables to explain the data.
    * copydata::Bool = true - If you want to use the same input matrix or a copy.
    * centralize::Bool = true - If you want to z-score columns. Recommended if not z-scored yet.
    * kernel::AbstractString = "rbf" - use a non linear kernel.
    * width::AbstractFloat   = 1.0 - If you want to z-score columns. Recommended if not z-scored yet.

* KPLS - Kernel PLS MLJ model
    * nfactors::Int = 10 - The number of latent variables to explain the data.
    * copydata::Bool = true - If you want to use the same input matrix or a copy.
    * centralize::Bool = true - If you want to z-score columns. Recommended if not z-scored yet.


References
=======
* PLS1 and PLS2 based on
   * Bob Collins Slides, LPAC Group. http://vision.cse.psu.edu/seminars/talks/PLSpresentation.pdf
* A Kernel PLS2 based on
   * Kernel Partial Least Squares Regression in Reproducing Kernel Hilbert Space" by Roman Rosipal and Leonard J Trejo. Journal of Machine Learning Research 2 (2001) 97-123 http://www.jmlr.org/papers/volume2/rosipal01a/rosipal01a.pdf

* NIPALS: Nonlinear Iterative Partial Least Squares
    * Wold, H. (1966). Estimation of principal components and related models
by iterative least squares. In P.R. Krishnaiaah (Ed.). Multivariate Analysis.
(pp.391-420) New York: Academic Press.

* SIMPLS: more efficient, optimal result
    * Supports multivariate Y
    * De Jong, S., 1993. SIMPLS: an alternative approach to partial least squares
regression. Chemometrics and Intelligent Laboratory Systems, 18: 251–
263

License
=======

The PLSRegressor.jl is free software: you can redistribute it and/or modify it under the terms of the MIT "Expat"
License. A copy of this license is provided in ``LICENSE.md``
