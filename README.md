
<a id='FinitePosets'></a>

<a id='FinitePosets-1'></a>

# FinitePosets


<a id='FinitePosets' href='#FinitePosets'>#</a>
**`FinitePosets`** &mdash; *Module*.



This  package deals with  finite posets. 

There  are two types of  posets. A "canonical poset"  or `CPoset` is on the elements  `1:n`  where  `n=length(P)`.  A  `Poset`  is  on  a given list of elements  which can be of any type. A `Poset` internally contains a`CPoset` which  works on the indices  of the elements, which  is more efficient than working  with the elements themselves.  For efficiency, many functions work on  the internal `CPoset` by transforming  their input to indices and their output to elements.

A  `CPoset` `p` contains one of the following data:

  * `hasse(p)`:  a list representing  the Hasse diagram  of the poset: the `i`-th  entry is the list of elements which cover (are immediate  successors of) `i`, that  is the list of `j` such that `i<j` and there is no `k` such that `i<k<j`.
  * `incidence(p)`: a  boolean matrix  such that `incidence[i,j]==true` iff `i<=j`. This is sometimes called the ζ-matrix of the poset.

Some  computations work better on the  incidence matrix, and some others on the  Hasse diagram.  If needed  for a  computation and  missing, one of the above  data is computed from the other. This may take some substantial time for large posets.

There  are several ways of defining a  poset. One way is entering the Hasse diagram:

```julia-repl
julia> p=CPoset([[2,3],[4],[4],Int[]])
1<2,3<4
```

As  seen above,  `p` is  displayed as  a list  of covering  maximal chains; elements  which are equivalent for the poset are printed together separated by commas.

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

A  convenient  constructor  for  `Poset`s  takes  a  function  representing `isless`  for the poset and  the list of elements  and constructs the poset from  the incidence matrix, computed by  applying the function to each pair of  elements. For `isless` one can  give either a function implementing `<` or a function implementing `≤` (it is `and`-ed with `!=` in any case).

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

A  poset can be specified  by a list of  tuples specifying order relations. The  transitive closure  of these  relations is  computed, resulting  in an incidence  matrix from which the poset  is constructed. The elements of the poset, if not specified separately, are all the elements that appear in the tuples.

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

Finally `showpic(p)` where `p` is a `CPoset` or a `Poset` gives a graphical display  of the  poset provided  you have  the command  `dot` of `graphviz` installed. It then uses the xdg "open" command to open the resulting `.png` file. This works on Linux and MacOs but I could not try it on Windows.

see the on-line help on `⊕, ⊗,  +, *, chains, chainpoly, covering_chains, coxetermatrix,  dual,  hasse,  height, incidence,  induced,  interval,  isjoinlattice,  ismeetlattice,  linear_extension,  linear_extensions,  maxima, maximal_chains,  antichains, minima, moebius,  moebiusmatrix,  partition,  showpic, transitive_closure` for more information


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1-L240' class='documenter-source'>source</a><br>

<a id='FinitePosets.Poset' href='#FinitePosets.Poset'>#</a>
**`FinitePosets.Poset`** &mdash; *Type*.



`Poset(p::CPoset,e::AbstractVector=1:length(p))`

creates a `Poset` with order specified by `p` and elements `e`.

```julia-repl
julia> Poset(CPoset([[2,3],[4],[4],Int[]]),[:a,:b,:c,:d])
a<b,c<d
```

with no second argument transforms a `CPoset` into a `Poset`.


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L371-L380' class='documenter-source'>source</a><br>


`Poset(f::Function,e::AbstractVector)`

creates a `Poset` with elements `e` and order between two elements given by function `f`.

```julia-repl
julia> Poset((x,y)->all(x.≤y),vec(collect(Iterators.product(1:2,1:3))))
(1, 1)<(2, 1)<(2, 2)<(2, 3)
(1, 1)<(1, 2)<(2, 2)
(1, 2)<(1, 3)<(2, 3)
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L426-L437' class='documenter-source'>source</a><br>


`Poset(covers::Vector{Tuple{T,T}}) where T`

creates a poset representing the transitive closure of the given relations. The  poset is on the elements which appear in the relations.

```julia-repl
julia> Poset([(:a,:b),(:d,:c)])
a<b
d<c
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L477-L487' class='documenter-source'>source</a><br>


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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L502-L523' class='documenter-source'>source</a><br>

<a id='FinitePosets.CPoset' href='#FinitePosets.CPoset'>#</a>
**`FinitePosets.CPoset`** &mdash; *Type*.



`CPoset(m::Matrix{Bool})`

Creates a poset from an incidence matrix `m`, that is `m[i,j]==true` if and only if `i≤j` in the poset,

```julia-repl
julia> CPoset(Bool[1 1 1 1 1;0 1 0 1 1;0 0 1 1 1;0 0 0 1 0;0 0 0 0 1])
1<2,3<4,5
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L399-L409' class='documenter-source'>source</a><br>


`CPoset(h::Vector{<:Vector{<:Integer}})`

Creates a poset from a Hasse diagram given as a `Vector` whose `i`-th entry is  the  list  of  indices  which  are immediate successors (covers) of the `i`-th  element, that is `h[i]`  is the list of  `j` such that `i<j` in the poset and such that there is no `k` such that `i<k<j`.

```julia-repl
julia> CPoset([[2,3],[4,5],[4,5],Int[],Int[]])
1<2,3<4,5
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L412-L423' class='documenter-source'>source</a><br>


`CPoset(f::Function,n::integer)`

creates the `Poset` on `1:n` with order given by function `f`.

```julia-repl
julia> CPoset((x,y)->y%x==0,8)  # the divisibility poset
1<5,7
1<2<4<8
1<3<6
2<6
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L441-L452' class='documenter-source'>source</a><br>


`CPoset(covers::Vector{Tuple{Int,Int}})`

creates a poset representing the transitive closure of the given relations. The  poset is on `1:n` where `n` is the maximum number which appears in the relations.

```julia-repl
julia> CPoset([(6,2),(5,1)])
3,4
5<1
6<2
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L455-L467' class='documenter-source'>source</a><br>


  * `CPoset(:chain,n)`  a chain on `1:n`
  * `CPoset(:antichain,n)`  an antichain on `1:n`
  * `CPoset(:diamond,n)`  a diamond poset on `1:n`


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L494-L498' class='documenter-source'>source</a><br>

<a id='FinitePosets.hasse' href='#FinitePosets.hasse'>#</a>
**`FinitePosets.hasse`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L312-L333' class='documenter-source'>source</a><br>


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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L659-L678' class='documenter-source'>source</a><br>

<a id='FinitePosets.incidence' href='#FinitePosets.incidence'>#</a>
**`FinitePosets.incidence`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L685-L704' class='documenter-source'>source</a><br>

<a id='FinitePosets.transitive_closure' href='#FinitePosets.transitive_closure'>#</a>
**`FinitePosets.transitive_closure`** &mdash; *Function*.



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

julia> transitive_closure(m)
5×5 Matrix{Bool}:
 1  1  1  1  1
 0  1  1  1  1
 0  0  1  1  1
 0  0  0  1  1
 0  0  0  0  1
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L273-L300' class='documenter-source'>source</a><br>

<a id='FinitePosets.linear_extension' href='#FinitePosets.linear_extension'>#</a>
**`FinitePosets.linear_extension`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L563-L588' class='documenter-source'>source</a><br>

<a id='FinitePosets.linear_extensions' href='#FinitePosets.linear_extensions'>#</a>
**`FinitePosets.linear_extensions`** &mdash; *Function*.



`linear_extensions(P::CPoset)`

returns all linear extensions of the `CPoset` (see linear_extension)

```julia-repl
julia> p=CPoset((i,j)->j%i==0,4) # divisibility poset on 1:4
1<3
1<2<4

julia> linear_extensions(p)
3-element Vector{Vector{Int64}}:
 [1, 2, 3, 4]
 [1, 2, 4, 3]
 [1, 3, 2, 4]
```

`linear_extensions(P::Poset)` returns the linear extensions of `p.C`.


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L639-L656' class='documenter-source'>source</a><br>

<a id='FinitePosets.dual' href='#FinitePosets.dual'>#</a>
**`FinitePosets.dual`** &mdash; *Function*.



`dual(P)`

the dual poset to the `Poset` or `CPoset` (the order relation is reversed).

```julia-repl
julia> p=CPoset((i,j)->i%4<j%4,8)
4,8<1,5<2,6<3,7

julia> dual(p)
3,7<2,6<1,5<4,8
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L885-L897' class='documenter-source'>source</a><br>

<a id='FinitePosets.partition' href='#FinitePosets.partition'>#</a>
**`FinitePosets.partition`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L907-L927' class='documenter-source'>source</a><br>

<a id='FinitePosets.induced' href='#FinitePosets.induced'>#</a>
**`FinitePosets.induced`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L938-L956' class='documenter-source'>source</a><br>

<a id='FinitePosets.isjoinlattice' href='#FinitePosets.isjoinlattice'>#</a>
**`FinitePosets.isjoinlattice`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1005-L1022' class='documenter-source'>source</a><br>

<a id='FinitePosets.ismeetlattice' href='#FinitePosets.ismeetlattice'>#</a>
**`FinitePosets.ismeetlattice`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1025-L1042' class='documenter-source'>source</a><br>

<a id='FinitePosets.maxima' href='#FinitePosets.maxima'>#</a>
**`FinitePosets.maxima`** &mdash; *Function*.



`maxima(P)` the maximal elements of the `Poset` or `CPoset`

`maxima(P,E)` the maximal elements of the subset `E` of elements of `P`

```julia-repl
julia> p=CPoset([[3],[3],[4,5],Int[],Int[]])
1,2<3<4,5

julia> maxima(p)
2-element Vector{Int64}:
 4
 5
 
julia> maxima(p,1:3)
1-element Vector{Int64}:
 3
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1147-L1166' class='documenter-source'>source</a><br>

<a id='FinitePosets.minima' href='#FinitePosets.minima'>#</a>
**`FinitePosets.minima`** &mdash; *Function*.



`minima(P)` the minimal elements of the `Poset` or `CPoset`

`minima(P,E)` the minimal elements of the subset `E` of elements of `P`

```julia-repl
julia> p=CPoset([[3],[3],[4,5],Int[],Int[]])
1,2<3<4,5

julia> minima(p)
2-element Vector{Int64}:
 1
 2
 
julia> minima(p,3:5)
1-element Vector{Int64}:
 3
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1120-L1139' class='documenter-source'>source</a><br>

<a id='FinitePosets.covering_chains' href='#FinitePosets.covering_chains'>#</a>
**`FinitePosets.covering_chains`** &mdash; *Function*.



`covering_chains(P::CPoset)`

A (greedy: the first is longest possible) list of covering chains for P.


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L855-L859' class='documenter-source'>source</a><br>

<a id='FinitePosets.interval' href='#FinitePosets.interval'>#</a>
**`FinitePosets.interval`** &mdash; *Function*.



`interval(P,f::Function,a)` `interval(P,f::Function,a,g::Function,b)`

returns  an interval in the `Poset` or  `CPoset` given by `P`. The function `f` must be one of the comparison functions `≤, <, ≥, >`. In the first form it returns the interval above `a` or below `a`, depending on the comparison function;  a may be an element  of `P`, or a vector  of elements of `P`; in the  latter case, the order ideal of  elements below (or above) any element of  `a` is returned. In the second  form it returns the intersection of the intervals `interval(P,f,a)` and `interval(P,g,b)`.

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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1177-L1227' class='documenter-source'>source</a><br>

<a id='FinitePosets.maximal_chains' href='#FinitePosets.maximal_chains'>#</a>
**`FinitePosets.maximal_chains`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1261-L1277' class='documenter-source'>source</a><br>

<a id='FinitePosets.chains' href='#FinitePosets.chains'>#</a>
**`FinitePosets.chains`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1300-L1314' class='documenter-source'>source</a><br>

<a id='FinitePosets.antichains' href='#FinitePosets.antichains'>#</a>
**`FinitePosets.antichains`** &mdash; *Function*.



`antichains(p::CPoset)` computes the antichains of `p`

```julia-repl
julia> p=CPoset((i,j)->j%i==0,4)
1<3
1<2<4

julia> FinitePosets.antichains(p)
7-element Vector{Vector{Int64}}:
 []
 [1]
 [2]
 [3]
 [4]
 [2, 3]
 [3, 4]
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1396-L1414' class='documenter-source'>source</a><br>

<a id='FinitePosets.height' href='#FinitePosets.height'>#</a>
**`FinitePosets.height`** &mdash; *Function*.



`height(P)`  the height of the `Poset` or `CPoset` (the longest length of a chain).


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1341-L1344' class='documenter-source'>source</a><br>

<a id='FinitePosets.chainpoly' href='#FinitePosets.chainpoly'>#</a>
**`FinitePosets.chainpoly`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1321-L1333' class='documenter-source'>source</a><br>

<a id='FinitePosets.ranking' href='#FinitePosets.ranking'>#</a>
**`FinitePosets.ranking`** &mdash; *Function*.



`ranking(P)`

here `P` is a `Poset` or a `CPoset`. A poset is ranked if the recipe

`ρ(x)=0` if `x∈minima(P)`, `ρ(y)=ρ(x)+1` if `y` is an immediate successor of `x`

gives a well-defined function `ρ`. Then `ρ` is called a ranking of `P`. The function  `ranking` returns the  vector of `ρ(x)`  for `x` running over the elements of `P` if `P` has a ranking, and `nothing` otherwise.

A  poset  `P`  is  graded  if  all  maximal chains have the same length, or equivalently `P` is ranked and `allequal(ranking(P)[maxima(P)])`.

```julia-repl
julia> ranking(Poset(:partitionsdominance,6))
11-element Vector{Int64}:
 0
 1
 2
 3
 3
 4
 5
 5
 6
 7
 8

julia> ranking(Poset(:partitionsdominance,7)) # not ranked

```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1347-L1378' class='documenter-source'>source</a><br>

<a id='Combinat.moebius' href='#Combinat.moebius'>#</a>
**`Combinat.moebius`** &mdash; *Function*.



`moebius(P::CPoset,y=first(maxima(P)))`

the vector of values `μ(x,y)` of the Moebius function of `P` for `x` varying. Here is an example giving the ususal Moebius function on integers.

```julia-repl
julia> p=CPoset((i,j)->i%j==0,8)
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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1045-L1068' class='documenter-source'>source</a><br>

<a id='FinitePosets.moebiusmatrix' href='#FinitePosets.moebiusmatrix'>#</a>
**`FinitePosets.moebiusmatrix`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L1099-L1113' class='documenter-source'>source</a><br>

<a id='FinitePosets.coxetermatrix' href='#FinitePosets.coxetermatrix'>#</a>
**`FinitePosets.coxetermatrix`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L840-L852' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L716-L727' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L748-L761' class='documenter-source'>source</a><br>

<a id='FinitePosets.:⊕' href='#FinitePosets.:⊕'>#</a>
**`FinitePosets.:⊕`** &mdash; *Function*.



`P⊕ Q` returns the ordinal sum of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)⊕ CPoset(:chain,3)
1<2<3<4<5

julia> Poset(:chain,[1,2])⊕ Poset(:chain,[:a,:b,:c])
1<2<a<b<c
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L731-L740' class='documenter-source'>source</a><br>

<a id='FinitePosets.:⊗' href='#FinitePosets.:⊗'>#</a>
**`FinitePosets.:⊗`** &mdash; *Function*.



`P⊗ Q` returns the ordinal product of two `CPoset`s or of two `Poset`s.

```julia-repl
julia> CPoset(:chain,2)⊗ CPoset(:chain,3)
1<3<5<2<4<6

julia> Poset(:chain,[1,2])⊗ Poset(:chain,[:a,:b,:c])
(1, :a)<(1, :b)<(1, :c)<(2, :a)<(2, :b)<(2, :c)
```


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L814-L823' class='documenter-source'>source</a><br>

<a id='FinitePosets.showpic' href='#FinitePosets.showpic'>#</a>
**`FinitePosets.showpic`** &mdash; *Function*.



`showpic(p;opt...)` display a graphical representation of the Hasse diagram of  the `Poset` or `CPoset` using the  commands `dot` and `open`. If `p isa Poset` it is possible to give as keyword aguments a list of `IO` properties which will be forwarded to the `show_element` method of `p`.


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L786-L791' class='documenter-source'>source</a><br>

<a id='FinitePosets.dot' href='#FinitePosets.dot'>#</a>
**`FinitePosets.dot`** &mdash; *Function*.



`dot(p)` gives a rendering of the Hasse diagram of the `Poset` or `CPoset` in the graphical language `dot`.


<a target='_blank' href='https://github.com/jmichel7/FinitePosets.jl/blob/6687afede9a1d5c9f948d09540ab79b3ff37407e/src/FinitePosets.jl#L768-L771' class='documenter-source'>source</a><br>

