using Statistics
using LinearAlgebra
import Random
using MLJ

@testset "KPLS Pediction Tests (in sample)" begin

    @testset "Test KPLS Single Non Linear Target" begin

        Random.seed!(1)

        z(x)     = 4.26 * (exp.(-x) - 4 * exp.(-2.0*x) + 3 * exp.(-3.0*x))
        x_values = Array(range(0.0,step=3.5,length=100))
        z_pure   = z(x_values)
        noise    = Random.randn(100)
        z_noisy  = z_pure + noise
        X        = collect(x_values)[:,:]
        Y        = z_noisy[:,:] #z_pure
        
        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-2


    end

    @testset "Test KPLS Single Target (Linear Target)" begin


        X        = [1 2; 2 4; 4.0 6][:,:]
        Y        = [-2; -4; -6.0][:,:]

        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-2

        X        = [1 2; 2 4; 4.0 6][:,:]
        Y        = [2; 4; 6.0][:,:]

        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-2

    end

    @testset "Test KPLS Multiple Target (Linear Target)" begin


        X        = [1; 2; 3.0][:,:]
        Y        = [1 1; 2 2; 3 3.0][:,:]
        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-6

        X        = [1; 2; 3.0][:,:]
        Y        = [1 -1; 2 -2; 3 -3.0][:,:]
        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-6

        @testset "Linear Prediction Tests " begin


        X        = [1 2; 2 4; 4 6.0][:,:]
        Y        = [4 2;6 4;8 6.0][:,:]
        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-6

        X           = [1 -2; 2 -4; 4 -6.0][:,:]
        Y           = [-4 -2;-6 -4;-8 -6.0][:,:]
        pls_model      = KPLS(n_factors=1,kernel="rbf",width=0.01,centralize=true,copy_data=true,rng=42)
        pls_machine    = MLJ.machine(pls_model, X, Y)
        
        train = range(1,len(X))
        MLJ.fit!(pls_machine, rows=train,force=true)
        yhat = MLJ.predict(pls_machine, rows=train);
        @test MLJ.mae(yhat, y[train]) |> mean < 1e-6


        end


    end

end;


