%macro harmonize_main_loop;
proc sql noprint;
   select year     into :hrsyears_list separated by  " "  from  _hrsinfo_libin;
   select count(*) into :cnt_hrsyears from _hrsinfo_libin;
quit;

%put  `Macro harmonize_main_loop` starts `;
%put  hrsyears_list = &hrsyears_list;


%do iyear = 1 %to &cnt_hrsyears;
 %let year = %scan(&hrsyears_list, &iyear, ' ');
 %put ===>->-> Main loop executed for year :=  &year   ========;
 %harmonize_1year(&year);
%end; /* Main loop: iyear */

%mend harmonize_main_loop;

