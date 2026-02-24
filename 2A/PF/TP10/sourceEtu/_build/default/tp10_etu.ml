
module type Scheduler = sig
  type prog = unit -> unit

  (* rend la main *)
  val yield : unit -> unit

  (* rend la main et lance l'exécution d'une nouvelle fonction *)
  val spawn : prog -> unit

  (* "tue" le processus appelant *)
  val stop : unit -> unit

  (* handler/ordonnanceur *)
  val run : prog -> unit
end

module Scheduler : Scheduler = struct
  type prog = unit -> unit

  type _ eff +=
    | Yield : unit eff
    | Spawn : prog -> unit eff
    | Stop  : unit eff


  let queue = Queue.create ()

  let yield () = Effect.perform Yield
  let spawn prog =  Effect.perform (Spawn prog)
  let stop () = Effect.perform Stop

  (* handler/ordonnanceur *)
  let rec run prog =
  try
    prog ();
    begin match Queue.take_opt queue with
    | None -> ()
    | Some k -> Effect.Deep.continue k ()
  end
  with
    | effect Yield , k ->
        begin Queue.add k queue;
        match Queue.take_opt queue with
        | None -> ()
        | Some next -> Effect.Deep.continue next ()
    end
    | effect (Spawn p) , k ->
        begin Queue.add k queue;
        run p
    end
    | effect Stop , k ->
        begin match Queue.take_opt queue with
        | None -> ()
        | Some next -> Effect.Deep.continue next ()
    end
  end
end

open Scheduler

let task name = for i = 1 to 10 do
print_endline name;
yield ();
done;
stop ()
let ping () = task "ping!"
let pong () = task "pong!"

let ping_pong () = spawn (ping);
  spawn (pong);
  stop ()
    
module type Channel = sig
  val create : unit -> ('a -> unit) * (unit -> 'a)
end

module Channel : Channel = struct
  open Scheduler

  let create () = failwith "TODO"
end


(* crible d'Eratosthène *)
let sieve max =
  let open Scheduler in
  let rec filter recv_from_parent =
    let v0 = recv_from_parent () in
    if v0 < 0 then stop ();
    Format.printf "%d@." v0;
    yield ();
    let send, recv = Channel.create () in
    spawn (fun () -> filter recv);
    while true do
      let v = recv_from_parent () in
      yield ();
      if v mod v0 <> 0 then send v;
      if v < 0 then stop ()
    done
  in
  let main () =
    if max < 2 then stop ();
    let send, recv = Channel.create () in
    spawn (fun () -> filter recv);
    for i = 2 to max do
      send i;
      yield ()
    done;
    send (-1);
    stop ()
  in
  run main      
