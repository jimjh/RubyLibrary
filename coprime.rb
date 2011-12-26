require 'set'

# A pair has a left and a right
module Pair
  attr_accessor :left
  attr_accessor :right
end

class Coprime

  # map from integer n to a set of all integers less than n and
  # coprime to n.
  attr_reader :coprimes

  # set of all frontiers
  # a frontier is a leaf in the search tree (where the last search
  # stopped)
  attr_reader :frontiers

  # initializes the frontiers and known coprimes
  def initialize
    @coprimes = {2 => [1], 3 => [1]}
    @frontiers = [Frontier.new(2,1), Frontier.new(3,1)]
    @frontier_lowerbound = 1      # all frontiers at least beyond this number
  end

  # calculates the totient number of n
  def totient( n )
    return get_coprimes(n).count
  end

  def totient_lowerbound( n )
    coprimes = @coprimes[n]
    return coprimes.nil? ? 1 : coprimes.count
  end

  # takes a positive integer n and returns a set of all integers less
  # than n and coprime to n.
  # side effects: advances frontiers (and updates coprimes) if necessary
  def get_coprimes( n )

    # if n is lower than our lower bound, just return
    return coprimes[n] if n < @frontier_lowerbound

    # push every frontier at least beyond n
    frontiers = @frontiers
    @frontiers = []
    frontiers.each do |frontier|
      if (frontier.left > n)
        @frontiers << frontier
      else
        advance_frontier(frontier, n)
      end
    end

# took twice as long
#    @frontiers = @frontiers.collect_concat do |frontier|
#      advance_frontier(frontier,n)
#    end

    @frontier_lowerbound = n
    return coprimes[n]

  end

  # takes a frontier and returns an array of frontiers that
  # are at least beyond x
  def advance_frontier(frontier, x)

    m = frontier.left
    n = frontier.right    

    # otherwise, make one step down the search tree
    advanced = frontier.advance
    advanced.each do |frontier| 
      add_coprime(frontier)
      if (frontier.left > x)
        @frontiers << frontier
      else
        advance_frontier(frontier, x)
      end
    end
  
  end

  # adds the given pair of coprimes to @coprimes
  # assumes that left > right (which is true for all frontiers)
  def add_coprime( pair )
    # if there already is a set, insert it; otherwise, create a new set
    curr = @coprimes[pair.left]
    if curr.nil?
      @coprimes[pair.left] = [pair.right]
    else curr << pair.right
    end
  end


  # Frontier: a leaf in the search tree, represented as a pair
  # of coprime numbers, where left > right.
  class Frontier

    include Pair

    def initialize( left, right )
      @left = left
      @right = right
    end

    # takes the current frontier and returns a set of the next frontiers
    def advance
      m = @left
      n = @right
      return [Frontier.new(2*m+n, m), Frontier.new(2*m-n, m), Frontier.new(m+2*n, n)]
    end

  end

end
