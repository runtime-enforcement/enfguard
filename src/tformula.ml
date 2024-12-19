open Base

module MyTerm = Term
module Errs = Errors
open MFOTL_lib
module Ctxt = Ctxt.Make(Dom)
module Term = MyTerm

type info_type = {
    enftype: Enftype.t;
    filter:  Filter.t;
    flag:    bool;
  } [@@deriving compare, sexp_of, hash, equal]

module TypeInfo : Modules.I with type t = info_type = struct

  type t = info_type [@@deriving compare, sexp_of, hash, equal]

  let to_string l s info =
    if Enftype.is_only_observable info.enftype then
      s
    else
      Printf.sprintf (Etc.paren l 0 "%s : %s") s (Enftype.to_string info.enftype)

  let dummy = { enftype = Enftype.obs; filter = Filter.tt; flag = false }

end 

include MFOTL.Make(TypeInfo)(Tterm.TypedVar)(Dom)(Tterm)

include Tyformula.MFOTL_Enforceability(Sig)

let rec core_of_formula (f : Tyformula.typed_t) (types: Ctxt.t) : Ctxt.t * core_t * Enftype.t * bool =
  let f_q ?(true_ok=true) f x =
    if is_past_guarded x true f then
      true
    else if is_past_guarded x false f && true_ok then
      false
    else
      (Stdio.print_endline ("However, the formula is not monitorable because the variable\n "
                            ^ Tterm.TypedVar.to_string x
                            ^ "\nis not monitorable in\n "
                            ^ Tyformula.to_string_typed f);
       raise (Errs.FormulaError
                (Printf.sprintf "variable %s is not monitorable in %s"
                   (Tterm.TypedVar.to_string x) (Tyformula.to_string_typed f))))
  in 
  let f_q_nonvar f x =
    let nonvars = Set.filter (Tyformula.terms f) ~f:(fun t -> not (Tterm.is_var t)) in
    let nonvars_fvs = Tterm.fv_list (Set.elements nonvars) in
    if List.mem nonvars_fvs x ~equal:Tterm.equal_v then
      f_q f x
    else
      true
  in
  let check_right_bound enftype (i: Interval.t) =
    if Enftype.is_only_observable enftype && not (Interval.is_bounded i) then
      (Stdio.print_endline ("However, the formula is not monitorable because the interval\n "
                            ^ Interval.to_string i
                            ^ "\nis not future-bounded");
       raise (Errs.FormulaError
                (Printf.sprintf "interval %s is not future-bounded" (Interval.to_string i))))
  in
  (*print_endline (Printf.sprintf "core_of_formula(%s)" (Tyformula.to_string_typed f));*)
  match f.form with
  | TT -> types, TT, Enftype.cau, false
  | FF -> types, FF, Enftype.sup, false
  | EqConst (trm, c) ->
     types, EqConst (trm, c), Enftype.obs, false
  | Predicate (e, trms) when not (Sig.equal_pred_kind (Sig.kind_of_pred e) Sig.Predicate) ->
     let enftype  = Sig.enftype_of_pred e in
     types, Predicate (e, trms),
     Enftype.join enftype Enftype.obs, false
  | Predicate (e, trms) ->
     let enftype  = Sig.enftype_of_pred e in
     types, EqConst (Tterm.make_dummy (Tterm.App (e, trms)), Dom.Int 1),
     Enftype.join enftype Enftype.obs, false
  | Predicate' (e, trms, f) ->
     let types, mf = of_formula f types in
     types, Predicate' (e, trms, mf), mf.info.enftype, false
  | Let _ -> raise (Errs.FormulaError "Let bindings must be unrolled to convert to Tformula")
  | Let' (r, enftype, trms, f, g) ->
     let _, mf = of_formula f types in
     let types, mg = of_formula g types in
     types, Let' (r, enftype, trms, mf, mg),
     Enftype.join mf.info.enftype mg.info.enftype, false
  | Agg (s, op, x, y, f) ->
     let types, mf = of_formula f types in
     let vars_to_monitor =
       Tterm.fv_list [x]
       @ (List.filter (Set.elements (Tyformula.fv f))
            ~f:(fun x -> List.mem y x ~equal:Tterm.equal_v)) in
     ignore (List.map vars_to_monitor ~f:(f_q ~true_ok:false f));
     types, Agg (s, op, x, y, mf),
     mf.info.enftype, false
  | Top (s, op, x, y, f) ->
     let types, mf = of_formula f types in
     let vars_to_monitor =
       Tterm.fv_list x
       @ (List.filter (Set.elements (Tyformula.fv f))
            ~f:(fun x -> List.mem y x ~equal:Tterm.equal_v)) in
     ignore (List.map vars_to_monitor ~f:(f_q ~true_ok:false f));
     types, Top (s, op, x, y, mf),
     mf.info.enftype, false
  | Neg f ->
     let types, mf = of_formula f types in
     types, Neg mf, mf.info.enftype, false
  | And (s, fs) ->
     let types, mfs = List.fold_map fs ~init:types ~f:(fun types f -> of_formula f types) in
     let mf1, mf_rest = List.hd_exn mfs, List.tl_exn mfs in
     let enftype = List.fold_left ~init:mf1.info.enftype
                     ~f:(fun enftype mf -> Enftype.join enftype mf.info.enftype) mf_rest in
     types, And (s, mfs), enftype, false
  | Or (s, fs) ->
     let types, mfs = List.fold_map fs ~init:types ~f:(fun types f -> of_formula f types) in
     let mf1, mf_rest = List.hd_exn mfs, List.tl_exn mfs in
     let enftype = List.fold_left ~init:mf1.info.enftype
                     ~f:(fun enftype mf -> Enftype.join enftype mf.info.enftype) mf_rest in
     types, Or (s, mfs), enftype, false
  | Imp (s, f, g) ->
     let types, mf = of_formula f types in
     let types, mg = of_formula g types in
     types, Imp (s, mf, mg), Enftype.join mf.info.enftype mg.info.enftype, false
  | Exists (x, f) ->
     let types, mf = of_formula f types in
     (*print_endline "--core_of_formula.Exists";
       print_endline (Formula.to_string f);*)
     (*Map.iteri types ~f:(fun ~key ~data -> print_endline (key ^ " -> " ^ Dom.tt_to_string data));*)
     types, Exists (x, mf), mf.info.enftype, f_q_nonvar f x
  | Forall (x, f) ->
     let types, mf = of_formula f types in
     types, Forall (x, mf), mf.info.enftype, f_q_nonvar f x
  | Prev (i, f) ->
     let types, mf = of_formula f types in
     types, Prev (i, mf), mf.info.enftype, false
  | Next (i, f) ->
     let types, mf = of_formula f types in
     types, Next (i, mf), mf.info.enftype, false
  | Once (i, f) ->
     let types, mf = of_formula f types in
     types, Once (i, mf), mf.info.enftype, false
  | Eventually (i, f) ->
     let types, mf = of_formula f types in
     check_right_bound mf.info.enftype i;
     types, Eventually (i, mf), mf.info.enftype, true
  | Historically (i, f) ->
     let types, mf = of_formula f types in
     types, Historically (i, mf), mf.info.enftype, false
  | Always (i, f) ->
     let types, mf = of_formula f types in
     check_right_bound mf.info.enftype i;
     types, Always (i, mf), mf.info.enftype, true
  | Since (s, i, f, g) ->
     let types, mf = of_formula f types in
     let types, mg = of_formula g types in
     types, Since (s, i, mf, mg), Enftype.join mf.info.enftype mg.info.enftype, false
  | Until (s, i, f, g) ->
     let types, mf = of_formula f types in
     let types, mg = of_formula g types in
     check_right_bound (Enftype.join mf.info.enftype mg.info.enftype) i;
     types, Until (s, i, mf, mg), Enftype.join mf.info.enftype mg.info.enftype, true
  | Type (f, ty) ->
     let types, mf = of_formula f types in
     types, Type (mf, ty), mf.info.enftype, false

and of_formula f  (types: Ctxt.t) =
  let types, f, enftype, flag = core_of_formula f types in
  types, make f { enftype; filter = Filter.tt; flag }

let of_formula' f =
  snd (of_formula f Ctxt.empty)
