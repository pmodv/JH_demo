# produce a series of data to export
import Pkg;

Pkg.add(["CSV","Distributions","DataFrames","Tables","Primes","JuliaHub"]);

using Distributions, CSV,DataFrames,Tables,Primes,JuliaHub;

    # our profound computation
function profound_computation()   

    for i in 1:100

        # add some "side-effects" to make logging relevant
        path_dep_variable = rand(1:10)

        #  ... and the relevant log...
        if mod(path_dep_variable,3) == 0
            @warn "Attention!  Random divisible-by-three event!" number = path_dep_variable 
        end

        # random number to factor
        p = factor(i*path_dep_variable)

        factor_keys = collect(keys(p))

        
        @info "factorization logging:" index = i factors = p largest_factor=maximum(factor_keys)

        end
    end

    

profound_computation()
# dictionary of parameters for our three distributions
paramDict = Dict("geo"=>0.9,"beta"=>(3,9),"gamma"=>(6,5))

# distributions
geo_dist = Distributions.Geometric(paramDict["geo"])

# note: "unpacking" tuple argument with ellipses
beta_dist = Distributions.Beta(paramDict["beta"]...)

# note:  again, "unpacking" tuple argument with ellipses
gamma_dist = Distributions.Gamma(paramDict["gamma"]...)

# generate some data(parametric, for our demo)

# 100 geometric RV's
d1 = (rand(geo_dist,100));

# 100 beta RV's
d2 = (rand(beta_dist,100));

# 100 gamma RV's
d3 = (rand(gamma_dist,100));

# concatenate into a single matrix

df = hcat(d1,d2,d3);


# write to CSV file

# df is currently a "Matrix" - needs to be a "Tables" Type for CSV write
 
headers = [Symbol(x) for x in ["d1","d2","d3"]]
df_table = Tables.table(df; header=headers)



# perform esoteric computation, here 
# demonstrate logging ability within JH


Tables.columnnames(df_table)
    
CSV.write("data.csv",df_table)


# last step - very important
# push data.csv to JuliaHub, enabling the analyst in Part 3 to access the dataset from the Project
JuliaHub.upload_dataset("Dataset_3_Variable_Model", "data.csv",replace=true)
