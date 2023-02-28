unit VersionSupport;

    {$mode objfpc}

interface

    (*
      Building on the excellent vinfo.pas supplied by Paul Ishenin and available elsewhere on the Lazarus
      Forums
        - I hid the TVersionInfo class from the end user to simplify their (mine) number of required Uses...
        - Added defensive code to TVersionInfo if no build info is compiled into the exe
        - Deduced GetResourceStrings - works under Linux 64/GTK2 with Lazarus 0.9.30, but fails under
          Win XP 32bit/Lazarus 0.9.29 - suspecting my install as the lazresexplorer example also fails
          for me under Lazarus 0.9.29, but works with Lazarus 0.9.30
     
      Trawled through IDE source code, FPC source code and Lazarus supplied example program lasresexplorer
      to find the other defines and lookups...
     
      End user only needs to use VersionSupport - no other units necessary for their project.
     
      Jedi CodeFormatter seems to fail on the {$I %VARIABLE%} references, so sticking them all in here
      means end user code can be neatly formatted using Jedi CodeFormatter
     
      Other interesting includes I picked up in my travels are...
      //  {$I %HOME%} = User Home Directory
      //  {$I %FILE%} = Current pas file
      //  {$I %LINE%} = current line number
     
      Mike Thompson - mike.cornflake@gmail.com
      Origin: July 24 2011
     
      Changes:
      January 2017:   Updated code to cope with refactored LCL Platform Definitions
    *)

uses
  Classes, SysUtils;

// Surfacing general defines and lookups
function GetCompiledDate: string;
function GetCompilerInfo: string;
function GetTargetInfo: string;
function GetOS: string;
function GetCPU: string;
function GetLCLVersion: string;
function GetWidgetSet: string;

// Exposing resource and version info compiled into exe
function GetResourceStrings(oStringList: TStringList): boolean;
function GetFileVersion: string;
function GetProductVersion: string;

implementation

uses
  resource, versiontypes, versionresource, LCLVersion, InterfaceBase,
  LCLPlatformDef;

function GetWidgetSet: string;
begin
  Result := LCLPlatformDisplayNames[WidgetSet.LCLPlatform];
end;

function GetCompilerInfo: string;
begin
  Result := 'FPC ' + {$I %FPCVERSION%};
end;

function GetTargetInfo: string;
begin
  Result := {$I %FPCTARGETCPU%} + ' - ' + {$I %FPCTARGETOS%};
end;

function GetOS: string;
begin
  Result := {$I %FPCTARGETOS%};
end;

function GetCPU: string;
begin
  Result := {$I %FPCTARGETCPU%};
end;

function GetLCLVersion: string;
begin
  Result := 'LCL ' + lcl_version;
end;

function GetCompiledDate: string;
var
  sDate, sTime: string;
begin
  sDate := {$I %DATE%};
  sTime := {$I %TIME%};

  Result := sDate + ' at ' + sTime;
end;

{ Routines to expose TVersionInfo data }

type
  TVersionInfo = class
  private
    FBuildInfoAvailable: boolean;
    FVersResource: TVersionResource;
    function GetFixedInfo: TVersionFixedInfo;
    function GetStringFileInfo: TVersionStringFileInfo;
    function GetVarFileInfo: TVersionVarFileInfo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(Instance: THandle);

    property BuildInfoAvailable: boolean read FBuildInfoAvailable;

    property FixedInfo: TVersionFixedInfo read GetFixedInfo;
    property StringFileInfo: TVersionStringFileInfo read GetStringFileInfo;
    property VarFileInfo: TVersionVarFileInfo read GetVarFileInfo;
  end;

var
  FInfo: TVersionInfo;

procedure CreateInfo;
begin
  if not Assigned(FInfo) then
  begin
    FInfo := TVersionInfo.Create;
    FInfo.Load(HINSTANCE);
  end;
end;

function GetResourceStrings(oStringList: TStringList): boolean;
var
  i, j: integer;
  oTable: TVersionStringTable;
begin
  CreateInfo;

  oStringList.Clear;
  Result := False;

  if FInfo.BuildInfoAvailable then
  begin
    Result := True;
    for i := 0 to FInfo.StringFileInfo.Count - 1 do
    begin
      oTable := FInfo.StringFileInfo.Items[i];

      for j := 0 to oTable.Count - 1 do
        if Trim(oTable.ValuesByIndex[j]) <> '' then
          oStringList.Values[oTable.Keys[j]] := oTable.ValuesByIndex[j];
    end;
  end;
end;

function ProductVersionToString(PV: TFileProductVersion): string;
begin
  Result := Format('%d.%d.%d.%d', [PV[0], PV[1], PV[2], PV[3]]);
end;

function GetProductVersion: string;
begin
  CreateInfo;

  if FInfo.BuildInfoAvailable then
    Result := ProductVersionToString(FInfo.FixedInfo.ProductVersion)
  else
    Result := 'No build information available';
end;

function GetFileVersion: string;
begin
  CreateInfo;

  if FInfo.BuildInfoAvailable then
    Result := ProductVersionToString(FInfo.FixedInfo.FileVersion)
  else
    Result := 'No build information available';
end;

{ TVersionInfo }

function TVersionInfo.GetFixedInfo: TVersionFixedInfo;
begin
  Result := FVersResource.FixedInfo;
end;

function TVersionInfo.GetStringFileInfo: TVersionStringFileInfo;
begin
  Result := FVersResource.StringFileInfo;
end;

function TVersionInfo.GetVarFileInfo: TVersionVarFileInfo;
begin
  Result := FVersResource.VarFileInfo;
end;

constructor TVersionInfo.Create;
begin
  inherited Create;

  FVersResource := TVersionResource.Create;
  FBuildInfoAvailable := False;
end;

destructor TVersionInfo.Destroy;
begin
  FVersResource.Free;

  inherited Destroy;
end;

procedure TVersionInfo.Load(Instance: THandle);
var
  Stream: TResourceStream;
  ResID: integer;
  Res: TFPResourceHandle;
begin
  FBuildInfoAvailable := False;
  ResID := 1;

  // Defensive code to prevent failure if no resource available...
  Res := FindResource(Instance, PChar(PtrInt(ResID)), PChar(RT_VERSION));
  if Res = 0 then
    Exit;

  Stream := TResourceStream.CreateFromID(Instance, ResID, PChar(RT_VERSION));
  try
    FVersResource.SetCustomRawDataStream(Stream);

    // access some property to load from the stream
    FVersResource.FixedInfo;

    // clear the stream
    FVersResource.SetCustomRawDataStream(nil);

    FBuildInfoAvailable := True;
  finally
    Stream.Free;
  end;
end;

initialization
  FInfo := nil;

finalization
  if Assigned(FInfo) then
    FInfo.Free;
end.
     
