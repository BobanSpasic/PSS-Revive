program prPSS_Revive;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
      {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
      {$ENDIF}
  Forms,
  tachartlazaruspkg,
  tachartbgra,
  Interfaces, // this includes the LCL widgetset
  untMain,
  untMiniINI,
  untPopUp,
  untUtils,
  untPSSx80Utils,
  untUnPortMIDI,
  untSysExUtils,
  untSQLProxy,
  untParConst,
  untPSSx80Voice,
  untPSSx80Bank;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title:='PSS Revive';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
