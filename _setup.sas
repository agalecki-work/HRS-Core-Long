
/*=== NO changes needed in this file ===*/

filename _macros "&HRS_Core_Long_path/macros";
%include _macros(

%let fcmp_member_path = &HRS_FCMP_path\&fcmp_member-FCMP;

libname _clib "&fcmp_member_path\cmplib";

/* FCMP library for selected fcmp member is loaded */
options cmplib = _clib.&fcmp_member;

libname _cinfo  "&fcmp_member_path\info";

/* Copy <fcmp_member>_info SAS datsets --*/

proc copy in=_cinfo out=work memtype=data;
   select &fcmp_member._:;
run;
