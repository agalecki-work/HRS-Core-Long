%macro array_stmnt2(year, _vgrp, vout, vin);
%local i vin_cnt vgrpnm grp_type vin2;
/* call this macro from inside DATA step */
%let vgrpnm = %sysfunc(compress(&_vgrp,'$'));
%let grp_type =  %sysfunc(findc(&_vgrp,'$'));
%let ctype = $;
%if %eval(&grp_type) =0 %then %let ctype =;
%put ==>: array_stmnt year :=&year, var_grp := &_vgrp, ctype := &ctype;
%put > var_in := &vin;
%put > var_out := &vout;
%let vin_cnt=%sysfunc(countw(&vin));
%*put vin_cnt := &vin_cnt;

%let vout_cnt=%sysfunc(countw(&vout));

array &vgrpnm._vin {&vin_cnt} &ctype  _temporary_; 
%do i =1 %to &vin_cnt; /* Populate temp array */
  &vgrpnm._vin[&i] = %scan(&vin, &i, ' ');
%end;

%if &ctype = $ %then 
  %do;
      %* put --- &vgrp (character) processed ---- ;
      &vout = exec_vgrpc(&year, "&_vgrp", &vgrpnm._vin);
  %end;
%else
  %do;  
      %*put --- &vgrp (numeric) processed ---- ;
       array &vgrpnm._vout {&vout_cnt} &vout;
       call exec_vgrpx(&year, "&_vgrp", &vgrpnm._vout, &vgrpnm._vin);  
  %end;

%mend array_stmnt2; 
