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
  Classes, LazFileUtils, SysUtils, strUtils;

procedure FindSYX(Directory: string; var sl: TStringList);
procedure FindPERF(Directory: string; var sl: TStringList);
procedure Unused(const A1);
procedure Unused(const A1, A2);
procedure Unused(const A1, A2, A3);
function SameArrays(var a1, a2: array of byte): boolean;
function ShortenFileName(aFileName: string): string;

implementation

procedure FindSYX(Directory: string; var sl: TStringList);
var
  sr: TSearchRec;
begin
  if FindFirst(Directory + '*.syx', faAnyFile, sr) = 0 then
    repeat
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
  dlmtCounter:=0;
  Result := '';
  for i := 1 to Length(aFileName) do
  if (aFileName[i] = '/') or (aFileName[i] = '\') then inc(dlmtCounter);
  Result := copy(aFileName, 1, NPos(PathDelim, aFileName, 2));
  Result := Result + '...';
  Result := Result + copy(aFileName, NPos(PathDelim, aFileName, dlmtCounter - 2), Length(aFileName));
end;

end.
