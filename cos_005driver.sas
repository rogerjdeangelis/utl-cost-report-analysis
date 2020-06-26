*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cos_005driver;                                                                                      *;
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
*  Tables created by repo https://github.com/rogerjdeangelis/CostReports                                        *;
*  or                                                                                                           *;
*                                                                                                               *;
*  * You need to either download cos.exe or run cst_000makefile.sas,                                            *;
*        cst_005driver.sas, cos_makefile and cos_driver                                                         *;
*                                                                                                               *;
*    cst repo is at https://github.com/rogerjdeangelis/CostReports                                              *;
*    cos repo is at https://github.com/rogerjdeangelis/utl-cost-report-analysis                                 *;
*                                                                                                               *;
*  * you can get cos.exe at                                                                                     *;
*                                                                                                               *;
*     D ropbox                                                                                                  *;
*     https://www.dropbox.com/s/x068gdpm6uygwe5/cos.exe?dl=0                                                    *;
*                                                                                                               *;
*     Google Drive                                                                                              *;
*     https://drive.google.com/file/d/1WWVK_8bm9lBFvFN54D46S6GUkT17X_BM/view?usp=sharing                        *;
*                                                                                                               *;
*     MS OneDrive                                                                                               *;
*     https://1drv.ms/u/s!AoqaX8I7j_icglMn-H01psG-mPQf?e=u4MkB3                                                 *;
*  ;                                                                                                            *;
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
*    Modules     (note this just saves and compiles the code)                                                   *;
*    Sequentially                                                                                               *;
*                                                                                                               *;
*    cos_000     * makefile - after running this you should be able to execute the module driver;               *;
*    cos_005     * driver                                                                                       *;
*    cos_050     * zip 2 to zcta                                                                                *;
*    cos_100     * copy celval 10gb                                                                             *;
*    cos_125     * copy cst tables (from previous repo)                                                         *;
*    cos_150     * create zip_demographics table                                                                *;
*    cos_200     * simple excel puf example                                                                     *;
*    cos_250     * more complex excel puf example                                                               *;
*                                                                                                               *;
*                                                                                                               *;
* WorkSheets                                                                                                   *;
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
| `_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \
| | | | | | (_| |   <  __/  _| | |  __/
|_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|

Module cos_000.sas is the SAS makefile
It `compiles` all the modules needed to run the driver program.
Users need to run this first and then they can run a short list
of mudules using the `module` driver.
Users can also change and `recompile` a module by editing the source
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
 / _ \ \/ / __/ _ \ `__| `_ \ / _` | / __|
|  __/>  <| ||  __/ |  | | | | (_| | \__ \
 \___/_/\_\\__\___|_|  |_| |_|\__,_|_|___/
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
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
             _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
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
 CEL2LBL                       Cell to Description ie S200001_00200_00200_C to State@S200001_00200_00200_C)`
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
     _      _                                   __ _
  __| |_ __(_)_   _____ _ __    ___ ___  _ __  / _(_) __ _
 / _` | `__| \ \ / / _ \ `__|  / __/ _ \| `_ \| |_| |/ _` |
| (_| | |  | |\ V /  __/ |    | (_| (_) | | | |  _| | (_| |
 \__,_|_|  |_| \_/ \___|_|     \___\___/|_| |_|_| |_|\__, |
                                                     |___/
*/

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
     gbl_zipcode / nowarn;
;


%let gbl_tok       =  cos                 ;   * token and part of root;
%let gbl_pretok    =  cst                 ;   * token and part of root;
%let gbl_typ       =  snf                 ;   * skilled nursing facilities;

%let gbl_yrs       =  2011-2019           ;   * years to process;

%let gbl_zipzcta   =  1                   ;   * create zip to zcta lookup;
%let gbl_ziptbl    =  1                   ;   * create zip to zcta lookup;
%let gbl_cstcop    =  1                   ;   * copy tables from previous cst repo;
%let gbl_celval    =  0                   ;   * copy tables from previous cst repo;

%let gbl_example1  = 1                    ;   * example1 excel puf;
%let gbl_example2  = 1                    ;   * example1 excel puf;

%let gbl_root      =  m                   ;   * where things are;
%let gbl_oto       =  &gbl_root:/cos/oto  ;   * autocall library;

%let gbl_zipcode   =  http://mcdc.missouri.edudata/acs2018/uszctas5yr.sas7bdat recfm=n lrecl=256;

%let _yrs=%qsysfunc(compress(&gbl_yrs,%str(-)));
%let _yrs=%unquote(&_yrs);

libname cos "&gbl_root:/&gbl_tok";
libname cst "&gbl_root:/cst";

%inc "&gbl_root:/cos/oto/cos_010.sas" / nosource;

options sasautos=(sasautos "&gbl_root:/cos/oto")
       fmtsearch=(work.formats cos.cos_fmtv1a) ;

/*   _      ____      _
 ___(_)_ __|___ \ ___| |_ ___ __ _
|_  / | `_ \ __) |_  / __/ __/ _` |
 / /| | |_) / __/ / /| || (_| (_| |
/___|_| .__/_____/___|\__\___\__,_|
      |_|
*/

%if &gbl_zipzcta %then %do;

  %cos_050;

%end;

/*        _            _
  ___ ___| |_   ____ _| |
 / __/ _ \ \ \ / / _` | |
| (_|  __/ |\ V / (_| | |
 \___\___|_| \_/ \__,_|_|

*/

%if &gbl_celval %then %do;

  %cos_100

%end;

/*        _
  ___ ___| |_ ___ ___  _ __
 / __/ __| __/ __/ _ \| `_ \
| (__\__ \ || (_| (_) | |_) |
 \___|___/\__\___\___/| .__/
                      |_|
*/

* copy the SAS tables you created with the cst repository;

%if &gbl_cstcop %then %do;

   %cos_125;

%end;

/*   _       _   _     _
 ___(_)_ __ | |_| |__ | |
|_  / | `_ \| __| `_ \| |
 / /| | |_) | |_| |_) | |
/___|_| .__/ \__|_.__/|_|
      |_|
*/

%if &gbl_ziptbl %then %do;

  %cos_150;

%end;

/*                              _      _
  _____  ____ _ _ __ ___  _ __ | | ___/ |
 / _ \ \/ / _` | `_ ` _ \| `_ \| |/ _ \ |
|  __/>  < (_| | | | | | | |_) | |  __/ |
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_|
                         |_|
*/

%if &gbl_example1 %then %do;

  %cos_200;

%end;

/*                              _      ____
  _____  ____ _ _ __ ___  _ __ | | ___|___ \
 / _ \ \/ / _` | `_ ` _ \| `_ \| |/ _ \ __) |
|  __/>  < (_| | | | | | | |_) | |  __// __/
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_____|
                         |_|
*/

%if &gbl_example2 %then %do;

  %cos_250;

%end;

/*              _       _      _
  ___ _ __   __| |   __| |_ __(_)_   _____ _ __
 / _ \ `_ \ / _` |  / _` | `__| \ \ / / _ \ `__|
|  __/ | | | (_| | | (_| | |  | |\ V /  __/ |
 \___|_| |_|\__,_|  \__,_|_|  |_| \_/ \___|_|

*/
