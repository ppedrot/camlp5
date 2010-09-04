(* camlp5r *)
(* $Id: pprintf.mli,v 1.6 2010/09/04 08:46:05 deraugla Exp $ *)
(* Copyright (c) INRIA 2007-2010 *)

(** Definitions for pprintf statement.

    This module contains types and functions for the "pprintf" statement
    added by the syntax extension "pa_pprintf.cmo". *)

type pr_context = { ind : int; bef : string; aft : string; dang : string };
   (** Printing context.
    - "ind" : the current indendation
    - "bef" : what should be printed before, in the same line
    - "aft" : what should be printed after, in the same line
    - "dang" : the dangling token to know whether parentheses are necessary *)

type pr_fun 'a = pr_context -> 'a -> string;

value empty_pc : pr_context;
   (** Empty printer context, equal to:
       [{ind = 0; bef = ""; aft = ""; dang = ""}] *)

value sprint_break :
  int -> int -> pr_context -> (pr_context -> string) ->
    (pr_context -> string) -> string;
   (** [sprint_break nspaces offset pc f g] concat the two strings returned
       by [f] and [g], either in one line, if it holds without overflowing
       (see module [Pretty]), with [nspaces] spaces betwen them, or in two
       lines with [offset] spaces added in the indentation for the second
       line.
         This function don't need to be called directly. It is generated by
       the [pprintf] statement according to its parameters when the format
       contains breaks, like [@;] and [@ ]. *)

value sprint_break_all :
  bool -> pr_context -> (pr_context -> string) ->
    list (int * int * pr_context -> string) -> string;
   (** [sprint_break_all force_newlines pc f fl] concat all strings returned
       by the list with separators [f]-[fl], the separators being the number
       of spaces and the offset like in the function [sprint_break]. The
       function works as "all or nothing", i.e. if the resulting string
       does not hold on the line, all strings are printed in different
       lines (even if sub-parts could hold in single lines). If the parameter
       [force_newline] is [True], all strings are printed in different
       lines, no horizontal printing is tested.
         This function don't need to be called directly. It is generated by
       the [pprintf] statement according to its parameters when the format
       contains parenthesized parts with "break all" like "@[<a>" and "@]",
       or "@[<b>" and "@]". *)

#load "pa_macro.cmo";

IFDEF OCAML_1_07 OR COMPATIBLE_WITH_OLD_OCAML THEN
  value with_ind : pr_context -> int -> pr_context;
  value with_ind_bef : pr_context -> int -> string -> pr_context;
  value with_ind_bef_aft :
    pr_context -> int -> string -> string -> pr_context;
  value with_bef : pr_context -> string -> pr_context;
  value with_bef_aft : pr_context -> string -> string -> pr_context;
  value with_bef_aft_dang :
    pr_context -> string -> string -> string -> pr_context;
  value with_bef_dang : pr_context -> string -> string -> pr_context;
  value with_aft : pr_context -> string -> pr_context;
  value with_aft_dang : pr_context -> string -> string -> pr_context;
  value with_dang : pr_context -> string -> pr_context;
END;
