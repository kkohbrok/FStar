
open Prims
open FStar_Pervasives

type z3_replay_result =
(FStar_SMTEncoding_Z3.unsat_core, FStar_SMTEncoding_Term.error_labels) FStar_Util.either


let z3_result_as_replay_result : 'Auu____13 'Auu____14 'Auu____15 . ('Auu____15, ('Auu____14 * 'Auu____13)) FStar_Util.either  ->  ('Auu____15, 'Auu____14) FStar_Util.either = (fun uu___87_31 -> (match (uu___87_31) with
| FStar_Util.Inl (l) -> begin
FStar_Util.Inl (l)
end
| FStar_Util.Inr (r, uu____46) -> begin
FStar_Util.Inr (r)
end))


let recorded_hints : FStar_Util.hints FStar_Pervasives_Native.option FStar_ST.ref = (FStar_Util.mk_ref FStar_Pervasives_Native.None)


let replaying_hints : FStar_Util.hints FStar_Pervasives_Native.option FStar_ST.ref = (FStar_Util.mk_ref FStar_Pervasives_Native.None)


let format_hints_file_name : Prims.string  ->  Prims.string = (fun src_filename -> (FStar_Util.format1 "%s.hints" src_filename))


let initialize_hints_db : 'Auu____87 . Prims.string  ->  'Auu____87  ->  Prims.unit = (fun src_filename format_filename -> ((

let uu____97 = (FStar_Options.record_hints ())
in (match (uu____97) with
| true -> begin
(FStar_ST.op_Colon_Equals recorded_hints (FStar_Pervasives_Native.Some ([])))
end
| uu____122 -> begin
()
end));
(

let uu____123 = (FStar_Options.use_hints ())
in (match (uu____123) with
| true -> begin
(

let norm_src_filename = (FStar_Util.normalize_file_path src_filename)
in (

let val_filename = (

let uu____126 = (FStar_Options.hint_file ())
in (match (uu____126) with
| FStar_Pervasives_Native.Some (fn) -> begin
fn
end
| FStar_Pervasives_Native.None -> begin
(format_hints_file_name norm_src_filename)
end))
in (

let uu____130 = (FStar_Util.read_hints val_filename)
in (match (uu____130) with
| FStar_Pervasives_Native.Some (hints) -> begin
(

let expected_digest = (FStar_Util.digest_of_file norm_src_filename)
in ((

let uu____136 = (FStar_Options.hint_info ())
in (match (uu____136) with
| true -> begin
(

let uu____137 = (

let uu____138 = (FStar_Options.hint_file ())
in (match (uu____138) with
| FStar_Pervasives_Native.Some (fn) -> begin
(Prims.strcat " from \'" (Prims.strcat val_filename "\'"))
end
| uu____142 -> begin
""
end))
in (FStar_Util.print3 "(%s) digest is %s%s.\n" norm_src_filename (match ((Prims.op_Equality hints.FStar_Util.module_digest expected_digest)) with
| true -> begin
"valid; using hints"
end
| uu____145 -> begin
"invalid; using potentially stale hints"
end) uu____137))
end
| uu____146 -> begin
()
end));
(FStar_ST.op_Colon_Equals replaying_hints (FStar_Pervasives_Native.Some (hints.FStar_Util.hints)));
))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____165 = (FStar_Options.hint_info ())
in (match (uu____165) with
| true -> begin
(FStar_Util.print1 "(%s) Unable to read hint file.\n" norm_src_filename)
end
| uu____166 -> begin
()
end))
end))))
end
| uu____167 -> begin
()
end));
))


let finalize_hints_db : Prims.string  ->  Prims.unit = (fun src_filename -> ((

let uu____173 = (FStar_Options.record_hints ())
in (match (uu____173) with
| true -> begin
(

let hints = (

let uu____175 = (FStar_ST.op_Bang recorded_hints)
in (FStar_Option.get uu____175))
in (

let hints_db = (

let uu____197 = (FStar_Util.digest_of_file src_filename)
in {FStar_Util.module_digest = uu____197; FStar_Util.hints = hints})
in (

let norm_src_filename = (FStar_Util.normalize_file_path src_filename)
in (

let val_filename = (

let uu____200 = (FStar_Options.hint_file ())
in (match (uu____200) with
| FStar_Pervasives_Native.Some (fn) -> begin
fn
end
| FStar_Pervasives_Native.None -> begin
(format_hints_file_name norm_src_filename)
end))
in (FStar_Util.write_hints val_filename hints_db)))))
end
| uu____204 -> begin
()
end));
(FStar_ST.op_Colon_Equals recorded_hints FStar_Pervasives_Native.None);
(FStar_ST.op_Colon_Equals replaying_hints FStar_Pervasives_Native.None);
))


let with_hints_db : 'a . Prims.string  ->  (Prims.unit  ->  'a)  ->  'a = (fun fname f -> ((initialize_hints_db fname false);
(

let result = (f ())
in ((finalize_hints_db fname);
result;
));
))


let filter_using_facts_from : FStar_TypeChecker_Env.env  ->  FStar_SMTEncoding_Term.decls_t  ->  FStar_SMTEncoding_Term.decl Prims.list = (fun e theory -> (

let should_enc_fid = (fun fid -> (match (fid) with
| FStar_SMTEncoding_Term.Namespace (lid) -> begin
(FStar_TypeChecker_Env.should_enc_lid e lid)
end
| uu____280 -> begin
false
end))
in (

let matches_fact_ids = (fun include_assumption_names a -> (match (a.FStar_SMTEncoding_Term.assumption_fact_ids) with
| [] -> begin
true
end
| uu____292 -> begin
((FStar_List.contains a.FStar_SMTEncoding_Term.assumption_name include_assumption_names) || (FStar_All.pipe_right a.FStar_SMTEncoding_Term.assumption_fact_ids (FStar_Util.for_some (fun fid -> (should_enc_fid fid)))))
end))
in (

let theory_rev = (FStar_List.rev theory)
in (

let uu____302 = (FStar_List.fold_left (fun uu____325 d -> (match (uu____325) with
| (out, include_assumption_names) -> begin
(match (d) with
| FStar_SMTEncoding_Term.Assume (a) -> begin
(

let uu____362 = (matches_fact_ids include_assumption_names a)
in (match (uu____362) with
| true -> begin
(((d)::out), (include_assumption_names))
end
| uu____375 -> begin
((out), (include_assumption_names))
end))
end
| FStar_SMTEncoding_Term.RetainAssumptions (names1) -> begin
(((d)::out), ((FStar_List.append names1 include_assumption_names)))
end
| uu____387 -> begin
(((d)::out), (include_assumption_names))
end)
end)) (([]), ([])) theory_rev)
in (match (uu____302) with
| (pruned_theory, uu____399) -> begin
pruned_theory
end))))))


let filter_assertions : FStar_TypeChecker_Env.env  ->  FStar_SMTEncoding_Z3.unsat_core  ->  FStar_SMTEncoding_Term.decls_t  ->  (FStar_SMTEncoding_Term.decl Prims.list * Prims.bool) = (fun e core theory -> (match (core) with
| FStar_Pervasives_Native.None -> begin
(

let uu____434 = (filter_using_facts_from e theory)
in ((uu____434), (false)))
end
| FStar_Pervasives_Native.Some (core1) -> begin
(

let uu____444 = (FStar_List.fold_right (fun d uu____468 -> (match (uu____468) with
| (theory1, n_retained, n_pruned) -> begin
(match (d) with
| FStar_SMTEncoding_Term.Assume (a) -> begin
(match ((FStar_List.contains a.FStar_SMTEncoding_Term.assumption_name core1)) with
| true -> begin
(((d)::theory1), ((n_retained + (Prims.parse_int "1"))), (n_pruned))
end
| uu____511 -> begin
(match ((FStar_Util.starts_with a.FStar_SMTEncoding_Term.assumption_name "@")) with
| true -> begin
(((d)::theory1), (n_retained), (n_pruned))
end
| uu____522 -> begin
((theory1), (n_retained), ((n_pruned + (Prims.parse_int "1"))))
end)
end)
end
| uu____525 -> begin
(((d)::theory1), (n_retained), (n_pruned))
end)
end)) theory (([]), ((Prims.parse_int "0")), ((Prims.parse_int "0"))))
in (match (uu____444) with
| (theory', n_retained, n_pruned) -> begin
(

let uu____543 = (

let uu____546 = (

let uu____549 = (

let uu____550 = (

let uu____551 = (FStar_All.pipe_right core1 (FStar_String.concat ", "))
in (Prims.strcat "UNSAT CORE: " uu____551))
in FStar_SMTEncoding_Term.Caption (uu____550))
in (uu____549)::[])
in (FStar_List.append theory' uu____546))
in ((uu____543), (true)))
end))
end))


let filter_facts_without_core : FStar_TypeChecker_Env.env  ->  FStar_SMTEncoding_Term.decls_t  ->  (FStar_SMTEncoding_Term.decl Prims.list * Prims.bool) = (fun e x -> (

let uu____570 = (filter_using_facts_from e x)
in ((uu____570), (false))))

type errors =
{error_reason : Prims.string; error_fuel : Prims.int; error_ifuel : Prims.int; error_hint : Prims.string Prims.list FStar_Pervasives_Native.option; error_messages : (Prims.string * FStar_Range.range) Prims.list}


let __proj__Mkerrors__item__error_reason : errors  ->  Prims.string = (fun projectee -> (match (projectee) with
| {error_reason = __fname__error_reason; error_fuel = __fname__error_fuel; error_ifuel = __fname__error_ifuel; error_hint = __fname__error_hint; error_messages = __fname__error_messages} -> begin
__fname__error_reason
end))


let __proj__Mkerrors__item__error_fuel : errors  ->  Prims.int = (fun projectee -> (match (projectee) with
| {error_reason = __fname__error_reason; error_fuel = __fname__error_fuel; error_ifuel = __fname__error_ifuel; error_hint = __fname__error_hint; error_messages = __fname__error_messages} -> begin
__fname__error_fuel
end))


let __proj__Mkerrors__item__error_ifuel : errors  ->  Prims.int = (fun projectee -> (match (projectee) with
| {error_reason = __fname__error_reason; error_fuel = __fname__error_fuel; error_ifuel = __fname__error_ifuel; error_hint = __fname__error_hint; error_messages = __fname__error_messages} -> begin
__fname__error_ifuel
end))


let __proj__Mkerrors__item__error_hint : errors  ->  Prims.string Prims.list FStar_Pervasives_Native.option = (fun projectee -> (match (projectee) with
| {error_reason = __fname__error_reason; error_fuel = __fname__error_fuel; error_ifuel = __fname__error_ifuel; error_hint = __fname__error_hint; error_messages = __fname__error_messages} -> begin
__fname__error_hint
end))


let __proj__Mkerrors__item__error_messages : errors  ->  (Prims.string * FStar_Range.range) Prims.list = (fun projectee -> (match (projectee) with
| {error_reason = __fname__error_reason; error_fuel = __fname__error_fuel; error_ifuel = __fname__error_ifuel; error_hint = __fname__error_hint; error_messages = __fname__error_messages} -> begin
__fname__error_messages
end))


let error_to_short_string : errors  ->  Prims.string = (fun err1 -> (

let uu____724 = (FStar_Util.string_of_int err1.error_fuel)
in (

let uu____725 = (FStar_Util.string_of_int err1.error_ifuel)
in (FStar_Util.format4 "%s (fuel=%s; ifuel=%s; %s)" err1.error_reason uu____724 uu____725 (match ((FStar_Option.isSome err1.error_hint)) with
| true -> begin
"with hint"
end
| uu____728 -> begin
""
end)))))

type query_settings =
{query_env : FStar_TypeChecker_Env.env; query_decl : FStar_SMTEncoding_Term.decl; query_name : Prims.string; query_index : Prims.int; query_range : FStar_Range.range; query_fuel : Prims.int; query_ifuel : Prims.int; query_rlimit : Prims.int; query_hint : Prims.string Prims.list FStar_Pervasives_Native.option; query_errors : errors Prims.list; query_all_labels : FStar_SMTEncoding_Term.error_labels; query_suffix : FStar_SMTEncoding_Term.decl Prims.list}


let __proj__Mkquery_settings__item__query_env : query_settings  ->  FStar_TypeChecker_Env.env = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_env
end))


let __proj__Mkquery_settings__item__query_decl : query_settings  ->  FStar_SMTEncoding_Term.decl = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_decl
end))


let __proj__Mkquery_settings__item__query_name : query_settings  ->  Prims.string = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_name
end))


let __proj__Mkquery_settings__item__query_index : query_settings  ->  Prims.int = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_index
end))


let __proj__Mkquery_settings__item__query_range : query_settings  ->  FStar_Range.range = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_range
end))


let __proj__Mkquery_settings__item__query_fuel : query_settings  ->  Prims.int = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_fuel
end))


let __proj__Mkquery_settings__item__query_ifuel : query_settings  ->  Prims.int = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_ifuel
end))


let __proj__Mkquery_settings__item__query_rlimit : query_settings  ->  Prims.int = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_rlimit
end))


let __proj__Mkquery_settings__item__query_hint : query_settings  ->  Prims.string Prims.list FStar_Pervasives_Native.option = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_hint
end))


let __proj__Mkquery_settings__item__query_errors : query_settings  ->  errors Prims.list = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_errors
end))


let __proj__Mkquery_settings__item__query_all_labels : query_settings  ->  FStar_SMTEncoding_Term.error_labels = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_all_labels
end))


let __proj__Mkquery_settings__item__query_suffix : query_settings  ->  FStar_SMTEncoding_Term.decl Prims.list = (fun projectee -> (match (projectee) with
| {query_env = __fname__query_env; query_decl = __fname__query_decl; query_name = __fname__query_name; query_index = __fname__query_index; query_range = __fname__query_range; query_fuel = __fname__query_fuel; query_ifuel = __fname__query_ifuel; query_rlimit = __fname__query_rlimit; query_hint = __fname__query_hint; query_errors = __fname__query_errors; query_all_labels = __fname__query_all_labels; query_suffix = __fname__query_suffix} -> begin
__fname__query_suffix
end))


let with_fuel_and_diagnostics : query_settings  ->  FStar_SMTEncoding_Term.decl Prims.list  ->  FStar_SMTEncoding_Term.decl Prims.list = (fun settings label_assumptions -> (

let n1 = settings.query_fuel
in (

let i = settings.query_ifuel
in (

let rlimit = settings.query_rlimit
in (

let uu____1106 = (

let uu____1109 = (

let uu____1110 = (

let uu____1111 = (FStar_Util.string_of_int n1)
in (

let uu____1112 = (FStar_Util.string_of_int i)
in (FStar_Util.format2 "<fuel=\'%s\' ifuel=\'%s\'>" uu____1111 uu____1112)))
in FStar_SMTEncoding_Term.Caption (uu____1110))
in (

let uu____1113 = (

let uu____1116 = (

let uu____1117 = (

let uu____1124 = (

let uu____1125 = (

let uu____1130 = (FStar_SMTEncoding_Util.mkApp (("MaxFuel"), ([])))
in (

let uu____1133 = (FStar_SMTEncoding_Term.n_fuel n1)
in ((uu____1130), (uu____1133))))
in (FStar_SMTEncoding_Util.mkEq uu____1125))
in ((uu____1124), (FStar_Pervasives_Native.None), ("@MaxFuel_assumption")))
in (FStar_SMTEncoding_Util.mkAssume uu____1117))
in (

let uu____1136 = (

let uu____1139 = (

let uu____1140 = (

let uu____1147 = (

let uu____1148 = (

let uu____1153 = (FStar_SMTEncoding_Util.mkApp (("MaxIFuel"), ([])))
in (

let uu____1156 = (FStar_SMTEncoding_Term.n_fuel i)
in ((uu____1153), (uu____1156))))
in (FStar_SMTEncoding_Util.mkEq uu____1148))
in ((uu____1147), (FStar_Pervasives_Native.None), ("@MaxIFuel_assumption")))
in (FStar_SMTEncoding_Util.mkAssume uu____1140))
in (uu____1139)::(settings.query_decl)::[])
in (uu____1116)::uu____1136))
in (uu____1109)::uu____1113))
in (

let uu____1159 = (

let uu____1162 = (

let uu____1165 = (

let uu____1168 = (

let uu____1169 = (

let uu____1174 = (FStar_Util.string_of_int rlimit)
in (("rlimit"), (uu____1174)))
in FStar_SMTEncoding_Term.SetOption (uu____1169))
in (uu____1168)::(FStar_SMTEncoding_Term.CheckSat)::(FStar_SMTEncoding_Term.GetReasonUnknown)::[])
in (

let uu____1175 = (

let uu____1178 = (

let uu____1181 = (FStar_Options.record_hints ())
in (match (uu____1181) with
| true -> begin
(FStar_SMTEncoding_Term.GetUnsatCore)::[]
end
| uu____1184 -> begin
[]
end))
in (

let uu____1185 = (

let uu____1188 = (

let uu____1191 = (FStar_Options.print_z3_statistics ())
in (match (uu____1191) with
| true -> begin
(FStar_SMTEncoding_Term.GetStatistics)::[]
end
| uu____1194 -> begin
[]
end))
in (FStar_List.append uu____1188 settings.query_suffix))
in (FStar_List.append uu____1178 uu____1185)))
in (FStar_List.append uu____1165 uu____1175)))
in (FStar_List.append label_assumptions uu____1162))
in (FStar_List.append uu____1106 uu____1159)))))))


let used_hint : query_settings  ->  Prims.bool = (fun s -> (FStar_Option.isSome s.query_hint))


let next_hint : query_settings  ->  FStar_Util.hint FStar_Pervasives_Native.option = (fun uu____1206 -> (match (uu____1206) with
| {query_env = uu____1209; query_decl = uu____1210; query_name = qname; query_index = qindex; query_range = uu____1213; query_fuel = uu____1214; query_ifuel = uu____1215; query_rlimit = uu____1216; query_hint = uu____1217; query_errors = uu____1218; query_all_labels = uu____1219; query_suffix = uu____1220} -> begin
(

let uu____1229 = (FStar_ST.op_Bang replaying_hints)
in (match (uu____1229) with
| FStar_Pervasives_Native.Some (hints) -> begin
(FStar_Util.find_map hints (fun uu___88_1257 -> (match (uu___88_1257) with
| FStar_Pervasives_Native.Some (hint) when ((Prims.op_Equality hint.FStar_Util.hint_name qname) && (Prims.op_Equality hint.FStar_Util.hint_index qindex)) -> begin
FStar_Pervasives_Native.Some (hint)
end
| uu____1263 -> begin
FStar_Pervasives_Native.None
end)))
end
| uu____1266 -> begin
FStar_Pervasives_Native.None
end))
end))


let query_errors : 'Auu____1277 'Auu____1278 . query_settings  ->  (FStar_SMTEncoding_Z3.z3status * 'Auu____1278 * 'Auu____1277)  ->  errors FStar_Pervasives_Native.option = (fun settings uu____1294 -> (match (uu____1294) with
| (z3status, elapsed_time, stats) -> begin
(match (z3status) with
| FStar_SMTEncoding_Z3.UNSAT (uu____1306) -> begin
FStar_Pervasives_Native.None
end
| uu____1307 -> begin
(

let uu____1308 = (FStar_SMTEncoding_Z3.status_string_and_errors z3status)
in (match (uu____1308) with
| (msg, error_labels) -> begin
(

let err1 = (

let uu____1318 = (FStar_List.map (fun uu____1339 -> (match (uu____1339) with
| (uu____1350, x, y) -> begin
((x), (y))
end)) error_labels)
in {error_reason = msg; error_fuel = settings.query_fuel; error_ifuel = settings.query_ifuel; error_hint = settings.query_hint; error_messages = uu____1318})
in FStar_Pervasives_Native.Some (err1))
end))
end)
end))


let detail_hint_replay : 'Auu____1361 'Auu____1362 . query_settings  ->  (FStar_SMTEncoding_Z3.z3status * 'Auu____1362 * 'Auu____1361)  ->  Prims.unit = (fun settings uu____1376 -> (match (uu____1376) with
| (z3status, uu____1384, uu____1385) -> begin
(

let uu____1386 = ((used_hint settings) && (FStar_Options.detail_hint_replay ()))
in (match (uu____1386) with
| true -> begin
(match (z3status) with
| FStar_SMTEncoding_Z3.UNSAT (uu____1387) -> begin
()
end
| _failed -> begin
(

let ask_z3 = (fun label_assumptions -> (

let res = (FStar_Util.mk_ref FStar_Pervasives_Native.None)
in ((

let uu____1405 = (with_fuel_and_diagnostics settings label_assumptions)
in (FStar_SMTEncoding_Z3.ask (filter_assertions settings.query_env settings.query_hint) settings.query_all_labels uu____1405 FStar_Pervasives_Native.None (fun r -> (FStar_ST.op_Colon_Equals res (FStar_Pervasives_Native.Some (r))))));
(

let uu____1442 = (FStar_ST.op_Bang res)
in (FStar_Option.get uu____1442));
)))
in (FStar_SMTEncoding_ErrorReporting.detail_errors true settings.query_env settings.query_all_labels ask_z3))
end)
end
| uu____1477 -> begin
()
end))
end))


let find_localized_errors : errors Prims.list  ->  errors FStar_Pervasives_Native.option = (fun errs -> (FStar_All.pipe_right errs (FStar_List.tryFind (fun err1 -> (match (err1.error_messages) with
| [] -> begin
false
end
| uu____1498 -> begin
true
end)))))


let has_localized_errors : errors Prims.list  ->  Prims.bool = (fun errs -> (

let uu____1513 = (find_localized_errors errs)
in (FStar_Option.isSome uu____1513)))


let report_errors : query_settings  ->  Prims.unit = (fun settings -> (

let uu____1520 = ((FStar_Options.detail_errors ()) && (

let uu____1522 = (FStar_Options.n_cores ())
in (Prims.op_Equality uu____1522 (Prims.parse_int "1"))))
in (match (uu____1520) with
| true -> begin
(

let initial_fuel1 = (

let uu___89_1524 = settings
in (

let uu____1525 = (FStar_Options.initial_fuel ())
in (

let uu____1526 = (FStar_Options.initial_ifuel ())
in {query_env = uu___89_1524.query_env; query_decl = uu___89_1524.query_decl; query_name = uu___89_1524.query_name; query_index = uu___89_1524.query_index; query_range = uu___89_1524.query_range; query_fuel = uu____1525; query_ifuel = uu____1526; query_rlimit = uu___89_1524.query_rlimit; query_hint = FStar_Pervasives_Native.None; query_errors = uu___89_1524.query_errors; query_all_labels = uu___89_1524.query_all_labels; query_suffix = uu___89_1524.query_suffix})))
in (

let ask_z3 = (fun label_assumptions -> (

let res = (FStar_Util.mk_ref FStar_Pervasives_Native.None)
in ((

let uu____1545 = (with_fuel_and_diagnostics initial_fuel1 label_assumptions)
in (FStar_SMTEncoding_Z3.ask (filter_facts_without_core settings.query_env) settings.query_all_labels uu____1545 FStar_Pervasives_Native.None (fun r -> (FStar_ST.op_Colon_Equals res (FStar_Pervasives_Native.Some (r))))));
(

let uu____1582 = (FStar_ST.op_Bang res)
in (FStar_Option.get uu____1582));
)))
in (FStar_SMTEncoding_ErrorReporting.detail_errors false settings.query_env settings.query_all_labels ask_z3)))
end
| uu____1617 -> begin
(

let uu____1618 = (find_localized_errors settings.query_errors)
in (match (uu____1618) with
| FStar_Pervasives_Native.Some (err1) -> begin
((FStar_All.pipe_right settings.query_errors (FStar_List.iter (fun e -> (

let uu____1628 = (

let uu____1629 = (error_to_short_string e)
in (Prims.strcat "SMT solver says: " uu____1629))
in (FStar_Errors.diag settings.query_range uu____1628)))));
(FStar_TypeChecker_Err.add_errors settings.query_env err1.error_messages);
)
end
| FStar_Pervasives_Native.None -> begin
(

let err_detail = (

let uu____1631 = (FStar_All.pipe_right settings.query_errors (FStar_List.map (fun e -> (

let uu____1641 = (error_to_short_string e)
in (Prims.strcat "SMT solver says: " uu____1641)))))
in (FStar_All.pipe_right uu____1631 (FStar_String.concat "; ")))
in (

let uu____1644 = (

let uu____1651 = (

let uu____1656 = (FStar_Util.format1 "Unknown assertion failed (%s)" err_detail)
in ((uu____1656), (settings.query_range)))
in (uu____1651)::[])
in (FStar_TypeChecker_Err.add_errors settings.query_env uu____1644)))
end))
end)))


let query_info : query_settings  ->  (FStar_SMTEncoding_Z3.z3status * Prims.int * Prims.string FStar_Util.smap)  ->  Prims.unit = (fun settings z3result -> (

let uu____1689 = ((FStar_Options.hint_info ()) || (FStar_Options.print_z3_statistics ()))
in (match (uu____1689) with
| true -> begin
(

let uu____1690 = z3result
in (match (uu____1690) with
| (z3status, elapsed_time, statistics) -> begin
(

let uu____1706 = (FStar_SMTEncoding_Z3.status_string_and_errors z3status)
in (match (uu____1706) with
| (status_string, errs) -> begin
(

let tag = (match (z3status) with
| FStar_SMTEncoding_Z3.UNSAT (uu____1714) -> begin
"succeeded"
end
| uu____1715 -> begin
(Prims.strcat "failed {reason-unknown=" (Prims.strcat status_string "}"))
end)
in (

let range = (

let uu____1717 = (

let uu____1718 = (FStar_Range.string_of_range settings.query_range)
in (

let uu____1719 = (

let uu____1720 = (FStar_SMTEncoding_Z3.at_log_file ())
in (Prims.strcat uu____1720 ")"))
in (Prims.strcat uu____1718 uu____1719)))
in (Prims.strcat "(" uu____1717))
in (

let used_hint_tag = (match ((used_hint settings)) with
| true -> begin
" (with hint)"
end
| uu____1722 -> begin
""
end)
in (

let stats = (

let uu____1724 = (FStar_Options.print_z3_statistics ())
in (match (uu____1724) with
| true -> begin
(

let f = (fun k v1 a -> (Prims.strcat a (Prims.strcat k (Prims.strcat "=" (Prims.strcat v1 " ")))))
in (

let str = (FStar_Util.smap_fold statistics f "statistics={")
in (

let uu____1736 = (FStar_Util.substring str (Prims.parse_int "0") ((FStar_String.length str) - (Prims.parse_int "1")))
in (Prims.strcat uu____1736 "}"))))
end
| uu____1737 -> begin
""
end))
in ((

let uu____1739 = (

let uu____1742 = (

let uu____1745 = (

let uu____1748 = (FStar_Util.string_of_int settings.query_index)
in (

let uu____1749 = (

let uu____1752 = (

let uu____1755 = (

let uu____1758 = (FStar_Util.string_of_int elapsed_time)
in (

let uu____1759 = (

let uu____1762 = (FStar_Util.string_of_int settings.query_fuel)
in (

let uu____1763 = (

let uu____1766 = (FStar_Util.string_of_int settings.query_ifuel)
in (

let uu____1767 = (

let uu____1770 = (FStar_Util.string_of_int settings.query_rlimit)
in (uu____1770)::(stats)::[])
in (uu____1766)::uu____1767))
in (uu____1762)::uu____1763))
in (uu____1758)::uu____1759))
in (used_hint_tag)::uu____1755)
in (tag)::uu____1752)
in (uu____1748)::uu____1749))
in (settings.query_name)::uu____1745)
in (range)::uu____1742)
in (FStar_Util.print "%s\tQuery-stats (%s, %s)\t%s%s in %s milliseconds with fuel %s and ifuel %s and rlimit %s %s\n" uu____1739));
(FStar_All.pipe_right errs (FStar_List.iter (fun uu____1784 -> (match (uu____1784) with
| (uu____1791, msg, range1) -> begin
(

let e = (FStar_Errors.mk_issue FStar_Errors.EInfo (FStar_Pervasives_Native.Some (range1)) msg)
in (

let tag1 = (match ((used_hint settings)) with
| true -> begin
"(Hint-replay failed): "
end
| uu____1796 -> begin
""
end)
in (

let uu____1797 = (FStar_Errors.format_issue e)
in (FStar_Util.print2 "\t\t%s%s\n" tag1 uu____1797))))
end))));
)))))
end))
end))
end
| uu____1798 -> begin
()
end)))


let record_hint : 'Auu____1807 'Auu____1808 . query_settings  ->  (FStar_SMTEncoding_Z3.z3status * 'Auu____1808 * 'Auu____1807)  ->  Prims.unit = (fun settings z3result -> (

let uu____1829 = (

let uu____1830 = (FStar_Options.record_hints ())
in (not (uu____1830)))
in (match (uu____1829) with
| true -> begin
()
end
| uu____1831 -> begin
(

let uu____1832 = z3result
in (match (uu____1832) with
| (z3status, uu____1840, uu____1841) -> begin
(

let mk_hint = (fun core -> {FStar_Util.hint_name = settings.query_name; FStar_Util.hint_index = settings.query_index; FStar_Util.fuel = settings.query_fuel; FStar_Util.ifuel = settings.query_ifuel; FStar_Util.unsat_core = core; FStar_Util.query_elapsed_time = (Prims.parse_int "0")})
in (

let store_hint = (fun hint -> (

let uu____1858 = (FStar_ST.op_Bang recorded_hints)
in (match (uu____1858) with
| FStar_Pervasives_Native.Some (l) -> begin
(FStar_ST.op_Colon_Equals recorded_hints (FStar_Pervasives_Native.Some ((FStar_List.append l ((FStar_Pervasives_Native.Some (hint))::[])))))
end
| uu____1908 -> begin
()
end)))
in (match (z3status) with
| FStar_SMTEncoding_Z3.UNSAT (unsat_core) -> begin
(match ((used_hint settings)) with
| true -> begin
(store_hint (mk_hint settings.query_hint))
end
| uu____1915 -> begin
(store_hint (mk_hint unsat_core))
end)
end
| uu____1916 -> begin
()
end)))
end))
end)))


let process_result : query_settings  ->  (FStar_SMTEncoding_Z3.z3status * Prims.int * Prims.string FStar_Util.smap)  ->  errors FStar_Pervasives_Native.option = (fun settings result -> ((

let uu____1946 = ((used_hint settings) && (

let uu____1948 = (FStar_Options.z3_refresh ())
in (not (uu____1948))))
in (match (uu____1946) with
| true -> begin
(FStar_SMTEncoding_Z3.refresh ())
end
| uu____1949 -> begin
()
end));
(

let errs = (query_errors settings result)
in ((query_info settings result);
(record_hint settings result);
(detail_hint_replay settings result);
errs;
));
))


let fold_queries : query_settings Prims.list  ->  (query_settings  ->  (FStar_SMTEncoding_Z3.z3result  ->  Prims.unit)  ->  Prims.unit)  ->  (query_settings  ->  FStar_SMTEncoding_Z3.z3result  ->  errors FStar_Pervasives_Native.option)  ->  (errors Prims.list  ->  Prims.unit)  ->  Prims.unit = (fun qs ask1 f report1 -> (

let rec aux = (fun acc qs1 -> (match (qs1) with
| [] -> begin
(report1 acc)
end
| (q)::qs2 -> begin
(ask1 q (fun res -> (

let uu____2044 = (f q res)
in (match (uu____2044) with
| FStar_Pervasives_Native.None -> begin
()
end
| FStar_Pervasives_Native.Some (errs) -> begin
(aux ((errs)::acc) qs2)
end))))
end))
in (aux [] qs)))


let ask_and_report_errors : FStar_TypeChecker_Env.env  ->  FStar_SMTEncoding_Term.error_labels  ->  FStar_SMTEncoding_Term.decl Prims.list  ->  FStar_SMTEncoding_Term.decl  ->  FStar_SMTEncoding_Term.decl Prims.list  ->  Prims.unit = (fun env all_labels prefix1 query suffix -> ((FStar_SMTEncoding_Z3.giveZ3 prefix1);
(

let default_settings = (

let uu____2078 = (match (env.FStar_TypeChecker_Env.qname_and_index) with
| FStar_Pervasives_Native.None -> begin
(failwith "No query name set!")
end
| FStar_Pervasives_Native.Some (q, n1) -> begin
(((FStar_Ident.text_of_lid q)), (n1))
end)
in (match (uu____2078) with
| (qname, index1) -> begin
(

let rlimit = (

let uu____2104 = (FStar_Options.z3_rlimit_factor ())
in (

let uu____2105 = (

let uu____2106 = (FStar_Options.z3_rlimit ())
in (uu____2106 * (Prims.parse_int "544656")))
in (uu____2104 * uu____2105)))
in (

let uu____2107 = (FStar_TypeChecker_Env.get_range env)
in (

let uu____2108 = (FStar_Options.initial_fuel ())
in (

let uu____2109 = (FStar_Options.initial_ifuel ())
in {query_env = env; query_decl = query; query_name = qname; query_index = index1; query_range = uu____2107; query_fuel = uu____2108; query_ifuel = uu____2109; query_rlimit = rlimit; query_hint = FStar_Pervasives_Native.None; query_errors = []; query_all_labels = all_labels; query_suffix = suffix}))))
end))
in (

let use_hints_setting = (

let uu____2115 = (next_hint default_settings)
in (match (uu____2115) with
| FStar_Pervasives_Native.Some ({FStar_Util.hint_name = uu____2120; FStar_Util.hint_index = uu____2121; FStar_Util.fuel = i; FStar_Util.ifuel = j; FStar_Util.unsat_core = FStar_Pervasives_Native.Some (core); FStar_Util.query_elapsed_time = uu____2125}) -> begin
((

let uu___90_2131 = default_settings
in {query_env = uu___90_2131.query_env; query_decl = uu___90_2131.query_decl; query_name = uu___90_2131.query_name; query_index = uu___90_2131.query_index; query_range = uu___90_2131.query_range; query_fuel = i; query_ifuel = j; query_rlimit = uu___90_2131.query_rlimit; query_hint = FStar_Pervasives_Native.Some (core); query_errors = uu___90_2131.query_errors; query_all_labels = uu___90_2131.query_all_labels; query_suffix = uu___90_2131.query_suffix}))::[]
end
| uu____2134 -> begin
[]
end))
in (

let initial_fuel_max_ifuel = (

let uu____2140 = (

let uu____2141 = (FStar_Options.max_ifuel ())
in (

let uu____2142 = (FStar_Options.initial_ifuel ())
in (uu____2141 > uu____2142)))
in (match (uu____2140) with
| true -> begin
(

let uu____2145 = (

let uu___91_2146 = default_settings
in (

let uu____2147 = (FStar_Options.max_ifuel ())
in {query_env = uu___91_2146.query_env; query_decl = uu___91_2146.query_decl; query_name = uu___91_2146.query_name; query_index = uu___91_2146.query_index; query_range = uu___91_2146.query_range; query_fuel = uu___91_2146.query_fuel; query_ifuel = uu____2147; query_rlimit = uu___91_2146.query_rlimit; query_hint = uu___91_2146.query_hint; query_errors = uu___91_2146.query_errors; query_all_labels = uu___91_2146.query_all_labels; query_suffix = uu___91_2146.query_suffix}))
in (uu____2145)::[])
end
| uu____2148 -> begin
[]
end))
in (

let half_max_fuel_max_ifuel = (

let uu____2152 = (

let uu____2153 = (

let uu____2154 = (FStar_Options.max_fuel ())
in (uu____2154 / (Prims.parse_int "2")))
in (

let uu____2161 = (FStar_Options.initial_fuel ())
in (uu____2153 > uu____2161)))
in (match (uu____2152) with
| true -> begin
(

let uu____2164 = (

let uu___92_2165 = default_settings
in (

let uu____2166 = (

let uu____2167 = (FStar_Options.max_fuel ())
in (uu____2167 / (Prims.parse_int "2")))
in (

let uu____2174 = (FStar_Options.max_ifuel ())
in {query_env = uu___92_2165.query_env; query_decl = uu___92_2165.query_decl; query_name = uu___92_2165.query_name; query_index = uu___92_2165.query_index; query_range = uu___92_2165.query_range; query_fuel = uu____2166; query_ifuel = uu____2174; query_rlimit = uu___92_2165.query_rlimit; query_hint = uu___92_2165.query_hint; query_errors = uu___92_2165.query_errors; query_all_labels = uu___92_2165.query_all_labels; query_suffix = uu___92_2165.query_suffix})))
in (uu____2164)::[])
end
| uu____2175 -> begin
[]
end))
in (

let max_fuel_max_ifuel = (

let uu____2179 = ((

let uu____2184 = (FStar_Options.max_fuel ())
in (

let uu____2185 = (FStar_Options.initial_fuel ())
in (uu____2184 > uu____2185))) && (

let uu____2188 = (FStar_Options.max_ifuel ())
in (

let uu____2189 = (FStar_Options.initial_ifuel ())
in (uu____2188 >= uu____2189))))
in (match (uu____2179) with
| true -> begin
(

let uu____2192 = (

let uu___93_2193 = default_settings
in (

let uu____2194 = (FStar_Options.max_fuel ())
in (

let uu____2195 = (FStar_Options.max_ifuel ())
in {query_env = uu___93_2193.query_env; query_decl = uu___93_2193.query_decl; query_name = uu___93_2193.query_name; query_index = uu___93_2193.query_index; query_range = uu___93_2193.query_range; query_fuel = uu____2194; query_ifuel = uu____2195; query_rlimit = uu___93_2193.query_rlimit; query_hint = uu___93_2193.query_hint; query_errors = uu___93_2193.query_errors; query_all_labels = uu___93_2193.query_all_labels; query_suffix = uu___93_2193.query_suffix})))
in (uu____2192)::[])
end
| uu____2196 -> begin
[]
end))
in (

let min_fuel1 = (

let uu____2200 = (

let uu____2201 = (FStar_Options.min_fuel ())
in (

let uu____2202 = (FStar_Options.initial_fuel ())
in (uu____2201 < uu____2202)))
in (match (uu____2200) with
| true -> begin
(

let uu____2205 = (

let uu___94_2206 = default_settings
in (

let uu____2207 = (FStar_Options.min_fuel ())
in {query_env = uu___94_2206.query_env; query_decl = uu___94_2206.query_decl; query_name = uu___94_2206.query_name; query_index = uu___94_2206.query_index; query_range = uu___94_2206.query_range; query_fuel = uu____2207; query_ifuel = (Prims.parse_int "1"); query_rlimit = uu___94_2206.query_rlimit; query_hint = uu___94_2206.query_hint; query_errors = uu___94_2206.query_errors; query_all_labels = uu___94_2206.query_all_labels; query_suffix = uu___94_2206.query_suffix}))
in (uu____2205)::[])
end
| uu____2208 -> begin
[]
end))
in (

let all_configs = (FStar_List.append use_hints_setting (FStar_List.append ((default_settings)::[]) (FStar_List.append initial_fuel_max_ifuel (FStar_List.append half_max_fuel_max_ifuel max_fuel_max_ifuel))))
in (

let check_one_config = (fun config k -> ((

let uu____2225 = ((used_hint config) || (FStar_Options.z3_refresh ()))
in (match (uu____2225) with
| true -> begin
(FStar_SMTEncoding_Z3.refresh ())
end
| uu____2226 -> begin
()
end));
(

let uu____2227 = (with_fuel_and_diagnostics config [])
in (

let uu____2230 = (

let uu____2233 = (FStar_SMTEncoding_Z3.mk_fresh_scope ())
in FStar_Pervasives_Native.Some (uu____2233))
in (FStar_SMTEncoding_Z3.ask (filter_assertions config.query_env config.query_hint) config.query_all_labels uu____2227 uu____2230 k)));
))
in (

let check_all_configs = (fun configs -> (

let report1 = (fun errs -> (report_errors (

let uu___95_2252 = default_settings
in {query_env = uu___95_2252.query_env; query_decl = uu___95_2252.query_decl; query_name = uu___95_2252.query_name; query_index = uu___95_2252.query_index; query_range = uu___95_2252.query_range; query_fuel = uu___95_2252.query_fuel; query_ifuel = uu___95_2252.query_ifuel; query_rlimit = uu___95_2252.query_rlimit; query_hint = uu___95_2252.query_hint; query_errors = errs; query_all_labels = uu___95_2252.query_all_labels; query_suffix = uu___95_2252.query_suffix})))
in (fold_queries configs check_one_config process_result report1)))
in (

let uu____2253 = (

let uu____2260 = (FStar_Options.admit_smt_queries ())
in (

let uu____2261 = (FStar_Options.admit_except ())
in ((uu____2260), (uu____2261))))
in (match (uu____2253) with
| (true, uu____2266) -> begin
()
end
| (false, FStar_Pervasives_Native.None) -> begin
(check_all_configs all_configs)
end
| (false, FStar_Pervasives_Native.Some (id)) -> begin
(

let skip = (match ((FStar_Util.starts_with id "(")) with
| true -> begin
(

let full_query_id = (

let uu____2278 = (

let uu____2279 = (

let uu____2280 = (

let uu____2281 = (FStar_Util.string_of_int default_settings.query_index)
in (Prims.strcat uu____2281 ")"))
in (Prims.strcat ", " uu____2280))
in (Prims.strcat default_settings.query_name uu____2279))
in (Prims.strcat "(" uu____2278))
in (Prims.op_disEquality full_query_id id))
end
| uu____2282 -> begin
(Prims.op_disEquality default_settings.query_name id)
end)
in (match ((not (skip))) with
| true -> begin
(check_all_configs all_configs)
end
| uu____2283 -> begin
()
end))
end)))))))))));
))


let solve : (Prims.unit  ->  Prims.string) FStar_Pervasives_Native.option  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.term  ->  Prims.unit = (fun use_env_msg tcenv q -> ((

let uu____2306 = (

let uu____2307 = (

let uu____2308 = (FStar_TypeChecker_Env.get_range tcenv)
in (FStar_All.pipe_left FStar_Range.string_of_range uu____2308))
in (FStar_Util.format1 "Starting query at %s" uu____2307))
in (FStar_SMTEncoding_Encode.push uu____2306));
(

let tcenv1 = (FStar_TypeChecker_Env.incr_query_index tcenv)
in (

let uu____2310 = (FStar_SMTEncoding_Encode.encode_query use_env_msg tcenv1 q)
in (match (uu____2310) with
| (prefix1, labels, qry, suffix) -> begin
(

let pop1 = (fun uu____2344 -> (

let uu____2345 = (

let uu____2346 = (

let uu____2347 = (FStar_TypeChecker_Env.get_range tcenv1)
in (FStar_All.pipe_left FStar_Range.string_of_range uu____2347))
in (FStar_Util.format1 "Ending query at %s" uu____2346))
in (FStar_SMTEncoding_Encode.pop uu____2345)))
in (match (qry) with
| FStar_SMTEncoding_Term.Assume ({FStar_SMTEncoding_Term.assumption_term = {FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.FalseOp, uu____2348); FStar_SMTEncoding_Term.freevars = uu____2349; FStar_SMTEncoding_Term.rng = uu____2350}; FStar_SMTEncoding_Term.assumption_caption = uu____2351; FStar_SMTEncoding_Term.assumption_name = uu____2352; FStar_SMTEncoding_Term.assumption_fact_ids = uu____2353}) -> begin
(pop1 ())
end
| uu____2368 when tcenv1.FStar_TypeChecker_Env.admit -> begin
(pop1 ())
end
| FStar_SMTEncoding_Term.Assume (uu____2369) -> begin
((ask_and_report_errors tcenv1 labels prefix1 qry suffix);
(pop1 ());
)
end
| uu____2371 -> begin
(failwith "Impossible")
end))
end)));
))


let solver : FStar_TypeChecker_Env.solver_t = {FStar_TypeChecker_Env.init = FStar_SMTEncoding_Encode.init; FStar_TypeChecker_Env.push = FStar_SMTEncoding_Encode.push; FStar_TypeChecker_Env.pop = FStar_SMTEncoding_Encode.pop; FStar_TypeChecker_Env.mark = FStar_SMTEncoding_Encode.mark; FStar_TypeChecker_Env.reset_mark = FStar_SMTEncoding_Encode.reset_mark; FStar_TypeChecker_Env.commit_mark = FStar_SMTEncoding_Encode.commit_mark; FStar_TypeChecker_Env.encode_modul = FStar_SMTEncoding_Encode.encode_modul; FStar_TypeChecker_Env.encode_sig = FStar_SMTEncoding_Encode.encode_sig; FStar_TypeChecker_Env.preprocess = (fun e g -> (

let uu____2377 = (

let uu____2384 = (FStar_Options.peek ())
in ((e), (g), (uu____2384)))
in (uu____2377)::[])); FStar_TypeChecker_Env.solve = solve; FStar_TypeChecker_Env.is_trivial = FStar_SMTEncoding_Encode.is_trivial; FStar_TypeChecker_Env.finish = FStar_SMTEncoding_Z3.finish; FStar_TypeChecker_Env.refresh = FStar_SMTEncoding_Z3.refresh}


let dummy : FStar_TypeChecker_Env.solver_t = {FStar_TypeChecker_Env.init = (fun uu____2399 -> ()); FStar_TypeChecker_Env.push = (fun uu____2401 -> ()); FStar_TypeChecker_Env.pop = (fun uu____2403 -> ()); FStar_TypeChecker_Env.mark = (fun uu____2405 -> ()); FStar_TypeChecker_Env.reset_mark = (fun uu____2407 -> ()); FStar_TypeChecker_Env.commit_mark = (fun uu____2409 -> ()); FStar_TypeChecker_Env.encode_modul = (fun uu____2412 uu____2413 -> ()); FStar_TypeChecker_Env.encode_sig = (fun uu____2416 uu____2417 -> ()); FStar_TypeChecker_Env.preprocess = (fun e g -> (

let uu____2423 = (

let uu____2430 = (FStar_Options.peek ())
in ((e), (g), (uu____2430)))
in (uu____2423)::[])); FStar_TypeChecker_Env.solve = (fun uu____2446 uu____2447 uu____2448 -> ()); FStar_TypeChecker_Env.is_trivial = (fun uu____2455 uu____2456 -> false); FStar_TypeChecker_Env.finish = (fun uu____2458 -> ()); FStar_TypeChecker_Env.refresh = (fun uu____2460 -> ())}




