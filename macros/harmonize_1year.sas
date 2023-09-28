%macro harmonize_1year(year);
/* Macro invoked by `harmonize_main_loop` macro */
/* Requires macro variable `year` */

/* Auxiliary dataset with info pertaining to a given year */

data tmp1z;
   set xprod_yr_by_vgrps;
   if year = &year;
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
  select datain   into :datain  from _hrsinfo_libin where year = &year;   /* datain */
  select vin_nms  into :vin_nms_grpd  separated by "~"  from tmp1z;
  select vinz_nms into :vinz_nms_grpd separated by "~"  from tmp1z;
  select vout_nms into :vout_nms_grpd separated by "~"  from tmp1z;
  select distinct vin_nms into :vin_nms_all separated by " "  from tmp1a;
  select count(*) into :cnt_vout                              from _hrsinfo_vout;
  select vout_nm  into :vout_list  separated by " "  from    _hrsinfo_vout;
  select ctype    into :ctype_list  separated by "~"  from   _hrsinfo_vout;
  select count(*) into :cnt_vgrps  from  _hrsinfo_vgrps;
  select vgrp     into :vgrp_list  separated by "~"  from  _hrsinfo_vgrps;


 quit;
 
 %put === Macro vars used to execute macro `harmonize_1year` ====;
 %put year                    := &yearx;
 %put # of var groups         := &cnt_vgrps;
 %put List of var groups      := &vgrp_list;
 %put # of harmonized vars    := &cnt_vout;
 %put List of grouped harmonized vars := &vout_nms_grpd;
 %put datain                  := &datain;
 %put vin_nms_grpd            := &vin_nms_grpd; 
 %put vinz_nms_grpd           := &vinz_nms_grpd; /* Will be used to declare arrays of variables */
 %put vin_nms_all            := &vin_nms_all;
 

data _year_outdata; 
  set &hrs_libin..&datain(keep = pn hhid &vin_nms_all);
  missing O D R I N Z;
  _CHARZZZ_= ""; /*  Artificial variable */
  _ZZZ_ =.;
  studyyr =&year;
  
   /*-- set initial values to missing ---*/
   %do i=1 %to &cnt_vout; 
     %let vnm = %scan(&vout_list, &i);   
     %let ctype= %scan(&ctype_list, &i, ~);
     %*put ctype := &;
     &vnm =
     %if &ctype =$ %then "?"; %else .Z;;
   %end;    
   %do i =1 %to &cnt_vgrps;
     %let _vgrp = %scan(&vgrp_list, &i,'~'); 
     %let vinz = %scan(&vinz_nms_grpd, &i, '~');
     %let vout = %scan(&vout_nms_grpd, &i,  '~');
     %array_stmnt2(&year, &_vgrp, &vout, &vinz);
   %end;
 drop &vin_nms_all;
  drop _CHARZZZ_ _ZZZ_;
run;

proc append base = _harmonized_base
            data = _year_outdata;
run;

* proc print data =  _harmonized_base;
run;

%mend harmonize_1year;
