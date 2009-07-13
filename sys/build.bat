brcc32 ..\res\cmanagericons.rc
brcc32 ..\res\cupdateicons.rc
brcc32 ..\res\carchiveicons.rc
brcc32 ..\res\cqueryicons.rc
brcc32 ..\res\ctransformicons.rc
brcc32 ..\res\cvalidateicons.rc
copy /Y ..\res\*.res .\
brcc32 CMandbpat.rc
brcc32 strings.rc
dcc32 /q /b cmanager.dpr
dcc32 /q /b cupdate.dpr
dcc32 /q /b carchive.dpr
dcc32 /q /b cquery.dpr
dcc32 /q /b ctransform.dpr
dcc32 /q /b cvalidate.dpr