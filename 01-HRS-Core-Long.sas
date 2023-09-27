
options nocenter mprint nodate;

/*--- Provide path to HRS-Core-Long (current) folder ---*/

%let HRS_Core_Long_path = .;   

filename _setup "&HRS_Core_Long_path\_setup.sas";
%include _setup;



%macro HRS_Core_Long(
    HRS_libin =,
    HRS_yrs = 1992-2030, 
    vgrps = ?,
    HRS_fcmp =


%mend  HRS_Core_Long;

%HRS_Core_Long(
