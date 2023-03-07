module WeightedEdgeListFormat

  struct WELFormat <: Graphs.AbstractGraphFormat
    delim
    WELFormat() = new(",")
    WELFormat(delim) = new(delim)
  end

  function Graphs.loadgraph(io::IO, gname::String, f::WELFormat)
    g, _ = read_edge_list_weighted(io; delim=f.delim)

    g
  end

  Graphs.loadgraphs(io::IO, f::WELFormat) = loadgraph(io, "...", f)

  function read_edge_list_weighted(filename; delim=" ")
    csv = CSV.read(filename, DataFrame; header=false, delim=delim)
    if minimum(csv[:, 1]) == 0 || minimum(csv[:, 2]) == 0
      csv .+= 1
    end
    labels = unique(sort(vcat(csv[:, 1], csv[:, 2])))
    g = SimpleWeightedGraph(csv[:, 1], csv[:, 2], csv[:, 3]; combine=max)

    g, labels
  end


end # module WeightedEdgeListFormat
