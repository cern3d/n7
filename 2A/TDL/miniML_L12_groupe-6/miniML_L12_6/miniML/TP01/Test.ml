open Ast 
open MiniML

let%test _ = ( (miniML "../../exemples/exemple-00.mml") = (IntegerValue 3))
let%test _ = ( (miniML "../../exemples/exemple-01.mml") = (IntegerValue (-8)))
let%test _ = ( (miniML "../../exemples/exemple-02.mml") = (IntegerValue 4))
let%test _ = ( (miniML "../../exemples/exemple-03.mml") = (IntegerValue 5))
let%test _ = ( (miniML "../../exemples/exemple-04.mml") = (IntegerValue 1))
let%test _ = ( (miniML "../../exemples/exemple-05.mml") = (IntegerValue 2))
let%test _ = ( (miniML "../../exemples/exemple-06.mml") = (IntegerValue 120))
let%test _ = ( (miniML "../../exemples/exemple-07.mml") = (IntegerValue 10))
let%test _ = ( (miniML "../../exemples/exemple-08.mml") = (IntegerValue 5))
let%test _ = ( (miniML "../../exemples/exemple-09.mml") = (FrozenValue (FunctionNode ("x",AccessNode "x"),[])))
let%test _ = ( (miniML "../../exemples/exemple-11.mml") = (IntegerValue 120))
let%test _ = ( (miniML "../../exemples/exemple-12.mml") = (IntegerValue 120))
               

let%test _ = (miniML "../../exemples/exemple-14.mml") = (IntegerValue 5)
let%test _ = (miniML "../../exemples/exemple-15.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-16.mml") = (BooleanValue false)
let%test _ = (miniML "../../exemples/exemple-17.mml") = (IntegerValue (-5))
let%test _ = (miniML "../../exemples/exemple-18.mml") = (BooleanValue false)
let%test _ = (miniML "../../exemples/exemple-19.mml") = (BooleanValue true)


let%test _ = (miniML "../../exemples/exemple-20.mml") = (IntegerValue 7)
let%test _ = (miniML "../../exemples/exemple-21.mml") = (IntegerValue 0)
let%test _ = (miniML "../../exemples/exemple-22.mml") = (IntegerValue 2)
let%test _ = (miniML "../../exemples/exemple-23.mml") = (IntegerValue (-5))
let%test _ = (miniML "../../exemples/exemple-24.mml") = (IntegerValue 20)
let%test _ = (miniML "../../exemples/exemple-25.mml") = (IntegerValue 0)
let%test _ = (miniML "../../exemples/exemple-26.mml") = (IntegerValue 5)
let%test _ = (miniML "../../exemples/                       exemple-27.mml") = (IntegerValue 1)


let%test _ = (miniML "../../exemples/exemple-28.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-29.mml") = (BooleanValue false)
let%test _ = (miniML "../../exemples/     exemple-30.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-31.mml") = (BooleanValue false)


let%test _ = (miniML "../../exemples/exemple-32.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-33.mml") = (BooleanValue false)
let%test _ = (miniML "../../exemples/exemple-34.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-35.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-36.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-37.mml") = (BooleanValue true)
let%test _ = (miniML "../../exemples/exemple-38.mml") = (BooleanValue true)


let%test _ = (miniML "../../exemples/exemple-39.mml") = (IntegerValue 8)
let%test _ = (miniML "../../exemples/exemple-40.mml") = (IntegerValue 25)
let%test _ = (miniML "../../exemples/exemple-41.mml") = (IntegerValue 1)
let%test _ = (miniML "../../exemples/exemple-42.mml") = (IntegerValue 2)


let%test _ = (miniML "../../exemples/exemple-43.mml") = (IntegerValue 6)
let%test _ = (miniML "../../exemples/exemple-44.mml") = (IntegerValue 25)
let%test _ = (miniML "../../exemples/exemple-45.mml") = (IntegerValue 15)
let%test _ = (miniML "../../exemples/exemple-46.mml") = (IntegerValue 50)
let%test _ = (miniML "../../exemples/exemple-47.mml") = (IntegerValue 15)
let%test _ = (miniML "../../exemples/exemple-48.mml") = (IntegerValue 50)


let%test _ = (miniML "../../exemples/exemple-49.mml") = (IntegerValue 120)
let%test _ = (miniML "../../exemples/exemple-50.mml") = (IntegerValue 11)
let%test _ = (miniML "../../exemples/exemple-51.mml") = (IntegerValue 81)
let%test _ = (miniML "../../exemples/exemple-52.mml") = (IntegerValue 14)
let%test _ = (miniML "../../exemples/exemple-53.mml") = (IntegerValue 20)
let%test _ = (miniML "../../exemples/exemple-54.mml") = (IntegerValue 13)