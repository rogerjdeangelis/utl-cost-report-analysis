# utl-cost-report-analysis
Cost report analysis
    Cost report analysis  
    
    The Skilled Nursing Data has been updated to contain data as of 11/12/2020
                                                                                                                                                                  
    Cost Report and Cost Report Analysis Repositories are still under                                                                                             
    development. The draft makefile and driver for this repository are                                                                                            
    almost complete.  
    
    There are two ways to populate the schema.
          1. You can download and unzip the schema (~10gb)
          2. You can run cos_000makefile.sas and then cos_005driver.sas.
             This will create the same data as is in the download.
             Note you can test the code by running each mocaro in the makefile
                                                                                                                                                                  
    Cost Report Analysis                                                                                                                                          
    https://github.com/rogerjdeangelis/utl-cost-report-analysis                                                                                                   
                                                                                                                                                                  
    Cost Reports (related)                                                                                                                                        
    https://github.com/rogerjdeangelis/CostReports   
    
    GitHub
    https://tinyurl.com/y4ebnthm
    https://github.com/rogerjdeangelis/utl-skilled-nursing-cost-reports-2011-2019-in-excel
                                                                                                                                                                  
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
                                                                                                                                                                  
    You need to download or run the makefile and driver to create the SAS schema.  
    
    None of these sites support lights out programmable downloading.                                                                                               
                                                                                                                                                                
    Github only supports tiny file files.                                                                                                                          
                                                                                                                                                                  
    You will have to manually  download 'cos.exe and run the self extracting zip.                                                                                
                                                                                                                                                                  
    Note self extracting unziped SAS schema is about 10gb                                                                                                         
                                                                           
    Google Drive   
    https://tinyurl.com/y4pqrj6d                                                       
    https://drive.google.com/file/d/1u4ZG9Lv87vXh699i_PAEK0Sgl9chb7-N/view?usp=sharing                                                                                           
                                                                                                                                                                  
    SCHEMA                                                                                                                                                              
                                                                                                                                                                  
    #  Table Name        File Size    Label                                                                                                                       
                                                                                                                                                                  
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
                                                                                                                                                                  
    CEL_REPORTKEY  PROVIDER State  Component Name               Fiscal Begin Date    Skilled Nursing Facility  Skilled Nursing Facility  Skilled Nursing Facility 
                                                              S200001_01400_00100_C  Numberof Beds             BedDays Available         Inpatient_DaysAll Total  
      1023771      365787  OH      ELISABETH PRENTISS CENTER    01/01/2011           S300001_00100_00100_N     S300001_00100_00200_N     S300001_00100_00700_N    
                                                                                                                                                                  
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
