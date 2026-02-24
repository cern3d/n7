type zero = private Dummy1
type _ succ = private Dummy2

type (_, _) nlist =
  | Nil : ('a, zero) nlist
  | Cons : 'a * ('a, 'n) nlist -> ('a, 'n succ) nlist

let rec map : type n . ('a -> 'b) -> ('a , n) nlist -> ('b, n) nlist =
 fun f lst ->
  match lst with
  | Nil -> Nil
  | Cons (x, xs) -> Cons (f x, map f xs)

let rec snoc : type n . 'a -> ('a , n) nlist -> ('a, n succ) nlist =
fun e lst ->
  match lst with
  | Nil -> Cons( e, Nil)
  | Cons (x, xs) -> Cons ( x, snoc e xs)

let rec tail : type n . ('a , n) nlist -> 'a =
fun lst ->
  match lst with
  | Nil -> Nil
  | Cons (_, xs) -> xs

let rec rev : type n . ('a , n) nlist -> ('a , n) nlist =
fun lst ->
  match lst with
  | Nil -> Nil
  | Cons (x, Cons(a,b)) -> Cons(a,Cons(x,rev b))
