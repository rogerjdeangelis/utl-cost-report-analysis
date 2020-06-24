*****************************************************************************************************************;                                  
*                                                                                                               *;                                  
*; %let pgm=cos_000makefile;                                                                                    *;                                  
*                                                                                                               *;                                  
*  WIN 10 64bit SAS 9.4M6(64bit)  (This code will not run in lockdown?)                                         *;                                  
*                                                                                                               *;                                  
*; %let purpose=Compile and save SAS modules for cos_004rdriver script;                                         *;                                  
*                                                                                                               *;                                  
*  Documentation                                                                                                *;                                  
*  ==============                                                                                               *;                                  
*                                                                                                               *;                                  
*  https://github.com/rogerjdeangelis/utl-cost-report-analysis/blob/master/cst_design.pdf                       *;                                  
*                                                                                                               *;                                  
*  Github repository (sample input, output and code is at)                                                      *;                                  
*                                                                                                               *;                                  
*  https://github.com/rogerjdeangelis/CostReports  (run first or download schema)                               *;                                  
*  https://github.com/rogerjdeangelis/utl-cost-report-analysis (creates schema tables;                          *;                                  
*                                                                                                               *;                                  
*  PROJECT TOKEN = cos                                                                                          *;                                  
*                                                                                                               *;                                  
*  worksheet descriptions                                                                                       *;                                  
*  https://www.costreportdata.com/worksheet_formats.html                                                        *;                                  
*                                                                                                               *;                                  
* INTERNAL MACROS                                                                                               *;                                  
* ===============                                                                                               *;                                  
*                                                                                                               *;                                  
*  cos_NNN - first module in cost report analysis                                                               *;                                  
*                                                                                                               *;                                  
* EXTERNAL MACROS IN AUTOCALL LIBRARY                                                                           *;                                  
* ====================================                                                                          *;                                  
*                                                                                                               *;                                  
*  utlnopts                                                                                                     *;                                  
*  utloptst                                                                                                     *;                                  
*  array                                                                                                        *;                                  
*  do_over                                                                                                      *;                                  
*  varlist                                                                                                      *;                                  
*                                                                                                               *;                                  
* INPUTS (works for all cost reports here is input for SNF)                                                     *;                                  
* =========================================================                                                     *;                                  
*                                                                                                               *;                                  
*   Central fact table You need to download and unzip - self extracting zip file                                *;                                  
*   or run cst_000makefile.sas and cst_005driver.sas                                                            *;                                  
*                                                                                                               *;                                  
*   Google Drive                                                                                                *;                                  
*   cel_cellValue.exe  (cel_cellValue.sas7bdat)                                                                 *;                                  
*   https://drive.google.com/file/d/1mrwYW-hg7y-wyJrV1nE9EPB3ylEcg1Zo/view?usp=sharing                          *;                                  
*                                                                                                               *;                                  
* Outputs from cos_000makefile.sas and cos_005driver.sas                                                        *;                                  
* ======================================================                                                        *;                                  
*                                                                                                               *;                                  
*  Schema tables (create by makefile then driver)                                                               *;                                  
*                                                                                                               *;                                  
*                                                                                                               *;                                  
*    #  Name              File Size                                                                             *;                                  
*                                                                                                               *;                                  
*    1  ADR_ADDRESS            25MB                                                                             *;                                  
*    2  CEL_CELLVALUE          10GB                                                                             *;                                  
*       CEL_CELLVALUE(Index)    1GB                                                                             *;                                  
*    3  COL_DESCRIBE          448KB                                                                             *;                                  
*                                                                                                               *;                                  
*    4  COS_FMTV1A (LOOKUPS)   18MB                                                                             *;                                  
*        RPTKEY2PRVDR                                                                                           *;                                  
*        CEL2LBL                                                                                                *;                                  
*        ZIP2ZCTA                                                                                               *;                                  
*                                                                                                               *;                                  
*    5  RPV_REPORTPROVIDER      5MB                                                                             *;                                  
*    6  TPL_TEMPLATE          832KB                                                                             *;                                  
*    7  ZCT_ZIP2ZCTA            1MB                                                                             *;                                  
*    8  ZIP_DEMOGRAPHICS      115MB                                                                             *;                                  
*                                                                                                               *;                                  
*                                                                                                               *;                                  
* PROCESS                                                                                                       *;                                  
* =======                                                                                                       *;                                  
*                                                                                                               *;                                  
*  Worksheets scraped                                                                                           *;                                  
*  ==================                                                                                           *;                                  
*                                                                                                               *;                                  
* WorkSheet                                                                                                    *;                                   
*                                                                                                               *;                                  
*  S1,S2, S3 CERTIFICATION AND SETTLEMENT SUMMARY                                                               *;                                  
*                                                                                                               *;                                  
*  S41       SNF-BASED HOME HEALTH AGENCY                                                                       *;                                  
*                                                                                                               *;                                  
*  O01       ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS                                                           *;                                  
*                                                                                                               *;                                  
*  S7        PROSPECTIVE PAYMENT FOR SNF STATISTICAL DATA                                                       *;                                  
*  A0        RECLASSIFICATION AND ADJUSTMENT OF TRIAL BALANCE OF EXPENSES                                       *;                                  
*                                                                                                               *;                                  
*  A7        RECONCILIATION OF CAPITAL COSTS CENTERS                                                            *;                                  
*                                                                                                               *;                                  
*  C0        COMPUTATION OF RATIO OF COSTS TO CHARGES                                                           *;                                  
*  O0        ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS  * decided not to output rare?                            *;                                  
*                                                                                                               *;                                  
*  E00A181   CALCULATION OF REIMBURSEMENT SETTLEMENT TITLE XVIII                                                *;                                  
*  E00A192   ANALYSIS OF PAYMENTS TO PROVIDERS FOR SERVICES RENDERED                                            *;                                  
*                                                                                                               *;                                  
*  G0        BALANCE SHEET                                                                                      *;                                  
*  G2        STATEMENT OF PATIENT REVENUES AND OPERATING EXPENSES                                               *;                                  
*  G3        STATEMENT OF REVENUES AND EXPENSES                                                                 *;                                  
*                                                                                                               *;                                  
*****************************************************************************************************************;                                  
*                                                                                                               *;                                  
* CHANGE HISTORY                                                                                                *;                                  
*                                                                                                               *;                                  
*  1. Roger Deangelis              24JUN2019   Creation                                                         *;                                  
*     rogerjdeangelis@gamil.com                                                                                 *;                                  
*                                                                                                               *;                                  
*****************************************************************************************************************;                                  
                                                                                                                                                    
%let gbl_exe   =  %sysfunc(compbl(c:\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work f:\wrk                                    
     -rsasuser -autoexec c:\oto\tut_Oto.sas -nosplash -sasautos &c:\oto -RLANG -config c:\cfg\cfgsas94m6.cfg));                                     
                                                                                                                                                    
/*                                                                                                                                                  
 _                                                                                                                                                  
(_)___ ___ _   _  ___  ___                                                                                                                          
| / __/ __| | | |/ _ \/ __|                                                                                                                         
| \__ \__ \ |_| |  __/\__ \                                                                                                                         
|_|___/___/\__,_|\___||___/                                                                                                                         
                                                                                                                                                    
                                                                                                                                                    
1. There are cel_reportKeys in the overview report csv, snf10_20##_RPT.csv, that are not                                                            
   in the numeric CSVs. Even when the data has been locked, data over 4 years old.                                                                  
                                                                                                                                                    
2, Some of the cel_reportKeys in the overview report csv, snf10_20##_RPT.csv, have very little                                                      
   data in the numeric csvs.                                                                                                                        
                 _          _ _                                                                                                                     
 _ __ ___   __ _| | _____ / _(_) | ___                                                                                                              
| '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \                                                                                                             
| | | | | | (_| |   <  __/  _| | |  __/                                                                                                             
|_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|                                                                                                             
                                                                                                                                                    
Module cos_000.sas is the SAS makefile                                                                                                              
It 'compiles' all the modules needed to run the driver program.                                                                                     
Users need to run this first and then they can run a short list                                                                                     
of mudules using the 'module' driver.                                                                                                               
Users can also change and 'recompile' a module by editing the source                                                                                
located in the makefile. Highlight and submit highlighted code.                                                                                     
                                                                                                                                                    
 Modules                                                                                                                                            
 Sequentially                                                                                                                                       
%cos_000     * makefile - after running this you should be able to execute the module driver;                                                       
%cos_005     * driver                                                                                                                               
%cos_100     * copy tables created                                                                                                                  
%cos_150     * copy census zcta level data from U of missouri                                                                                       
%cos_200     * simple excel puf example                                                                                                             
%cos_250     * more complex excel puf example                                                                                                       
           _                                                                                                                                        
  _____  _| |_ ___ _ __ _ __   __ _| |___                                                                                                           
 / _ \ \/ / __/ _ \ '__| '_ \ / _` | / __|                                                                                                          
|  __/>  <| ||  __/ |  | | | | (_| | \__ \                                                                                                          
 \___/_/\_\\__\___|_|  |_| |_|\__,_|_|___/                                                                                                          
 _                   _                                                                                                                              
(_)_ __  _ __  _   _| |_                                                                                                                            
| | '_ \| '_ \| | | | __|                                                                                                                           
| | | | | |_) | |_| | |_                                                                                                                            
|_|_| |_| .__/ \__,_|\__|                                                                                                                           
        |_|                                                                                                                                         
                                                                                                                                                    
* You need to either download cos.exe or run cst_000makefile.sas, cst_005driver.sas, cos_makefile and cos_driver                                    
  cst repo is at https://github.com/rogerjdeangelis/CostReports                                                                                     
  cos repo is at https://github.com/rogerjdeangelis/utl-cost-report-analysis                                                                        
                                                                                                                                                    
* you can get cos.exe at                                                                                                                            
                                                                                                                                                    
   Dropbox                                                                                                                                          
   https://www.dropbox.com/s/x068gdpm6uygwe5/cos.exe?dl=0                                                                                           
                                                                                                                                                    
   Google Drive                                                                                                                                     
   https://drive.google.com/file/d/1WWVK_8bm9lBFvFN54D46S6GUkT17X_BM/view?usp=sharing                                                               
                                                                                                                                                    
   MS OneDrive                                                                                                                                      
   https://1drv.ms/u/s!AoqaX8I7j_icglMn-H01psG-mPQf?e=u4MkB3                                                                                        
;                                                                                                                                                   
             _               _                                                                                                                      
  ___  _   _| |_ _ __  _   _| |_                                                                                                                    
 / _ \| | | | __| '_ \| | | | __|                                                                                                                   
| (_) | |_| | |_| |_) | |_| | |_                                                                                                                    
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                                   
                |_|                                                                                                                                 
SCHEMA TABLES AND FORMATS                                                                                                                           
                                                                                                                                                    
Name              File Size    Label                                                                                                                
                                                                                                                                                    
ADR_ADDRESS            25MB    2011-Current unzipped report csvs from https://downloads.cms.gov/files/hcris/snf19fy####                             
CEL_CELLVALUE          10GB    2011-Current alpha & numeric csvs csvs unzipped from https://downloads.cms.gov/files/hcris/snf19fy####               
CEL_CELLVALUE(Index)    1GB    INDEX Report Record Number also sorted on Report Record Number (cel_reportKey)                                       
COL_DESCRIBE          448KB    Descriptions for all the key cells in the pdf cost report workshhet line and column                                  
                                                                                                                                                    
COS_FMTV1A (LOOKUPS)   18MB    COS Format Catalog                                                                                                   
 RPTKEY2PRVDR                  Mapping of numeric Report Record Number to Provider Number 2011-Current ie 1023771 to 365787                         
 CEL2LBL                       Cell to Description ie S200001_00200_00200_C to State@S200001_00200_00200_C)'                                        
 ZIP2ZCTA                      Two DIFFERENT zipcodes can map to the same ZCTA, many to one. https://www.udsmapper.org/zcta-crosswalk.cfm           
                                                                                                                                                    
RPV_REPORTPROVIDER      5MB    Master Report Record number (cel_reportKey) to Provider CCN aslo a format cel2lbl                                    
TPL_TEMPLATE          832KB    All possible cells. This assures all subsets will have all columns, even if the column is 100 percent mssing         
ZCT_ZIP2ZCTA            1MB    Zip Code to Census ZCTA. A ZTCA can span zips . One to many zip to zcta                                              
ZIP_DEMOGRAPHICS      115MB    SAS Census ZCTA level Demographics over 200 columns from http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat   
 _                                                                                                                                                  
(_)___ ___ _   _  ___  ___                                                                                                                          
| / __/ __| | | |/ _ \/ __|                                                                                                                         
| \__ \__ \ |_| |  __/\__ \                                                                                                                         
|_|___/___/\__,_|\___||___/                                                                                                                         
                                                                                                                                                    
  1. If a cell has not been poulated in all cost reports post 2010 data then                                                                        
     it will not appear in the output excel puf. It will be                                                                                         
     in the snowflake schema. All cells that have at least one poluated value                                                                       
     post 2010 will be in the excel puf. This can be fixed because the                                                                              
     col_describe table will habe meta data on the missing cell.                                                                                    
  2. May require 1980s classic SAS. msy not run in EG?                                                                                              
                                                                                                                                                    
/*                                                                                                                                                  
                  __ _                                                                                                                              
  ___ ___  _ __  / _(_) __ _                                                                                                                        
 / __/ _ \| '_ \| |_| |/ _` |                                                                                                                       
| (_| (_) | | | |  _| | (_| |                                                                                                                       
 \___\___/|_| |_|_| |_|\__, |                                                                                                                       
                       |___/                                                                                                                        
*/                                                                                                                                                  
                                                                                                                                                    
                                                                                                                                                    
* so you can rerun safely;                                                                                                                          
%symdel                                                                                                                                             
     gbl_tok                                                                                                                                        
     gbl_typ                                                                                                                                        
     gbl_yrs                                                                                                                                        
     gbl_dir                                                                                                                                        
     gbl_drvr                                                                                                                                       
     gbl_tool                                                                                                                                       
     gbl_dirsub                                                                                                                                     
     gbl_cstcop                                                                                                                                     
     gbl_ziptbl                                                                                                                                     
     gbl_makefile                                                                                                                                   
     gbl_driver                                                                                                                                     
     gbl_tools                                                                                                                                      
     gbl_root                                                                                                                                       
     gbl_oto                                                                                                                                        
     gbl_zipcode                                                                                                                                    
;                                                                                                                                                   
                                                                                                                                                    
%let gbl_tok      =  cos                 ;   * token and part of root;                                                                              
%let gbl_typ      =  snf                 ;   * skilled nursing facilities;                                                                          
                                                                                                                                                    
%let gbl_yrs       =  2011-2019          ;   * years to process;                                                                                    
                                                                                                                                                    
%let gbl_dir      =  1                   ;   * if 1 then build directory structure else 0;                                                          
%let gbl_drvr     =  1                   ;   * if 1 download driver else 0;                                                                         
%let gbl_tools    =  1                   ;   * if 1 download driver and macro library and makefile;                                                 
%let gbl_dirsub   =  1                   ;   * if 1 then build sub directories else 0;                                                              
                                                                                                                                                    
%let gbl_cstcop   =  1                   ;   * if you make chages to source cos_100 macro;                                                          
%let gbl_ziptbl   =  1                   ;   * if you make chages to source cos_150 macro;                                                          
                                                                                                                                                    
%let gbl_example1 =  1                   ;   * if you make chages to source cos_200 macro;                                                          
%let gbl_example2 =  1                   ;   * if you make chages to source cos_250 macro;                                                          
                                                                                                                                                    
%let gbl_makefile =  https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cos_000.makefile.sas;  * makefile ;                       
%let gbl_driver   =  https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cos_005driver.sas;  * driver ;                            
%let gbl_tools    =  https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_010.sas;  * tools ;                                   
                                                                                                                                                    
%let gbl_root     =  d                   ;   * where things are;                                                                                    
%let gbl_oto      =  &gbl_root:/cos/oto  ;   * autocall library;                                                                                    
                                                                                                                                                    
%let gbl_zipcode  =  http://mcdc.missouri.edudata/acs2018/uszctas5yr.sas7bdat recfm=n lrecl=256;                                                    
                                                                                                                                                    
%let _yrs=%qsysfunc(compress(&gbl_yrs,%str(-)));                                                                                                    
%let _yrs=%unquote(&_yrs);                                                                                                                          
                                                                                                                                                    
* gbl_exe is used with systask for parallel processin. May be needed for slower laptops not needed with my system;                                  
%let gbl_exe   =  %sysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk                                  
                  -rsasuser -autoexec &_r\oto\tut_Oto.sas -nosplash -sasautos &_r\oto -RLANG -config &_r\cfg\sasv9.cfg));                           
                                                                                                                                                    
/*              _                    __ _                                                                                                           
  ___ _ __   __| |   ___ ___  _ __  / _(_) __ _                                                                                                     
 / _ \ '_ \ / _` |  / __/ _ \| '_ \| |_| |/ _` |                                                                                                    
|  __/ | | | (_| | | (_| (_) | | | |  _| | (_| |                                                                                                    
 \___|_| |_|\__,_|  \___\___/|_| |_|_| |_|\__, |                                                                                                    
                                          |___/                                                                                                     
                                                                                                                                                    
 ___ _   _ ___ _____                                                                                                                                
|_ _| \ | |_ _|_   _|                                                                                                                               
 | ||  \| || |  | |                                                                                                                                 
 | || |\  || |  | |                                                                                                                                 
|___|_| \_|___| |_|                                                                                                                                 
                                                                                                                                                    
                     _                     _                  _ _                                                                                   
  ___ _ __ ___  __ _| |_ ___    __ _ _   _| |_ ___   ___ __ _| | |                                                                                  
 / __| '__/ _ \/ _` | __/ _ \  / _` | | | | __/ _ \ / __/ _` | | |                                                                                  
| (__| | |  __/ (_| | ||  __/ | (_| | |_| | || (_) | (_| (_| | | |                                                                                  
 \___|_|  \___|\__,_|\__\___|  \__,_|\__,_|\__\___/ \___\__,_|_|_|                                                                                  
*/                                                                                                                                                  
                                                                                                                                                    
%if &gbl_dir %then %do;                                                                                                                             
                                                                                                                                                    
  data _null_;                                                                                                                                      
                                                                                                                                                    
      newdir=dcreate('cos',"&gbl_root:/");                                                                                                          
      newdir=dcreate('oto',"&gbl_root:/cos");   * autocall folder;                                                                                  
                                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
%end /* create dir */;                                                                                                                              
                                                                                                                                                    
/*             _               _ _ _            __           _                                                                                      
  __ _ ___ ___(_) __ _ _ __   | (_) |__  ___   / _|_ __ ___ | |_                                                                                    
 / _` / __/ __| |/ _` | '_ \  | | | '_ \/ __| | |_| '_ ` _ \| __|                                                                                   
| (_| \__ \__ \ | (_| | | | | | | | |_) \__ \ |  _| | | | | | |_                                                                                    
 \__,_|___/___/_|\__, |_| |_| |_|_|_.__/|___/ |_| |_| |_| |_|\__|                                                                                   
                 |___/                                                                                                                              
*/                                                                                                                                                  
                                                                                                                                                    
%if %sysfunc(fileexist("&gbl_root:/cos")) %then %do;                                                                                                
                                                                                                                                                    
  libname cst "&gbl_root:/cst";  * output from preious repo https://github.com/rogerjdeangelis/CostReports;                                         
  libname cos "&gbl_root:/cos";                                                                                                                     
                                                                                                                                                    
  options fmtsearch=(work.formats cos.cos_fmtv1a) ;                                                                                                 
  options sasautos=(sasautos,"&gbl_oto");   * autocall library;                                                                                     
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
/*          _                                                                                                                                       
  __ _  ___| |_   _ __ ___   __ _  ___ _ __ ___  ___                                                                                                
 / _` |/ _ \ __| | '_ ` _ \ / _` |/ __| '__/ _ \/ __|                                                                                               
| (_| |  __/ |_  | | | | | | (_| | (__| | | (_) \__ \                                                                                               
 \__, |\___|\__| |_| |_| |_|\__,_|\___|_|  \___/|___/                                                                                               
 |___/                                                                                                                                              
*/                                                                                                                                                  
                                                                                                                                                    
%if &gbl_tool %then %do;                                                                                                                            
                                                                                                                                                    
  filename _bcot "&gbl_oto/cos_010.sas";                                                                                                            
  proc http                                                                                                                                         
     method='get'                                                                                                                                   
     url="&gbl_tools"                                                                                                                               
     out= _bcot;                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
  filename _bcot "&gbl_oto/cos_000makefile.sas";                                                                                                    
  proc http                                                                                                                                         
     method='get'                                                                                                                                   
     url="&gbl_makefile;                                                                                                                            
     out= _bcot;                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
  filename _bcot "&gbl_oto/cos_005driver,sas";                                                                                                      
  proc http                                                                                                                                         
     method='get'                                                                                                                                   
     url="&gbl_driver;                                                                                                                              
     out= _bcot;                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
/*                         _ _        _              _                                                                                              
  ___ ___  _ __ ___  _ __ (_) | ___  | |_ ___   ___ | |___                                                                                          
 / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ | __/ _ \ / _ \| / __|                                                                                         
| (_| (_) | | | | | | |_) | | |  __/ | || (_) | (_) | \__ \                                                                                         
 \___\___/|_| |_| |_| .__/|_|_|\___|  \__\___/ \___/|_|___/                                                                                         
                    |_|                                                                                                                             
*/                                                                                                                                                  
                                                                                                                                                    
* compile utility macros;                                                                                                                           
filename cin "&gbl_oto/cos_010.sas" lrecl=4096 recfm=v;                                                                                             
%inc cin / nosource;                                                                                                                                
                                                                                                                                                    
                                                                                                                                                    
%if &gbl_dirsub %then %do;                                                                                                                          
                                                                                                                                                    
/*         _           _ _                                                                                                                          
 ___ _   _| |__     __| (_)_ __ ___                                                                                                                 
/ __| | | | '_ \   / _` | | '__/ __|                                                                                                                
\__ \ |_| | |_) | | (_| | | |  \__ \                                                                                                                
|___/\__,_|_.__/   \__,_|_|_|  |___/                                                                                                                
                                                                                                                                                    
This copies the macro below to your autocall library.                                                                                               
Create directory structure for costreports                                                                                                          
* Note you can edit the code below and it will                                                                                                      
  de decompiled and copied to your autocall library;                                                                                                
*/                                                                                                                                                  
                                                                                                                                                    
  data _null_;                                                                                                                                      
                                                                                                                                                    
    newdir=dcreate('utl',"&gbl_root:/");                                                                                                            
    newdir=dcreate('ver',"&gbl_root:/");                                                                                                            
    newdir=dcreate('xls',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('csv',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('fmt',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('pdf',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('zip',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('doc',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('ppt',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('log',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('lst',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('rtf',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('vdo',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('rtf',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('rda',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('b64',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('vba',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('sas',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('ps1',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('b64',"&gbl_root:/cos/");                                                                                                        
    newdir=dcreate('sd1',"&gbl_root:/cos/");                                                                                                        
                                                                                                                                                    
run;quit;                                                                                                                                           
                                                                                                                                                    
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
                                                                                                                                                    
                                                                                                                                                    
/*                                _     _        _     _                                                                                            
  ___ ___  _ __  _   _    ___ ___| |_  | |_ __ _| |__ | | ___  ___                                                                                  
 / __/ _ \| '_ \| | | |  / __/ __| __| | __/ _` | '_ \| |/ _ \/ __|                                                                                 
| (_| (_) | |_) | |_| | | (__\__ \ |_  | || (_| | |_) | |  __/\__ \                                                                                 
 \___\___/| .__/ \__, |  \___|___/\__|  \__\__,_|_.__/|_|\___||___/                                                                                 
          |_|    |___/                                                                                                                              
*/                                                                                                                                                  
                                                                                                                                                    
* this is usually run using the driver;                                                                                                             
                                                                                                                                                    
%if &gbl_cstcop %then %do;                                                                                                                          
                                                                                                                                                    
filename ft15f001 "&gbl_oto/cos_100.sas";                                                                                                           
parmcards4;                                                                                                                                         
%macro cos_100/des="creates cel_cellValue tpl_template col_describe formats $cel2lbl adr_address $zip2zcta";                                        
                                                                                                                                                    
  /* if you have not run the cst_driver. Just download and unzip                                                                                    
                                                                                                                                                    
   Dropbox                                                                                                                                          
   https://www.dropbox.com/s/x068gdpm6uygwe5/cos.exe?dl=0                                                                                           
                                                                                                                                                    
   Google Drive                                                                                                                                     
   https://drive.google.com/file/d/1WWVK_8bm9lBFvFN54D46S6GUkT17X_BM/view?usp=sharing                                                               
                                                                                                                                                    
   MS OneDrive                                                                                                                                      
   https://1drv.ms/u/s!AoqaX8I7j_icglMn-H01psG-mPQf?e=u4MkB3                                                                                        
  */                                                                                                                                                
                                                                                                                                                    
    *         _             _ _            _                                                                                                        
      ___ ___| |    ___ ___| | |_   ____ _| |_   _  ___                                                                                             
     / __/ _ \ |   / __/ _ \ | \ \ / / _` | | | | |/ _ \                                                                                            
    | (_|  __/ |  | (_|  __/ | |\ V / (_| | | |_| |  __/                                                                                            
     \___\___|_|___\___\___|_|_| \_/ \__,_|_|\__,_|\___|                                                                                            
              |_____|                                                                                                                               
    ;                                                                                                                                               
                                                                                                                                                    
    * this requires that &gbl_root:/cst/cst.cst_200&gbl_typ.fiv20112019.sas7bdat exist;                                                             
                                                                                                                                                    
    options compress=char;                                                                                                                          
                                                                                                                                                    
    libname cst "&gbl_root:/cst";                                                                                                                   
                                                                                                                                                    
    data cos.cel_cellValue;                                                                                                                         
       set cst.cst_200&gbl_typ.fiv&_yrs(                                                                                                            
            keep=rpt_rec_num cstnam cstval                                                                                                          
            rename=(                                                                                                                                
                    rpt_rec_num = cel_reportKey                                                                                                     
                    cstnam      = cel_name                                                                                                          
                    cstval      = cel_value                                                                                                         
                   ));                                                                                                                              
            label cel_name = "Report-Key Worksheet lineNumber column";                                                                              
    run;quit;                                                                                                                                       
                                                                                                                                                    
   /*_           _                            _                                                                                                     
    (_)_ __   __| | _____  __  ___  ___  _ __| |_                                                                                                   
    | | '_ \ / _` |/ _ \ \/ / / __|/ _ \| '__| __|                                                                                                  
    | | | | | (_| |  __/>  <  \__ \ (_) | |  | |_                                                                                                   
    |_|_| |_|\__,_|\___/_/\_\ |___/\___/|_|   \__|                                                                                                  
   */                                                                                                                                               
                                                                                                                                                    
    proc sort data=cos.cel_cellvalue                                                                                                                
               out=cos.cel_cellvalue(index=(cel_reportKey)) sortsize=80g;                                                                           
       by cel_reportKey cel_name;                                                                                                                   
    run;quit;                                                                                                                                       
                                                                                                                                                    
   /*_         _    _                       _       _                                                                                               
    | |_ _ __ | |  | |_ ___ _ __ ___  _ __ | | __ _| |_ ___                                                                                         
    | __| '_ \| |  | __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \                                                                                        
    | |_| |_) | |  | ||  __/ | | | | | |_) | | (_| | ||  __/                                                                                        
     \__| .__/|_|___\__\___|_| |_| |_| .__/|_|\__,_|\__\___|                                                                                        
        |_|    |_____|               |_|                                                                                                            
   */                                                                                                                                               
                                                                                                                                                    
    data cos.tpl_template;                                                                                                                          
        set cst.cst_200&gbl_typ.max&_yrs;                                                                                                           
    run;quit;                                                                                                                                       
                                                                                                                                                    
    /*         _        _                     _ _                                                                                                   
      ___ ___ | |    __| | ___  ___  ___ _ __(_) |__   ___                                                                                          
     / __/ _ \| |   / _` |/ _ \/ __|/ __| '__| | '_ \ / _ \                                                                                         
    | (_| (_) | |  | (_| |  __/\__ \ (__| |  | | |_) |  __/                                                                                         
     \___\___/|_|___\__,_|\___||___/\___|_|  |_|_.__/ \___|                                                                                         
               |_____|                                                                                                                              
    */                                                                                                                                              
                                                                                                                                                    
    data cos.col_describe;                                                                                                                          
         set cst.cst_025&gbl_typ.describe(rename=(col_cel_description=col_description)) end=dne;                                                    
         output;                                                                                                                                    
         if dne then do;                                                                                                                            
         COL_CEL_NAME    ='YER               ';    COL_DESCRIPTION ='Year of CSV file from CMS wweb data @YER      ';output;                        
         COL_CEL_NAME    ='PRVDR_NUM         ';    COL_DESCRIPTION ='Provider Number @PRVDR_NUM                    ';output;                        
         COL_CEL_NAME    ='INITL_RPT_SW      ';    COL_DESCRIPTION ='Initial Report Switch @INITL_RPT_SW           ';output;                        
         COL_CEL_NAME    ='LAST_RPT_SW       ';    COL_DESCRIPTION ='Last Report Switch @LAST_RPT_SW               ';output;                        
         COL_CEL_NAME    ='TRNSMTL_NUM       ';    COL_DESCRIPTION ='Transmittal Number @TRNSMTL_NUM               ';output;                        
         COL_CEL_NAME    ='FI_NUM            ';    COL_DESCRIPTION ='Fiscal Intermediary Number @FI_NUM            ';output;                        
         COL_CEL_NAME    ='UTIL_CD           ';    COL_DESCRIPTION ='Utilization Code @UTIL_CD                     ';output;                        
         COL_CEL_NAME    ='SPEC_IND          ';    COL_DESCRIPTION ='Special Indicator @SPEC_IND                   ';output;                        
         COL_CEL_NAME    ='RPT_REC_NUM       ';    COL_DESCRIPTION ='Report Record Number @RPT_REC_NUM             ';output;                        
         COL_CEL_NAME    ='PRVDR_CTRL_TYPE_CD';    COL_DESCRIPTION ='Provider Control Type Code @PRVDR_CTRL_TYPE_CD';output;                        
         COL_CEL_NAME    ='RPT_STUS_CD       ';    COL_DESCRIPTION ='Report Status Code @RPT_STUS_CD               ';output;                        
         COL_CEL_NAME    ='ADR_VNDR_CD       ';    COL_DESCRIPTION ='Automated Desk Review Vendor Code @ADR_VNDR_CD';output;                        
         COL_CEL_NAME    ='NPI               ';    COL_DESCRIPTION ='National Provider Identifier @NPI             ';output;                        
         COL_CEL_NAME    ='FY_BGN_DT         ';    COL_DESCRIPTION ='Fiscal Year Begin Date @FY_BGN_DT             ';output;                        
         COL_CEL_NAME    ='FY_END_DT         ';    COL_DESCRIPTION ='Fiscal Year End Date @FY_END_DT               ';output;                        
         COL_CEL_NAME    ='PROC_DT           ';    COL_DESCRIPTION ='HCRIS Process Date @PROC_DT                   ';output;                        
         COL_CEL_NAME    ='FI_CREAT_DT       ';    COL_DESCRIPTION ='Fiscal Intermediary Create Date @FI_CREAT_DT  ';output;                        
         COL_CEL_NAME    ='NPR_DT            ';    COL_DESCRIPTION ='Notice of Program Reimbursement Date @NPR_DT  ';output;                        
         COL_CEL_NAME    ='FI_RCPT_DT        ';    COL_DESCRIPTION ='Fiscal Intermediary Receipt Date @FI_RCPT_DT  ';output;                        
         end;                                                                                                                                       
         drop rc0;                                                                                                                                  
    run;quit;                                                                                                                                       
                                                                                                                                                    
    /*        _ _                              ____    _       _          _                                                                         
      ___ ___| | |  _ __   __ _ _ __ ___   ___|___ \  | | __ _| |__   ___| |                                                                        
     / __/ _ \ | | | '_ \ / _` | '_ ` _ \ / _ \ __) | | |/ _` | '_ \ / _ \ |                                                                        
    | (_|  __/ | | | | | | (_| | | | | | |  __// __/  | | (_| | |_) |  __/ |                                                                        
     \___\___|_|_| |_| |_|\__,_|_| |_| |_|\___|_____| |_|\__,_|_.__/ \___|_|                                                                        
                                                                                                                                                    
    */                                                                                                                                              
                                                                                                                                                    
    * get provider level information;                                                                                                               
    proc transpose data=cst.cst_150&gbl_typ.rpt&_yrs(drop=npi spec_ind)                                                                             
                    out=cos_100tblrptxpo(rename=(rpt_rec_num=cel_reportKey  _name_=cel_name col1=cel_value));                                       
      by yer rpt_rec_num;                                                                                                                           
      var _all_;                                                                                                                                    
    run;quit;                                                                                                                                       
                                                                                                                                                    
    data cos_100tblchrval;                                                                                                                          
                                                                                                                                                    
       set cos.cel_cellvalue(where=(cel_name in (                                                                                                   
            'S200001_00100_00100_C'                                                                                                                 
            'S200001_00200_00100_C',                                                                                                                
            'S200001_00200_00200_C',                                                                                                                
            'S200001_00200_00300_C',                                                                                                                
            'S200001_00300_00100_C',                                                                                                                
            'S200001_00300_00200_C',                                                                                                                
            'S200001_00300_00300_C',                                                                                                                
            'S200001_00400_00100_C',                                                                                                                
            'S200001_00400_00200_C',                                                                                                                
            'S200001_00400_00300_C',                                                                                                                
            'S200001_00400_00400_C',                                                                                                                
            'S200001_00400_00500_C',                                                                                                                
            'S200001_00400_00600_C',                                                                                                                
            'S200001_01400_00100_C',                                                                                                                
            'S200001_01400_00200_C' )));                                                                                                            
                                                                                                                                                    
    run;quit;                                                                                                                                       
                                                                                                                                                    
    data cos_100fmtlbl;                                                                                                                             
      retain fmtname '$cel2lbl';                                                                                                                    
      set cos.col_describe ( rename=(col_cel_name=start  col_description=label));                                                                   
    run;quit;                                                                                                                                       
                                                                                                                                                    
    proc format cntlin=cos_100fmtlbl lib=cos.cos_fmtv1a;                                                                                            
    run;quit;                                                                                                                                       
                                                                                                                                                    
    data cos_100tblrptnunalp ;                                                                                                                      
      retain yer cel_reportKey;                                                                                                                     
      length                                                                                                                                        
         CEL_REPORTKEY   5                                                                                                                          
         CEL_NAME       $21                                                                                                                         
         CEL_VALUE      $40                                                                                                                         
      ;                                                                                                                                             
      set                                                                                                                                           
        cos_100tblrptxpo                                                                                                                            
        cos_100tblchrval ;                                                                                                                          
      ;                                                                                                                                             
      idlabel=put(cel_name,$cel2lbl.);                                                                                                              
      cel_value=left(cel_value);                                                                                                                    
    run;quit;                                                                                                                                       
                                                                                                                                                    
    proc datasets lib = work nolist;                                                                                                                
      modify cos_100tblrptnunalp ;                                                                                                                  
        attrib _all_ label = "" ;                                                                                                                   
        format _all_;                                                                                                                               
        informat _all_;                                                                                                                             
      run ;                                                                                                                                         
    quit ;                                                                                                                                          
                                                                                                                                                    
   proc sort data=cos_100tblrptnunalp(keep=yer cel_reportkey cel_name cel_value where=(cel_name ="FY_BGN_DT" ))                                     
             out=cos_100tblrptnunalpchk(drop=cel_name);                                                                                             
      by cel_reportKey desending yer;                                                                                                               
   run;quit;                                                                                                                                        
                                                                                                                                                    
   data cos_100tblrptnunalplup;                                                                                                                     
      retain fmtname '$keydte2yer';                                                                                                                 
      set cos_100tblrptnunalpchk;                                                                                                                   
      start=cats(cel_reportKey,cel_value);                                                                                                          
      label=cats('20',yer);                                                                                                                         
      keep fmtname start label;                                                                                                                     
   run;quit;                                                                                                                                        
                                                                                                                                                    
   proc format cntlin=cos_100tblrptnunalplup  lib=cos.cos_fmtv1a;                                                                                   
   run;quit;                                                                                                                                        
                                                                                                                                                    
                                                                                                                                                    
   proc sort data=cos_100tblrptnunalp out=cos_100tblrpunq;                                                                                          
     by cel_reportKey;                                                                                                                              
   run;quit;                                                                                                                                        
                                                                                                                                                    
   proc format cntlin=cos.zct_zip2zcta lib=cos.cos_fmtv1a;                                                                                          
   run;quit;                                                                                                                                        
                                                                                                                                                    
   proc transpose data=cos_100tblrpunq out=cos_100tblrpunqxpo (drop=_name_ _label_ );                                                               
     by  cel_reportKey;                                                                                                                             
     var cel_value;                                                                                                                                 
     id cel_name;                                                                                                                                   
     idlabel idlabel;                                                                                                                               
   run;quit;                                                                                                                                        
                                                                                                                                                    
   data cos.adr_address;                                                                                                                            
    length  COSTREPORT$3 year $4 CEL_REPORTKEY 5 PRVDR_NUM $10  zip5 $5 zcta$5;                                                                     
    retain                                                                                                                                          
    CostReport %upcase("&gbl_typ")                                                                                                                  
    YEAR                                                                                                                                            
    CEL_REPORTKEY                                                                                                                                   
    PRVDR_NUM                                                                                                                                       
    S200001_00400_00100_C                                                                                                                           
    S200001_01400_00200_C                                                                                                                           
    S200001_01400_00100_C                                                                                                                           
    S200001_00300_00300_C                                                                                                                           
    S200001_00100_00100_C                                                                                                                           
    S200001_00200_00100_C                                                                                                                           
    S200001_00300_00100_C                                                                                                                           
    S200001_00200_00200_C                                                                                                                           
    S200001_00200_00300_C                                                                                                                           
    S200001_00300_00200_C                                                                                                                           
    UTIL_CD                                                                                                                                         
    RPT_REC_NUM                                                                                                                                     
    FY_BGN_DT                                                                                                                                       
    TRNSMTL_NUM                                                                                                                                     
    PRVDR_CTRL_TYPE_CD                                                                                                                              
    LAST_RPT_SW                                                                                                                                     
    FI_NUM                                                                                                                                          
    FY_END_DT                                                                                                                                       
    ADR_VNDR_CD                                                                                                                                     
    RPT_STUS_CD                                                                                                                                     
    FI_CREAT_DT                                                                                                                                     
    INITL_RPT_SW                                                                                                                                    
    NPR_DT                                                                                                                                          
    FI_RCPT_DT                                                                                                                                      
    PROC_DT                                                                                                                                         
    S200001_00400_00400_C                                                                                                                           
    S200001_00400_00500_C                                                                                                                           
    S200001_00400_00200_C                                                                                                                           
    S200001_00400_00300_C                                                                                                                           
    S200001_00400_00600_C                                                                                                                           
    ;                                                                                                                                               
    label                                                                                                                                           
      cel_reportKey = "Individual Cost Report Some provides have multiple repors within a year"                                                     
      costReport    = "Cost Report SNF HHA HOSPICE FQHC ..."                                                                                        
      Year          = "Year of CSV Zip file"                                                                                                        
      ZIP5          = "5 digit zipcode"                                                                                                             
      ZCTA          = "5 digit ZCTA code"                                                                                                           
    ;                                                                                                                                               
   set                                                                                                                                              
     cos_100tblrpunqxpo;                                                                                                                            
     zip5=substr(S200001_00200_00300_C,1,5);                                                                                                        
     S200001_00200_00300_C=cats('09'x,S200001_00200_00300_C);                                                                                       
     zcta=put(zip5,$zip2zcta.);                                                                                                                     
     year=cats("20",yer);                                                                                                                           
     drop yer;                                                                                                                                      
   run;quit;                                                                                                                                        
                                                                                                                                                    
                                                                                                                                                    
   %utl_optlen(inp=cos.adr_address,out=cos.adr_address);                                                                                            
                                                                                                                                                    
   *           _     ____                         _     _                                                                                           
    _ __ _ __ | |_  |___ \   _ __  _ __ _____   _(_) __| | ___ _ __                                                                                 
   | '__| '_ \| __|   __) | | '_ \| '__/ _ \ \ / / |/ _` |/ _ \ '__|                                                                                
   | |  | |_) | |_   / __/  | |_) | | | (_) \ V /| | (_| |  __/ |                                                                                   
   |_|  | .__/ \__| |_____| | .__/|_|  \___/ \_/ |_|\__,_|\___|_|                                                                                   
        |_|                 |_|                                                                                                                     
   ;                                                                                                                                                
                                                                                                                                                    
   data cos.rpv_reportProvider;                                                                                                                     
     retain fmtname "rptKey2prvdr";                                                                                                                 
     set cos.adr_address(keep=cel_reportKey  prvdr_num) ;                                                                                           
     start=cel_reportKey;                                                                                                                           
     label=prvdr_num;                                                                                                                               
   run;quit;                                                                                                                                        
                                                                                                                                                    
   proc format cntlin=cos.rpv_reportProvider lib=cos.cos_fmtv1a;                                                                                    
   run;quit;                                                                                                                                        
                                                                                                                                                    
%mend cos_100;                                                                                                                                      
;;;;                                                                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
%*cos_100;                                                                                                                                          
                                                                                                                                                    
/*   _       _   _     _                                                                                                                            
 ___(_)_ __ | |_| |__ | |                                                                                                                           
|_  / | '_ \| __| '_ \| |                                                                                                                           
 / /| | |_) | |_| |_) | |                                                                                                                           
/___|_| .__/ \__|_.__/|_|                                                                                                                           
      |_|                                                                                                                                           
*/                                                                                                                                                  
                                                                                                                                                    
%if &gbl_ziptbl %then %do;                                                                                                                          
                                                                                                                                                    
filename ft15f001 "&gbl_oto/cos_150.sas";                                                                                                           
parmcards4;                                                                                                                                         
%macro cos_150/des="download and create table zct_zip2zcta and format $zip2zcta";                                                                   
                                                                                                                                                    
   libname cos "&gbl_root:/cos";                                                                                                                    
                                                                                                                                                    
  /*    _      ____          _                                                                                                                      
    ___(_)_ __|___ \ _______| |_ __ _                                                                                                               
   |_  / | '_ \ __) |_  / __| __/ _` |                                                                                                              
    / /| | |_) / __/ / / (__| || (_| |                                                                                                              
   /___|_| .__/_____/___\___|\__\__,_|                                                                                                              
         |_|                                                                                                                                        
  */                                                                                                                                                
                                                                                                                                                    
  * download b64 encoded sas dataset - github does nto support binary download wirg aoi key ;                                                       
  * https://www.udsmapper.org/zcta-crosswalk.cfm  zip to zcta crosswalk ;                                                                           
                                                                                                                                                    
  filename _bcot "&gbl_root:/cos/b64/cst_025zip2zcta_sas7bdat.b64";                                                                                 
                                                                                                                                                    
  proc http                                                                                                                                         
     method='get'                                                                                                                                   
     url="https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_025zip2zcta_sas7bdat.b64"                                        
     out= _bcot;                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
  %utl_b64decode(&gbl_root:/cos/b64/cst_025zip2zcta_sas7bdat.b64,%sysfunc(pathname(work))/zct_zip2zcta.sas7bdat);                                   
                                                                                                                                                    
  data cos.zct_zip2zcta;                                                                                                                            
     retain                                                                                                                                         
        fmtname                                                                                                                                     
        zct_zipcode                                                                                                                                 
        zct_zcta                                                                                                                                    
     ;                                                                                                                                              
     set zct_zip2zcta;                                                                                                                              
     zct_zipcode=start;                                                                                                                             
     zct_zcta   =label;                                                                                                                             
  run;quit;                                                                                                                                         
                                                                                                                                                    
  proc format cntlin=cos.zct_zip2zcta;                                                                                                              
  run;quit;                                                                                                                                         
                                                                                                                                                    
                                                                                                                                                    
  /*   If the site is updated you may want to rerun this;                                                                                           
  data cos.cos_400zip(label="zip_zipcode to zip_zcta https://www.udsmapper.org/zcta-crosswalk.cfm");                                                
    length zip_zcta $5;                                                                                                                             
    set XEL.'ZiptoZCTA_crosswalk$'n(                                                                                                                
             keep=zip_code zcta                                                                                                                     
             rename=(zip_code=zip_zipcode zcta=zip_zcta)                                                                                            
             where=(substr(zip_zcta,1,5) ne "No ZC")                                                                                                
             );                                                                                                                                     
  run;quit;                                                                                                                                         
                                                                                                                                                    
  * contoll in dataset to create a format;                                                                                                          
  data cst.cst_025zip2Zcta;                                                                                                                         
     retain fmtname "$zip2zcta";                                                                                                                    
     set cst_025zip2zcta;                                                                                                                           
     start=zip_zipcode;                                                                                                                             
     label=zip_zcta;                                                                                                                                
     keep start label fmtname;                                                                                                                      
  run;quit;                                                                                                                                         
  */                                                                                                                                                
                                                                                                                                                    
                                                                                                                                                    
  /*    _             _                                                                                                                             
    ___(_)_ __     __| | ___ _ __ ___   ___                                                                                                         
   |_  / | '_ \   / _` |/ _ \ '_ ` _ \ / _ \                                                                                                        
    / /| | |_) | | (_| |  __/ | | | | | (_) |                                                                                                       
   /___|_| .__/   \__,_|\___|_| |_| |_|\___/                                                                                                        
         |_|                                                                                                                                        
 */                                                                                                                                                 
                                                                                                                                                    
  * http has to be on the next line with quote on first line;                                                                                       
                                                                                                                                                    
  filename inx url "                                                                                                                                
  http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat" recfm=n lrecl=256;                                                                     
  filename out "%sysfunc(pathname(work))/uszctas5yr.sas7bdat" recfm=n lrecl=256;                                                                    
  data _null_;                                                                                                                                      
     rc=fcopy('inx', 'out');                                                                                                                        
     put rc=;  /* 0 = ok */                                                                                                                         
  run;quit;                                                                                                                                         
  filename inx clear;                                                                                                                               
  filename out clear;                                                                                                                               
                                                                                                                                                    
  * drop estimation information;                                                                                                                    
  %utlnopts;                                                                                                                                        
  %let drops=%varlist(uszctas5yr,prx=/_MOE/);                                                                                                       
                                                                                                                                                    
  data cos.zip_demographics (label="source http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat");                                             
                                                                                                                                                    
    retain zcta;                                                                                                                                    
                                                                                                                                                    
    set uszctas5yr(drop=&drops);                                                                                                                    
    rename PCTPRIVATEINSURANCEONLYUNDER65=PCTPRIVINSURONLYUNDER65;                                                                                  
                                                                                                                                                    
  run;quit;                                                                                                                                         
                                                                                                                                                    
  %array(dems,values=%varlist(cos.zip_demographics));                                                                                               
                                                                                                                                                    
  proc datasets lib=cos;                                                                                                                            
    modify zip_demographics;                                                                                                                        
      rename                                                                                                                                        
       %do_over(dems,phrase=?=zip_?)                                                                                                                
      ;                                                                                                                                             
  run;quit;                                                                                                                                         
                                                                                                                                                    
  %utlopts;                                                                                                                                         
                                                                                                                                                    
%mend cos_150;                                                                                                                                      
;;;;                                                                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
%*cos_150;                                                                                                                                          
                                                                                                                                                    
/*                              _      _                                                                                                            
  _____  ____ _ _ __ ___  _ __ | | ___/ |                                                                                                           
 / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ |                                                                                                           
|  __/>  < (_| | | | | | | |_) | |  __/ |                                                                                                           
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_|                                                                                                           
                         |_|                                                                                                                        
*/                                                                                                                                                  
                                                                                                                                                    
%if &gbl_example1 %then %do;                                                                                                                        
                                                                                                                                                    
* probably better not to indent because of parmcards4;                                                                                              
                                                                                                                                                    
proc datasets lib=work nolist;                                                                                                                      
  delete mini minixpo;                                                                                                                              
run;quit;                                                                                                                                           
                                                                                                                                                    
filename ft15f001 "&gbl_oto/cos_200.sas";                                                                                                           
parmcards4;                                                                                                                                         
%macro cos_200/des="example of a simple excel puf";                                                                                                 
                                                                                                                                                    
* Code to Create Mini excel file;                                                                                                                   
                                                                                                                                                    
* suppose we know the provide CCN we are interested in;                                                                                             
%utlopts;                                                                                                                                           
                                                                                                                                                    
proc sql ;                                                                                                                                          
   create                                                                                                                                           
     table mini as                                                                                                                                  
   select                                                                                                                                           
     cel_reportKey                                                                                                                                  
    ,put(cel_reportKey,Rptkey2prvdr.) as Provider                                                                                                   
    ,cel_name                                                                                                                                       
    ,cel_value                                                                                                                                      
    ,put(cel_name,$cel2lbl.) as excel_column_header                                                                                                 
  from                                                                                                                                              
     cos.cel_cellvalue                                                                                                                              
  where                                                                                                                                             
     cel_name in(                                                                                                                                   
              'S200001_00200_00200_C'                                                                                                               
             ,'S200001_01400_00100_C'                                                                                                               
             ,'S200001_00400_00100_C'                                                                                                               
             ,'S200001_01400_00200_C'                                                                                                               
             ,'S300001_00100_00100_N'                                                                                                               
             ,'S300001_00100_00200_N'                                                                                                               
             ,'S300001_00100_00700_N'                                                                                                               
             ,'S300001_00100_01200_N'                                                                                                               
             ,'S300001_00100_01600_N'                                                                                                               
        ) and                                                                                                                                       
          put(cel_reportKey,Rptkey2prvdr.)  in ('345508','365787')                                                                                  
  order                                                                                                                                             
     by  cel_reportKey                                                                                                                              
        ,provider                                                                                                                                   
        ,cel_name                                                                                                                                   
;quit;                                                                                                                                              
                                                                                                                                                    
                                                                                                                                                    
proc transpose data=mini out=miniXpo(drop=_name_ _label_);                                                                                          
   by cel_reportKey                                                                                                                                 
      provider;                                                                                                                                     
   var cel_value;                                                                                                                                   
   id cel_name;                                                                                                                                     
   idlabel excel_column_header;                                                                                                                     
run;                                                                                                                                                
                                                                                                                                                    
                                                                                                                                                    
ods listing close;                                                                                                                                  
%utlfkil(&gbl_root:\cos\xls\cos_200&gbl_typ.&_yrs..xlsx);                                                                                           
                                                                                                                                                    
ods excel file="&gbl_root:\cos\xls\cos_200&gbl_typ.&_yrs..xlsx" style=pearl                                                                         
options(                                                                                                                                            
sheet_name="red"                                                                                                                                    
sheet_name='Definitions'                                                                                                                            
Frozen_headers= 'yes'                                                                                                                               
autofilter="all"                                                                                                                                    
);                                                                                                                                                  
                                                                                                                                                    
proc report data=cos.col_describe split="@" ;                                                                                                       
cols  COL_CEL_NAME COL_DESCRIPTION;                                                                                                                 
define COL_DESCRIPTION / display;                                                                                                                   
run;quit;                                                                                                                                           
                                                                                                                                                    
ods excel options(sheet_name="cos_200minixpo");                                                                                                     
proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in} split='@';                                                           
cols _all_;                                                                                                                                         
define S200001_01400_00200_C / order;                                                                                                               
run;quit;                                                                                                                                           
                                                                                                                                                    
ods excel close;                                                                                                                                    
ods listing;                                                                                                                                        
                                                                                                                                                    
%mend cos_200;                                                                                                                                      
;;;;                                                                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
%*cos_200;                                                                                                                                          
                                                                                                                                                    
/*                              _      ____                                                                                                         
  _____  ____ _ _ __ ___  _ __ | | ___|___ \                                                                                                        
 / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ __) |                                                                                                       
|  __/>  < (_| | | | | | | |_) | |  __// __/                                                                                                        
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_____|                                                                                                       
                         |_|                                                                                                                        
*/                                                                                                                                                  
                                                                                                                                                    
                                                                                                                                                    
%if &gbl_example2 %then %do;                                                                                                                        
                                                                                                                                                    
filename ft15f001 "&gbl_oto/cos_150.sas";                                                                                                           
parmcards4;                                                                                                                                         
%macro cos_250/des="create a more complex excel puf";                                                                                               
                                                                                                                                                    
* get demographic and geography for provider_   365787, 335834 ;                                                                                    
                                                                                                                                                    
proc datasets lib=work nolist;                                                                                                                      
  delete dem_365787                                                                                                                                 
         fac_365787                                                                                                                                 
         xpo_365787                                                                                                                                 
         pre_365787                                                                                                                                 
         num_365787                                                                                                                                 
         get_365787                                                                                                                                 
  ;                                                                                                                                                 
run;quit;                                                                                                                                           
                                                                                                                                                    
proc sql;                                                                                                                                           
  create                                                                                                                                            
    table dem_365787 (where=(year ne ""))  as                                                                                                       
  select                                                                                                                                            
    adr.COSTREPORT                                                                                                                                  
   ,adr.YEAR                                                                                                                                        
   ,adr.CEL_REPORTKEY                                                                                                                               
   ,adr.PRVDR_NUM                                                                                                                                   
   ,adr.ZIP5                                                                                                                                        
   ,adr.ZCTA                                                                                                                                        
   ,zip.zip_zcta5                                                                                                                                   
   ,FY_BGN_DT                                                                                                                                       
   ,FY_END_DT                                                                                                                                       
   ,adr.S200001_00400_00100_C                                                                                                                       
   ,adr.S200001_00300_00300_C                                                                                                                       
   ,adr.S200001_00100_00100_C                                                                                                                       
   ,adr.S200001_00200_00100_C                                                                                                                       
   ,adr.S200001_00300_00100_C                                                                                                                       
   ,adr.S200001_00200_00200_C                                                                                                                       
   ,adr.S200001_00200_00300_C                                                                                                                       
   ,adr.S200001_00300_00200_C                                                                                                                       
   ,ZIP.ZIP_STATE                                                                                                                                   
   ,ZIP.ZIP_TOTPOP                                                                                                                                  
   ,ZIP.ZIP_MEDIANAGE                                                                                                                               
   ,ZIP.ZIP_PCTOVER65                                                                                                                               
   ,ZIP.ZIP_PCTOVER65MALES                                                                                                                          
   ,ZIP.ZIP_PCTBLACK1                                                                                                                               
   ,ZIP.ZIP_AVGHHINC                                                                                                                                
   ,ZIP.ZIP_MEDIANHHINC                                                                                                                             
   ,ZIP.ZIP_MEDIANGROSSRENT                                                                                                                         
   ,ZIP.ZIP_PCTPOOR                                                                                                                                 
   ,ZIP.ZIP_PCTNUMHHFOODSTMP                                                                                                                        
   ,ZIP.ZIP_PCTLABORFORCE                                                                                                                           
   ,ZIP.ZIP_PCTPROFESSIONAL                                                                                                                         
   ,ZIP.ZIP_NOCOMPUTER                                                                                                                              
   ,ZIP.ZIP_PCTNOINTERNET                                                                                                                           
   ,ZIP.ZIP_PCTVEHICLES2                                                                                                                            
   ,ZIP.ZIP_PCTBORNINUS                                                                                                                             
   ,ZIP.ZIP_PCTHIGHSCHOOLORMORE                                                                                                                     
   ,ZIP.ZIP_PCTMARRIED                                                                                                                              
   ,ZIP.ZIP_PCTFAMHHS                                                                                                                               
   ,ZIP.ZIP_PCTSINGLEFEMALEFAMILIES                                                                                                                 
   ,ZIP.ZIP_PCTRENTEROCC                                                                                                                            
  from                                                                                                                                              
    cos.zip_demographics as zip left join cos.adr_address as adr                                                                                    
  on                                                                                                                                                
    zip.zip_zcta5   = adr.zcta and                                                                                                                  
    adr.prvdr_num   in  (/*'335834',*/ '365787' ,'345508')                                                                                          
                                                                                                                                                    
;quit;                                                                                                                                              
                                                                                                                                                    
/* get celreportKeys for providers 365787, 335834 - for index on fact table*/                                                                       
                                                                                                                                                    
proc sql;                                                                                                                                           
  select                                                                                                                                            
      cel_reportKey into :_keys separated by ","                                                                                                    
  from                                                                                                                                              
      dem_365787                                                                                                                                    
  order                                                                                                                                             
      by cel_reportKey                                                                                                                              
;quit;                                                                                                                                              
                                                                                                                                                    
%put &_keys;                                                                                                                                        
                                                                                                                                                    
/* add labels */                                                                                                                                    
                                                                                                                                                    
proc sql;                                                                                                                                           
  create                                                                                                                                            
      table fac_365787 as                                                                                                                           
  select                                                                                                                                            
      l.*                                                                                                                                           
       ,put(l.cel_reportKey,rptKey2prvdr.) as prvdr_num                                                                                             
       ,r.col_description                                                                                                                           
  from                                                                                                                                              
     cos.cel_cellvalue as l, cos.col_describe as r                                                                                                  
  where                                                                                                                                             
     cel_reportKey in (&_keys) and                                                                                                                  
     ((cel_name eqt "G0") or (cel_name in                                                                                                           
          (                                                                                                                                         
           'S300001_00100_00100_N'                                                                                                                  
          ,'S300001_00100_00200_N'                                                                                                                  
          ,'S300001_00100_00700_N'                                                                                                                  
          ,'S300001_00100_01200_N'                                                                                                                  
          ,'S300001_00100_01600_N'                                                                                                                  
          ))) and                                                                                                                                   
     l.cel_name  = r.col_cel_name                                                                                                                   
;quit;                                                                                                                                              
                                                                                                                                                    
/*                                                                                                                                                  
INFO: Index CEL_REPORTKEY selected for WHERE clause optimization.                                                                                   
NOTE: Table WORK.FAC_365787 created, with 800 rows and 4 columns.                                                                                   
                                                                                                                                                    
5843!  quit;                                                                                                                                        
NOTE: PROCEDURE SQL used (Total process time):                                                                                                      
      real time           0.06 seconds                                                                                                              
                                                                                                                                                    
S200001_01500_00100_N                                                                                                                               
                                                                                                                                                    
proc print data=cos.col_describe;                                                                                                                   
var col_description;                                                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
Numberof Beds                            @S300001_00100_00100_N                                                                                     
BedDays Available                        @S300001_00100_00200_N                                                                                     
Inpatient_DaysAll Total                  @S300001_00100_00700_N                                                                                     
DischargAll Total                        @S300001_00100_01200_N                                                                                     
LOSAll Total                             @S300001_00100_01600_N                                                                                     
                                                                                                                                                    
Inpatient_DaysTitle V                    @S300001_00100_00300_N                                                                                     
Inpatient_DaysTitle XVIII                @S300001_00100_00400_N                                                                                     
Inpatient_DaysTitle XIX                  @S300001_00100_00500_N                                                                                     
Inpatient_DaysAll Other                  @S300001_00100_00600_N                                                                                     
DischargTitle V                          @S300001_00100_00800_N                                                                                     
DischargTitle XVIII                      @S300001_00100_00900_N                                                                                     
DischargTitle XIX                        @S300001_00100_01000_N                                                                                     
DischargAll Other                        @S300001_00100_01100_N                                                                                     
LOSTitle V                               @S300001_00100_01300_N                                                                                     
LOSTitle XVIII                           @S300001_00100_01400_N                                                                                     
LOSTitle XIX                             @S300001_00100_01500_N                                                                                     
AdmitTitle V                             @S300001_00100_01700_N                                                                                     
*/                                                                                                                                                  
                                                                                                                                                    
proc transpose data=fac_365787 out=xpo_365787 (drop=_label_ _name_);                                                                                
  by cel_reportKey;                                                                                                                                 
  var cel_value;                                                                                                                                    
  id cel_name;                                                                                                                                      
  idlabel col_description;                                                                                                                          
run;quit;                                                                                                                                           
                                                                                                                                                    
                                                                                                                                                    
proc sql;                                                                                                                                           
  create                                                                                                                                            
     table pre_365787(where=(prvdr_num ne "335834")) as                                                                                             
  select                                                                                                                                            
     l.*                                                                                                                                            
     ,input(l.FY_BGN_DT,mmddyy10.) as FiscalBegin format=mmddyy10.                                                                                  
    ,r.*                                                                                                                                            
  from                                                                                                                                              
     dem_365787 as l, xpo_365787 as r                                                                                                               
  where                                                                                                                                             
     l.cel_reportKey = r.cel_reportKey                                                                                                              
  order                                                                                                                                             
     by prvdr_num, input(l.FY_BGN_DT,mmddyy10.)                                                                                                     
;quit;                                                                                                                                              
                                                                                                                                                    
%utl_optlen(inp=pre_365787,out=pre_365787);                                                                                                         
                                                                                                                                                    
* convert to numeric;                                                                                                                               
                                                                                                                                                    
%utlnopts;                                                                                                                                          
%array(nms,values=%utl_varlist(pre_365787,prx=/_N$/i));                                                                                             
                                                                                                                                                    
                                                                                                                                                    
%utlnopts;                                                                                                                                          
proc sql;                                                                                                                                           
  create                                                                                                                                            
    table num_365787 as                                                                                                                             
  select                                                                                                                                            
    %do_over(nms,phrase=%nrstr(                                                                                                                     
        input(?,best16.) as ? format=comma16. label="%qsysfunc(putc(?,cel2lbl.))"),between=comma)                                                   
   ,*                                                                                                                                               
  from                                                                                                                                              
    pre_365787                                                                                                                                      
;quit;                                                                                                                                              
%utlopts;                                                                                                                                           
                                                                                                                                                    
data get_365787;                                                                                                                                    
 retain                                                                                                                                             
         COSTREPORT                                                                                                                                 
         YEAR                                                                                                                                       
         CEL_REPORTKEY                                                                                                                              
         PRVDR_NUM                                                                                                                                  
         ZIP5                                                                                                                                       
         zip_zcta5                                                                                                                                  
         FY_BGN_DT                                                                                                                                  
         FY_END_DT                                                                                                                                  
         S200001_00400_00100_C                                                                                                                      
         S200001_00300_00300_C                                                                                                                      
         S200001_00100_00100_C                                                                                                                      
         S200001_00200_00100_C                                                                                                                      
         S200001_00300_00100_C                                                                                                                      
         S200001_00200_00200_C                                                                                                                      
         S200001_00200_00300_C                                                                                                                      
         S200001_00300_00200_C                                                                                                                      
         ZIP_STATE                                                                                                                                  
         ZIP_TOTPOP                                                                                                                                 
         ZIP_MEDIANAGE                                                                                                                              
         ZIP_PCTOVER65MALES                                                                                                                         
         ZIP_PCTBLACK1                                                                                                                              
         ZIP_AVGHHINC                                                                                                                               
         ZIP_MEDIANHHINC                                                                                                                            
         ZIP_MEDIANGROSSRENT                                                                                                                        
         ZIP_PCTOVER65                                                                                                                              
         ZIP_PCTPOOR                                                                                                                                
         ZIP_PCTNUMHHFOODSTMP                                                                                                                       
         ZIP_PCTLABORFORCE                                                                                                                          
         ZIP_PCTPROFESSIONAL                                                                                                                        
         ZIP_PCTNOINTERNET                                                                                                                          
         ZIP_PCTVEHICLES2                                                                                                                           
         ZIP_PCTBORNINUS                                                                                                                            
         ZIP_PCTHIGHSCHOOLORMORE                                                                                                                    
         ZIP_PCTMARRIED                                                                                                                             
         ZIP_PCTFAMHHS                                                                                                                              
         ZIP_PCTSINGLEFEMALEFAMILIES                                                                                                                
         ZIP_PCTRENTEROCC                                                                                                                           
         S300001_00100_00100_N                                                                                                                      
         S300001_00100_00200_N                                                                                                                      
         S300001_00100_00700_N                                                                                                                      
         S300001_00100_01200_N                                                                                                                      
         S300001_00100_01600_N                                                                                                                      
  ;                                                                                                                                                 
  set num_365787(drop=ZIP_NOCOMPUTER drop=FISCALBEGIN zcta) ;                                                                                       
     format                                                                                                                                         
         ZIP_PCTOVER65                                                                                                                              
         ZIP_PCTPOOR                                                                                                                                
         ZIP_PCTNUMHHFOODSTMP                                                                                                                       
         ZIP_PCTLABORFORCE                                                                                                                          
         ZIP_PCTPROFESSIONAL                                                                                                                        
         ZIP_PCTNOINTERNET                                                                                                                          
         ZIP_PCTVEHICLES2                                                                                                                           
         ZIP_PCTBORNINUS                                                                                                                            
         ZIP_PCTHIGHSCHOOLORMORE                                                                                                                    
         ZIP_PCTMARRIED                                                                                                                             
         ZIP_PCTFAMHHS                                                                                                                              
         ZIP_PCTSINGLEFEMALEFAMILIES                                                                                                                
         ZIP_PCTRENTEROCC             5.1                                                                                                           
     ;                                                                                                                                              
   drop G000000_00200_00100_N -- G000000_04700_00500_N;                                                                                             
run;quit;                                                                                                                                           
                                                                                                                                                    
%utlfkil("&gbl_root:\cos\xls\cos_250&gbl_typ.&_yrs..xlsx");                                                                                         
                                                                                                                                                    
%utlopts;                                                                                                                                           
ods excel file="&gbl_root:\cos\xls\cos_250&gbl_typ.&_yrs..xlsx";                                                                                    
proc report data=get_365787 nowd missing split="@" style(column)={cellwidth=5in};                                                                   
title "Comparison of a Large Skilled Nursin Facilities in A Rich and Poor Zipcode";                                                                 
define Year       / "Source CSV@File Year";                                                                                                         
define CostReport / "CostReport";                                                                                                                   
define Prvdr_num  / "Provide CCN";                                                                                                                  
define Cel_reportKey  / "Report@Record Number";                                                                                                     
define zip5  / "Zipcode";                                                                                                                           
define zip_zcta5  / "Census Zip@Tabulation@Area";                                                                                                   
define S200001_00300_00300_C  / style={just=center};                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
ods excel close;                                                                                                                                    
%mend cos_250;                                                                                                                                      
;;;;                                                                                                                                                
run;quit;                                                                                                                                           
                                                                                                                                                    
%end;                                                                                                                                               
                                                                                                                                                    
%*cos_250;                                                                                                                                          
                                                                                                                                                    
                                                                                                                                                    
/*              _                   _         __ _ _                                                                                                
  ___ _ __   __| |  _ __ ___   __ _| | _____ / _(_) | ___                                                                                           
 / _ \ '_ \ / _` | | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \                                                                                          
|  __/ | | | (_| | | | | | | | (_| |   <  __/  _| | |  __/                                                                                          
 \___|_| |_|\__,_| |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|                                                                                          
*/                                                                                                                                                  
