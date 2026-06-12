(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
type t = Top | Bot | Z of bool

(* a printing function (useful for debuging), *)
let fprint ff = function
  | Top -> Format.fprintf ff "⊤"
  | Z s -> Format.fprintf ff (if s then "pair" else "impair")
  | Bot -> Format.fprintf ff "⊥"

(* the order of the lattice. *)
let order x y = match x, y with
  | Bot, _ -> true
  | _,Top -> true
  | Z i , Z j -> i=j
  | _ -> false

(* and infimums of the lattice. *)
let top = Top
let bottom = Bot

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

let join x y = match x, y with
  | Bot, _ -> y
  | _, Bot -> x
  | _, Top -> Top
  | Top, _ -> Top
  | Z(i), Z(j) -> if i = j then Z(i) else Top

let meet x y = match x, y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _, Top -> x
  | Top, _ -> y
  | Z(i), Z(j) -> if i = j then Z(i) else Bot

let widening = join  (* Ok, maybe you'll need to implement this one if your
                      * lattice has infinite ascending chains and you want
                      * your analyses to terminate. *)

let sem_itv a b = 
  if a>b then Bot else if a=b then if a mod 2 = 0 then Z(true) else Z(false) else Top 

let sem_plus x y = match x,y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _, Top -> Top
  | Top, _ -> Top
  | Z(i), Z(j) -> Z(i&&j)
  
let sem_minus x y = match x,y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _, Top -> Top
  | Top, _ -> Top
  | Z(i), Z(j) -> Z(i&&j)

let sem_times x y = match x,y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _, Top -> Top
  | Top, _ -> Top
  | Z(i), Z(j) -> Z(i||j)
let sem_div x y = match x,y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _, Top -> Top
  | Top, _ -> Top
  | Z(i), Z(j) -> Top

let sem_guard = function
  | t -> t

let backsem_plus x y r = x, y
let backsem_minus x y r = x, y
let backsem_times x y r = x, y
let backsem_div x y r = x, y
