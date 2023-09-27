options nocenter mprint nodate;

/*--- Provide path to HRS-Core-Long (current) folder ---*/

%let HRS_Core_Long_path = .; 

/* --- Define SAS library with input data ---*/

libname libin "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";

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
%include _macros(HRS_Core_Long_setup, augment_years);
%HRS_Core_Long_setup;


%augment_years(HRS_yrs); /* Dataset _hrsyears is created */

/* Add info to SAS info datasets */
%include _macros(augment_info);
%augment_info;


%mend HRS_Core_Long;

%HRS_Core_Long(
    HRS_libin = libin,       /* libref for SAS library */
    HRS_yrs = 1992-2020,
    HRS_FCMP = hrs_fcmp,     /* fileref to HRS_FCMP folder */
    FCMP_member = DLfunction
)


    
    

endsas;

