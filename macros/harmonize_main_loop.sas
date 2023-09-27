%macro harmonize_main_loop;
%do iyear = 1 %to &cnt_hrsyears;
 %let year =%scan(&hrsyears_list, &iyear, ' ');
 %put ===>->-> Main loop executed for year &year   ========;
 
  
 /* Auxiliary dataset with info pertaining to a given year */
 data tmp1z;
    set xprod_yr_by_vgrps;
    if year ="&year";
 run;
  
 data tmp1a;
   set tmp1z(keep = vin_nms);
   length vnm $32;
   n = countw(vin_nms);
   if (n>0) then;
    do i=1 to n;
    vnm =scan(vin_nms,i);
    output;
   end;
 run;
 
 proc sql noprint;
  select datain   into :datain  from _datain_skip_info where year = "&year";   /* datain */
  select vin_nms  into :vin_nms_grpd  separated by "~"  from tmp1z;
  select vinz_nms into :vinz_nms_grpd separated by "~"  from tmp1z;
  select vout_nms into :vout_nms_grpd separated by "~"  from tmp1z;
  select distinct vin_nms into :vin_nms_all separated by " "  from tmp1a;
 
 quit;
 
 %put === Macro vars used to execute macro `harmonize_1year` ====;
 %put year                    := &year;
 %put # of var groups         := &cnt_vgrps;
 %put List of var groups      := &vgrp_list;
 %put # of harmonized vars    := &cnt_vout;
 %put List of grouped harmonized vars := &vout_nms_grpd;
 %put datain                  := &datain;
 %put vin_nms_grpd            := &vin_nms_grpd; 
 %put vinz_nms_grpd           := &vinz_nms_grpd; /* Will be used to declare arrays of variables */
 %put vin_nms_all            := &vin_nms_all;
 
 %harmonize_1year;
%end; /* Main loop: iyear */

%mend harmonize_main_loop;

