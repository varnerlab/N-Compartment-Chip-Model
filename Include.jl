# setup paths -
const _PATH_TO_ROOT = pwd()
const _PATH_TO_SRC = "$(_PATH_TO_ROOT)/src"

# Load external packages -
using DataFrames
using CSV
using Plots
using Dates
using DifferentialEquations

# activate the project, and download any missing packages -
import Pkg
Pkg.activate(_PATH_TO_ROOT);
Pkg.instantiate()

# load my codes -
include("$(_PATH_TO_SRC)/Types.jl")
include("$(_PATH_TO_SRC)/Data.jl")
include("$(_PATH_TO_SRC)/Balances.jl")
include("$(_PATH_TO_SRC)/Solve.jl")