(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
type t = Bot | Itv of int option * int option

(* Extension de <= `a Z U {-oo}. *)
let leq_minf x y = match x, y with
| None, _ -> true (* -oo <= y *)
| _, None -> false (* x > -oo (x != -oo) *)
| Some x, Some y -> x <= y

(* Extension de <= `a Z U {+oo}. *)
let leq_pinf x y = match x, y with
| _, None -> true (* x <= +oo *)
| None, _ -> false (* +oo > y (y != +oo) *)
| Some x, Some y -> x <= y

let mk_Itv o1 o2 = match o1, o2 with
| None, _ | _, None -> Itv (o1, o2)
| Some n1, Some n2 -> if n1 > n2 then Bot else Itv (o1, o2)

(* a printing function (useful for debuging), *)
let fprint ff = function
  | Itv (Some(i),Some(j)) -> Format.fprintf ff "(%d,%d)" i j
  | Itv(None,Some(j)) -> Format.fprintf ff "(-inf,%d)" j
  | Itv(Some(i),None) -> Format.fprintf ff "(%d,+inf)" i
  | Itv(None,None) -> Format.fprintf ff "(-inf,+inf)"
  | Bot -> Format.fprintf ff "⊥"

(* the order of the lattice. *)
let order x y = match x, y with
  | Bot, _ -> true
  | Itv(i,j), Itv(p,q) ->
      leq_minf p i && leq_pinf j q
  | _ -> false

(* and infimums of the lattice. *)
let top = Itv(None,None)
let bottom = Bot

(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)
let min_opt a b = match a, b with
  | None, _ | _, None -> None
  | Some x, Some y -> Some (min x y)

let max_opt a b = match a, b with
  | None, _ | _, None -> None
  | Some x, Some y -> Some (max x y)

let join x y = match x, y with
  | Bot, z | z, Bot -> z
  | Itv(i,j), Itv(p,q) ->
      Itv (min_opt i p, max_opt j q)

let meet x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Itv(i,j), Itv(p,q) ->
      mk_Itv (max_opt i p) (min_opt j q)

let widening _ _ = top  (* Ok, maybe you'll need to implement this one if your
                      * lattice has infinite ascending chains and you want
                      * your analyses to terminate. *)

let sem_itv a b = 
  mk_Itv (Some(a)) (Some(b))


let add_opt a b = match a, b with
  | Some x, Some y -> Some (x + y)
  | _ -> None


let sem_plus x y = match x,y with
  | Itv(i,j), Itv(p,q) -> Itv ((add_opt i p),(add_opt j q))
  | _ -> Bot
  

let sub_opt a b = match a, b with
  | Some x, Some y -> Some (x - y)
  | _ -> None


let sem_minus x y = match x,y with
  | Bot, _ | _, Bot -> Bot
  | Itv(i,j), Itv(p,q) ->
      mk_Itv (sub_opt i q) (sub_opt j p)



let all_mul a b c d =
  match a, b, c, d with
  | Some i, Some j, Some p, Some q ->
      let vals = [i*p; i*q; j*p; j*q] in
      Some (List.fold_left min max_int vals),
      Some (List.fold_left max min_int vals)
  | _ -> None, None

let sem_times x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Itv(i,j), Itv(p,q) ->
      let l, u = all_mul i j p q in
      mk_Itv l u


let sem_div x y = match x,y with
  | Bot, _ -> Bot
  | _, Bot -> Bot
  | _ -> Bot

let sem_guard t = t

let backsem_plus x y r = x, y
let backsem_minus x y r = x, y
let backsem_times x y r = x, y
let backsem_div x y r = x, y
