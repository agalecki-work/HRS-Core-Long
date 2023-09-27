%macro create_data_template;
/* Create macro variables */
proc sql noprint;
 select year     into :hrsyears_list separated by  " "  from  _hrsinfo_libin;
 select count(*) into :cnt_hrsyears                     from _hrsinfo_libin;
 select vgrp     into :vgrp_list     separated by "~"   from _hrsinfo_vgrps;
 select count(*) into :cnt_vgrps                        from _hrsinfo_vgrps;
 select vout_nm  into :vout_list     separated by " "   from _hrsinfo_vout;
 select count(*) into :cnt_vout                         from _hrsinfo_vout;
 select vout_lbl into :lbl_list      separated by "~"   from _hrsinfo_vout;
 select ctype    into :ctype_list    separated by "~"   from _hrsinfo_vout;
quit;

%put List of hrs years       := &hrsyears_list;
%put # of hrs years          := &cnt_hrsyears;
 
%put List of var groups      := &vgrp_list;
%put # of var groups         := &cnt_vgrps;

%put List of harmonized vars := &vout_list;
%put # of harmonized vars    := &cnt_vout;
%put -- List of var labels separated with tilda (~) is stored in `lbl_list` macro var;
%put List of ctype variable  := &ctype_list;
data _tmp;
  set  _hrsinfo_vout;
  if strip(ctypelen) ne '';
run;

*proc print data=_tmp;
run;

%let ctypelen_list =;
proc sql noprint;
 select count(*)  into :cnt_ctypelen                    from _tmp;
 select ctypelen  into :ctypelen_list separated by "~"  from _tmp;
 select vout_nm   into :ctypelen_nms  separated by " "  from _tmp;
quit;

%put # of vars with non blank length := &cnt_ctypelen; 
%put List of ctypelen values := &ctypelen_list;


/*--  STEP0: initialize `_harmonized_out` data */
data _harmonized_base; *  (label ="&fcmp_label.. FCMP member `&fcmp_member` compiled on &fcmp_datestamp.");
 label hhid         = "HOUSEHOLD IDENTIFIER"
      pn            = "PERSON NUMBER"
      studyyr       = "STUDY YEAR";

 /*-- Label statements ---*/
 %do i=1 %to &cnt_vout; 
   %let vnm = %scan(&vout_list, &i);   
   %let vlbl= %scan(&lbl_list, &i, ~);
   %*put vnm := &vnm;
   label &vnm = "&vlbl";
 %end;    
 
 /*-- Length statements ---*/      
 length hhid $6 pn $3;
  %if %eval(&cnt_ctypelen) > 0 %then 
    %do i= 1 %to &cnt_ctypelen;
     %let vnm = %scan(&ctypelen_nms, &i);  
     %let ctp = %scan(&ctypelen_list, &i, ~);
     length &vnm &ctp;
    %end;
 
  call missing(of _all_);
  stop;
;
run;
%mend create_data_template;

