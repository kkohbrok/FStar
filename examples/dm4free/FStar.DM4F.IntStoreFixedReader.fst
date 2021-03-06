module FStar.DM4F.IntStoreFixedReader

open FStar.DM4F.Heap.IntStoreFixed

type int_store_reader (a:Type) = heap -> M a
let return_isr (a:Type) (x:a) : int_store_reader a = fun store -> x
let bind_isr (a b : Type) (x:int_store_reader a) (f: a -> int_store_reader b)
  : int_store_reader b
= fun store ->
    let z = x store in
    f z store

let get () : int_store_reader heap = fun store -> store

total reifiable reflectable new_effect {
  INT_STORE_READER : a:Type -> Effect
  with repr   = int_store_reader
    ; bind   = bind_isr
    ; return = return_isr
    ; get   = get
}

effect IntStoreReader (a:Type) (pre:INT_STORE_READER?.pre) (post: heap -> a -> GTot Type0) =
  INT_STORE_READER a (fun l0 p -> pre l0 /\ (forall x. pre l0 /\ post l0 x ==> p x))

effect ISR (a:Type) =
  INT_STORE_READER a (fun (l0:heap) (p:(a -> Type0)) -> forall (x:a). p x)

effect ISRNull (a:Type) =
  INT_STORE_READER a (fun (l0:heap) (p:(a -> Type0)) -> forall (x:a). p x)


let read (i:id)
  : INT_STORE_READER int (fun s0 p -> p (index s0 i))
=
  let store = ISR?.get () in
  index store i
