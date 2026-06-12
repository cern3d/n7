open MiniML
open Semantics

let getValeur (_,v,_) = v

let getType (t,_,_) = t

(* Tests de non regression *)
let%test _ = ( getValeur (miniML "../../exemples/exemple-00.mml") = (IntegerValue 3) )
let%test _ = ( getType (miniML "../../exemples/exemple-00.mml") = IntegerType )
let%test _ = ( getValeur (miniML "../../exemples/exemple-01.mml") = (IntegerValue (-8)) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-02.mml") = (IntegerValue 4) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-03.mml") = (IntegerValue 5) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-04.mml") = (IntegerValue 1) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-05.mml") = (IntegerValue 2) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-06.mml") = (IntegerValue 120) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-07.mml") = (IntegerValue 10) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-08.mml") = (IntegerValue 5) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-09.mml") = (FrozenValue (FunctionNode ("x",AccessNode "x"),[])) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-11.mml") = (IntegerValue 120) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-12.mml") = (IntegerValue 120) )
let%test _ = ( getValeur (miniML "../../exemples/exemple-13.mml") = (NullValue) )

let%test _ =
  getValeur (miniML "../../exemples/exemple-14.mml")
  = IntegerValue 5

let%test _ =
  getValeur (miniML "../../exemples/exemple-15.mml")
  = IntegerValue 9

let%test _ =
  getValeur (miniML "../../exemples/exemple-16.mml")
  = IntegerValue 2

let%test _ =
  getValeur (miniML "../../exemples/exemple-17.mml")
  = IntegerValue 5

let%test _ =
  getValeur (miniML "../../exemples/exemple-18.mml")
  = IntegerValue 0

let%test _ =
  getValeur (miniML "../../exemples/exemple-19.mml")
  = (ErrorValue TypeMismatchError)

let%test _ =
  getValeur (miniML "../../exemples/exemple-20.mml")
  = (ErrorValue TypeMismatchError)

let%test _ =
  getValeur (miniML "../../exemples/exemple-18.mml")
  = IntegerValue 0



let%test _ =
  getType (miniML "../../exemples/exemple-23.mml") = (ErrorType)


let%test _ =
  getType (miniML "../../exemples/exemple-25.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-26.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-27.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-28.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-29.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-30.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-31.mml") = (ErrorType)


let%test _ =
  getType (miniML "../../exemples/exemple-33.mml") = (ErrorType)

let%test _ =
  getType (miniML "../../exemples/exemple-34.mml") = (ErrorType)




let%test _ = 
  getType (miniML "../../exemples/exemple-35.mml") = (ReferenceType IntegerType)


let%test _ = 
  getType (miniML "../../exemples/exemple-36.mml") = (UnitType)


let%test _ = 
  getType (miniML "../../exemples/exemple-37.mml") = (IntegerType)


let%test _ = 
  getType (miniML "../../exemples/exemple-38.mml") = (BooleanType)


let%test _ = 
  getType (miniML "../../exemples/exemple-39.mml") = (BooleanType)


let%test _ = 
  getType (miniML "../../exemples/exemple-40.mml") = (ReferenceType IntegerType)


let%test _ = 
  getType (miniML "../../exemples/exemple-41.mml") = (BooleanType)


let%test _ = 
  getType (miniML "../../exemples/exemple-42.mml") = (BooleanType)


let%test _ = 
  getType (miniML "../../exemples/exemple-43.mml") = (ReferenceType IntegerType)