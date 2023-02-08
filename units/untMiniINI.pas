{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 Implementing the MiniDexed's INI-File reader/writter.
 Compared to standard INI-Files, the implementation in MiniDexed
 does not have or use [Sections] in INI-Files.
 Two helper functions to initialize minidexed.ini and performance.ini
 are included.
}

unit untMiniINI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, StrUtils, SysUtils;

type
  TNotes = array[0..127] of string;

type
  TMiniINIFile = class(TPersistent)
  private
    FMiniINI: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(aFile: string): boolean;
    function SaveToFile(aFile: string): boolean;
    function ReadInteger(aName: string; aDefault: integer): integer;
    function ReadString(aName: string; aDefault: string): string;
    procedure WriteInteger(aName: string; aVal: integer);
    procedure WriteString(aName, aVal: string);
    procedure Comment(aName: string);
    procedure Uncomment(aName: string);
    function NameExists(aName: string): boolean;

  end;

const
  FNotes: TNotes = ('C-2', 'C#-2', 'D-2', 'D#-2', 'E-2', 'F-2', 'F#-2',
    'G-2', 'G#-2', 'A-2', 'B-2', 'H-2',
    'C-1', 'C#-1', 'D-1', 'D#-1', 'E-1', 'F-1',
    'F#-1', 'G-1', 'G#-1', 'A-1', 'B-1', 'H-1',
    'C0', 'C#0', 'D0', 'D#0', 'E0', 'F0', 'F#0',
    'G0', 'G#0', 'A0', 'B0', 'H0',
    'C1', 'C#1', 'D1', 'D#1', 'E1', 'F1', 'F#1',
    'G1', 'G#1', 'A1', 'B1', 'H1',
    'C2', 'C#2', 'D2', 'D#2', 'E2', 'F2', 'F#2',
    'G2', 'G#2', 'A2', 'B2', 'H2',
    'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3',
    'G3', 'G#3', 'A3', 'B3', 'H3',
    'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4',
    'G4', 'G#4', 'A4', 'B4', 'H4',
    'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5',
    'G5', 'G#5', 'A5', 'B5', 'H5',
    'C6', 'C#6', 'D6', 'D#6', 'E6', 'F6', 'F#6',
    'G6', 'G#6', 'A6', 'B6', 'H6',
    'C7', 'C#7', 'D7', 'D#7', 'E7', 'F7', 'F#7',
    'G7', 'G#7', 'A7', 'B7', 'H7',
    'C8', 'C#8', 'D8', 'D#8', 'E8', 'F8', 'F#8', 'G8');

function GetNoteName(aValue: integer): string;
function StrToCHex(aVal: string): string;

implementation

function GetNoteName(aValue: integer): string;
begin
  if (aValue >= 0) and (aValue < 128) then
    Result := FNotes[aValue]
  else
    Result := 'UNK';
end;

function StrToCHex(aVal: string): string;
var
  tmpInt: integer;
begin
  if TryStrToInt(aVal, tmpInt) then
    Result := IntToHex(tmpInt, 2)
  else
    Result := '0'; //wrong, but...
  if pos('$', Result) > 0 then Result := ReplaceStr(Result, '$', '0x')
  else
    Result := '0x' + Result;
end;

constructor TMiniINIFile.Create;
begin
  inherited;
  FMiniINI := TStringList.Create;
end;

destructor TMiniINIFile.Destroy;
begin
  if Assigned(FMiniINI) then FMiniINI.Free;
  inherited;
end;

function TMiniINIFile.LoadFromFile(aFile: string): boolean;
begin
  Result := False;
  try
    FMiniINI.LoadFromFile(aFile);
    Result := True;
  except
    on e: Exception do Result := False;
  end;
end;

function TMiniINIFile.SaveToFile(aFile: string): boolean;
begin
  Result := False;
  try
    FMiniINI.SaveToFile(aFile);
    Result := True;
  except
    on e: Exception do Result := False;
  end;
end;

function TMiniINIFile.ReadInteger(aName: string; aDefault: integer): integer;
var
  tmp: string;
begin
  tmp := FMiniINI.Values[aName];
  if tmp = '' then Result := aDefault
  else
  if (not TryStrToInt(trim(tmp), Result) = True) then Result := aDefault;
end;

function TMiniINIFile.ReadString(aName: string; aDefault: string): string;
var
  tmp: string;
begin
  tmp := FMiniINI.Values[aName];
  if tmp = '' then Result := trim(aDefault)
  else
    Result := trim(tmp);
end;

procedure TMiniINIFile.WriteInteger(aName: string; aVal: integer);
begin
  FMiniINI.Values[aName] := IntToStr(aVal);
end;

procedure TMiniINIFile.WriteString(aName, aVal: string);
begin
  FMiniINI.Values[aName] := trim(aVal);
end;

procedure TMiniINIFile.Comment(aName: string);
begin
  if FMiniINI.IndexOfName('#' + aName) <> -1 then
    FMiniINI.Delete(FMiniINI.IndexOfName('#' + aName));  //delete old commented line
  FMiniINI.Insert(FMiniINI.IndexOfName(aName), '#' +
    FMiniINI[FMiniINI.IndexOfName(aName)]);
  //insert new commented line
  FMiniINI.Delete(FMiniINI.IndexOfName(aName)); //delete uncommented line
end;

procedure TMiniINIFile.Uncomment(aName: string);
var
  tmpStr: string;
begin
  tmpStr := copy(aName, 2, length(aName));
  if FMiniINI.IndexOfName(tmpStr) <> -1 then
    FMiniINI.Delete(FMiniINI.IndexOfName(tmpStr));  //delete old uncommented line
  FMiniINI.Insert(FMiniINI.IndexOfName(aName), tmpStr + '=');
  //insert new uncommented line
  FMiniINI.Values[tmpStr] := FMiniINI.Values[aName]; //copy value
  FMiniINI.Delete(FMiniINI.IndexOfName(aName)); //delete commented line
end;

function TMiniINIFile.NameExists(aName: string): boolean;
begin
  Result := FMiniINI.IndexOfName(aName) <> -1;
end;

end.
