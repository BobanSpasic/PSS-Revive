{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 Class implementing PSSx80 Voice Bank Data and related functions for 32 Voices.

 See the comments in the untPSSx80Voice about the Checksumm and CalculateHash functions.
}

unit untPSSx80Bank;

{$mode ObjFPC}{$H+}


interface

uses
  Classes, SysUtils, TypInfo, untPSSx80Voice;

type
  TPSSx80_VMEM_BankDump = array [1..32] of TPSSx80_VMEM_Dump;

type
  TPSSx80BankContainer = class(TPersistent)
  private
    FPSSx80BankParams: array [1..5] of TPSSx80VoiceContainer;
  public
    constructor Create;
    destructor Destroy; override;
    function GetVoice(aVoiceNr: integer;
      var FPSSx80Voice: TPSSx80VoiceContainer): boolean;
    function SetVoice(aVoiceNr: integer;
      var FPSSx80Voice: TPSSx80VoiceContainer): boolean;
    function GetVCED(aVoiceNr: integer): TPSSx80_VCED_Params;
    procedure LoadBankFromStream(var aStream: TMemoryStream; Position: integer);
    function GetVoiceName(aVoiceNr: integer): string;
    procedure SetVoiceName(aVoiceNr: integer; aName: string);
    function SaveBankToSysExFile(aFile: string): boolean;
    procedure SysExBankToStream(var aStream: TMemoryStream);
    procedure AppendSysExBankToStream(var aStream: TMemoryStream);
    procedure InitBank;
  end;

implementation

constructor TPSSx80BankContainer.Create;
var
  i: integer;
begin
  inherited;
  for i := 1 to 5 do
  begin
    FPSSx80BankParams[i] := TPSSx80VoiceContainer.Create;
    FPSSx80BankParams[i].InitVoice;
  end;
end;

destructor TPSSx80BankContainer.Destroy;
var
  i: integer;
begin
  for i := 5 downto 1 do
    if Assigned(FPSSx80BankParams[i]) then
      FPSSx80BankParams[i].Destroy;
  inherited;
end;

function TPSSx80BankContainer.GetVoice(aVoiceNr: integer;
  var FPSSx80Voice: TPSSx80VoiceContainer): boolean;
begin
  if (aVoiceNr > 0) and (aVoiceNr < 6) then
  begin
    if Assigned(FPSSx80BankParams[aVoiceNr]) then
    begin
      FPSSx80Voice.Set_VMEM_Params(FPSSx80BankParams[aVoiceNr].Get_VMEM_Params);
      Result := True;
    end
    else
      Result := False;
  end
  else
    Result := False;
end;

function TPSSx80BankContainer.SetVoice(aVoiceNr: integer;
  var FPSSx80Voice: TPSSx80VoiceContainer): boolean;
begin
  if (aVoiceNr > 0) and (aVoiceNr < 6) then
  begin
    FPSSx80BankParams[aVoiceNr].Set_VMEM_Params(FPSSx80Voice.Get_VMEM_Params);
    FPSSx80BankParams[aVoiceNr].FPSSx80_VCED_Params.BANK:=aVoiceNr;
    Result := True;
  end
  else
    Result := False;
end;

procedure TPSSx80BankContainer.LoadBankFromStream(var aStream: TMemoryStream;
  Position: integer);
var
  i: integer;
begin
  if (Position < aStream.Size) and ((aStream.Size - Position) >= 360) then   //????
    aStream.Position := Position
  else
    Exit;
  try
    for  i := 1 to 5 do
    begin
      if assigned(FPSSx80BankParams[i]) then
      begin
        FPSSx80BankParams[i].Load_VMEM_FromStream(aStream, aStream.Position);
        FPSSx80BankParams[i].FPSSx80_VCED_Params.BANK := i;
      end;
    end;
  except

  end;
end;

function TPSSx80BankContainer.GetVoiceName(aVoiceNr: integer): string;
begin
  if (aVoiceNr > 0) and (aVoiceNr < 6) then
    Result := FPSSx80BankParams[aVoiceNr].GetVoiceName
  else
    Result := '';
end;

function TPSSx80BankContainer.GetVCED(aVoiceNr: integer): TPSSx80_VCED_Params;
begin
  Result := FPSSx80BankParams[aVoiceNr].Get_VCED_Params;
end;

procedure TPSSx80BankContainer.SetVoiceName(aVoiceNr: integer; aName: string);
begin
  FPSSx80BankParams[aVoiceNr].SetVoiceName(aName);
end;

function TPSSx80BankContainer.SaveBankToSysExFile(aFile: string): boolean;
var
  tmpStream: TMemoryStream;
  i: integer;
begin
  tmpStream := TMemoryStream.Create;
  try
    Result := True;
    for i := 1 to 5 do
    begin
      tmpStream.WriteByte($F0);
      tmpStream.WriteByte($43);
      tmpStream.WriteByte($76);
      tmpStream.WriteByte($00);
      if FPSSx80BankParams[i].Save_VMEM_ToStream(i, tmpStream) = False then
        Result := False;
      tmpStream.WriteByte(FPSSx80BankParams[i].GetChecksum);
      tmpStream.WriteByte($F7);
    end;
    if Result = True then
      tmpStream.SaveToFile(aFile);
  finally
    tmpStream.Free;
  end;
end;

procedure TPSSx80BankContainer.SysExBankToStream(var aStream: TMemoryStream);
var
  i: integer;
begin
  aStream.Clear;
  aStream.Position := 0;
  for i := 1 to 5 do
  begin
    aStream.WriteByte($F0);
    aStream.WriteByte($43);
    aStream.WriteByte($76);
    aStream.WriteByte($00);
    FPSSx80BankParams[i].Save_VMEM_ToStream(i, aStream);
    aStream.WriteByte(FPSSx80BankParams[i].GetChecksum);
    aStream.WriteByte($F7);
  end;
end;

procedure TPSSx80BankContainer.AppendSysExBankToStream(var aStream: TMemoryStream);
var
  i: integer;
begin
  for i := 1 to 5 do
  begin
    aStream.WriteByte($F0);
    aStream.WriteByte($43);
    aStream.WriteByte($76);
    aStream.WriteByte($00);
    FPSSx80BankParams[i].Save_VMEM_ToStream(i, aStream);
    aStream.WriteByte(FPSSx80BankParams[i].GetChecksum);
    aStream.WriteByte($F7);
  end;
end;

procedure TPSSx80BankContainer.InitBank;
var
  i: integer;
begin
  for i := 1 to 5 do
  FPSSx80BankParams[i].InitVoice;
end;

end.
