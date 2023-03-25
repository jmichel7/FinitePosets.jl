# auto-generated tests from julia-repl docstrings
using Test, FinitePosets
function mytest(file::String,src::String,man::String)
  println(file," ",src)
  omit=src[end]==';'
  src=replace(src,"\\\\"=>"\\")
  exec=repr(MIME("text/plain"),eval(Meta.parse(src)),context=:limit=>true)
  if omit exec="nothing" end
  exec=replace(exec,r" *(\n|$)"s=>s"\1")
  exec=replace(exec,r"\n$"s=>"")
  man=replace(man,r" *(\n|$)"s=>s"\1")
  man=replace(man,r"\n$"s=>"")
  i=1
  while i<=lastindex(exec) && i<=lastindex(man) && exec[i]==man[i]
    i=nextind(exec,i)
  end
  if exec!=man 
    print("exec=$(repr(exec[i:end]))\nmanl=$(repr(man[i:end]))\n")
  end
  exec==man
end
@testset verbose = true "Gapjm" begin
@testset "FinitePosets.jl" begin
@test mytest("FinitePosets.jl","p=CPoset([[2,3],[4],[4],Int[]])","1<2,3<4")
@test mytest("FinitePosets.jl","length(p)","4")
@test mytest("FinitePosets.jl","incidence(p)","4×4 Matrix{Bool}:\n 1  1  1  1\n 0  1  0  1\n 0  0  1  1\n 0  0  0  1")
@test mytest("FinitePosets.jl","linear_extension(p)","4-element Vector{Int64}:\n 1\n 2\n 3\n 4")
@test mytest("FinitePosets.jl","P=Poset(p,[:a,:b,:c,:d])","a<b,c<d")
@test mytest("FinitePosets.jl","P.C","1<2,3<4")
@test mytest("FinitePosets.jl","l=vec(collect(Iterators.product(1:2,1:2)))","4-element Vector{Tuple{Int64, Int64}}:\n (1, 1)\n (2, 1)\n (1, 2)\n (2, 2)")
@test mytest("FinitePosets.jl","P=Poset((x,y)->all(map(<=,x,y)),l)","(1, 1)<(2, 1),(1, 2)<(2, 2)")
@test mytest("FinitePosets.jl","eltype(P)","Tuple{Int64, Int64}")
@test mytest("FinitePosets.jl","summary(P)","\"Poset{Tuple{Int64, Int64}} of length 4\"")
@test mytest("FinitePosets.jl","P=Poset(CPoset([all(map(<=,x,y)) for x in l, y in l]),l)","(1, 1)<(2, 1),(1, 2)<(2, 2)")
@test mytest("FinitePosets.jl","P.show_element=(io,p,n)->join(io,p.elements[n],\".\");","nothing")
@test mytest("FinitePosets.jl","P","1.1<2.1,1.2<2.2")
@test mytest("FinitePosets.jl","delete!(P,:show_element);","nothing")
@test mytest("FinitePosets.jl","Poset([(:a,:b),(:c,:d)])","a<b\nc<d")
@test mytest("FinitePosets.jl","CPoset([(1,3),(2,5)])","4\n1<3\n2<5")
@test mytest("FinitePosets.jl","≤(P,(1,1),(2,1))","true")
@test mytest("FinitePosets.jl","≤(P.C,1,2)","true")
@test mytest("FinitePosets.jl","interval(P,≤,(1,2))","2-element Vector{Tuple{Int64, Int64}}:\n (1, 1)\n (1, 2)")
@test mytest("FinitePosets.jl","interval(P,≥,(1,2))","2-element Vector{Tuple{Int64, Int64}}:\n (1, 2)\n (2, 2)")
@test mytest("FinitePosets.jl","interval(P,<,(1,2))","1-element Vector{Tuple{Int64, Int64}}:\n (1, 1)")
@test mytest("FinitePosets.jl","interval(P,≥,(2,1),≤,(2,2))","2-element Vector{Tuple{Int64, Int64}}:\n (2, 1)\n (2, 2)")
@test mytest("FinitePosets.jl","interval(P,>,(1,1),<,(2,2))","2-element Vector{Tuple{Int64, Int64}}:\n (2, 1)\n (1, 2)")
@test mytest("FinitePosets.jl","interval(P.C,>,1,<,4)","2-element Vector{Int64}:\n 2\n 3")
@test mytest("FinitePosets.jl","maximal_chains(P)","2-element Vector{Vector{Tuple{Int64, Int64}}}:\n [(1, 1), (2, 1), (2, 2)]\n [(1, 1), (1, 2), (2, 2)]")
@test mytest("FinitePosets.jl","height(P)","3")
@test mytest("FinitePosets.jl","moebiusmatrix(P)","4×4 Matrix{Int64}:\n 1  -1  -1   1\n 0   1   0  -1\n 0   0   1  -1\n 0   0   0   1")
@test mytest("FinitePosets.jl","minima(P)","1-element Vector{Tuple{Int64, Int64}}:\n (1, 1)")
@test mytest("FinitePosets.jl","maxima(P)","1-element Vector{Tuple{Int64, Int64}}:\n (2, 2)")
@test mytest("FinitePosets.jl","Q=CPoset(:chain,3)","1<2<3")
@test mytest("FinitePosets.jl","P1=Poset(Q)","1<2<3")
@test mytest("FinitePosets.jl","P⊕ P1","(1, 1)<(2, 1),(1, 2)<(2, 2)<1<2<3")
@test mytest("FinitePosets.jl","P1*P1","(1, 1)<(2, 1)<(3, 1)<(3, 2)<(3, 3)\n(1, 1)<(1, 2)<(2, 2)<(3, 2)\n(2, 1)<(2, 2)\n(1, 2)<(1, 3)<(2, 3)<(3, 3)\n(2, 2)<(2, 3)")
@test mytest("FinitePosets.jl","P1⊗ P1","(1, 1)<(1, 2)<(1, 3)<(2, 1)<(2, 2)<(2, 3)<(3, 1)<(3, 2)<(3, 3)")
@test mytest("FinitePosets.jl","m=[j-i in [0,1] for i in 1:5, j in 1:5]","5×5 Matrix{Bool}:\n 1  1  0  0  0\n 0  1  1  0  0\n 0  0  1  1  0\n 0  0  0  1  1\n 0  0  0  0  1")
@test mytest("FinitePosets.jl","transitive_closure(m)","5×5 Matrix{Bool}:\n 1  1  1  1  1\n 0  1  1  1  1\n 0  0  1  1  1\n 0  0  0  1  1\n 0  0  0  0  1")
@test mytest("FinitePosets.jl","m=incidence(CPoset(:diamond,5))","5×5 Matrix{Bool}:\n 1  1  1  1  1\n 0  1  0  0  1\n 0  0  1  0  1\n 0  0  0  1  1\n 0  0  0  0  1")
@test mytest("FinitePosets.jl","hasse(m)","5-element Vector{Vector{Int64}}:\n [2, 3, 4]\n [5]\n [5]\n [5]\n []")
@test mytest("FinitePosets.jl","Poset(CPoset([[2,3],[4],[4],Int[]]),[:a,:b,:c,:d])","a<b,c<d")
@test mytest("FinitePosets.jl","CPoset(Bool[1 1 1 1 1;0 1 0 1 1;0 0 1 1 1;0 0 0 1 0;0 0 0 0 1])","1<2,3<4,5")
@test mytest("FinitePosets.jl","CPoset([[2,3],[4,5],[4,5],Int[],Int[]])","1<2,3<4,5")
@test mytest("FinitePosets.jl","Poset((x,y)->all(x.≤y),vec(collect(Iterators.product(1:2,1:3))))","(1, 1)<(2, 1)<(2, 2)<(2, 3)\n(1, 1)<(1, 2)<(2, 2)\n(1, 2)<(1, 3)<(2, 3)")
@test mytest("FinitePosets.jl","CPoset((x,y)->y%x==0,8)","1<5,7\n1<2<4<8\n1<3<6\n2<6")
@test mytest("FinitePosets.jl","CPoset([(6,2),(5,1)])","3,4\n5<1\n6<2")
@test mytest("FinitePosets.jl","Poset([(:a,:b),(:d,:c)])","a<b\nd<c")
@test mytest("FinitePosets.jl","p=Poset(:powerset,3);p.show_element=(io,p,n)->join(io,p.elements[n]);","nothing")
@test mytest("FinitePosets.jl","p","<1<12<123\n<2<12\n<3<13<123\n1<13\n2<23<123\n3<23")
@test mytest("FinitePosets.jl","Poset(:partitionsdominance,5)","[1, 1, 1, 1, 1]<[2, 1, 1, 1]<[2, 2, 1]<[3, 1, 1]<[3, 2]<[4, 1]<[5]")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->j%i==0,6)","1<5\n1<2<4\n1<3<6\n2<6")
@test mytest("FinitePosets.jl","linear_extension(p)","6-element Vector{Int64}:\n 1\n 2\n 3\n 5\n 4\n 6")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->j%i==0,5)","1<3,5\n1<2<4")
@test mytest("FinitePosets.jl","hasse(p)","5-element Vector{Vector{Int64}}:\n [2, 3, 5]\n [4]\n []\n []\n []")
@test mytest("FinitePosets.jl","p=CPoset([i==6 ? Int[] : [i+1] for i in 1:6])","1<2<3<4<5<6")
@test mytest("FinitePosets.jl","incidence(p)","6×6 Matrix{Bool}:\n 1  1  1  1  1  1\n 0  1  1  1  1  1\n 0  0  1  1  1  1\n 0  0  0  1  1  1\n 0  0  0  0  1  1\n 0  0  0  0  0  1")
@test mytest("FinitePosets.jl","CPoset(:chain,2)+CPoset(:chain,3)","1<2\n3<4<5")
@test mytest("FinitePosets.jl","Poset(:chain,[1,2])+Poset(:chain,[:a,:b,:c])","1<2\na<b<c")
@test mytest("FinitePosets.jl","CPoset(:chain,2)⊕ CPoset(:chain,3)","1<2<3<4<5")
@test mytest("FinitePosets.jl","Poset(:chain,[1,2])⊕ Poset(:chain,[:a,:b,:c])","1<2<a<b<c")
@test mytest("FinitePosets.jl","CPoset(:chain,2)*CPoset(:chain,3)","1<2<3<6\n1<4<5<6\n2<5")
@test mytest("FinitePosets.jl","Poset(:chain,[1,2])*Poset(:chain,[:a,:b,:c])","(1, :a)<(2, :a)<(1, :b)<(2, :c)\n(1, :a)<(2, :b)<(1, :c)<(2, :c)\n(2, :a)<(1, :c)")
@test mytest("FinitePosets.jl","CPoset(:chain,2)⊗ CPoset(:chain,3)","1<3<5<2<4<6")
@test mytest("FinitePosets.jl","Poset(:chain,[1,2])⊗ Poset(:chain,[:a,:b,:c])","(1, :a)<(1, :b)<(1, :c)<(2, :a)<(2, :b)<(2, :c)")
@test mytest("FinitePosets.jl","coxetermatrix(CPoset(:diamond,5))","5×5 Matrix{Int64}:\n  0  -1  -1  -1  -2\n  0   0   1   1   1\n  0   1   0   1   1\n  0   1   1   0   1\n -1  -1  -1  -1  -1")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->i%4<j%4,8)","4,8<1,5<2,6<3,7")
@test mytest("FinitePosets.jl","dual(p)","3,7<2,6<1,5<4,8")
@test mytest("FinitePosets.jl","p=CPoset([i==j || i%4<j%4 for i in 1:8, j in 1:8])","4,8<1,5<2,6<3,7")
@test mytest("FinitePosets.jl","partition(p)","4-element Vector{Vector{Int64}}:\n [4, 8]\n [2, 6]\n [3, 7]\n [1, 5]")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->i%4<j%4,8)","4,8<1,5<2,6<3,7")
@test mytest("FinitePosets.jl","induced(p,2:6)","3<4<1,5<2")
@test mytest("FinitePosets.jl","induced(Poset(p),2:6)","4<5<2,6<3")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->j%i==0,8)","1<5,7\n1<2<4<8\n1<3<6\n2<6")
@test mytest("FinitePosets.jl","isjoinlattice(p)","false")
@test mytest("FinitePosets.jl","p=CPoset((i,j)->j%i==0,8)","1<5,7\n1<2<4<8\n1<3<6\n2<6")
@test mytest("FinitePosets.jl","ismeetlattice(p)","true")
@test mytest("FinitePosets.jl","moebiusmatrix(CPoset(:diamond,5))","5×5 Matrix{Int64}:\n 1  -1  -1  -1   2\n 0   1   0   0  -1\n 0   0   1   0  -1\n 0   0   0   1  -1\n 0   0   0   0   1")
@test mytest("FinitePosets.jl","p=CPoset([[3],[3],[4,5],Int[],Int[]])","1,2<3<4,5")
@test mytest("FinitePosets.jl","minima(p)","2-element Vector{Int64}:\n 1\n 2")
@test mytest("FinitePosets.jl","p=CPoset([[3],[3],[4,5],Int[],Int[]])","1,2<3<4,5")
@test mytest("FinitePosets.jl","maxima(p)","2-element Vector{Int64}:\n 4\n 5")
@test mytest("FinitePosets.jl","l=vec(collect(Iterators.product(1:2,1:2)))","4-element Vector{Tuple{Int64, Int64}}:\n (1, 1)\n (2, 1)\n (1, 2)\n (2, 2)")
@test mytest("FinitePosets.jl","P=Poset((x,y)->all(map(<=,x,y)),l)","(1, 1)<(2, 1),(1, 2)<(2, 2)")
@test mytest("FinitePosets.jl","interval(P,≤,(1,2))","2-element Vector{Tuple{Int64, Int64}}:\n (1, 1)\n (1, 2)")
@test mytest("FinitePosets.jl","interval(P,≥,(1,2))","2-element Vector{Tuple{Int64, Int64}}:\n (1, 2)\n (2, 2)")
@test mytest("FinitePosets.jl","interval(P,<,(1,2))","1-element Vector{Tuple{Int64, Int64}}:\n (1, 1)")
@test mytest("FinitePosets.jl","interval(P,≥,(2,1),≤,(2,2))","2-element Vector{Tuple{Int64, Int64}}:\n (2, 1)\n (2, 2)")
@test mytest("FinitePosets.jl","interval(P,>,(1,1),<,(2,2))","2-element Vector{Tuple{Int64, Int64}}:\n (2, 1)\n (1, 2)")
@test mytest("FinitePosets.jl","interval(P.C,>,1,<,4)","2-element Vector{Int64}:\n 2\n 3")
@test mytest("FinitePosets.jl","p=Poset([(:a,:b),(:a,:c),(:b,:d),(:c,:d)])","a<b,c<d")
@test mytest("FinitePosets.jl","maximal_chains(p)","2-element Vector{Vector{Symbol}}:\n [:a, :b, :d]\n [:a, :c, :d]")
@test mytest("FinitePosets.jl","maximal_chains(p.C)","2-element Vector{Vector{Int64}}:\n [1, 2, 4]\n [1, 3, 4]")
@test mytest("FinitePosets.jl","chains(CPoset(:chain,3))","8-element Vector{Vector{Int64}}:\n []\n [1]\n [2]\n [3]\n [1, 2]\n [1, 3]\n [2, 3]\n [1, 2, 3]")
@test mytest("FinitePosets.jl","chainpoly(Poset(:powerset,3))","5-element Vector{Int64}:\n  1\n  8\n 19\n 18\n  6")
end
end
