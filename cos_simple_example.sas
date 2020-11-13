libname cos "d:/cos";

proc sql ;
   create
     table cos.&pgm.Chk as
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
             ,'S300001_00100_01600_N')
  order
     by  cel_reportKey
        ,provider
        ,cel_name
;quit;

proc transpose data=cos.&pgm.chk out=cos.&pgm.chkxpo(drop=_name_ _label_) ;
  by cel_reportkey provider;
  var cel_value;
  id cel_name;
  idlabel excel_column_header;
run;quit;

%utl_optlen(inp=cos.&pgm.chkxpo,out=cos.&pgm.chkxpo);

ods listing close;
%utlfkil(&gbl_root:\cos\xls\&pgm.chkxpo.xlsx);

ods excel file="&gbl_root:\cos\xls\&pgm.chkxpo.xlsx" style=pearl
options(
sheet_name="red"
sheet_name="&pgm.ChkXpo"
Frozen_headers= 'yes'
autofilter="all"
);

proc report data=cos.&pgm.chkxpo nowd missing style(column)={just=right cellwidth=5in} split='@';
cols _all_;
run;quit;

ods excel close;
ods listing;
