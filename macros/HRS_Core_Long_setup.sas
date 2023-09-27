
%macro HRS_Core_Long_setup;

/* Path to FCMP member folder */   
%let _fcmp_member_path = %sysfunc(pathname(hrs_fcmp))\&fcmp_member.-FCMP;
%put _fcmp_member_path =;

libname _clib "&_fcmp_member_path\cmplib";

/* FCMP library for selected fcmp member is loaded */
options cmplib = _clib.&fcmp_member;

libname _cinfo  "&_fcmp_member_path\info";

/* Copy <fcmp_member>_info SAS datsets --*/

proc copy in=_cinfo out=work memtype=data;
   select &fcmp_member._:;
run;

%mend  HRS_Core_Long_setup;
