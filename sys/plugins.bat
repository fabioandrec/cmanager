cd .\plugins\accountchart
dcc32 /b /q accountchart.dpr
cd ..\accountlist
dcc32 /b /q accountlist.dpr
cd ..\dbstats
dcc32 /b /q dbstats.dpr
cd ..\NBPACurrencyRates
dcc32 /b /q NBPACurrencyRates.dpr
cd ..\NBPBSCurrencyRates
dcc32 /b /q NBPBSCurrencyRates.dpr
cd ..\RunCalc
dcc32 /b /q RunCalc.dpr
cd ..\MbankExtFF
dcc32 /b /q MbankExtFF.dpr
cd ..\SqlConsole
dcc32 /b /q SqlConsole.dpr
cd ..\Metastock
brcc32 Default.rc
dcc32 /b /q Metastock.dpr
cd ..\..