require 'priority_queue'
require 'set'

# directed, weighted graph
class Graph

  INFINITY = 1 << 64

  def initialize
    @g = {} # the graph - {node => {edge1 => weight, edge2 => weight}, ...}
    @nodes = Set.new
  end

  # s= source, t= target, w= weight
  def add_edge(s, t, w)

    if (not @g.has_key? s)
      @g[s] = {t => w}
    else
      @g[s][t] = w
    end

    @nodes.merge [s,t]

  end

  # uses Dijkstra's to find shortest paths from source
  def shortest_distances( src )
    
    raise ArgumentError if (not @g.has_key? src)

    # keep a priority queue of nodes, ordered by known distances
    distances = CPriorityQueue.new
    @nodes.each { |node|
      distances[node] = INFINITY
    }
    distances[src] = 0;

    results = {}

    while( not distances.empty? ) do
      
      # get the shortest known
      pair = distances.delete_min
      node = pair[0]
      node_dist = pair[1]
  
      # record
      results[node] = node_dist 

      # traverse all neighbors
      neighbors = @g[node] || {}
      neighbors.each { |neighbor, dist|
        # if it's nearer to go by me, update
        neighbor_d = distances[neighbor] || -1    # neighbor may have been found already
        if (node_dist + dist < neighbor_d)
          distances[neighbor] = node_dist + dist
        end
      }

    end

    return results

  end

end
