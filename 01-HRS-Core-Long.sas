/*--- Define SAS library with HRS Core data ---*/

libname hrs_core "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";

libnmame libout "C:\temp";
%let dtout = libout.hrs_long;

/*--- FCMP  */
%let HRS_FCMP_path = C:\Users\agalecki\Documents\GitHub\HRS-FCMP;

%let fcmp_member = DLFUNCTION;

/*--- NO changess below this line ---*/

%let fcmp_member_path = &HRS_FCMP_path\&fcmp_member-FCMP;
filename member "&fcmp_member_path";


options