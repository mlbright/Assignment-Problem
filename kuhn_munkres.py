#!/usr/bin/python
#------------------------------------------------------------------------------#

# The Kuhn-Munkres or Hungarian algorithm.
# Complexity: O(n^3)
# Computes a max weight perfect matching in a bipartite graph

# Modified from:
# http://www.enseignement.polytechnique.fr/informatique/INF441/INF441b/code/kuhnMunkres.py

# Very good explanations at:
# http://www.topcoder.com/tc?module=Static&d1=tutorials&d2=hungarianAlgorithm
# http://www.cse.ust.hk/~golin/COMP572/Notes/Matching.pdf
# http://www.math.uwo.ca/~mdawes/courses/344/kuhn-munkres.pdf

"""
    For min weight perfect matching, simply negate the weights.

    Global variables:
       n = number of vertices on each side
       U,V vertex sets
       lu,lv are the labels of U and V resp.
       the matching is encoded as 
       - a mapping Mu from U to V, 
       - and Mv from V to U.
    
    The algorithm repeatedly builds an alternating tree, rooted in a
    free vertex u0. S is the set of vertices in U covered by the tree.
    For every vertex v, T[v] is the parent in the tree and Mv[v] the
    child.

    The algorithm maintains min_slack, s.t. for every vertex v not in
    T, min_slack[v]=(val,u1), where val is the minimum slack
    lu[u]+lv[v]-w[u][v] over u in S, and u1 is the vertex that
    realizes this minimum.

    Complexity is O(n^3), because there are n iterations in
    assign, and each call to augment costs O(n^2). This is
    because augment() makes at most n iterations itself, and each
    updating of min_slack costs O(n).
"""


def improve_labels(val):
    """ change the labels, and maintain min_slack. """
    for u in S:
        lu[u] -= val
    for v in xrange(N):
        if v in T:
            lv[v] += val
        else:
            min_slack[v][0] -= val


def improve_matching(v):
    """ apply the alternating path from v to the root in the tree. """
    u = T[v]
    if u in Mu:
        improve_matching(Mu[u])
    Mu[u] = v
    Mv[v] = u


def slack(u,v):
    return lu[u] + lv[v] - w[u][v]


def augment():
    """ augment the matching, possibly improving the labels on the way. """
    while True:
        # select edge (u,v) with u in S, v not in T and min slack
        ((val, u), v) = min([(min_slack[v], v) for v in xrange(N) if v not in T])
        assert u in S
        if val > 0:        
            improve_labels(val)
        # now we are sure that (u,v) is saturated
        assert slack(u,v)==0
        T[v] = u                            # add (u,v) to the tree
        if v in Mv:
            u1 = Mv[v]                      # matched edge, 
            assert not u1 in S
            S.add(u1)
            for v in xrange(N): # maintain min_slack
                if v not in T and min_slack[v][0] > slack(u1,v):
                    min_slack[v] = [slack(u1,v), u1]
        else:
            improve_matching(v) # v is a free vertex
            return


def assign(weights):
    """
    given w, the weight matrix of a complete bipartite graph,
    returns the mappings Mu : U -> V, Mv : V -> U,
    encoding the matching as well as the value of it.
    """
    global S,T,Mu,Mv,lu,lv,min_slack,w,N
    w  = weights
    N  = len(w)
    lu = [max([w[u][v] for v in xrange(N)]) for u in xrange(N)]  # start with trivial labels
    lv = [0 for v in xrange(N)]
    Mu = {}                                       # start with empty matching
    Mv = {}
    while len(Mu) < N:
        u0 = [u for u in xrange(N) if u not in Mu][0] # choose free vertex u0
        S = set([u0])
        T = {}
        min_slack = [[slack(u0,v), u0] for v in xrange(N)]
        augment()
    # val. of matching is total edge weight
    val = sum(lu) + sum(lv)
    return (Mv, Mu, val)


if __name__ == "__main__":

    # a small example 
    print assign([[1,2,3,4],[2,4,6,8],[3,6,9,12],[4,8,12,16]])
    # even smaller examples
    print assign([[1,2,3],[3,3,3],[3,3,2]])
    print assign([[7,4,3],[3,1,2],[3,0,0]])
    print assign([[-1,-2,-3],[-3,-3,-3],[-3,-3,-2]])
    print assign([
        [62,75,80,93,95,97],
        [75,80,82,85,71,97],
        [80,75,81,98,90,97],
        [78,82,84,80,50,98],
        [90,85,85,80,85,99],
        [65,75,80,75,68,96]
        ])
