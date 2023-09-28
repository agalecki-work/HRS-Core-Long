options nocenter mprint nodate;

/*--- Provide path to HRS-Core-Long (current) folder ---*/

%let HRS_Core_Long_path = .; 

/* --- Define SAS library with input data ---*/

libname libin "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";


/* --- Define SAS library with output data ---*/
libname out_data "C:\temp");

/* Define fileref to HRS_FCMP folder */
filename hrs_fcmp "C:\Users\agalecki\Documents\GitHub\HRS-FCMP";


%macro HRS_Core_Long(
    HRS_libin =,
    HRS_yrs   =, 
    vgrps     = ?,
    HRS_FCMP  =,      /* fileref to HRS_FCMP folder */
    FCMP_member =,
    out =
);

filename _macros "&HRS_Core_Long_path/macros";
%include _macros(HRS_Core_Long_setup, augment_info);
%include _macros(isBlank);
%include _macros(create_data_template);
%include _macros(array_stmnt2, harmonize_1year, harmonize_main_loop);

%HRS_Core_Long_setup;

/* Add info to SAS info datasets */
%include _macros(augment_info);
%augment_info;

/* data `_harmonized_base` with zero rows is created */
%create_data_template;

/* data `_harmonized_base` is appended */

%harmonize_main_loop;
%let nc = %sysfunc(countw("&out", . ));
%let len = %length(&out);

%if %eval(&len) > 0 %then %do;
 %let outlib = %scan(&out,1, '.');
 %let dtnm = %scan(&out,2, '.');
 %if %eval(&nc) = 1 %then %do;
  %let outlib = WORK

%end;

copy in=&hrs_libin out=storm move;
      select hurricane;
run;

%mend HRS_Core_Long;

%HRS_Core_Long(
    HRS_libin = libin,         /* libref for SAS library */
    HRS_yrs = 1992-2020,
    vgrps = subhh$ skip need,
    HRS_FCMP = hrs_fcmp,       /* fileref to HRS_FCMP folder */
    FCMP_member = DLfunction,
    out = outdata.hrs_long 
)

proc print data =_year_outdata;
run;


    
    

* endsas;

