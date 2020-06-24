*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cos_000driver;                                                                                      *;
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
*/




/*   _      _                                   __ _
  __| |_ __(_)_   _____ _ __    ___ ___  _ __  / _(_) __ _
 / _` | '__| \ \ / / _ \ '__|  / __/ _ \| '_ \| |_| |/ _` |
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
     gbl_zipcode
;


%let gbl_tok      =  cos                 ;   * token and part of root;
%let gbl_pretok   =  cst                 ;   * token and part of root;
%let gbl_typ      =  snf                 ;   * skilled nursing facilities;

%let gbl_yrs       =  2011-2019          ;   * years to process;

%let gbl_ziptbl   =  1                   ;   * create zip to zcta lookup;
%let gbl_cstcop   =  1                   ;   * copy tables from previous cst repo;

%let gbl_example1  = 1                   ;   * example1 excel puf;
%let gbl_example2  = 1                   ;   * example1 excel puf;

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

libname cos "d:/&gbl_tok";
libname cst "d:/cst";

%utlnopts;
%inc "d:/cst/oto/cst_010.sas" / nosource;

options sasautos=(sasautos "&gbl_root:/cos/oto")
       fmtsearch=(work.formats cos.cos_fmtv1a) ;

/*                                _     _        _     _
  ___ ___  _ __  _   _    ___ ___| |_  | |_ __ _| |__ | | ___  ___
 / __/ _ \| '_ \| | | |  / __/ __| __| | __/ _` | '_ \| |/ _ \/ __|
| (_| (_) | |_) | |_| | | (__\__ \ |_  | || (_| | |_) | |  __/\__ \
 \___\___/| .__/ \__, |  \___|___/\__|  \__\__,_|_.__/|_|\___||___/
          |_|    |___/
*/

* copy the SAS tables you created with the cst repository

%if &gbl_cstcop %then %do;

   %cos_100;

%end;

/*   _       _   _     _
 ___(_)_ __ | |_| |__ | |
|_  / | '_ \| __| '_ \| |
 / /| | |_) | |_| |_) | |
/___|_| .__/ \__|_.__/|_|
      |_|
*/

%if &gbl_ziptbl %then %do;

  %cos_150;

%end;

/*                              _      _
  _____  ____ _ _ __ ___  _ __ | | ___/ |
 / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ |
|  __/>  < (_| | | | | | | |_) | |  __/ |
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_|
                         |_|
*/

%if &gbl_example1 %then %do;

  %cos_200;

%end;

/*                              _      ____
  _____  ____ _ _ __ ___  _ __ | | ___|___ \
 / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ __) |
|  __/>  < (_| | | | | | | |_) | |  __// __/
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|_____|
                         |_|
*/

%if &gbl_example2 %then %do;

  %cos_200;

%end;

/*              _       _      _
  ___ _ __   __| |   __| |_ __(_)_   _____ _ __
 / _ \ '_ \ / _` |  / _` | '__| \ \ / / _ \ '__|
|  __/ | | | (_| | | (_| | |  | |\ V /  __/ |
 \___|_| |_|\__,_|  \__,_|_|  |_| \_/ \___|_|

*/










































   *           _     _                _
    _ __ _ __ | |_  | | _____ _   _  | |_ ___    _   _  ___  __ _ _ __
   | '__| '_ \| __| | |/ / _ \ | | | | __/ _ \  | | | |/ _ \/ _` | '__|
   | |  | |_) | |_  |   <  __/ |_| | | || (_) | | |_| |  __/ (_| | |
   |_|  | .__/ \__| |_|\_\___|\__, |  \__\___/   \__, |\___|\__,_|_|
        |_|                   |___/              |___/


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

   *          _                _     _
     __ _  __| |_ __  __ _  __| | __| |_ __ ___  ___ ___
    / _` |/ _` | '__|/ _` |/ _` |/ _` | '__/ _ \/ __/ __|
   | (_| | (_| | |  | (_| | (_| | (_| | | |  __/\__ \__ \
    \__,_|\__,_|_|___\__,_|\__,_|\__,_|_|  \___||___/___/
                |_____|
   ;

   proc sort data=cos_100tblrptnunalp out=cos_100tblrpunq;
     by cel_reportKey;
   run;quit;

   /*
   data tst;
     set COS_100TBLRPUNQ (where=(yer ne '' and cel_name ="FY_BGN_DT" ));
     if yer ne substr(cel_value,9) then do; output; stop; end;
   run;quit;
   */

   proc format cntlin=cos.zct_zip2zcta lib=cos.cos_fmtv1a;
   run;quit;

   proc transpose data=cos_100tblrpunq out=cos_100tblrpunqxpo (drop=_name_ _label_ );
     by  cel_reportKey;
     var cel_value;
     id cel_name;
     idlabel idlabel;
   run;quit;

 /*
    idlabel=put(cel_name,$cel2lbl.);

   data cos_100fmtlbl;
     retain fmtname '$cel2lbl';
     set cos.col_describe ( rename=(col_cel_name=start col_description=label));
   run;quit;

   proc format cntlin=cos_100fmtlbl;
   run;quit;
 */

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






















%if &gbl_report %hen %do;


  data cst_150&gbl_typ.rpt%qsysfunc(compress(&gbl_yrs,%str(-)));
      set cst.cst_150&gbl_typ.rpt%qsysfunc(compress(&gbl_yrs,%str(-)));
  run;quit;




















    *                          _                      _        _     _
     _ __ ___ _ __   ___  _ __| |_    ___ _____   __ | |_ __ _| |__ | | ___
    | '__/ _ \ '_ \ / _ \| '__| __|  / __/ __\ \ / / | __/ _` | '_ \| |/ _ \
    | | |  __/ |_) | (_) | |  | |_  | (__\__ \\ V /  | || (_| | |_) | |  __/
    |_|  \___| .__/ \___/|_|   \__|  \___|___/ \_/    \__\__,_|_.__/|_|\___|
             |_|
    ;

   * overkill for now because SAS tend to lock files;
   filename download clear;
   filename download "&gbl_root:/cos/zip/cst_150snfrpt20112019.zip";
   proc http
      method='GET'
      url="https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_150snfrpt20112019.zip"
      out=download;
   run;quit;
   filename download clear;

   %let cmd=%str(powershell expand-archive -path &gbl_root:/cos/zip/cst_150&gbl_typ.rpt20112019.zip -destinationpath %sysfunc(pathname(work)));
   %put &=cmd;
   options xwait xsync;run;quit;
   systask kill _ps1;
   systask command "&cmd" taskname=_ps1;
   waitfor _ps1;








































   proc append data=cst.cst_200&gbl_typ.max%qsysfunc(compress(&gbl_yrs,%str(-)))
               base=cst.cst_200&gbl_typ.max%qsysfunc(compress(&gbl_yrs,%str(-)))










%end;

    proc sort data=cos.cel_cellValue noequals;
    by


    *
    you need to manually download and unzip cos.exe form

    Dropbox
    https://www.dropbox.com/s/x068gdpm6uygwe5/cos.exe?dl=0

    Google Drive
    https://drive.google.com/file/d/1WWVK_8bm9lBFvFN54D46S6GUkT17X_BM/view?usp=sharing

    MS OneDrive
    https://1drv.ms/u/s!AoqaX8I7j_icglMn-H01psG-mPQf?e=u4MkB3
    ;

    *_                                                    _
    | |__   __ ___   __  _ __ _   _ _ __     ___ ___  ___| |_
    | '_ \ / _` \ \ / / | '__| | | | '_ \   / __/ _ \/ __| __|
    | | | | (_| |\ V /  | |  | |_| | | | | | (_| (_) \__ \ |_
    |_| |_|\__,_| \_/   |_|   \__,_|_| |_|  \___\___/|___/\__|

    ;

    libname cst "&gbl_root"/cst";
     /*
     These file should be avaiable after runing the CostReport rep
     cst_025snfdescribe
     cst_025snfmax
     cst_200snffiv20112019
     */

    options compress=char;
    libname cst "d:/cst";
    data cos.cel_cellValue;
       set cst.cst_200snffiv20112019 (
            keep=rpt_rec_num cstnam cstval
            rename=(
                    rpt_rec_num = cel_reportKey
                    cstnam      = cel_name
                    cstval      = cel_value
                   ));
            label cel_name = "Report-Key Worksheet lineNumber column";
    run;quit;

   *_           _                            _
   (_)_ __   __| | _____  __  ___  ___  _ __| |_
   | | '_ \ / _` |/ _ \ \/ / / __|/ _ \| '__| __|
   | | | | | (_| |  __/>  <  \__ \ (_) | |  | |_
   |_|_| |_|\__,_|\___/_/\_\ |___/\___/|_|   \__|

   ;

   proc sort data=cos.cel_cellvalue out=cos.cel_cellvalue sortsize=80g;
      by cel_reportKey cel_name;
   run;quit;

   proc sql;
     create
        index cel_reportKey
     on
        cos.cel_cellvalue
   ;quit;

%end;


%if &gbl_req %then %do;

    * these are external to cst and cos;

    *           _     _                       _       _
      __ _  ___| |_  | |_ ___ _ __ ___  _ __ | | __ _| |_ ___
     / _` |/ _ \ __| | __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
    | (_| |  __/ |_  | ||  __/ | | | | | |_) | | (_| | ||  __/
     \__, |\___|\__|  \__\___|_| |_| |_| .__/|_|\__,_|\__\___|
     |___/                             |_|
    ;

    %if &gbl_make %then %do;

        filename _bcot "%sysfunc(pathname(work))/cst_200&gbl_typ.max20112019_sas7bdat.b64";
        proc http
           method='get'
           url="https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_200&gbl_typ.max20112019_sas7bdat.b64"
           out= _bcot;
        run;quit;

        %utl_b64decode(%sysfunc(pathname(work))/cst_200&gbl_typ.max20112019_sas7bdat.b64,%sysfunc(pathname(work))/tpl_template.sas7bdat);

        data cos.tpl_template;
            set tpl_template(rename=cstnam=tpl_cel_name);
        run;quit;

        %*utl_b64encode(d:/cst/cst_200snfmax20112019.sas7bdat,&gbl_root:/cos/b64/cst_200snfmax20112019_sas7bdat.b64);

    /*    _                     _ _
       __| | ___  ___  ___ _ __(_) |__   ___
      / _` |/ _ \/ __|/ __| '__| | '_ \ / _ \
     | (_| |  __/\__ \ (__| |  | | |_) |  __/
      \__,_|\___||___/\___|_|  |_|_.__/ \___|
    */

    * download b64 encoded sas dataset - github does nto support binary download wirg aoi key ;
    filename _bcot "&gbl_root:/cos/b64/cst_025&gbl_typ.describe_sas7bdat.b64";
    proc http
       method='get'
       url="&gbl_desinp"
       out= _bcot;
    run;quit;

    * Only run if descrition table changes;
    %*utl_b64encode(d:/cst/cst_025snfdescribe.sas7bdat,&gbl_root:/cos/b64/cst_025&gbl_typ.describe_sas7bdat.b64);

    %utl_b64decode(&gbl_root:/cos/b64/cst_025&gbl_typ.describe_sas7bdat.b64,%sysfunc(pathname(work))/col_describe.sas7bdat);


    data cos.col_describe;
         set col_describe(rename=(col_cel_description=col_description)) end=dne;
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

    /* check sas dataset
       libname cos "d:/cos";
       proc print data=cos.cst_025snfdescribe(obs=5);
       run;quit;
    */

     *    _      ____          _
      ___(_)_ __|___ \ _______| |_ __ _
     |_  / | '_ \ __) |_  / __| __/ _` |
      / /| | |_) / __/ / / (__| || (_| |
     /___|_| .__/_____/___\___|\__\__,_|
           |_|
     ;

    * download b64 encoded sas dataset - github does nto support binary download wirg aoi key ;
    * https://www.udsmapper.org/zcta-crosswalk.cfm  zip to zcta crosswalk ;
    filename _bcot "&gbl_root:/cos/b64/cst_025&gbl_typ.describe_sas7bdat.b64";

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


    /*   If the site is updated tou may want to rerun this;
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

%end;


%if &gbl_report %hen %do;

    *                          _                      _        _     _
     _ __ ___ _ __   ___  _ __| |_    ___ _____   __ | |_ __ _| |__ | | ___
    | '__/ _ \ '_ \ / _ \| '__| __|  / __/ __\ \ / / | __/ _` | '_ \| |/ _ \
    | | |  __/ |_) | (_) | |  | |_  | (__\__ \\ V /  | || (_| | |_) | |  __/
    |_|  \___| .__/ \___/|_|   \__|  \___|___/ \_/    \__\__,_|_.__/|_|\___|
             |_|
    ;


   set cst.cst_150&gbl_typ.rpt20112019

   * overkill for now because SAS tend to lock files;
   filename download clear;
   filename download "&gbl_root:/cos/zip/cst_150snfrpt20112019.zip";
   proc http
      method='GET'
      url="https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_150snfrpt20112019.zip"
      out=download;
   run;quit;
   filename download clear;

   %let cmd=%str(powershell expand-archive -path &gbl_root:/cos/zip/cst_150&gbl_typ.rpt20112019.zip -destinationpath %sysfunc(pathname(work)));
   %put &=cmd;
   options xwait xsync;run;quit;
   systask kill _ps1;
   systask command "&cmd" taskname=_ps1;
   waitfor _ps1;

   *         _ _                              ____    _       _          _
     ___ ___| | |  _ __   __ _ _ __ ___   ___|___ \  | | __ _| |__   ___| |
    / __/ _ \ | | | '_ \ / _` | '_ ` _ \ / _ \ __) | | |/ _` | '_ \ / _ \ |
   | (_|  __/ | | | | | | (_| | | | | | |  __// __/  | | (_| | |_) |  __/ |
    \___\___|_|_| |_| |_|\__,_|_| |_| |_|\___|_____| |_|\__,_|_.__/ \___|_|

   ;

   * get provider level information;
   proc transpose data=cst_150snfrpt20112019(drop=npi spec_ind)  out=cos_100tblrptxpo(
     rename=(rpt_rec_num=cel_reportKey  _name_=cel_name col1=cel_value));
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

%end;


















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


   *           _     _                _
    _ __ _ __ | |_  | | _____ _   _  | |_ ___    _   _  ___  __ _ _ __
   | '__| '_ \| __| | |/ / _ \ | | | | __/ _ \  | | | |/ _ \/ _` | '__|
   | |  | |_) | |_  |   <  __/ |_| | | || (_) | | |_| |  __/ (_| | |
   |_|  | .__/ \__| |_|\_\___|\__, |  \__\___/   \__, |\___|\__,_|_|
        |_|                   |___/              |___/
   ;

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

   /*
   data tst;
     set COS_100TBLRPUNQ (where=(yer ne '' and cel_name ="FY_BGN_DT" ));
     if yer ne substr(cel_value,9) then do; output; stop; end;
   run;quit;
   */

   proc format cntlin=cos.zct_zip2zcta lib=cos.cos_fmtv1a;
   run;quit;

   proc transpose data=cos_100tblrpunq out=cos_100tblrpunqxpo (drop=_name_ _label_ );
     by  cel_reportKey;
     var cel_value;
     id cel_name;
     idlabel idlabel;
   run;quit;

 /*
    idlabel=put(cel_name,$cel2lbl.);

   data cos_100fmtlbl;
     retain fmtname '$cel2lbl';
     set cos.col_describe ( rename=(col_cel_name=start col_description=label));
   run;quit;

   proc format cntlin=cos_100fmtlbl;
   run;quit;
 */

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













   *_           _                            _              _              _
   (_)_ __   __| | _____  __  ___  ___  _ __| |_    ___ ___| | __   ____ _| |_   _  ___
   | | '_ \ / _` |/ _ \ \/ / / __|/ _ \| '__| __|  / __/ _ \ | \ \ / / _` | | | | |/ _ \
   | | | | | (_| |  __/>  <  \__ \ (_) | |  | |_  | (_|  __/ |  \ V / (_| | | |_| |  __/
   |_|_| |_|\__,_|\___/_/\_\ |___/\___/|_|   \__|  \___\___|_|___\_/ \__,_|_|\__,_|\___|
                                                            |_____|
   ;

   proc sort data=cos.cel_cellvalue out=cos.cel_cellvalue sortsize=80g;
      by cel_reportKey cel_name;
   run;quit;

   proc sql;
     create
        index cel_reportKey
     on
        cos.cel_cellvalue
   ;quit;

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

%end;

*               _                   _         __ _ _
  ___ _ __   __| |  _ __ ___   __ _| | _____ / _(_) | ___
 / _ \ '_ \ / _` | | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \
|  __/ | | | (_| | | | | | | | (_| |   <  __/  _| | |  __/
 \___|_| |_|\__,_| |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|

;


libname cos "d:/cos";
libname cst "d:/cst";

%utlnopts;
%inc "d:/cst/oto/cst_010.sas" / nosource;

options fmtsearch=(work.formats cos.cos_fmtv1a) ;

* get demographic and geography for provider_   365787, 335834 ;

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

%utlopts;
ods excel file="&gbl_root:\cos\xls\cos_&gbl_typ.ccn335834_345508.xlsx";
proc report data=get_365787 nowd missing split="@" style(column)={cellwidth=5in};
title "Comparison of a Large Skilled Nursin Facilities in A Rich and Poor Zipcode";
define Year       / "Source CSV@File Year";
define CostReport / "CostReport";
define Prvdr_num  / "Provide CCN";
define Cel_reportKey  / "Provide_CCN";
define zip5  / "Zipcode";
define zip_zcta5  / "Census Zip@Tabulation@Area";
define S200001_00300_00300_C  / style={just=center};
run;quit;
ods excel close;


libname mysqllib mysql user=root password="sas28rlx" database=world port=3306;

*               _                             _
  ___ _ __   __| |   ___ ___  _ __ ___  _ __ | | _____  __
 / _ \ '_ \ / _` |  / __/ _ \| '_ ` _ \| '_ \| |/ _ \ \/ /
|  __/ | | | (_| | | (_| (_) | | | | | | |_) | |  __/>  <
 \___|_| |_|\__,_|  \___\___/|_| |_| |_| .__/|_|\___/_/\_\
                                       |_|
                                _
  _____  ____ _ _ __ ___  _ __ | | ___
 / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
|  __/>  < (_| | | | | | | |_) | |  __/
 \___/_/\_\__,_|_| |_| |_| .__/|_|\___|
                         |_|
;

options ls=255;
proc contents data=cos._all_;
run;quit;

proc catalog cat=cos.cos_fmtv1a;
contents;
run;quit;

proc datasets lib=cos;

 modify ADR_ADDRESS        (label="2011-Current unzipped report csvs from https://downloads.cms.gov/files/hcris/snf19fy####");
 modify CEL_CELLVALUE      (label="2011-Current alpha & numeric csvs csvs unzipped from https://downloads.cms.gov/files/hcris/snf19fy####");
 modify COL_DESCRIBE       (label="Descriptions for all the key cells in the pdf cost report workshhet line and column");
 modify RPV_REPORTPROVIDER (label="Master Report Record number (cel_reportKey) to Provider CCN aslo a format cel2lbl");
 modify TPL_TEMPLATE       (label="All possible cells. This assures all subsets will have all columns, even if the column is 100 percent mssing");
 modify ZCT_ZIP2ZCTA       (label="Zip Code to Census ZCTA. A ZTCA can span zips . One to many zip to zcta");
 modify ZIP_DEMOGRAPHICS   (label="SAS Census ZCTA level Demographics over 200 columns from http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat");

run;quit;


proc catalog c = cos.cos_fmtv1a;;
modify rptkey2prvdr.format(description ="Mapping of numeric Report Record Number to Provider Number 2011-Current ie 1023771 to 365787");
modify cel2lbl.formatc    (description = 'Cell to Description ie S200001_00200_00200_C to State@S200001_00200_00200_C")'
modify zip2zcta.formatc   (description = "Two DIFFERENT zipcodes can map to the same ZCTA, many to one. https://www.udsmapper.org/zcta-crosswalk.cfm" );
run;



* ____ ___  ____    ____   ____ _   _ _____ __  __    _
 / ___/ _ \/ ___|  / ___| / ___| | | | ____|  \/  |  / \
| |  | | | \___ \  \___ \| |   | |_| |  _| | |\/| | / _ \
| |__| |_| |___) |  ___) | |___|  _  | |___| |  | |/ ___ \
 \____\___/|____/  |____/ \____|_| |_|_____|_|  |_/_/   \_\

;



#  Name                  Label                                                                                                                  File Size

1  ADR_ADDRESS           2011-Current unzipped report csvs from https://downloads.cms.gov/files/hcris/snf19fy####                                    25MB
2  CEL_CELLVALUE         2011-Current alpha & numeric csvs csvs unzipped from https://downloads.cms.gov/files/hcris/snf19fy####                      10GB
   CEL_CELLVALUE         INDEX Report Record Number also sorted on Report Record Number (cel_reportKey)                                               1GB
3  COL_DESCRIBE          Descriptions for all the key cells in the pdf cost report workshhet line and column                                        448KB

4  COS_FMTV1A            COS Format Catalog                                                                                                          18MB
    RPTKEY2PRVDR         Mapping of numeric Report Record Number to Provider Number 2011-Current ie 1023771 to 365787");
    CEL2LBL              Cell to Description ie S200001_00200_00200_C to State@S200001_00200_00200_C")'
    ZIP2ZCTA             Two DIFFERENT zipcodes can map to the same ZCTA, many to one. https://www.udsmapper.org/zcta-crosswalk.cfm" );

5  RPV_REPORTPROVIDER    Master Report Record number (cel_reportKey) to Provider CCN aslo a format cel2lbl                                            5MB
6  TPL_TEMPLATE          All possible cells. This assures all subsets will have all columns, even if the column is 100 percent mssing               832KB
7  ZCT_ZIP2ZCTA          Zip Code to Census ZCTA. A ZTCA can span zips . One to many zip to zcta                                                      1MB
8  ZIP_DEMOGRAPHICS      SAS Census ZCTA level Demographics over 200 columns from http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat         115MB













%let pgm=utl-cost-report-analysis;

Cost report analysis

Cost Report and Cost Report Analysis Repositories are still under
development. The draft makefile and driver for this repository are
almost complete.

Cost Report Analysis
https://github.com/rogerjdeangelis/utl-cost-report-analysis

Cost Reports (related)
https://github.com/rogerjdeangelis/CostReports

Documentation
https://tinyurl.com/yc5mbn7g
https://github.com/rogerjdeangelis/utl-cost-report-analysis/blob/master/cst_design.pdf

Skilled Nursing Facility Worksheets
https://tinyurl.com/ycbv8d2j
https://github.com/rogerjdeangelis/utl-cost-report-analysis/blob/master/snf_worksheets.pdf

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

Skilled Nursing Facilities (2011-2019)

You need to download the SAS schema manually from Dropbox, Google Drive or MS OndDrive.
None of these sites support lights out programable downloading.

Unfortunately you need an account on one of these sites.

Github does not support large files.

You will have to manually  download 'cos.exe and run the selfextrating schema.

Note self extracting unziped SAS schema is about 15gb

Dropbox
https://www.dropbox.com/s/x068gdpm6uygwe5/cos.exe?dl=0

Google Drive
https://drive.google.com/file/d/1WWVK_8bm9lBFvFN54D46S6GUkT17X_BM/view?usp=sharing

MS OneDrive
https://1drv.ms/u/s!AoqaX8I7j_icglMn-H01psG-mPQf?e=u4MkB3



#  Name              File Size    Label

1  ADR_ADDRESS            25MB    2011-Current unzipped report csvs from https://downloads.cms.gov/files/hcris/snf19fy####
2  CEL_CELLVALUE          10GB    2011-Current alpha & numeric csvs csvs unzipped from https://downloads.cms.gov/files/hcris/snf19fy####
   CEL_CELLVALUE(Index)    1GB    INDEX Report Record Number also sorted on Report Record Number (cel_reportKey)
3  COL_DESCRIBE          448KB    Descriptions for all the key cells in the pdf cost report workshhet line and column

4  COS_FMTV1A (LOOKUPS)   18MB    COS Format Catalog
    RPTKEY2PRVDR                  Mapping of numeric Report Record Number to Provider Number 2011-Current ie 1023771 to 365787
    CEL2LBL                       Cell to Description ie S200001_00200_00200_C to State@S200001_00200_00200_C)'
    ZIP2ZCTA                      Two DIFFERENT zipcodes can map to the same ZCTA, many to one. https://www.udsmapper.org/zcta-crosswalk.cfm

5  RPV_REPORTPROVIDER      5MB    Master Report Record number (cel_reportKey) to Provider CCN aslo a format cel2lbl
6  TPL_TEMPLATE          832KB    All possible cells. This assures all subsets will have all columns, even if the column is 100 percent mssing
7  ZCT_ZIP2ZCTA            1MB    Zip Code to Census ZCTA. A ZTCA can span zips . One to many zip to zcta
8  ZIP_DEMOGRAPHICS      115MB    SAS Census ZCTA level Demographics over 200 columns from http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

d:/cos/xls/minxpo.xlsx

CEL_REPORTKEY  PROVIDER State  Component Name               Fiscal Begin Date    Skilled Nursing Facility  Skilled Nursing Facility  Skilled Nursing Facility ...
                                                          S200001_01400_00100_C  Numberof Beds             BedDays Available         Inpatient_DaysAll Total  ...
  1023771      365787  OH      ELISABETH PRENTISS CENTER    01/01/2011           S300001_00100_00100_N     S300001_00100_00200_N     S300001_00100_00700_N    ...

  1059963      365787  OH      ELISABETH PRENTISS CENTER    01/01/2012           150                       54,750                     50,392
  1096177      365787  OH      ELISABETH PRENTISS CENTER    01/01/2013           150                       54,900                     51,711
  1122812      365787  OH      ELISABETH PRENTISS CENTER    01/01/2014           150                       54,750                     51,803
  1146196      365787  OH      ELISABETH PRENTISS CENTER    01/01/2015           150                       54,750                     51,478
  1177041      365787  OH      ELISABETH PRENTISS CENTER    01/01/2016           150                       54,750                     51,097
  1221220      365787  OH      ELISABETH PRENTISS CENTER    01/01/2017           150                       54,900                     51,604
  1248336      365787  OH      ELISABETH PRENTISS CENTER    01/01/2018           150                       54,750                     48,294

  1022214      345508  NC      REX NURSING CENTER OF APEX   07/01/2011           150                       54,750                     43,726
  1088899      345508  NC      REX NURSING CENTER OF APEX   07/01/2012           107                       39,162                     35,343
  1123122      345508  NC      REX NURSING CENTER OF APEX   07/01/2013           107                       39,055                     36,352
  1160551      345508  NC      REX NURSING CENTER OF APEX   07/01/2014           107                       39,055                     36,455
  1150314      345508  NC      REX NURSING CENTER OF APEX   07/01/2015           107                       39,055                     37,191
  1179006      345508  NC      REX NURSING CENTER OF APEX   07/01/2016           107                       39,162                     36,679
  1217908      345508  NC      REX NURSING CENTER OF APEX   07/01/2017           107                       39,055                     36,864
  1247394      345508  NC      REX NURSING CENTER OF APEX   07/01/2018           107                       39,055                     36,653


Program for this output not posted yet

d:/cos/xls/cos_snfccn335834_345508

Demographics for with hundreds of columns from http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat
                                                                                                                                     Skilled Nursing Facility
CEL_REPORTKEY  PROVIDER State  Component Name               Fiscal Begin Date   Population Percent Mean household  Median household  Inpatient_Days All Total
                                                         S200001_01400_00100_C             Poor       Income         Income          S300001_00100_00700_N ...
                                                                                40,280                $126,029      $110,513
  1023771      365787  OH      ELISABETH PRENTISS CENTER    01/01/2011          40,280     5.6        $126,029      $110,513         35,343 ...
  1059963      365787  OH      ELISABETH PRENTISS CENTER    01/01/2012          40,280     5.6        $126,029      $110,513         36,352 ...
  1096177      365787  OH      ELISABETH PRENTISS CENTER    01/01/2013          40,280     5.6        $126,029      $110,513         36,455 ...
  1122812      365787  OH      ELISABETH PRENTISS CENTER    01/01/2014          40,280     5.6        $126,029      $110,513         37,191 ...
  1146196      365787  OH      ELISABETH PRENTISS CENTER    01/01/2015          40,280     5.6        $126,029      $110,513         36,679 ...
  1177041      365787  OH      ELISABETH PRENTISS CENTER    01/01/2016          40,280     5.6        $126,029      $110,513         36,864 ...
  1221220      365787  OH      ELISABETH PRENTISS CENTER    01/01/2017          40,280     5.6        $126,029      $110,513         35,123 ...
  1248336      365787  OH      ELISABETH PRENTISS CENTER    01/01/2018          40,280     5.6        $126,029      $110,513         32,513 ...

  1022214      345508  NC      REX NURSING CENTER OF APEX   07/01/2011          40,246     31.3       $43,657       $31,555          50,392 ...
  1088899      345508  NC      REX NURSING CENTER OF APEX   07/01/2012          40,246     31.3       $43,657       $31,555          51,711 ...
  1123122      345508  NC      REX NURSING CENTER OF APEX   07/01/2013          40,246     31.3       $43,657       $31,555          51,803 ...
  1160551      345508  NC      REX NURSING CENTER OF APEX   07/01/2014          40,246     31.3       $43,657       $31,555          52,478 ...
  1150314      345508  NC      REX NURSING CENTER OF APEX   07/01/2015          40,246     31.3       $43,657       $31,555          51,097 ...
  1179006      345508  NC      REX NURSING CENTER OF APEX   07/01/2016          40,246     31.3       $43,657       $31,555          51,604 ...
  1217908      345508  NC      REX NURSING CENTER OF APEX   07/01/2017          40,246     31.3       $43,657       $31,555          48,294 ...
  1247394      345508  NC      REX NURSING CENTER OF APEX   07/01/2018          40,246     31.3       $43,657       $31,555          43,726 ...



Skilled Nursing Facilities (2011-2019)
Inpatient Days

                2011  2012  2013  2014  2015  2016  2017  2018
               ---+-----+-----+-----+-----+-----+-----+-----+---
INPATIENT_DAYS |                                               |
        55,000 +        Inpatient Days Poor Zipcode            +  55,000
               |                                               |
               |                    * P                        |
               |        * P   * P         * P   * P            |
        50,000 +  * P                                          +  50,000
               |                                      * P      |
               |                                               |
               |                                               |
        45,000 +                                               +  45,000
               |                                            * P|
               |                                               |
               |                                               |
        40,000 +        Inpatient Days Rich Zipcode            +  40,000
               |                                               |
               |                    * R                        |
               |        * R   * R         * R   * R            |
        35,000 +  * R                                 * R      +  35,000
               |                                               |
               |                                            * R|
               |                                               |
        30,000 +                                               +  30,000
               |                                               |
               ---+-----+-----+-----+-----+-----+-----+-----+---
                2011  2012  2013  2014  2015  2016  2017  2018

                                     YEAR
*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

libname cos "d:/cos";

options fmtsearch=(work.formats, cos.cos_fmtv1a);

* Code to Create Mini excel file;

* suppose we know the provide CCN we are interested in;

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
%utlfkil(d:/cos/xls/minixpo.xlsx);

ods excel file="d:/cos/xls/minixpo.xlsx" style=pearl
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

proc print data=miniXpo label;
run;quit;

ods excel options(sheet_name="minixpo");
proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in} split='@';
cols _all_;
define S200001_01400_00100_C / order;
run;quit;

ods excel close;
ods listing;

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;

64    libname cos "d:/cos";
NOTE: Libref COS was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\cos
65    options fmtsearch=(work.formats, cos.cos_fmtv1a);
66    * Code to Create Mini excel file;
67    * suppose we know the provide CCN we are interested in;
68    proc sql ;
69       create
70         table mini as
71       select
72         cel_reportKey
73        ,put(cel_reportKey,Rptkey2prvdr.) as Provider
74        ,cel_name
75        ,cel_value
76        ,put(cel_name,$cel2lbl.) as excel_column_header
77      from
78         cos.cel_cellvalue
79      where
80         cel_name in(
81                  'S200001_00200_00200_C'
82                 ,'S200001_01400_00100_C'
83                 ,'S200001_00400_00100_C'
84                 ,'S200001_01400_00200_C'
85                 ,'S300001_00100_00100_N'
86                 ,'S300001_00100_00200_N'
87                 ,'S300001_00100_00700_N'
88                 ,'S300001_00100_01200_N'
89                 ,'S300001_00100_01600_N'
90            ) and
91              put(cel_reportKey,Rptkey2prvdr.)  in ('345508','365787')
92      order
93         by  cel_reportKey
94            ,provider
95            ,cel_name
96    ;
NOTE: SAS threaded sort was used.
NOTE: Table WORK.MINI created, with 144 rows and 5 columns.

96  !  quit;
NOTE: PROCEDURE SQL used (Total process time):
      real time           1:12.72
      user cpu time       14.76 seconds
      system cpu time     7.31 seconds
      memory              17406.68k
      OS Memory           36224.00k
      Timestamp           06/14/2020 09:44:46 AM
      Step Count                        21  Switch Count  2


97    proc transpose data=mini out=miniXpo(drop=_name_ _label_);
98       by cel_reportKey
99          provider;
100      var cel_value;
101      id cel_name;
102      idlabel excel_column_header;
103   run;

NOTE: There were 144 observations read from the data set WORK.MINI.
NOTE: The data set WORK.MINIXPO has 16 observations and 11 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.10 seconds
      user cpu time       0.00 seconds
      system cpu time     0.03 seconds
      memory              2553.84k
      OS Memory           23028.00k
      Timestamp           06/14/2020 09:44:46 AM
      Step Count                        22  Switch Count  0


104   ods listing close;
105   %utlfkil(d:/cos/xls/minixpo.xlsx);
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value d:/cos/xls/minixpo.xlsx
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to d:/cos/xls/minixpo.xlsx
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00176
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00176
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
106   ods excel file="d:/cos/xls/minixpo.xlsx" style=pearl
107   options(
108   sheet_name="red"
109   sheet_name='Definitions'
110   Frozen_headers= 'yes'
111   autofilter="all"
112   );
113   proc report data=cos.col_describe split="@" ;
NOTE: Writing HTML Body file: sashtml1.htm
114   cols  COL_CEL_NAME COL_DESCRIPTION;
115   define COL_DESCRIPTION / display;
116   run;

NOTE: Multiple concurrent threads will be used to summarize data.
NOTE: There were 1436 observations read from the data set COS.COL_DESCRIBE.
NOTE: PROCEDURE REPORT used (Total process time):
      real time           1.23 seconds
      user cpu time       1.07 seconds
      system cpu time     0.06 seconds
      memory              34803.84k
      OS Memory           59684.00k
      Timestamp           06/14/2020 09:44:48 AM
      Step Count                        23  Switch Count  1


116 !     quit;
117   ods excel options(sheet_name="minixpo");
118   proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in} split='@';
119   cols _all_;
120   define S200001_01400_00100_C / order;
121   run;

NOTE: Multiple concurrent threads will be used to summarize data.
NOTE: There were 16 observations read from the data set WORK.MINIXPO.
NOTE: PROCEDURE REPORT used (Total process time):
      real time           0.18 seconds
      user cpu time       0.12 seconds
      system cpu time     0.03 seconds
      memory              7161.68k
      OS Memory           43556.00k
      Timestamp           06/14/2020 09:44:48 AM
      Step Count                        24  Switch Count  0


121 !     quit;
122   ods excel close;
NOTE: Writing EXCEL file: d:/cos/xls\minixpo.xlsx





















































data have;
input year Inpatient_Days;
if _n_ le 8 then Zipcode="R";
else zipcode="P";
cards4;
2011 35343
2012 36352
2013 36455
2014 37191
2015 36679
2016 36864
2017 35123
2018 32513
2011 50392
2012 51711
2013 51803
2014 52478
2015 51097
2016 51604
2017 48294
2018 43726
;;;;
run;quit;

options ls=64 ps=32;
proc plot data=have ;
 plot Inpatient_Days*Year="*" $ zipcode / box;
run;quit;

















Mean household income
$126,029
$126,029
$126,029
$126,029
$126,029
$126,029
$126,029
$126,029
$43,657
$43,657
$43,657
$43,657
$43,657
$43,657
$43,657
$43,657



Median household income
$110,513
$110,513
$110,513
$110,513
$110,513
$110,513
$110,513
$110,513
$31,555
$31,555
$31,555
$31,555
$31,555
$31,555
$31,555
$31,555



Population
40,280
40,280
40,280
40,280
40,280
40,280
40,280
40,280

40,246
40,246
40,246
40,246
40,246
40,246
40,246



Percent
Poor

5.6
5.6
5.6
5.6
5.6
5.6
5.6
5.6

31.3
31.3
31.3
31.3
31.3
31.3
31.3
31.3


Skilled Nursing Facility
Inpatient_DaysAll Total
S300001_00100_00700_N

35,343
36,352
36,455
37,191
36,679
36,864
36,653
37,089

50,392
51,711
51,803
51,478
51,097
51,604
48,294
43,726

















libname cos "d:/cos";

options fmtsearch=(work.formats, cos.cos_fmtv1a);

* Code to Create Mini excel file;

* suppose we know the provide CCN we are interested in;

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
%utlfkil(d:/cos/xls/minixpo.xlsx);

ods excel file="d:/cos/xls/minixpo.xlsx" style=pearl
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

proc print data=miniXpo label;
run;quit;

ods excel options(sheet_name="minixpo");
proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in} split='@';
cols _all_;
define S200001_01400_00100_C / order;
run;quit;

ods excel close;
ods listing;


64    libname cos "d:/cos";
NOTE: Libref COS was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\cos
65    options fmtsearch=(work.formats, cos.cos_fmtv1a);
66    * Code to Create Mini excel file;
67    * suppose we know the provide CCN we are interested in;
68    proc sql ;
69       create
70         table mini as
71       select
72         cel_reportKey
73        ,put(cel_reportKey,Rptkey2prvdr.) as Provider
74        ,cel_name
75        ,cel_value
76        ,put(cel_name,$cel2lbl.) as excel_column_header
77      from
78         cos.cel_cellvalue
79      where
80         cel_name in(
81                  'S200001_00200_00200_C'
82                 ,'S200001_01400_00100_C'
83                 ,'S200001_00400_00100_C'
84                 ,'S200001_01400_00200_C'
85                 ,'S300001_00100_00100_N'
86                 ,'S300001_00100_00200_N'
87                 ,'S300001_00100_00700_N'
88                 ,'S300001_00100_01200_N'
89                 ,'S300001_00100_01600_N'
90            ) and
91              put(cel_reportKey,Rptkey2prvdr.)  in ('345508','365787')
92      order
93         by  cel_reportKey
94            ,provider
95            ,cel_name
96    ;
NOTE: SAS threaded sort was used.
NOTE: Table WORK.MINI created, with 144 rows and 5 columns.

96  !  quit;
NOTE: PROCEDURE SQL used (Total process time):
      real time           1:12.72
      user cpu time       14.76 seconds
      system cpu time     7.31 seconds
      memory              17406.68k
      OS Memory           36224.00k
      Timestamp           06/14/2020 09:44:46 AM
      Step Count                        21  Switch Count  2


97    proc transpose data=mini out=miniXpo(drop=_name_ _label_);
98       by cel_reportKey
99          provider;
100      var cel_value;
101      id cel_name;
102      idlabel excel_column_header;
103   run;

NOTE: There were 144 observations read from the data set WORK.MINI.
NOTE: The data set WORK.MINIXPO has 16 observations and 11 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.10 seconds
      user cpu time       0.00 seconds
      system cpu time     0.03 seconds
      memory              2553.84k
      OS Memory           23028.00k
      Timestamp           06/14/2020 09:44:46 AM
      Step Count                        22  Switch Count  0


104   ods listing close;
105   %utlfkil(d:/cos/xls/minixpo.xlsx);
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value d:/cos/xls/minixpo.xlsx
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to d:/cos/xls/minixpo.xlsx
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00176
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00176
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
106   ods excel file="d:/cos/xls/minixpo.xlsx" style=pearl
107   options(
108   sheet_name="red"
109   sheet_name='Definitions'
110   Frozen_headers= 'yes'
111   autofilter="all"
112   );
113   proc report data=cos.col_describe split="@" ;
NOTE: Writing HTML Body file: sashtml1.htm
114   cols  COL_CEL_NAME COL_DESCRIPTION;
115   define COL_DESCRIPTION / display;
116   run;

NOTE: Multiple concurrent threads will be used to summarize data.
NOTE: There were 1436 observations read from the data set COS.COL_DESCRIBE.
NOTE: PROCEDURE REPORT used (Total process time):
      real time           1.23 seconds
      user cpu time       1.07 seconds
      system cpu time     0.06 seconds
      memory              34803.84k
      OS Memory           59684.00k
      Timestamp           06/14/2020 09:44:48 AM
      Step Count                        23  Switch Count  1


116 !     quit;
117   ods excel options(sheet_name="minixpo");
118   proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in} split='@';
119   cols _all_;
120   define S200001_01400_00100_C / order;
121   run;

NOTE: Multiple concurrent threads will be used to summarize data.
NOTE: There were 16 observations read from the data set WORK.MINIXPO.
NOTE: PROCEDURE REPORT used (Total process time):
      real time           0.18 seconds
      user cpu time       0.12 seconds
      system cpu time     0.03 seconds
      memory              7161.68k
      OS Memory           43556.00k
      Timestamp           06/14/2020 09:44:48 AM
      Step Count                        24  Switch Count  0


121 !     quit;
122   ods excel close;
NOTE: Writing EXCEL file: d:/cos/xls\minixpo.xlsx





































































































































































































































































































































































































































































































































































































































































































































































































































































































































            ;;;;%end;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;



"Skilled Nursing Facility
Numberof Bed

S300001_00100_00100_N"      "Skilled Nursing Facility
BedDays Availabl

S300001_00100_00200_N"      "Skilled Nursing Facility
Inpatient_DaysAll Tota

S300001_00100_00700_N"      "Skilled Nursing Facility
DischargAll Tota]l

S300001_00100_01200_N"      "Skilled Nursing Facility
LOSAll Tota

S300001_00100_01600_N"      "Assets
Capital_Accounts
Ge

G000000_05200_00500_N"      "Assets
Capital_Accounts
Fund Balances (Sum Of Lines 52 Thru 58)
General


G000000_05900_00500_N"      "Assets
Capital_Accounts
And Fund Balances (Sum Of Lines 51 And 5

G000000_06000_00500_N"



S300001_00100_00100_N
S300001_00100_00200_N
S300001_00100_00700_N
S300001_00100_01200_N
S300001_00100_01600_N
G000000_05200_00100_N
G000000_05200_00500_N
G000000_05900_00100_N
G000000_05900_00500_N
G000000_06000_00100_N
G000000_06000_00500_N































































%


ods excel file="d:/cos/xls/cos/

options label;

proc report data=num_365787 nowd missing split='@';
  cols prvdr_num S200001_00400_00100_C year
      S300001_00100_00100_N S300001_00100_00200_N S300001_00100_00700_N S300001_00100_01200_N S300001_00100_01600_N;

define year                 /width=8  ;
define S200001_00400_00100_C/width=24 ;
define S300001_00100_00100_N/width=24 ;
define S300001_00100_00200_N/width=24 ;
define S300001_00100_00700_N/width=24 ;
define S300001_00100_01200_N/width=24 ;
define S300001_00100_01600_N/width=24 ;

run;quit;





ods excel close;

%symdel l z / nowarn;

%dosubl("
  data;
    z=put('S300001_00100_00100_N',cel2lbl.);
    put z=;
    idx=substr(z,index(z,'@'));
    call symputx('z',idx);
  run;"
);




  %let l=&z;);

%put &=l;

%put &=z;


%symdel l z /nowarn;
data x;
rc=dosubl("data;call symputx('z','Susan','G');run;");
re=symget('z');
put re=;
run;quit;
%put &=z;


%symdel l z /nowarn;
data x;
rc=dosubl(%tslit(data;call execute("data;call symputx('z','Susan','G');run;");run;quit;);
put "&z";
%put &=z;





















                        ;;;;%end;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;



%let l=&z;
");

%symdel l z /nowarn;
%let z=;
%let l=;


%symdel  z /nowarn;

%dosubl("
data _null_;
    call execute('%let z=Roger;');
run;quit;");
");
%put &=z;

%symdel r z /nowarn;

%dosubl(%tslit(
data _null_;
    data _null_;x='Susan';call symputx('z',x);run;quit;%let z=&z;run;quit;%let r=%nrstr(&z);));
run;quit;
);

%put &=r;



                  ;;;;%end;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;

                    "%substr(%sysfunc(%sysfunc(putc(S200001_00400_00100_C ,cel2lbl.))









data maxes;
  set cst.cst_200snfmax20112019full(where=(substr(cstnam,20)="_N" and cstnam =: "G0"));
  val=input(cstval,16.);
run;quit;

proc sort data=maxes;
by descending val;
run;quit;




proc sql;
  create
      table fac_365787 as
  select
      l.*
       ,r.col_description
  from
     cos.cel_cellvalue as l, cos.col_describe as r
  where
     cel_reportKey in (&_keys) and cel_name eqt "G0" and
     l.cel_name  = r.col_cel_name
;quit;

proc sql;
  create
      table fac_365787 as
  select
      l.*
      ,r.col_description
      ,put(cel_reportKey,
  from
     cos.cel_cellvalue as l, cos.col_describe as r
  where
     cel_reportKey in (&_keys) and cel_name eqt "G0" and
     l.cel_name  = r.col_cel_name
;quit;

































   1013366
   1023771
   1045804
   1059963
   1077594
   1096177
   1122812
   1146196

   1208121
   1221220
   1242125
   1248336


1013366  1013366
1023771  1023771
1045804  1045804
1059963  1059963
1077594  1077594
1096177  1096177
1108506
1122812  1122812
1140887
1146196  1146196
1175459
1177041  1177041
1208121  1208121
1221220  1221220
1242125  1242125
1248336  1248336



filename wyl (
"d:/snfold/csv/snf10_2011_NMRC.csv"
"d:/snfold/csv/snf10_2012_NMRC.csv"
"d:/snfold/csv/snf10_2013_NMRC.csv"
"d:/snfold/csv/snf10_2014_NMRC.csv"
"d:/snfold/csv/snf10_2015_NMRC.csv"
"d:/snfold/csv/snf10_2016_NMRC.csv"
"d:/snfold/csv/snf10_2017_NMRC.csv"
"d:/snfold/csv/snf10_2018_NMRC.csv"
"d:/snfold/csv/snf10_2019_NMRC.csv" );

data rptrecnum(drop=yer);
 length yr $64 year $4;
 infile wyl FILENAME=yr delimiter=",";
 yer=yr;
 year=substr(yer,21,4);

 informat
   RPT_REC_NUM best.;
 input
    RPT_REC_NUM;

 if RPT_REC_NUM in (&_keys) then do;
   lyn=_infile_;
   output;
 end;
run;quit;

proc sql;
  create
    table chk as
  select
     *
  from
    rptrecnum
  where
    index(lyn,'S200001,01500,00100')>0
;quit;

        RPT_REC_
 Obs       NUM

   1     1013366
   2     1023771
   3     1045804
   4     1059963
   5     1077594
   6     1096177
   7     1108506
   8     1122812
   9     1146196
  10     1175459
  11     1177041
  12     1208121
  13     1221220
  14     1242125
  15     1248336


  2011     1013366    1013366,G000000,03400,00100,1073481000
  2011     1023771    1023771,G000000,03400,00100,-11015158
  2012     1045804    1045804,G000000,03400,00100,1017264000
  2012     1059963    1059963,G000000,03400,00100,-15248072
  2013     1077594    1077594,G000000,03400,00100,1023912000
  2013     1096177    1096177,G000000,03400,00100,-17356308
  2014     1122812    1122812,G000000,03400,00100,-23220751
  2015     1146196    1146196,G000000,03400,00100,-26382780
  2016     1177041    1177041,G000000,03400,00100,-30806076
  2017     1208121    1208121,G000000,03400,00100,1309488000
  2017     1221220    1221220,G000000,03400,00100,2136732829
  2018     1242125    1242125,G000000,03400,00100,1347986000
  2018     1248336    1248336,G000000,03400,00100,4720695




























libname snf "d:/snf";
data tst;
  set snf.snf_216numalp16yersrt (keep=rpt_rec_num where=(rpt_rec_num in (1175459)));
run;quit;

data x;
   set cst.cst_150snfnumalp20112019(keep=rpt_rec_num  where=(rpt_rec_num in (1175459)));
run;quit;

Up to 40 obs WORK.TST total obs=18

       RPT_REC_                                PRVDR_
Obs       NUM      YER    SNFVAL                NUM             SNFNAM            CSVDATLEN

  1     1175459    16     X                    335834    S000001_00100_00100_C         1
  2     1175459    16     2                    335834    S000001_00400_00100_C         1
  3     1175459    16     06/05/2017           335834    S000001_00500_00100_C        10
  4     1175459    16     13001                335834    S000001_00600_00100_C         5
  5     1175459    16     N                    335834    S000001_00700_00100_C         1
  6     1175459    16     N                    335834    S000001_00800_00100_C         1
  7     1175459    16     08/31/2017           335834    S000001_00900_00100_C        10
  8     1175459    16     4                    335834    S000001_01100_00100_C         1
  9     1175459    16     L                    335834    S000001_01200_00100_C         1
 10     1175459    16     1031 MICHIGAN AVE    335834    S200001_00100_00100_C        17
 11     1175459    16     BUFFALO              335834    S200001_00200_00100_C         7
 12     1175459    16     NY                   335834    S200001_00200_00200_C         2
 13     1175459    16     14203-1019           335834    S200001_00200_00300_C        10
 14     1175459    16     ERIE                 335834    S200001_00300_00100_C         4
 15     1175459    16     KALEDA HEALTH        335834    S200001_00400_00100_C        13
 16     1175459    16     335834               335834    S200001_00400_00200_C         6
 17     1175459    16     12/05/2001           335834    S200001_00400_00300_C        10
 18     1175459    16     3                    335834    S200001_01500_00100_N         1


















                                             and snfnam ='S200001_01400_00100_C'

                                                                      cel_name=:'G000000_03400'))

proc sql;
                                  keep=rpt_rec_num
  create
     table val_365787 as
  select
     l.



     dem_365787 as dem,














proc sql;
  create
     table p335461_fac as
  select
     ce_reportKey
    ,provider

  from
     p335461_dem(keep=cel_reportKey) as l, cos.cel_cellvalue


ZIP.ZIP_STATE
ZIP.ZIP_TOTPOP
ZIP.ZIP_PCTOVER65
ZIP.ZIP_PCTOVER65MALES
ZIP.ZIP_PCTBLACK1
ZIP.ZIP_AVGHHINC
ZIP.ZIP_NUMHHFOODSTMP
ZIP.ZIP_POOR
ZIP.ZIP_PCTLABORFORCE
ZIP.ZIP_PCTPROFESSIONAL
ZIP.ZIP_MEDIANHVALUE
ZIP.ZIP_VEHICLES2
ZIP.ZIP_PCTVEHICLES2
ZIP.ZIP_PCTSPANISH
ZIP.ZIP_PCTBORNINUS
ZIP.ZIP_PCTHIGHSCHOOL
ZIP.ZIP_PCTHIGHSCHOOLORMORE
ZIP.ZIP_PCTMARRIED

 as r
  where
     l.cel_reportKey = r.cel_reportKey
;quit;


data maxes;
  set cst.cst_200snfmax20112019full(where=(substr(cstnam,20)="_N" and cstnam =: "G0"));
  val=input(cstval,16.);
run;quit;

proc sort data=maxes;
by descending val;
run;quit;

*               _
  ___ _ __   __| |
 / _ \ '_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

;










data G000000_03400;
  set cos.cel_cellvalue(where=(cel_reportKey in (
    1117271,
    1085531,
    1153201,
    1182931,
    1218369,
    1249864,
    1078907,
    1041276 )  and
       cel_name =: "G000000_03400"));
  cel_valuen=input(cel_value,best18.);
  prvdr=put(cel_reportKey,rpt2prv.);
  drop cel_value;
run;quit;


proc sql;
create
   table cos.p335461_all as
select
   r.*
  ,l.*
from
   p335461_dem as l, G000000_03400(where=(cel_name='G000000_03400_00400_N')) as r
where
   l.cel_reportKey = r.cel_reportKey
;quit;
































cos.adr_addresscos.adr_addresscos.adr_address































        CMD=powershell expand-archive -path d:/cos/zip/cst_150snfrpt20112019.zip -destinationpath d:\cst\;



                                 cst.cst_150snfrpt20112019



                               %put &=gbl_typ;



























%if &gbl_adr %then %do;

*          _                _
  __ _  __| |_ __  __ _  __| |_ __ ___  ___ ___
 / _` |/ _` | '__|/ _` |/ _` | '__/ _ \/ __/ __|
| (_| | (_| | |  | (_| | (_| | | |  __/\__ \__ \
 \__,_|\__,_|_|___\__,_|\__,_|_|  \___||___/___/
             |_____|
;
*         _ _   ____        _                     _ _
  ___ ___| | | |___ \    __| | ___  ___  ___ _ __(_) |__   ___
 / __/ _ \ | |   __) |  / _` |/ _ \/ __|/ __| '__| | '_ \ / _ \
| (_|  __/ | |  / __/  | (_| |  __/\__ \ (__| |  | | |_) |  __/
 \___\___|_|_| |_____|  \__,_|\___||___/\___|_|  |_|_.__/ \___|

;

/*
proc sort data=cos.col_describe out=cos_100tbldesallunq nodupkey;
by col_cel_name;
run;quit;
*/

data cos_100fmtlbl;
  retain fmtname '$cel2lbl';
  set cos.col_describe ( rename=(col_cel_name=start  col_description=label));
run;quit;

proc format cntlin=cos_100fmtlbl;
run;quit;

/*
WORK.COS_100TBLCHRVAL

#    Variable         Type    Len

1    CEL_REPORTKEY    Num       4
2    CEL_NAME         Char     21
3    CEL_VALUE        Char     40
*/

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


proc transpose data=cst.cst_150snfrpt20112019(drop=npi spec_ind)  out=cos_100tblrptxpo(drop=_label_
  rename=(rpt_rec_num=cel_reportKey  _name_=cel_name col1=cel_value));
by yer rpt_rec_num;
var _all_;
run;quit;

/*
#    Variable       Type

YER            Char      2
RPT_REC_NUM    Num       5
CEL_NAME       Char     18
CEL_VALUE      Char     12

*/

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

proc datasets lib = work ;
  modify cos_100tblrptnunalp ;
    attrib _all_ label = "" ;
    format _all_;
    informat _all_;
  run ;
quit ;

proc sort data=cos_100tblrptnunalp out=cos_100tblrpunq noequals;
  by cel_reportKey;
run;quit;

/*
proc print data=cos_100tblrpunq noequals
Up to 40 obs from COS_100TBLRPTNUNALP total obs=3,822,389

                      CEL_
    Obs    YEAR    REPORTKEY    CEL_NAME              CEL_VALUE

      1    2011     1000236     YER                   11
      2    2011     1000236     RPT_REC_NUM           1000236
      3    2011     1000236     PRVDR_CTRL_TYPE_CD    4
      4    2011     1000236     PRVDR_NUM             335257
      5    2011     1000236     RPT_STUS_CD           2
      6    2011     1000236     INITL_RPT_SW          N
      7    2011     1000236     LAST_RPT_SW           N
*/

proc transpose data=cos_100tblrpunq out=cos_100tblrpunqxpo (drop=_name_ _label_ );
  by  cel_reportKey;
  var cel_value;
  id cel_name;
  idlabel idlabel;
run;quit;

data cos.adr_address;
 length  COSTREPORT$3 year $4 CEL_REPORTKEY 5 PRVDR_NUM $10  zip5 $5 zcta$5;
 retain
 CostReport "SNF"
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
set
  cos_100tblrpunqxpo;
  zip5=substr(S200001_00200_00300_C,1,5);
  S200001_00200_00300_C=cats('09'x,S200001_00200_00300_C);
  zcta=put(zip5,$zip2zcta.);
  year=cats("20",yer);
  drop yer;
run;quit;


%utl_optlen(inp=cos.adr_address,out=cos.adr_address);

data cos.rpv_reportProvider;
  retain fmtname "rpt2prv";
  set cos.cos_150snfrpt20112019(keep=rpt_rec_num prvdr_num rename=(rpt_rec_num=start prvdr_num=label));
run;quit;










proc format cntlin=cos.rpv_reportProvider;
run;quit;

data chk;
    prvdr = put(1004268,rpt2prv.);
    put prvdr=;
run;quit;


data

data p335461;
  set cos.adr_address(where=(prvdr_num='335461'));
run;quit;

proc sql;
  create
    table p335461_dem(where=(costReport="SNF"))  as
  select
    r.*
   ,l.*
  from
    cos.zip_demographics as l left join p335461 as r
  on
    l.zcta5 = r.zcta
;quit;

data G000000_03400;
  set cos.cel_cellvalue(where=(cel_reportKey in (
    1117271,
    1085531,
    1153201,
    1182931,
    1218369,
    1249864,
    1078907,
    1041276 )  and
       cel_name =: "G000000_03400"));
  cel_valuen=input(cel_value,best18.);
  prvdr=put(cel_reportKey,rpt2prv.);
  drop cel_value;
run;quit;


proc sql;
create
   table cos.p335461_all as
select
   r.*
  ,l.*
from
   p335461_dem as l, G000000_03400(where=(cel_name='G000000_03400_00400_N')) as r
where
   l.cel_reportKey = r.cel_reportKey
;quit;






%end;

/*
 _              _
| |_ ___   ___ | |___
| __/ _ \ / _ \| / __|
| || (_) | (_) | \__ \
 \__\___/ \___/|_|___/
*/


%if &gbl_tool %then %do;

  filename _bcot "&gbl_oto/cos_010.sas";
  proc http
     method='get'
     url="&gbl_tools"
     out= _bcot;
  run;quit;

%end;

*                          _
 ___  __ _ ___  __ _ _   _| |_ ___  ___
/ __|/ _` / __|/ _` | | | | __/ _ \/ __|
\__ \ (_| \__ \ (_| | |_| | || (_) \__ \
|___/\__,_|___/\__,_|\__,_|\__\___/|___/
;

libname cos "&gbl_root:/cos";             * location of snowflake schema;
options sasautos=(sasautos,"&gbl_oto");   * autocall library;

*                          _ _        _              _
  ___ ___  _ __ ___  _ __ (_) | ___  | |_ ___   ___ | |___
 / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ | __/ _ \ / _ \| / __|
| (_| (_) | | | | | | |_) | | |  __/ | || (_) | (_) | \__ \
 \___\___/|_| |_| |_| .__/|_|_|\___|  \__\___/ \___/|_|___/
                    |_|
;

%put &=gbl_oto;

* compile utility macros;
filename cin "&gbl_oto/cos_010.sas" lrecl=4096 recfm=v;
%inc cin / nosource;

*           _                     _         __ _ _
  __ _  ___| |_   _ __ ___   __ _| | _____ / _(_) | ___
 / _` |/ _ \ __| | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \
| (_| |  __/ |_  | | | | | | (_| |   <  __/  _| | |  __/
 \__, |\___|\__| |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|
 |___/
;

%if &gbl_make %then %do;

    filename _bcot "&gbl_oto/cst_000makefile.sas";
    proc http
       method='get'
       url="&gbl_makefile"
       out= _bcot;
    run;quit;

%end;

*           _         _      _
  __ _  ___| |_    __| |_ __(_)_   _____ _ __
 / _` |/ _ \ __|  / _` | '__| \ \ / / _ \ '__|
| (_| |  __/ |_  | (_| | |  | |\ V /  __/ |
 \__, |\___|\__|  \__,_|_|  |_| \_/ \___|_|
 |___/
;

%if &gbl_drvr %then %do;

    filename _bcot "&gbl_oto/cst_005driver.sas";
    proc http
       method='get'
       url="&gbl_driver"
       out= _bcot;
    run;quit;

%end ;

/*
 _              _
| |_ ___   ___ | |___
| __/ _ \ / _ \| / __|
| || (_) | (_) | \__ \
 \__\___/ \___/|_|___/
*/


%if &gbl_tool %then %do;

  filename _bcot "&gbl_oto/cst_010.sas";
  proc http
     method='get'
     url="&gbl_tools"
     out= _bcot;
  run;quit;

%end;
*               _   _       _ _
  ___ _ __   __| | (_)_ __ (_) |_
 / _ \ '_ \ / _` | | | '_ \| | __|
|  __/ | | | (_| | | | | | | | |_
 \___|_| |_|\__,_| |_|_| |_|_|\__|
;


* status switches for module return codes.  These switches are '1' if the corresponding module executed without error;
* I choose to leave of '%if &cos_050=1 %then execute module cos_100 fornow;

%let cos_050   =0;
%let cos_100   =0;
%let cos_150   =0;
%let cos_150_1 =0;
%let cos_150_2 =0;
%let cos_150_3 =0;
%let cos_150_3 =0;
%let cos_150_4 =0;
%let cos_200   =0;
%let cos_250   =0;
%let cos_300   =0;
%let cos_350   =0;

* create create autocall folder in .cos/oto;

%if &gbl_dir %then %do;

  data _null_;

      newdir=dcreate('cos',"&gbl_root:/");
      newdir=dcreate('oto',"&gbl_root:/cos");   * autocall folder;

  run;quit;

%end /* create dir */;
*           _                     _         __ _ _
  __ _  ___| |_   _ __ ___   __ _| | _____ / _(_) | ___
 / _` |/ _ \ __| | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \
| (_| |  __/ |_  | | | | | | (_| |   <  __/  _| | |  __/
 \__, |\___|\__| |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|
 |___/
;

%if &gbl_make %then %do;

    filename _bcot "&gbl_oto/cos_000makefile.sas";
    proc http
       method='get'
       url="&gbl_makefile"
       out= _bcot;
    run;quit;

%end;

*           _         _      _
  __ _  ___| |_    __| |_ __(_)_   _____ _ __
 / _` |/ _ \ __|  / _` | '__| \ \ / / _ \ '__|
| (_| |  __/ |_  | (_| | |  | |\ V /  __/ |
 \__, |\___|\__|  \__,_|_|  |_| \_/ \___|_|
 |___/
;

%if &gbl_drvr %then %do;

    filename _bcot "&gbl_oto/cos_005driver.sas";
    proc http
       method='get'
       url="&gbl_driver"
       out= _bcot;
    run;quit;

%end ;

/*
 _              _
| |_ ___   ___ | |___
| __/ _ \ / _ \| / __|
| || (_) | (_) | \__ \
 \__\___/ \___/|_|___/
*/


%if &gbl_tool %then %do;

  filename _bcot "&gbl_oto/cos_010.sas";
  proc http
     method='get'
     url="&gbl_tools"
     out= _bcot;
  run;quit;

%end;

*                          _
 ___  __ _ ___  __ _ _   _| |_ ___  ___
/ __|/ _` / __|/ _` | | | | __/ _ \/ __|
\__ \ (_| \__ \ (_| | |_| | || (_) \__ \
|___/\__,_|___/\__,_|\__,_|\__\___/|___/
;

libname cos "&gbl_root:/cos";             * location of snowflake schema;
options sasautos=(sasautos,"&gbl_oto");   * autocall library;

*                          _ _        _              _
  ___ ___  _ __ ___  _ __ (_) | ___  | |_ ___   ___ | |___
 / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ | __/ _ \ / _ \| / __|
| (_| (_) | | | | | | |_) | | |  __/ | || (_) | (_) | \__ \
 \___\___/|_| |_| |_| .__/|_|_|\___|  \__\___/ \___/|_|___/
                    |_|
;

%put &=gbl_oto;

* compile utility macros;
filename cin "&gbl_oto/cos_010.sas" lrecl=4096 recfm=v;
%inc cin / nosource;

%if &gbl_dirsub %then %do;

/*
          _       ___  ____   ___
  ___ ___| |_    / _ \| ___| / _ \
 / __/ __| __|  | | | |___ \| | | |
| (__\__ \ |_   | |_| |___) | |_| |
 \___|___/\__|___\___/|____/ \___/
            |_____|
This copies the macro below to your autocall library.
Create directory structure for costreports
* Note you can edit the code below and it will
  de decompiled and copied to your autocall library;
*/

options mrecall;

filename ft15f001 clear;
filename ft15f001 "&gbl_oto/cos_050.sas";
parmcards4;
%macro cos_050(
         root=&gbl_root /* for development ./dev/cos and for production .prd/cos */
         )/ des="create directory structure for costreports";

  %global cos_050;

  %let cos_050=0;
  %put &=cos_050;
  data _null_;

    newdir=dcreate('utl',"&root:/");
    newdir=dcreate('ver',"&root:/");
    newdir=dcreate('xls',"&root:/cos/");
    newdir=dcreate('csv',"&root:/cos/");
    newdir=dcreate('fmt',"&root:/cos/");
    newdir=dcreate('pdf',"&root:/cos/");
    newdir=dcreate('zip',"&root:/cos/");
    newdir=dcreate('doc',"&root:/cos/");
    newdir=dcreate('ppt',"&root:/cos/");
    newdir=dcreate('log',"&root:/cos/");
    newdir=dcreate('lst',"&root:/cos/");
    newdir=dcreate('rtf',"&root:/cos/");
    newdir=dcreate('vdo',"&root:/cos/");
    newdir=dcreate('rtf',"&root:/cos/");
    newdir=dcreate('rda',"&root:/cos/");
    newdir=dcreate('b64',"&root:/cos/");
    newdir=dcreate('vba',"&root:/cos/");
    newdir=dcreate('sas',"&root:/cos/");
    newdir=dcreate('ps1',"&root:/cos/");
    newdir=dcreate('b64',"&root:/cos/");

  run;quit;

  %if &syserr=0 %then %do;
      %let cos_050=1;  * success;
  %end;
  %else %do;
      %let cos_050=0;
  %end;

%mend cos_050;
;;;;
run;quit;

%cos_050(root=&gbl_root);

%end;

%if &gbl_ext %then %do;

    /*               _        _     _
     ___  __ _ ___  | |_ __ _| |__ | | ___
    / __|/ _` / __| | __/ _` | '_ \| |/ _ \
    \__ \ (_| \__ \ | || (_| | |_) | |  __/
    |___/\__,_|___/  \__\__,_|_.__/|_|\___|
    */

    * download b64 encoded sas dataset - github does nto support binary download wirg aoi key ;
    filename _bcot "&gbl_root:/cos/b64/cos_025snfdescribe_sas7bdat.b64";
    proc http
       method='get'
       url="&gbl_desinp"
       out= _bcot;
    run;quit;

    * Only run if descrition table changes;
    %*utl_b64encode(d:/cos/cos_025snfdescribe.sas7bdat,&gbl_root:/cos/b64/cos_025snfdescribe_sas7bdat.b64);

    %utl_b64decode(&gbl_root:/cos/b64/cos_025snfdescribe_sas7bdat.b64,&gbl_desout);

    /* check sas dataset
       libname cos "c:/cos";
       proc print data=cos.cos_025snfdescribe(obs=5);
       run;quit;
    */

%end;

*               _   _       _ _
  ___ _ __   __| | (_)_ __ (_) |_
 / _ \ '_ \ / _` | | | '_ \| | __|
|  __/ | | | (_| | | | | | | | |_
 \___|_| |_|\__,_| |_|_| |_|_|\__|
;



%*let pgm=utl-adding-zipcode-level-demographics-cost-report-schema;

libname cos "d:/cos";   /* cost report builder */
libname cos "d:/cos";   /* cost report analysis */

/*
libname xel "d:/cos/xls/zip_to_zcta_2019.xlsx";
proc contents data=xel._all_;
run;quit;

data cos.cos_400zip(label="zip_zipcode to zip_zcta https://www.udsmapper.org/zcta-crosswalk.cfm");
  length zip_zcta $5;
  set XEL.'ZiptoZCTA_crosswalk$'n(
           keep=zip_code zcta
           rename=(zip_code=zip_zipcode zcta=zip_zcta)
           where=(substr(zip_zcta,1,5) ne "No ZC")
           );
run;quit;

data cst.cst_025zip2Zcta;
   retain fmtname "$zip2zcta";
   set cos.cos_400zip;
   start=zip_zipcode;
   label=zip_zcta;
   keep start label fmtname;
run;quit;

*/

http://mcdc.missouri.edu/data/acs2018/uszctas5yr.sas7bdat

*    _             _
 ___| |_ __ _ _ __| |_
/ __| __/ _` | '__| __|
\__ \ || (_| | |  | |_
|___/\__\__,_|_|   \__|

;

proc format cntlin=cos.fmt_zipToZcta;
run;quit;

%utlnopts;
%let drops=%utl_varlist(cos.uszctas5yr,prx=/_MOE/);

%*put &=drops;

data cos.zip_demographics(label="source http://mcdc.missouri.edu/data/acs2018/ 5 year ");

  retain zcta;

  set cos.uszctas5yr(drop=&drops);
  rename PCTPRIVATEINSURANCEONLYUNDER65=PCTPRIVINSURONLYUNDER65;

run;quit;

%array(dems,values=%utl_varlist(cos.zip_demographics));

proc datasets lib=cos;
  modify zip_demographics;
    rename
     %do_over(dems,phrase=?=zip_?)
    ;
run;quit;

data cos.cel_cellvalue;
  retain cel_reportKey cel_name cel_value;
  set cos.cos_200snffiv20112019(
        keep   = rpt_rec_num cosnam cosval
        rename =(cosnam=cel_name cosval=cel_value rpt_rec_num=cel_reportKey)
        );
run;quit;

proc datasets lib=cos nolist;
delete col_coldescribe;
run;quit;

* copy describe;
proc append
  data=cos.cos_025snfdescribe(crop=rco rename=col_cel_description=col_description)
  base=cos.col_coldescribe;
run;quit;


* all populated cell;

proc datasets lib=cos nolist;
delete tpl_allCells;
run;quit;


*_
| |_ ___  _ __ ___   ___  _ __ _ __ _____      __
| __/ _ \| '_ ` _ \ / _ \| '__| '__/ _ \ \ /\ / /
| || (_) | | | | | | (_) | |  | | | (_) \ V  V /
 \__\___/|_| |_| |_|\___/|_|  |_|  \___/ \_/\_/

;












proc append data=cos.cos_300snfmax20112019 base=cos.tpl_allCells(keep=cosnam rename=cosnam=tpl_cellName);
run;quit;

/* chr data */

data cos_100tbldesall;
  set cos.col_coldescribe (where=(substr(col_cel_name,20)="_C")) end=dne;
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

/*
proc sort data=cos_100tbldesall out=cos_100tbldesallunq nodupkey;
by col_cel_name;
run;quit;
*/

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
  set cos_100tbldesallunq(where=(start ne 'YER') rename=(col_cel_name=start  col_description=label));
run;quit;

proc format cntlin=cos_100fmtlbl;
run;quit;

/*
WORK.COS_100TBLCHRVAL

#    Variable         Type    Len

1    CEL_REPORTKEY    Num       4
2    CEL_NAME         Char     21
3    CEL_VALUE        Char     40
*/


proc transpose data=cos.cos_150snfrpt20112019(drop=npi spec_ind)  out=cos_100tblrptxpo(drop=_label_
  rename=(rpt_rec_num=cel_reportKey  _name_=cel_name col1=cel_value));
by yer rpt_rec_num;
var _all_;
run;quit;

/*
#    Variable       Type

YER            Char      2
RPT_REC_NUM    Num       5
CEL_NAME       Char     18
CEL_VALUE      Char     12

*/

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

proc datasets lib = work ;
  modify cos_100tblrptnunalp ;
    attrib _all_ label = "" ;
    format _all_;
    informat _all_;
  run ;
quit ;

proc sort data=cos_100tblrptnunalp out=cos_100tblrpunq noequals;
  by cel_reportKey;
run;quit;

/*
proc print data=cos_100tblrpunq noequals
Up to 40 obs from COS_100TBLRPTNUNALP total obs=3,822,389

                      CEL_
    Obs    YEAR    REPORTKEY    CEL_NAME              CEL_VALUE

      1    2011     1000236     YER                   11
      2    2011     1000236     RPT_REC_NUM           1000236
      3    2011     1000236     PRVDR_CTRL_TYPE_CD    4
      4    2011     1000236     PRVDR_NUM             335257
      5    2011     1000236     RPT_STUS_CD           2
      6    2011     1000236     INITL_RPT_SW          N
      7    2011     1000236     LAST_RPT_SW           N
*/

proc transpose data=cos_100tblrpunq out=cos_100tblrpunqxpo (drop=_name_ _label_ );
  by  cel_reportKey;
  var cel_value;
  id cel_name;
  idlabel idlabel;
run;quit;

data cos.adr_address;
 length  COSTREPORT$3 year $4 CEL_REPORTKEY 5 PRVDR_NUM $10  zip5 $5 zcta$5;
 retain
 CostReport "SNF"
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
set
  cos_100tblrpunqxpo;
  zip5=substr(S200001_00200_00300_C,1,5);
  S200001_00200_00300_C=cats('09'x,S200001_00200_00300_C);
  zcta=put(zip5,$zip2zcta.);
  year=cats("20",yer);
  drop yer;
run;quit;


%utl_optlen(inp=cos.adr_address,out=cos.adr_address);

data cos.rpv_reportProvider;
  retain fmtname "rpt2prv";
  set cos.cos_150snfrpt20112019(keep=rpt_rec_num prvdr_num rename=(rpt_rec_num=start prvdr_num=label));
run;quit;

proc format cntlin=cos.rpv_reportProvider;
run;quit;

data chk;
    prvdr = put(1004268,rpt2prv.);
    put prvdr=;
run;quit;


data

data p335461;
  set cos.adr_address(where=(prvdr_num='335461'));
run;quit;

proc sql;
  create
    table p335461_dem(where=(costReport="SNF"))  as
  select
    r.*
   ,l.*
  from
    cos.zip_demographics as l left join p335461 as r
  on
    l.zcta5 = r.zcta
;quit;

data G000000_03400;
  set cos.cel_cellvalue(where=(cel_reportKey in (
    1117271,
    1085531,
    1153201,
    1182931,
    1218369,
    1249864,
    1078907,
    1041276 )  and
       cel_name =: "G000000_03400"));
  cel_valuen=input(cel_value,best18.);
  prvdr=put(cel_reportKey,rpt2prv.);
  drop cel_value;
run;quit;


proc sql;
create
   table cos.p335461_all as
select
   r.*
  ,l.*
from
   p335461_dem as l, G000000_03400(where=(cel_name='G000000_03400_00400_N')) as r
where
   l.cel_reportKey = r.cel_reportKey
;quit;























data test;
  set cos.adr_address(where=(cel_reportKey in (
    1117271,
    1085531,
    1153201,
    1182931,
    1218369,
    1249864,
    1078907,
    1041276 )));
run;quit;


    335461








proc sql;
  select
     l.*
    ,r.col_description
  from
     cos_100tblrptnunalp as l, cos_100tbldesall as r
  where
     l.cel_name = r.col_cel_name
;quit;







proc append data=cos.cel_cellvalue  base=cos_100tblrptxpo;
run;quit;

proc sort data=cos_100tblchrval  out=cos_100tblchrvalsrt noequals;
by cel_reportkey;
run;quit;

proc transpose data=cos_100tblchrvalsrt out=cos_100tblchrxpo(drop=_name _label_);
by cel_reportKey;
var cel_value;
id cel_name;
run;quit;



















  cos.cos_150snfrpt20112019




































/*
      COL_CEL_NAME         COL_DESCRIPTION

  S200001_00100_00100_C    Street@S200001_00100_00100_C
  S200001_00200_00100_C    City@S200001_00200_00100_C
  S200001_00200_00200_C    State@S200001_00200_00200_C
  S200001_00200_00300_C    Zip@S200001_00200_00300_C
  S200001_00300_00100_C    County@S200001_00300_00100_C
  S200001_00300_00200_C    Cbsa code@S200001_00300_00200_C
  S200001_00300_00300_C    Urban rural@S200001_00300_00300_C
  S200001_00400_00100_C    Component Name@S200001_00400_00100_C
  S200001_00400_00200_C    Provider CCN@S200001_00400_00200_C
  S200001_00400_00300_C    Date Cerified@S200001_00400_00300_C
  S200001_00400_00400_C    Payment V@S200001_00400_00400_C
  S200001_00400_00500_C    Payment XVIII@S200001_00400_00500_C
  S200001_00400_00600_C    Payment XIX@S200001_00400_00600_C
  S200001_01400_00100_C    Fiscal Begin Date@S200001_01400_00100_C
  S200001_01400_00200_C    Fiscal End Date@S200001_01400_00200_C
*/


YER                  Year of CSV file from CMS wweb data @YER
PRVDR_NUM            Provider Number @PRVDR_NUM
INITL_RPT_SW         Initial Report Switch @INITL_RPT_SW
LAST_RPT_SW          Last Report Switch @LAST_RPT_SW
TRNSMTL_NUM          Transmittal Number @TRNSMTL_NUM
FI_NUM               Fiscal Intermediary Number @FI_NUM
UTIL_CD              Utilization Code @UTIL_CD
SPEC_IND             Special Indicator @SPEC_IND
RPT_REC_NUM          Report Record Number @RPT_REC_NUM
PRVDR_CTRL_TYPE_CD   Provider Control Type Code @PRVDR_CTRL_TYPE_CD
RPT_STUS_CD          Report Status Code @RPT_STUS_CD
ADR_VNDR_CD          Automated Desk Review Vendor Code @ADR_VNDR_CD
NPI                  National Provider Identifier @NPI
FY_BGN_DT            Fiscal Year Begin Date @FY_BGN_DT
FY_END_DT            Fiscal Year End Date @FY_END_DT
PROC_DT              HCRIS Process Date @PROC_DT
FI_CREAT_DT          Fiscal Intermediary Create Date @FI_CREAT_DT
NPR_DT               Notice of Program Reimbursement Date @NPR_DT
FI_RCPT_DT           Fiscal Intermediary Receipt Date @FI_RCPT_DT




%macro tst;

  %do i=268435455 %to 268435456 %by 1;

    data _null_;

      array gb2[0:&i] 4. _temporary_;

      put "&i";

    run;quit;

%end;
run;quit;

%mend tst;

%tst;




































     cos.cos_150snfrpt20112019







data cos.cos_400uszctas5yr


 cos.cos_400uszctas5yr



PCTPRIVATEINSURANCEONLYUNDER65
PRIVATEINSURANCEONLYUNDER65_MOE
GRANDPRNTSLVNGWITHGRNDKID_MOE





cos.cos_250snffiv20112019
cos.cos_250snffac20112019

data chkzip;
  set cos.cos_300snfxpo20112019(keep=s200001_00200_00300_c obs=10);
run;quit;


proc sql;
  create
     table &pgm._zipJyn001 as
  select
     l.*
    ,r.*
  from
    pos.&pgm.HspCut as l left join lup.mo_zcta2015Cut as r
  on
    r.zcta5 =l.zip_cd
;quit;

* match and non match on zip;
data &pgm._zipJynZcta  &pgm._zipJynNoZcta;

  set &pgm._zipJyn001;
  if zcta5 = '' then output &pgm._zipJynNoZcta;
  else output &pgm._zipJynZcta;

run;quit;

* gen altenate ZCTA5;
data &pgm._addZip;

   set lup.mo_zcta2015Cut(where=(naltzips ne .));
   do i=1 to naltzips/100;
      zcta5=scan(altzips,i);
      output;
   end;
   drop i;

run;quit;

* small number of drops 259 out of 8,000;
proc sort data=&pgm._addZip out=&pgm._addZipUnq nodupkey;
  by zcta5;
run;quit;


proc sql;
  create
     table mo_zcta2015get as
  select
     *
  from
     &pgm._addZip
  where
     zcta5 in (
        select
         distinct
          r.zcta5
        from
          &pgm._zipJynNoZcta as l, &pgm._addZipUnq as r
        where
          r.zcta5 =l.zip_cd
    );
;quit;

data pos.mo_zcta2015Aug;
 set
  lup.mo_zcta2015Cut
      mo_zcta2015get;
  array nums[*] _numeric_;
  do i=1 to dim(nums);
     nums[i]=nums[i]/100;
  end;
run;quit;


proc sql;
  create
     table pos.&pgm._zipJyn002 as
  select
     case zcta5
       when '' then 'NBER'
       else 'ACS'
     end as source
    ,l.*
    ,r.*
    ,input(zip_cd,ruca.) as pctRural
  from
    pos.&pgm.HspCut as l left join pos.mo_zcta2015Aug as r
  on
    r.zcta5 =l.zip_cd
;quit;



data chk;



filename wild 'wild*.dat';
data;
   infile wild;
   input;
run;


x "cd c:/utl";
filename wyl 'csv/snf10_*_NMRC';
filename wyl (
"d:/snfold/csv/snf10_2011_NMRC.csv"
"d:/snfold/csv/snf10_2012_NMRC.csv"
"d:/snfold/csv/snf10_2013_NMRC.csv"
"d:/snfold/csv/snf10_2014_NMRC.csv"
"d:/snfold/csv/snf10_2015_NMRC.csv"
"d:/snfold/csv/snf10_2016_NMRC.csv"
"d:/snfold/csv/snf10_2017_NMRC.csv"
"d:/snfold/csv/snf10_2018_NMRC.csv"
"d:/snfold/csv/snf10_2019_NMRC.csv" );

data rptrecnum(drop=yer);
 length yr $64 year $4;
 infile wyl FILENAME=yr delimiter=",";
 yer=yr;
 year=substr(yer,21,4);

 informat
   RPT_REC_NUM best.
   ;
 input
    RPT_REC_NUM
 ;
 if rpt_rec_num ne lag(rpt_rec_num) then output;

run;quit;


118151 observations and 2 variables.





 input;
 putlog _infile_;
 if _n_=10 then stop;
run;quit;


filename wyl 'd:/snfold/csv/snf10_*_NMRC';
*filename wyl "d:/snfold/csv/snf10_2019_NMRC.csv";

data rptrecnum(drop=yer);
 length yr $64 year $4;
 infile wyl;

 informat
   RPT_REC_NUM $7.;
   ;
 input
    RPT_REC_NUM
 ;
 if rpt_rec_num ne lag(rpt_rec_num) then output;
run;quit;


 input;
 putlog _infile_;
 if _n_=10 then stop;
run;quit;





d:\snfold\csv\snf10_2019_NMRC.csv
