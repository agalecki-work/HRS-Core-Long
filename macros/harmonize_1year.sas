%macro harmonize_1year;

data _year_outdata; 
  set &hrs_datalib..&datain(keep = pn hhid &vin_nms_all);
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
