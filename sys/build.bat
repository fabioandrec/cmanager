rc /R ..\res\cmanagericons.rc
rc /R ..\res\cupdateicons.rc
rc /R ..\res\carchiveicons.rc
rc /R ..\res\cqueryicons.rc
rc /R ..\res\ctransformicons.rc
rc /R ..\res\cvalidateicons.rc
copy /Y ..\res\*.res .\
brcc32 CMandbpat.rc
brcc32 strings.rc
dcc32 /q /b cmanager.dpr
dcc32 /q /b cupdate.dpr
dcc32 /q /b carchive.dpr
dcc32 /q /b cquery.dpr
dcc32 /q /b ctransform.dpr
dcc32 /q /b cvalidate.dpr