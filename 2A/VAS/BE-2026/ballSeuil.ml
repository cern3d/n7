(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
type elem_t = | Bot | Top | Itv of int * int
type widening_info_t = int
type t = elem_t * widening_info_t

let to_interval x = match  x with
  | Bot -> (1, 0) (* Represents an empty/invalid interval *)
  | Top -> (min_int, max_int)
  | Itv (c, r) -> (c - r, c + r)

let from_interval a b =
  if a > b then Bot
  else
    let c = (a + b) / 2 in
    let r = max (abs (c - a)) (abs (b - c)) in
    Itv (c, r)

(* a printing function (useful for debuging), *)
let fprint ff = function
  | Bot -> Format.fprintf ff "Bot"
  | Top -> Format.fprintf ff "Top"
  | Itv (c, r) -> Format.fprintf ff "Itv(c: %d, r: %d)" c r

(* the order of the lattice. *)
let order x y = match x, y with
  | Bot, _ -> true
  | _, Top -> true
  | _, Bot -> false
  | Top, _ -> false
  | Itv (c1, r1), Itv (c2, r2) -> let (min1, max1) = to_interval x in
      let (min2, max2) = to_interval y in
      min1 >= min2 && max1 <= max2

(* and infimums of the lattice. *)
let top = Top
let bottom = Bot

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

let join x y = match x, y with
  | Bot, a | a, Bot -> a
  | Top, _ | _, Top -> Top
  | Itv _, Itv _ -> let (min1, max1) = to_interval x in
      let (min2, max2) = to_interval y in
      from_interval (min min1 min2) (max max1 max2)

let meet x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Top, a | a, Top -> a
  | Itv _, Itv _ -> let (min1, max1) = to_interval x in
      let (min2, max2) = to_interval y in
      let new_min = max min1 min2 in
      let new_max = min max1 max2 in
      from_interval new_min new_max

let widening x y = match x, y with
  | (Bot,_), (a,k2) -> (a,k2+1)
  | _, (Bot,k1) -> (fst x,k1+1)
  | (Top,_) , _ | _,(Top,_) -> (Top,5)
  | (Itv _,_), (Itv _,b) ->
      if order (fst y) (fst x) && (b<=5) then x else (Top,5)


let sem_itv n1 n2 = from_interval n1 n2


let sem_plus x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Top, _ | _, Top -> Top
  | Itv (c1, r1), Itv (c2, r2) -> Itv (c1 + c2, r1 + r2)

let sem_minus x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Top, _ | _, Top -> Top
  | Itv (c1, r1), Itv (c2, r2) -> Itv (c1 - c2, r1 + r2)

let sem_times x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Top, _ | _, Top -> Top
  | Itv _, Itv _ -> let (min1, max1) = to_interval x in
      let (min2, max2) = to_interval y in
      let p1, p2 = min1 * min2, min1 * max2 in
      let p3, p4 = max1 * min2, max1 * max2 in
      let new_min = min (min p1 p2) (min p3 p4) in
      let new_max = max (max p1 p2) (max p3 p4) in
      from_interval new_min new_max

let sem_div x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Top, _ | _, Top -> Top
  | Itv _, Itv _ -> let (min2, max2) = to_interval y in
      if min2 <= 0 && max2 >= 0 then Top else
        let (min1, max1) = to_interval x in
        let p1, p2 = min1 / min2, min1 / max2 in
        let p3, p4 = max1 / min2, max1 / max2 in
        let new_min = min (min p1 p2) (min p3 p4) in
        let new_max = max (max p1 p2) (max p3 p4) in
        from_interval new_min new_max

let sem_guard x = match x with
| Itv(c,r) -> meet x (Itv(0,r))
| Bot -> Bot
| Top -> Top (*exist pas un cercle de centre c et de rayon infini*)
let backsem_plus x y r = meet x (sem_minus r y),meet y (sem_minus r x)
let backsem_minus x y r = meet x (sem_plus r y),meet y (sem_plus r x)
let backsem_times x y r = x, y
let backsem_div x y r = x, y
(* Template to write your own non relational abstract domain. *)
