open Base

module Fdeque = Core.Fdeque

exception TypingError of string
exception EnforceabilityError of string

type timepoint = int
type timestamp = Time.t

val eat: string -> string -> string
val paren: int -> int -> ('b, 'c, 'd, 'e, 'f, 'g) format6 -> ('b, 'c, 'd, 'e, 'f, 'g) format6
val is_digit: char -> bool

exception Empty_deque of string
val deque_to_string: string -> (string -> 'a -> string) -> 'a Core.Fdeque.t -> string

val queue_drop: 'a Base.Queue.t -> int -> 'a Base.Queue.t

val list_to_string: string -> (string -> 'a -> string) -> 'a list -> string

val string_list_to_string: string list -> string

val some_string: unit -> string

val string_list_to_json: string list -> string

type valuation = (string, Dom.t, String.comparator_witness) Map.t

val compare_valuation: valuation -> valuation -> int
val equal_valuation: valuation -> valuation -> bool
val empty_valuation: valuation
val sexp_of_valuation: valuation -> Sexp.t
val extend_valuation: valuation -> valuation -> valuation
val hash_valuation: valuation -> int

val dom_map_to_string: (string, Dom.t, String.comparator_witness) Map.t -> string
val valuation_to_string: (string, Dom.t, String.comparator_witness) Map.t -> string

val int_list_to_json: int list -> string

val unquote: string -> string

val escape_underscores: string -> string

(*val fdeque_for_all2_exn: 'a Fdeque.t -> 'b Fdeque.t -> f:('a -> 'b -> bool) -> bool*)

val spaces: int -> string

val lexicographics: ('a -> 'a -> int) -> 'a list -> 'a list -> int
val lexicographic2: ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('a * 'b) -> ('a * 'b) -> int
val lexicographic3: ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('c -> 'c -> int) -> ('a * 'b * 'c) -> ('a * 'b * 'c) -> int
val lexicographic4: ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('c -> 'c -> int) -> ('d -> 'd -> int) -> ('a * 'b * 'c * 'd) -> ('a * 'b * 'c * 'd) -> int
val lexicographic5: ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('c -> 'c -> int) -> ('d -> 'd -> int) -> ('e -> 'e -> int) -> ('a * 'b * 'c * 'd * 'e) -> ('a * 'b * 'c * 'd * 'e) -> int


(* For debugging only *)
val _print: string -> ('a -> string) -> 'a -> 'a

val reorder: equal:('a -> 'a -> bool) -> 'a list -> 'a list -> 'a list
val reorder_subset: equal:('a -> 'a -> bool) -> 'a list -> 'a list -> 'a list
val dedup: equal:('a -> 'a -> bool) -> 'a list -> 'a list


val cartesian: 'a list list -> 'a list list
val set_cartesian: ('a, 'b) Comparator.Module.t -> ('a, 'b) Base.Set.t list -> ('a, 'b) Base.Set.t list

val gen_fresh: string -> string

val inter_list: ('a, 'b) Comparator.Module.t -> ('a, 'b) Base.Set.t list -> ('a, 'b) Base.Set.t

type string_set_list = (string, Base.String.comparator_witness) Base.Set.t list

val string_set_list_to_string: string_set_list -> string

val inter_string_set_list: string_set_list list -> string_set_list

val list_intersection: ('a -> 'a -> bool) -> 'a list list -> 'a list

val option_to_string : ('a -> string) -> 'a option -> string
