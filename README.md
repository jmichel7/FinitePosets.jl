
<a id='Posets'></a>

<a id='Posets-1'></a>

# Posets


<a id='Posets' href='#Posets'>#</a>
**`Posets`** &mdash; *Module*.



This  package deals with  finite posets. 

There  are two kinds of  posets. A "canonical poset"  or `CPoset` is on the elements  `1:n`  where  `n=length(P)`.  A  `Poset`  is  on  a given list of elements  which may be of any type. A `Poset` contains internally a`CPoset` working  on  the  indices  of  the  elements,  which is more efficient than working  with  the  elements  themselves.  Similarly  for  efficiency  many functions  work with the  `CPoset` by transformeing  their input to indices and their output to elements.

A  `CPoset` has the field:

  * `hasse`:  a list representing  the Hasse diagram  of the poset: the `i`-th  entry is the list of elements which cover (are immediate  successors of) `i`, that  is the list of `j` such that `i<j` and there is no `k` such that `i<k<j`.

The following is cached when computed to speed up subsequent computations:

  * `incidence`: a  boolean matrix  such that `incidence[i,j]==true` iff `i<=j`. This is sometimes called the ζ-matrix of the poset.

There are several ways of defining a poset.  By entering the Hasse diagram:

```julia-repl
julia> p=CPoset([[2,3],[4],[4],Int[]])
1<2,3<4
```

As  seen above, `p` is shown as a list of covering maximal chains; elements which  are  equivalent  for  the  poset  are  printed together separated by commas.

```julia-repl
julia> length(p) # the number of elements of `p`
4

julia> incidence(p)
4×4 Matrix{Bool}:
 1  1  1  1
 0  1  0  1
 0  0  1  1
 0  0  0  1

julia> linear_extension(p) # a total order compatible with p
4-element Vector{Int64}:
 1
 2
 3
 4
```

A `Poset` is constructed from a `CPoset` and a list of elements

```julia-repl
julia> P=Poset(p,[:a,:b,:c,:d])
a<b,c<d

julia> P.C # the CPoset attached to P
1<2,3<4
```

A  convenient  constructor  for  `Poset`s  takes  a  function  representing `isless`  for the poset and  the list of elements  and constructs the poset from  the incidence matrix, computed by  applying the function to each pair of  elements. For `isless` one can  give either a function implementing `<` or a function implementing `≤` (it is `or`-ed with `=` in any case).

```julia-repl
julia> l=vec(collect(Iterators.product(1:2,1:2)))
4-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (2, 1)
 (1, 2)
 (2, 2)

julia> P=Poset((x,y)->all(map(<=,x,y)),l)
(1, 1)<(2, 1),(1, 2)<(2, 2)

julia> eltype(P) # the type of the elements of P
Tuple{Int64, Int64}

julia> summary(P) # useful for big posets
"Poset{Tuple{Int64, Int64}} of length 4"
```

A  poset  can  also  be  constructed  from  an incidence matrix so the last example could also be entered as

```julia-repl
julia> P=Poset(CPoset([all(map(<=,x,y)) for x in l, y in l]),l)
(1, 1)<(2, 1),(1, 2)<(2, 2)
```

Flexibility  on  printing  a  `Poset`  is  obtained by setting the function `show_element`  which takes as arguments an  `IO`, the poset, and the index of the element to print:

```julia-repl
julia> P.show_element=(io,p,n)->join(io,p.elements[n],".");

julia> P
1.1<2.1,1.2<2.2

julia> delete!(P,:show_element); # back to default
```

The above fancy printing applies only when printing at the REPL or in pluto or  Jupyter. The default printing  gives a form which  can be input back in Julia

```julia-rep1
julia> print(P) 
Poset(CPoset([[2, 3], [4], [4], Int64[]]),[(1, 1), (2, 1), (1, 2), (2, 2)])
```

A poset can be specified by a list of tuples specifing order relations. The transitive  closure  of  these  relations  is computed, giving an incidence matrix  from which the  poset is built.  The elements of  the poset, if not specified separately, will be all the elements which appear in the tuples.

```julia-repl
julia> Poset([(:a,:b),(:c,:d)])
a<b
c<d

julia> CPoset([(1,3),(2,5)]) # the CPoset is on 1:maximum(entries)
4
1<3
2<5
```

To get the order relation `≤` of the poset `p` between elements `i` and `j` just call `≤(p,i,j)`. 

```julia-repl
julia> ≤(P,(1,1),(2,1))
true

julia> ≤(P.C,1,2) # the same
true
```

Intervals in a poset can be computed with strict or not bounds.

```julia-repl
julia> interval(P,≤,(1,2)) # elements below (1,2)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (1, 2)

julia> interval(P,≥,(1,2)) # elements above (1,2)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (2, 2)

julia> interval(P,<,(1,2)) # elements strictly below (1,2)
1-element Vector{Tuple{Int64, Int64}}:
 (1, 1)

julia> interval(P,≥,(2,1),≤,(2,2)) # elements between (2,1) and (2,2)
2-element Vector{Tuple{Int64, Int64}}:
 (2, 1)
 (2, 2)

julia> interval(P,>,(1,1),<,(2,2)) # elements strictly between
2-element Vector{Tuple{Int64, Int64}}:
 (2, 1)
 (1, 2)
julia> interval(P.C,>,1,<,4) # in terms of indices
2-element Vector{Int64}:
 2
 3
```

A sample of other functions available on posets:

```julia-repl
julia> maximal_chains(P)
2-element Vector{Vector{Tuple{Int64, Int64}}}:
 [(1, 1), (2, 1), (2, 2)]
 [(1, 1), (1, 2), (2, 2)]

julia> height(P) # the length of a maximal chain
3

julia> moebiusmatrix(P)
4×4 Matrix{Int64}:
 1  -1  -1   1
 0   1   0  -1
 0   0   1  -1
 0   0   0   1

julia> minima(P)
1-element Vector{Tuple{Int64, Int64}}:
 (1, 1)

julia> maxima(P)
1-element Vector{Tuple{Int64, Int64}}:
 (2, 2)

julia> Q=CPoset(:chain,3)
1<2<3

julia> P1=Poset(Q) # transformed to a Poset with elements 1:3
1<2<3

julia> P⊕ P1 # the ordinal sum
(1, 1)<(2, 1),(1, 2)<(2, 2)<1<2<3

julia> P1*P1
(1, 1)<(2, 1)<(3, 1)<(3, 2)<(3, 3)
(1, 1)<(1, 2)<(2, 2)<(3, 2)
(2, 1)<(2, 2)
(1, 2)<(1, 3)<(2, 3)<(3, 3)
(2, 2)<(2, 3)

julia> P1⊗ P1 # the ordinal product
(1, 1)<(1, 2)<(1, 3)<(2, 1)<(2, 2)<(2, 3)<(3, 1)<(3, 2)<(3, 3)
```

Finally `showpic(p)` where `p` is a `CPoset` or a `Poset` gives a graphical display of the poset (on Linux) provided you have the command `dot` and the command  `display` of  `imagemagick` installed.  It may  work on  MacOs and Windows but I did not test it.

see the on-line help on `⊕, ⊗,  chains, chainpoly, covering_chains, coxetermatrix,  dual,  hasse,  height, incidence,  induced,  interval,  isjoinlattice,  ismeetlattice,  linear_extension,  maxima, maximal_chains,  minima, moebius,  moebiusmatrix,  partition,  showpic, transitive_closure` for more information


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1-L233' class='documenter-source'>source</a><br>

<a id='Posets.Poset' href='#Posets.Poset'>#</a>
**`Posets.Poset`** &mdash; *Type*.



`Poset(p::CPoset,e::AbstractVector=1:length(p))`

creates a `Poset` with order specified by `p` and elements `e`.

```julia-repl
julia> Poset(CPoset([[2,3],[4],[4],Int[]]),[:a,:b,:c,:d])
a<b,c<d
```

with no second argument transforms a `CPoset` into a `Poset`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L356-L365' class='documenter-source'>source</a><br>


`Poset(f::Function,e::AbstractVector)`

creates a `Poset` with elements `e` and order between two elements given by function `f`.

```julia-repl
julia> Poset((x,y)->all(x.≤y),vec(collect(Iterators.product(1:2,1:3))))
(1, 1)<(2, 1)<(2, 2)<(2, 3)
(1, 1)<(1, 2)<(2, 2)
(1, 2)<(1, 3)<(2, 3)
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L407-L418' class='documenter-source'>source</a><br>


`Poset(covers::Vector{Tuple{T,T}}) where T`

creates a poset representing the transitive closure of the given relations. The  poset is on the elements which appear in the relations relations.

```julia-repl
julia> Poset([(:a,:b),(:d,:c)])
a<b
d<c
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L458-L469' class='documenter-source'>source</a><br>


  * `Poset(:chain,e)`  a chain with elements `e`
  * `Poset(:antichain,e)`  an antichain with elements `e`
  * `Poset(:powerset,n::Integer)`  the powerset of the set `1:n` with inclusion

```julia-repl
julia> p=Poset(:powerset,3);p.show_element=(io,p,n)->join(io,p.elements[n]);

julia> p
<1<12<123
<2<12
<3<13<123
1<13
2<23<123
3<23
```

  * `Poset(:powerset,e)`  the powerset of the set `e` with inclusion
  * `Poset(:partitionsdominance,n)`  the poset of partitions of `n` with dominance order

```julia-repl
julia> Poset(:partitionsdominance,5)
[1, 1, 1, 1, 1]<[2, 1, 1, 1]<[2, 2, 1]<[3, 1, 1]<[3, 2]<[4, 1]<[5]
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L483-L504' class='documenter-source'>source</a><br>

<a id='Posets.CPoset' href='#Posets.CPoset'>#</a>
**`Posets.CPoset`** &mdash; *Type*.



`CPoset(m::Matrix{Bool})`

Creates a poset from an incidence matrix `m`, that is `m[i,j]==true` if and only if `i≤j` in the poset,

```julia-repl
julia> CPoset(Bool[1 1 1 1 1;0 1 0 1 1;0 0 1 1 1;0 0 0 1 0;0 0 0 0 1])
1<2,3<4,5
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L380-L390' class='documenter-source'>source</a><br>


`CPoset(h::Vector{<:Vector{<:Integer}})`

Creates a poset from a Hasse diagram given as a `Vector` whose `i`-th entry is  the  list  of  indices  which  are immediate successors (covers) of the `i`-th  element, that is `h[i]`  is the list of  `j` such that `i<j` in the poset and such that there is no `k` such that `i<k<j`.

```julia-repl
julia> CPoset([[2,3],[4,5],[4,5],Int[],Int[]])
1<2,3<4,5
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L393-L404' class='documenter-source'>source</a><br>


`CPoset(f::Function,n::integer)`

creates the `Poset` on `1:n` with order given by function `f`.

```julia-repl
julia> CPoset((x,y)->y%x==0,8)  # the divisibility poset
1<5,7
1<2<4<8
1<3<6
2<6
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L422-L433' class='documenter-source'>source</a><br>


`CPoset(covers::Vector{Tuple{Int,Int}})`

creates a poset representing the transitive closure of the given relations. The  poset is on `1:n` where `n` is the maximum number which appears in the relations.

```julia-repl
julia> CPoset([(6,2),(5,1)])
3,4
5<1
6<2
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L436-L448' class='documenter-source'>source</a><br>


  * `CPoset(:chain,n)`  a chain on `1:n`
  * `CPoset(:antichain,n)`  an antichain on `1:n`


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L476-L479' class='documenter-source'>source</a><br>

<a id='Posets.hasse' href='#Posets.hasse'>#</a>
**`Posets.hasse`** &mdash; *Function*.



`hasse(m::Matrix{Bool})` Given  an  incidence  matrix  for  a  poset returns the corresponding Hasse diagram.

```julia-repl
julia> m=incidence(CPoset(:diamond,5))
5×5 Matrix{Bool}:
 1  1  1  1  1
 0  1  0  0  1
 0  0  1  0  1
 0  0  0  1  1
 0  0  0  0  1

julia> hasse(m)
5-element Vector{Vector{Int64}}:
 [2, 3, 4]
 [5]
 [5]
 [5]
 []
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L301-L322' class='documenter-source'>source</a><br>


`hasse(P::CPoset)`

the Hasse diagram of `P`.

```julia-repl
julia> p=CPoset((i,j)->j%i==0,5)
1<3,5
1<2<4

julia> hasse(p)
5-element Vector{Vector{Int64}}:
 [2, 3, 5]
 [4]      
 []       
 []       
 []       
```

`hasse(P::Poset)` returns `hasse(P.C)`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L589-L608' class='documenter-source'>source</a><br>

<a id='Posets.incidence' href='#Posets.incidence'>#</a>
**`Posets.incidence`** &mdash; *Function*.



`incidence(P::CPoset)`

returns the incidence matrix (also called the ζ matrix) of `P`.

```julia-repl
julia> p=CPoset([i==6 ? Int[] : [i+1] for i in 1:6])
1<2<3<4<5<6

julia> incidence(p)
6×6 Matrix{Bool}:
 1  1  1  1  1  1
 0  1  1  1  1  1
 0  0  1  1  1  1
 0  0  0  1  1  1
 0  0  0  0  1  1
 0  0  0  0  0  1
```

`incidence(P::Poset)` returns `incidence(P.C)`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L611-L630' class='documenter-source'>source</a><br>

<a id='Posets.transitive_closure' href='#Posets.transitive_closure'>#</a>
**`Posets.transitive_closure`** &mdash; *Function*.



`transitive_closure(M)` `transitive_closure!(M)`

`M`   should  be   a  square   boolean  matrix   representing  a  relation; `transitive_closure`  returns a boolean  matrix representing the transitive closure  of  this  relation;  `transitive_closure!`  modifies `M` in place, doing   no  allocations.  The   transitive  closure  is   computed  by  the Floyd-Warshall algorithm, which is quite fast even for large matrices.

```julia-repl
julia> m=[j-i in [0,1] for i in 1:5, j in 1:5]
5×5 Matrix{Bool}:
 1  1  0  0  0
 0  1  1  0  0
 0  0  1  1  0
 0  0  0  1  1
 0  0  0  0  1

julia>transitive_closure(m)
5×5 Matrix{Bool}:
 1  1  1  1  1
 0  1  1  1  1
 0  0  1  1  1
 0  0  0  1  1
 0  0  0  0  1
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L262-L289' class='documenter-source'>source</a><br>

<a id='Posets.linear_extension' href='#Posets.linear_extension'>#</a>
**`Posets.linear_extension`** &mdash; *Function*.



`linear_extension(P::CPoset)`

returns a linear extension of the `CPoset`, that is a vector `l` containing a permutation of the integers `1:length(P)` such that if `i<j` in `P` (that is  `incidence(P)[i,j]` is `true`), then `i` is  before `j` in `l`. This is also called a topological sort of `P`.

```julia-repl
julia> p=CPoset((i,j)->j%i==0,6) # divisibility poset on 1:6
1<5
1<2<4
1<3<6
2<6

julia> linear_extension(p)
6-element Vector{Int64}:
 1
 2
 3
 5
 4
 6
```

`linear_extension(P::Poset)` returns a linear extension of `P.C`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L544-L569' class='documenter-source'>source</a><br>

<a id='Posets.dual' href='#Posets.dual'>#</a>
**`Posets.dual`** &mdash; *Function*.



`dual(P)`

the dual poset to the `Poset` or `CPoset` (the order relation is reversed).

```julia-repl
julia> p=CPoset((i,j)->i%4<j%4,8)
4,8<1,5<2,6<3,7

julia> dual(p)
3,7<2,6<1,5<4,8
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L786-L798' class='documenter-source'>source</a><br>

<a id='Posets.partition' href='#Posets.partition'>#</a>
**`Posets.partition`** &mdash; *Function*.



`partition(P::CPoset)`

returns  the partition of `1:length(P)` induced by the equivalence relation associated  to  `P`;  that  is,  `i`  and  `j`  are in the same part of the partition  if the `k` such that `i<k` and `j<k` are the same as well as the `k` such that `k<i` and `k<j`.

```julia-repl
julia> p=CPoset([i==j || i%4<j%4 for i in 1:8, j in 1:8])
4,8<1,5<2,6<3,7

julia> partition(p)
4-element Vector{Vector{Int64}}:
 [4, 8]
 [2, 6]
 [3, 7]
 [1, 5]
```

`partition(P::Poset)` returns `partition(P.C)`


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L810-L830' class='documenter-source'>source</a><br>

<a id='Posets.induced' href='#Posets.induced'>#</a>
**`Posets.induced`** &mdash; *Function*.



`induced(P,S)`

returns the subposet induced by `P` on `S`, a sublist of `P.elements` if `P isa  Poset` or a subset  of `1:length(P)` if `P  isa CPoset`. Note that the sublist  `S` does not have to be in the same order as `P.elements`, so this can be just used to renumber the elements of `P`.

```julia-repl
julia> p=CPoset((i,j)->i%4<j%4,8)
4,8<1,5<2,6<3,7

julia> induced(p,2:6) # indices are renumbered
3<4<1,5<2

julia> induced(Poset(p),2:6) # elements are kept
4<5<2,6<3
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L841-L859' class='documenter-source'>source</a><br>

<a id='Posets.isjoinlattice' href='#Posets.isjoinlattice'>#</a>
**`Posets.isjoinlattice`** &mdash; *Function*.



`isjoinlattice(P::CPoset)`

returns  `true` if `P` is  a join semilattice, that  is any two elements of `P` have a unique smallest upper bound; returns `false` otherwise.

```julia-repl
julia> p=CPoset((i,j)->j%i==0,8)
1<5,7
1<2<4<8
1<3<6
2<6

julia> isjoinlattice(p)
false
```

`isjoinlattice(P::Poset)` returns `isjoinlattice(P.C)`


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L903-L920' class='documenter-source'>source</a><br>

<a id='Posets.ismeetlattice' href='#Posets.ismeetlattice'>#</a>
**`Posets.ismeetlattice`** &mdash; *Function*.



`ismeetlattice(P)`

returns  `true` if `P` is  a meet semilattice, that  is any two elements of `P` have a unique highest lower bound; returns `false` otherwise.

```julia-repl
julia> p=CPoset((i,j)->j%i==0,8)
1<5,7
1<2<4<8
1<3<6
2<6

julia> ismeetlattice(p)
true
```

`ismeetlattice(P::Poset)` returns `ismeetlattice(P.C)`


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L923-L940' class='documenter-source'>source</a><br>

<a id='Posets.maxima' href='#Posets.maxima'>#</a>
**`Posets.maxima`** &mdash; *Function*.



`maxima(P)` the maximal elements of the `Poset` or `CPoset`

```julia-repl
julia> p=CPoset([[3],[3],[4,5],Int[],Int[]])
1,2<3<4,5

julia> maxima(p)
2-element Vector{Int64}:
 4
 5
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1035-L1047' class='documenter-source'>source</a><br>

<a id='Posets.minima' href='#Posets.minima'>#</a>
**`Posets.minima`** &mdash; *Function*.



`minima(P)` the minimal elements of the `Poset` or `CPoset`

```julia-repl
julia> p=CPoset([[3],[3],[4,5],Int[],Int[]])
1,2<3<4,5

julia> minima(p)
2-element Vector{Int64}:
 1
 2
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1016-L1028' class='documenter-source'>source</a><br>

<a id='Posets.covering_chains' href='#Posets.covering_chains'>#</a>
**`Posets.covering_chains`** &mdash; *Function*.



`covering_chains(P::CPoset)`

A (greedy: the first is longest possible) list of covering chains for P.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L764-L768' class='documenter-source'>source</a><br>

<a id='Posets.interval' href='#Posets.interval'>#</a>
**`Posets.interval`** &mdash; *Function*.



`interval(P,f::Function,a)` `interval(P,f::Function,a,g::Function,b)`

returns  an interval in the `Poset` or  `CPoset` given by `P`. The function `f` must be one of the comparison functions `≤, <, ≥, >`. In the first form it returns the interval between `a` and one end (or the other, depending on the  comparison function). In  the second form  it returns the intersection of the intervals `interval(P,f,a)` and `interval(P,g,b)`.

```julia-repl
julia> l=vec(collect(Iterators.product(1:2,1:2)))
4-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (2, 1)
 (1, 2)
 (2, 2)

julia> P=Poset((x,y)->all(map(<=,x,y)),l)
(1, 1)<(2, 1),(1, 2)<(2, 2)

julia> interval(P,≤,(1,2)) # elements below (1,2)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (1, 2)

julia> interval(P,≥,(1,2)) # elements above (1,2)
2-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (2, 2)

julia> interval(P,<,(1,2)) # elements strictly below (1,2)
1-element Vector{Tuple{Int64, Int64}}:
 (1, 1)

julia> interval(P,≥,(2,1),≤,(2,2)) # elements between (2,1) and (2,2)
2-element Vector{Tuple{Int64, Int64}}:
 (2, 1)
 (2, 2)

julia> interval(P,>,(1,1),<,(2,2)) # elements strictly between
2-element Vector{Tuple{Int64, Int64}}:
 (2, 1)
 (1, 2)
julia> interval(P.C,>,1,<,4) # in terms of indices
2-element Vector{Int64}:
 2
 3
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1058-L1106' class='documenter-source'>source</a><br>

<a id='Posets.maximal_chains' href='#Posets.maximal_chains'>#</a>
**`Posets.maximal_chains`** &mdash; *Function*.



`maximal_chains(P)` the maximal chains of the `Poset` or `CPoset`.

```julia-repl
julia> p=Poset([(:a,:b),(:a,:c),(:b,:d),(:c,:d)])
a<b,c<d

julia> maximal_chains(p)
2-element Vector{Vector{Symbol}}:
 [:a, :b, :d]
 [:a, :c, :d]

julia> maximal_chains(p.C)
2-element Vector{Vector{Int64}}:
 [1, 2, 4]
 [1, 3, 4]
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1127-L1143' class='documenter-source'>source</a><br>

<a id='Posets.chains' href='#Posets.chains'>#</a>
**`Posets.chains`** &mdash; *Function*.



`chains(P)` the chains of the `Poset` or `CPoset`.

```julia-repl
julia> chains(CPoset(:chain,3))
8-element Vector{Vector{Int64}}:
 []
 [1]
 [2]
 [3]
 [1, 2]
 [1, 3]
 [2, 3]
 [1, 2, 3]
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1166-L1180' class='documenter-source'>source</a><br>

<a id='Posets.height' href='#Posets.height'>#</a>
**`Posets.height`** &mdash; *Function*.



`height(P)` the height the `Poset` or `CPoset` (the longest length of a chain).


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1207-L1209' class='documenter-source'>source</a><br>

<a id='Posets.chainpoly' href='#Posets.chainpoly'>#</a>
**`Posets.chainpoly`** &mdash; *Function*.



`chainspoly(P)` the chain polynomial of the `Poset` or `CPoset`, returned as the list of its coefficients.

```julia-repl
julia> chainpoly(Poset(:powerset,3))
5-element Vector{Int64}:
  1
  8
 19
 18
  6
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L1187-L1199' class='documenter-source'>source</a><br>

<a id='Posets.moebius' href='#Posets.moebius'>#</a>
**`Posets.moebius`** &mdash; *Function*.



`moebius(P::CPoset,y=first(maxima(P)))`

the vector of values `μ(x,y)` of the Moebius function of `P` for `x` varying. Here is an example giving the ususal Moebius function on integers.

```julia_repl
julia> p=CPoset((i,j)->i%j==0,1:8)
5,7<1
6<2<1
6<3<1
8<4<2

julia> moebius(p)
8-element Vector{Int64}:
  1
 -1
 -1
  0
 -1
  1
 -1
  0
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L943-L966' class='documenter-source'>source</a><br>

<a id='Posets.moebiusmatrix' href='#Posets.moebiusmatrix'>#</a>
**`Posets.moebiusmatrix`** &mdash; *Function*.



`moebiusmatrix(P::CPoset)`  the  matrix  of  the  Moebius  function  `μ(x,y)`  (the inverse of the ζ or incidence matrix)

```julia-repl
julia> moebiusmatrix(CPoset(:diamond,5))
5×5 Matrix{Int64}:
 1  -1  -1  -1   2
 0   1   0   0  -1
 0   0   1   0  -1
 0   0   0   1  -1
 0   0   0   0   1
```

`moebiusmatrix(P::Poset)` returns `moebiusmatrix(P.C)`


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L995-L1009' class='documenter-source'>source</a><br>

<a id='Posets.coxetermatrix' href='#Posets.coxetermatrix'>#</a>
**`Posets.coxetermatrix`** &mdash; *Function*.



`coxetermatrix(p)` the Coxeter matrix of the `Poset` or `CPoset`, defined as `-m*transpose(inv(m))` where `m` is the ζ or incidence matrix.

```julia-repl
julia> coxetermatrix(CPoset(:diamond,5))
5×5 Matrix{Int64}:
  0  -1  -1  -1  -2
  0   0   1   1   1
  0   1   0   1   1
  0   1   1   0   1
 -1  -1  -1  -1  -1
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L749-L761' class='documenter-source'>source</a><br>

<a id='Base.:+-Tuple{CPoset, CPoset}' href='#Base.:+-Tuple{CPoset, CPoset}'>#</a>
**`Base.:+`** &mdash; *Method*.



`P+Q` returns the sum of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)+CPoset(:chain,3)
1<2
3<4<5

julia> Poset(:chain,[1,2])+Poset(:chain,[:a,:b,:c])
1<2
a<b<c
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L642-L653' class='documenter-source'>source</a><br>

<a id='Base.:*-Tuple{CPoset, CPoset}' href='#Base.:*-Tuple{CPoset, CPoset}'>#</a>
**`Base.:*`** &mdash; *Method*.



`P*Q` returns the product of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)*CPoset(:chain,3)
1<2<3<6
1<4<5<6
2<5

julia> Poset(:chain,[1,2])*Poset(:chain,[:a,:b,:c])
(1, :a)<(2, :a)<(1, :b)<(2, :c)
(1, :a)<(2, :b)<(1, :c)<(2, :c)
(2, :a)<(1, :c)
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L674-L687' class='documenter-source'>source</a><br>

<a id='Posets.:⊕' href='#Posets.:⊕'>#</a>
**`Posets.:⊕`** &mdash; *Function*.



`P⊕ Q` returns the ordinal sum of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)⊕ CPoset(:chain,3)
1<2<3<4<5

julia> Poset(:chain,[1,2])⊕ Poset(:chain,[:a,:b,:c])
1<2<a<b<c
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L657-L666' class='documenter-source'>source</a><br>

<a id='Posets.:⊗' href='#Posets.:⊗'>#</a>
**`Posets.:⊗`** &mdash; *Function*.



`P⊗ Q` returns the ordinal product of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)⊗ CPoset(:chain,3)
1<3<5<2<4<6

julia> Poset(:chain,[1,2])⊗ Poset(:chain,[:a,:b,:c])
(1, :a)<(1, :b)<(1, :c)<(2, :a)<(2, :b)<(2, :c)
```


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L723-L732' class='documenter-source'>source</a><br>

<a id='Posets.showpic' href='#Posets.showpic'>#</a>
**`Posets.showpic`** &mdash; *Function*.



`showpic(p)` display a graphical representation of the Hasse diagram of the `Poset` or `CPoset` using the commands `dot` and `display`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L713-L716' class='documenter-source'>source</a><br>

<a id='Posets.dot' href='#Posets.dot'>#</a>
**`Posets.dot`** &mdash; *Function*.



`dot(p)` gives a rendering of the Hasse diagram of the `Poset` or `CPoset` in the graphical language `dot`.


<a target='_blank' href='https://github.com/jmichel7/Posets.jl/blob/c8e827a89bea9dd7c20fd47b927f7c6e994b20e0/src/Posets.jl#L694-L697' class='documenter-source'>source</a><br>

