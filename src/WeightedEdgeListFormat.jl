module WeightedEdgeListFormat
  using Graphs
  using CSV
  using DataFrames
  using GraphIO
  using SimpleWeightedGraphs

  export WELFormat
  export loadgraph
  export loadgraphs
  export read_edge_list_weighted

  import Graphs:
    AbstractGraphFormat, loadgraph, loadgraphs, savegraph

  struct WELFormat <: AbstractGraphFormat
    delim
    WELFormat() = new(",")
    WELFormat(delim) = new(delim)
  end

  function loadgraph(io::IO, gname::String, f::WELFormat)
    g, _ = read_edge_list_weighted(io; delim=f.delim)

    g
  end

  loadgraphs(io::IO, f::WELFormat) = loadgraph(io, "...", f)

  function read_edge_list_weighted(filename; delim=" ")
    csv = CSV.read(filename, DataFrame; header=false, delim=delim)
    if minimum(csv[:, 1]) == 0 || minimum(csv[:, 2]) == 0
      csv .+= 1
    end
    labels = unique(sort(vcat(csv[:, 1], csv[:, 2])))
    g = SimpleWeightedGraph(csv[:, 1], csv[:, 2], csv[:, 3]; combine=max)

    g, labels
  end

  function greet_123()
    print("AAa")
  end

end # module WeightedEdgeListFormat
