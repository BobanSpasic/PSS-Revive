{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 A couple of functions and procedures for general use in other units
}

unit untUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, LazFileUtils, SysUtils, StrUtils;

function GetValidFileName(aFileName: string): string;
function Printable(c: char): char;
procedure FindSYX(Directory: string; var sl: TStringList);
procedure FindImportable(Directory: string; var sl: TStringList);
procedure FindPERF(Directory: string; var sl: TStringList);
procedure Unused(const A1);
procedure Unused(const A1, A2);
procedure Unused(const A1, A2, A3);
function SameArrays(var a1, a2: array of byte): boolean;
function ShortenFileName(aFileName: string): string;

implementation

function GetValidFileName(aFileName: string): string;
var
  FDir, FFile, FExt: string;
  FFileWithExt: string;
  FWinReservedNames: array [1..22] of
  string = ('CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4',
    'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 'LPT3',
    'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9');
  FWinIllegalChars: array [1..9] of char = ('<', '>', ':', '"', '\', '/', '?', '|', '*');
  i: integer;
begin
  FDir := ExtractFileDir(aFileName);
  FFile := ExtractFileNameOnly(aFileName);
  FExt := ExtractFileExt(aFileName);

  if UpperCase(FExt) in FWinReservedNames then FExt := 'InvalidExtension';
  if UpperCase(FFile) in FWinReservedNames then FFile := 'InvalidName';

  for i := 1 to 9 do
    FFile := ReplaceStr(FFile, FWinIllegalChars[i], '_');

  for i := 1 to 9 do
    FExt := ReplaceStr(FExt, FWinIllegalChars[i], '_');

  for i := 1 to Length(FFile) do
    if (Ord(FFile[i]) < 32) then FFile[i] := '_';

  // do not allow dot or space at the end of the name (inkl. extension)
  FFileWithExt := FFile + FExt;
  if FFileWithExt[Length(FFileWithExt)] = ' ' then
    SetLength(FFileWithExt, Length(FFileWithExt) - 1);
  if FFileWithExt[Length(FFileWithExt)] = '.' then
    SetLength(FFileWithExt, Length(FFileWithExt) - 1);
  if FDir <> '' then
    Result := IncludeTrailingPathDelimiter(FDir) + FFileWithExt
  else
    Result := FFileWithExt;
end;

function Printable(c: char): char;
begin
  if (Ord(c) > 31) and (Ord(c) < 127) then Result := c
  else
    Result := #32;
end;

procedure FindSYX(Directory: string; var sl: TStringList);
var
  sr: TSearchRec;
begin
  if FindFirst(Directory + '*', faAnyFile, sr) = 0 then
    repeat
      if LowerCase(sr.Name).Contains('.syx') then
      sl.Add(ExtractFileName(sr.Name));
    until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure FindImportable(Directory: string; var sl: TStringList);
var
  sr: TSearchRec;
begin
  if FindFirst(Directory + '*', faAnyFile, sr) = 0 then
    repeat
      if LowerCase(sr.Name).Contains('.ved') or
      LowerCase(sr.Name).Contains('.mbk') or
      LowerCase(sr.Name).Contains('.lib')then
      sl.Add(ExtractFileName(sr.Name));
    until FindNext(sr) <> 0;
  FindClose(sr);
end;

procedure FindPERF(Directory: string; var sl: TStringList);
var
  sr: TSearchRec;
begin
  if FindFirst(Directory + '*.ini', faAnyFile, sr) = 0 then
    repeat
      sl.Add(ExtractFileName(sr.Name));
    until FindNext(sr) <> 0;
  FindClose(sr);
end;

{$PUSH}{$HINTS OFF}
procedure Unused(const A1);
begin
end;

procedure Unused(const A1, A2);
begin
end;

procedure Unused(const A1, A2, A3);
begin
end;

{$POP}

function SameArrays(var a1, a2: array of byte): boolean;
var
  i: integer;
begin
  i := Low(a1);
  while (i <= High(a1)) and (a1[i] = a2[i]) do
    Inc(i);
  Result := i >= High(a1);
end;

function ShortenFileName(aFileName: string): string;
var
  dlmtCounter: integer;
  i: integer;
begin
  dlmtCounter := 0;
  Result := '';
  for i := 1 to Length(aFileName) do
    if (aFileName[i] = '/') or (aFileName[i] = '\') then Inc(dlmtCounter);
  Result := copy(aFileName, 1, NPos(PathDelim, aFileName, 2));
  Result := Result + '...';
  Result := Result + copy(aFileName, NPos(PathDelim, aFileName, dlmtCounter - 2),
    Length(aFileName));
end;

end.
