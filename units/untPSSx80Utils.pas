{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 This unit implements the detection/recognition of DX-Series SysEx Messages.
 Sequencer and some other (for me less important) headers are not implemented.
 Not all the MSB/LSB Data could be found in Yamaha's documentation. I've got some
 of them by inspecting various SysEx dumps.
}

unit untPSSx80Utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, StrUtils, SysUtils, LazFileUtils;

function ContainsPSSx80Data(dmp: TMemoryStream; var StartPos: integer;
  var isBank: boolean): boolean;

function ContainsPSSx80Voice(dmp: TMemoryStream; var VoiceNr: integer): boolean;

function Printable(c: char): char;
function VCEDHexToStream(aHex: string; var aStream: TMemoryStream): boolean;
function StreamToVCEDHex(const aStream: TMemoryStream): string;

implementation

function ContainsPSSx80Data(dmp: TMemoryStream; var StartPos: integer;
  var isBank: boolean): boolean;
var
  h0, h1, h2, h3: byte;
  voiceCount: integer;
  tmpPos: integer;
begin
  Result := False;
  isBank := False;
  voiceCount := 0;
  if StartPos <= dmp.Size then
  begin
    dmp.Position := StartPos;
    StartPos := -1;
    while dmp.Position < dmp.Size do
    begin
      if dmp.Position = dmp.Size - 1 then break;
      h0 := dmp.ReadByte;
      if h0 = $F0 then      // $F0 - SysEx
      begin
        tmpPos := dmp.Position - 1;

        if dmp.Position = dmp.Size - 1 then break;
        h1 := dmp.ReadByte;     // $43 - Yamaha
        if dmp.Position = dmp.Size - 1 then break;
        h2 := dmp.ReadByte;     // $76 - PSSx80
        if dmp.Position = dmp.Size - 1 then break;
        h3 := dmp.ReadByte;     // $00

        if (h0 = $F0) and (h1 = $43) and (h2 = $76) and (h3 = $00) then
        begin
          Result := True;
          Inc(voiceCount);
          if voiceCount = 1 then StartPos := tmpPos;
        end;
      end;
    end;
    if voiceCount = 5 then isBank := True;
  end
  else
    StartPos := -1;
end;

function ContainsPSSx80Voice(dmp: TMemoryStream; var VoiceNr: integer): boolean;
var
  h0, h1, h2, h3, h4, h5: byte;
begin
  Result := False;
  dmp.Position := 0;
  if dmp.Size = 72 then
  begin
    h0 := dmp.ReadByte;     // $F0 - SysEx
    h1 := dmp.ReadByte;     // $43 - Yamaha
    h2 := dmp.ReadByte;     // $76 - PSSx80
    h3 := dmp.ReadByte;     // $00
    h4 := dmp.ReadByte;
    h5 := dmp.ReadByte;     // Bank, zero-based
    if (h0 = $F0) and (h1 = $43) and (h2 = $76) and (h3 = $00) and (h4 = $00) then
    begin
      Result := True;
      VoiceNr := h5 + 1;
    end;
  end;
end;

function Printable(c: char): char;
begin
  if (Ord(c) > 31) and (Ord(c) < 127) then Result := c
  else
    Result := #32;
end;

function VCEDHexToStream(aHex: string; var aStream: TMemoryStream): boolean;
var
  s: string;
  partS: string;
  buffer: array [0..156] of byte;
  i: integer;
begin
  try
    s := ReplaceStr(aHex, ' ', '');
    aStream.Clear;
    for i := 0 to 155 do
    begin
      partS := '$' + Copy(s, i * 2 + 1, 2);
      buffer[i] := byte(Hex2Dec(partS));
      aStream.WriteByte(buffer[i]);
    end;
    Result := True;
  except
    on e: Exception do Result := False;
  end;
end;

function StreamToVCEDHex(const aStream: TMemoryStream): string;
var
  i: integer;
begin
  Result := '';
  aStream.Position := 0;
  for i := 0 to aStream.Size - 1 do
  begin
    Result := Result + IntToHex(aStream.ReadByte, 2) + ' ';
  end;
  Result := ReplaceStr(Result, '$', '');
  Result := Trim(Result);
end;

end.
