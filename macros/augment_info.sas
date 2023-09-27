%macro augment_info;
/*
<member>_DATAIN, _FUNS, _INFO, _INIT, _VGRPS, _VIN_GRPS, _VOUT
*/

data _hrsinfo_libin_all;
 set  &fcmp_member._DATAIN(keep = year datain datain_blank);
 length datain $ 20;
 label datain_exist = "";
 hrs_libin ="&hrs_libin";
 dtref = strip(hrs_libin)||"."|| strip(datain);
 if strip(datain) = "" then dtref  = ""; 
 datain_exist = data_exist(dtref);
 skipit = " ";
 if datain_exist = 0 then skipit = "Y";
   drop dtref;
run;

data _hrsinfo_libin;
  set _hrsinfo_libin_all;
  if skipit ="Y" then delete;
  drop skipit;
run;

data _hrsinfo_vgrps (keep = vgrp ctype cnt_vout vout_nms);
  set &fcmp_member._VGRPS;
  sel_vgrps =  bind_vgrps("&vgrps"); 
  cnt_vgrps  = countw(sel_vgrps);
  keep_grp = 0;
  do i =1 to cnt_vgrps;  /* loop over selected vgrps */
    grpi = scan(sel_vgrps, i, " ");
    if upcase(vgrp) = upcase(grpi) then keep_grp +1 ;
  end;
  if keep_grp;
run;

data _hrsinfo_vout(keep = vgrp vout_nm ctype len ctypelen vout_lbl);
  set _hrsinfo_vgrps;
  length ctypelen $6;
  do i = 1 to cnt_vout;
   vout_nm = scan(vout_nms, i, " ");
   len = vout_length(vout_nm); /* Variable length */
   ctypelen = strip(ctype) ||strip(len);
   if strip(ctypelen) ="." then ctypelen = " ";
   vout_lbl = vout_label(vout_nm);
   output;
  end;
run;




ods html file="x.html";
proc print data = &fcmp_member._VGRPS;
run;

proc print data = _hrsinfo_vout;
run;


ods html close;



%mend augment_info;
