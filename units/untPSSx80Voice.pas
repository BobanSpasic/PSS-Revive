{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 Class implementing PSSx80 Voice Data and related functions for one Voice.


 - function GetChecksum implements the calculation of Checksum for one Voice.

 - function CalculateHash is used for calculating a unique identifier for use
 in database storage.
}

unit untPSSx80Voice;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, HlpHashFactory, SysUtils, untParConst;

type
  TPSSx80_VMEM_Dump = array [0..32] of byte;
  TPSSx80_VCED_Dump = array [0..36] of byte;

type
  TPSSx80_VCED_Params = packed record
    case boolean of
      True: (params: TPSSx80_VCED_Dump);
      False: (
        BANK: byte;         // 0-5
        M_DT1: byte;        // sign + 3 bits (0-7)
        M_MUL: byte;        // Freq multiplicator 0-15
        M_TL: byte;         // inverted 0-99 (0000000 = 99)
        M_LKS_HI: byte;     // 0-15
        M_LKS_LO: byte;     // 0-15
        M_RKS: byte;        // 0-3
        M_AR: byte;         // 0-63
        M_AM_EN: byte;      // 0-1
        M_DT2: byte;        // 0-1 1=+600cent
        M_D1R: byte;        // 0-63
        M_SIN_TBL: byte;    // 0-3
        M_D2R: byte;        // 0-63
        M_D1L: byte;        // 0-15
        M_RR: byte;         // 0-15
        M_SRR: byte;        // 0-15
        M_FB: byte;         // 0-7

        C_DT1: byte;
        C_MUL: byte;
        C_TL: byte;
        C_LKS_HI: byte;
        C_LKS_LO: byte;
        C_RKS: byte;
        C_AR: byte;
        C_AM_EN: byte;
        C_DT2: byte;
        C_D1R: byte;
        C_SIN_TBL: byte;
        C_D2R: byte;
        C_D1L: byte;
        C_RR: byte;
        C_SRR: byte;

        PMS: byte;
        AMS: byte;
        VDT: byte;
        V: byte;
        S: byte;
      );
  end;

  TPSSx80_VMEM_Params = packed record
    case boolean of
      True: (params: TPSSx80_VMEM_Dump);
      False: (
        BANK: byte;
        M_DT1_MUL: byte;
        C_DT1_MUL: byte;
        M_TL: byte;
        C_TL: byte;
        M_LKS_HI_LKS_LO: byte;
        C_LKS_HI_LKS_LO: byte;
        M_RKS_AR: byte;
        C_RKS_AR: byte;
        M_AM_EN_DT2_D1R: byte;
        C_AM_EN_DT2_D1R: byte;
        M_SIN_TBL_D2R: byte;
        C_SIN_TBL_D2R: byte;
        M_D1L_RR: byte;
        C_D1L_RR: byte;
        M_FB: byte;
        PMS_AMS: byte;
        Reserved_17: byte;
        Reserved_18: byte;
        Reserved_19: byte;
        M_SRR: byte;
        C_SRR: byte;
        VDT: byte;
        Reserved_23: byte;
        V_S: byte;
        Reserved_25: byte;
        Reserved_26: byte;
        Reserved_27: byte;
        Reserved_28: byte;
        Reserved_29: byte;
        Reserved_30: byte;
        Reserved_31: byte;
        Reserved_32: byte;
      );
  end;

type
  TPSSx80VoiceContainer = class(TPersistent)
  private
    FPSSx80_VCED_Params: TPSSx80_VCED_Params;
    FPSSx80_VMEM_Params: TPSSx80_VMEM_Params;
    FPSSx80_VoiceName: string;
  public
    function Load_VMEM_FromStream(var aStream: TMemoryStream;
      Position: integer): boolean;
    procedure InitVoice; //set defaults
    function Get_VMEM_Params: TPSSx80_VMEM_Params;
    function Get_VCED_Params: TPSSx80_VCED_Params;
    function Set_VMEM_Params(aParams: TPSSx80_VMEM_Params): boolean;
    function Set_VCED_Params(aParams: TPSSx80_VCED_Params): boolean;
    function Save_VMEM_ToStream(aBankNr: byte; var aStream: TMemoryStream): boolean;
    function GetChecksumPart: integer;
    function GetChecksum: integer;
    function GetVoiceName: string;
    procedure SetVoiceName(aVoiceName: string);
    procedure SysExVoiceToStream(var aStream: TMemoryStream);
    function CalculateHash: string;
  end;

function VCEDtoVMEM(aPar: TPSSx80_VCED_Params): TPSSx80_VMEM_Params;
function VMEMtoVCED(aPar: TPSSx80_VMEM_Params): TPSSx80_VCED_Params;

implementation

function VCEDtoVMEM(aPar: TPSSx80_VCED_Params): TPSSx80_VMEM_Params;
var
  t: TPSSx80_VMEM_Params;
begin
  t.BANK := aPar.BANK and 7;
  t.M_DT1_MUL := ((aPar.M_DT1 and 15) shl 4) + (aPar.M_MUL and 15);
  t.M_TL := aPar.M_TL and 127;
  t.M_LKS_HI_LKS_LO := ((aPar.M_LKS_HI and 15) shl 4) + (aPar.M_LKS_LO and 15);
  t.M_RKS_AR := ((aPar.M_RKS and 3) shl 6) + (aPar.M_AR and 63);
  t.M_AM_EN_DT2_D1R := ((aPar.M_AM_EN and 1) shl 7) + ((aPar.M_DT2 and 1) shl 6) +
    (aPar.M_D1R and 63);
  t.M_SIN_TBL_D2R := ((aPAr.M_SIN_TBL and 3) shl 6) + (aPar.M_D2R and 63);
  t.M_D1L_RR := ((aPar.M_D1L and 15) shl 4) + (aPar.M_RR and 15);
  t.M_SRR := aPar.M_SRR and 15;
  t.M_FB := (aPar.M_FB shl 3) and 56;

  t.C_DT1_MUL := ((aPar.C_DT1 and 15) shl 4) + (aPar.C_MUL and 15);
  t.C_TL := aPar.C_TL and 127;
  t.C_LKS_HI_LKS_LO := ((aPar.C_LKS_HI and 15) shl 4) + (aPar.C_LKS_LO and 15);
  t.C_RKS_AR := ((aPar.C_RKS and 3) shl 6) + (aPar.C_AR and 63);
  t.C_AM_EN_DT2_D1R := ((aPar.C_AM_EN and 1) shl 7) + ((aPar.C_DT2 and 1) shl 6) +
    (aPar.C_D1R and 63);
  t.C_SIN_TBL_D2R := ((aPAr.C_SIN_TBL and 3) shl 6) + (aPar.C_D2R and 63);
  t.C_D1L_RR := ((aPar.C_D1L and 15) shl 4) + (aPar.C_RR and 15);
  t.C_SRR := aPar.C_SRR and 15;

  t.PMS_AMS := ((aPar.PMS shl 4) and 112) + (aPAr.AMS and 3);
  t.VDT := aPar.VDT and 127;
  t.V_S := ((aPar.V shl 7) and 128) + ((aPar.S shl 6) and 64);
  t.Reserved_17 := 0;
  t.Reserved_18 := 0;
  t.Reserved_19 := 0;
  t.Reserved_23 := 0;
  t.Reserved_25 := 0;
  t.Reserved_26 := 0;
  t.Reserved_27 := 0;
  t.Reserved_28 := 0;
  t.Reserved_29 := 0;
  t.Reserved_30 := 0;
  t.Reserved_31 := 0;
  t.Reserved_32 := 0;

  Result := t;
end;

function VMEMtoVCED(aPar: TPSSx80_VMEM_Params): TPSSx80_VCED_Params;
var
  t: TPSSx80_VCED_Params;
begin
  t.BANK := aPar.BANK and 7;

  t.M_DT1 := (aPar.M_DT1_MUL shr 4) and 15;
  t.M_MUL := aPar.M_DT1_MUL and 15;
  t.M_TL := aPar.M_TL and 127;
  t.M_LKS_HI := (aPar.M_LKS_HI_LKS_LO shr 4) and 15;
  t.M_LKS_LO := aPar.M_LKS_HI_LKS_LO and 15;
  t.M_RKS := (aPar.M_RKS_AR shr 6) and 3;
  t.M_AR := aPar.M_RKS_AR and 63;
  t.M_AM_EN := (aPar.M_AM_EN_DT2_D1R shr 7) and 1;
  t.M_DT2 := (aPar.M_AM_EN_DT2_D1R shr 6) and 1;
  t.M_D1R := aPar.M_AM_EN_DT2_D1R and 63;
  t.M_SIN_TBL := (aPar.M_SIN_TBL_D2R shr 6) and 3;
  t.M_D2R := aPar.M_SIN_TBL_D2R and 63;
  t.M_D1L := (aPar.M_D1L_RR shr 4) and 15;
  t.M_RR := aPar.M_D1L_RR and 15;
  t.M_SRR := aPar.M_SRR and 15;
  t.M_FB := (aPar.M_FB shr 3) and 7;

  t.C_DT1 := (aPar.C_DT1_MUL shr 4) and 15;
  t.C_MUL := aPar.C_DT1_MUL and 15;
  t.C_TL := aPar.C_TL and 127;
  t.C_LKS_HI := (aPar.C_LKS_HI_LKS_LO shr 4) and 15;
  t.C_LKS_LO := aPar.C_LKS_HI_LKS_LO and 15;
  t.C_RKS := (aPar.C_RKS_AR shr 6) and 3;
  t.C_AR := aPar.C_RKS_AR and 63;
  t.C_AM_EN := (aPar.C_AM_EN_DT2_D1R shr 7) and 1;
  t.C_DT2 := (aPar.C_AM_EN_DT2_D1R shr 6) and 1;
  t.C_D1R := aPar.C_AM_EN_DT2_D1R and 63;
  t.C_SIN_TBL := (aPar.C_SIN_TBL_D2R shr 6) and 3;
  t.C_D2R := aPar.C_SIN_TBL_D2R and 63;
  t.C_D1L := (aPar.C_D1L_RR shr 4) and 15;
  t.C_RR := aPar.C_D1L_RR and 15;
  t.C_SRR := aPar.C_SRR and 15;

  t.PMS := (aPar.PMS_AMS shr 4) and 7;
  t.AMS := aPar.PMS_AMS and 3;
  t.VDT := aPAr.VDT and 127;
  t.V := (aPar.V_S shr 7) and 1;
  t.S := (aPar.V_S shr 6) and 1;

  Result := t;
end;

function TPSSx80VoiceContainer.GetVoiceName:string;
begin
  Result := FPSSx80_VoiceName;
end;

procedure TPSSx80VoiceContainer.SetVoiceName(aVoiceName: string);
begin
  FPSSx80_VoiceName:=aVoiceName;
end;

function TPSSx80VoiceContainer.Load_VMEM_FromStream(var aStream: TMemoryStream;
  Position: integer): boolean;
var
  i: integer;
  nibble_hi: byte;
  nibble_lo: byte;
  test_byte: byte;
begin
  Result := False;
  if (Position + 65) <= aStream.Size then
    aStream.Position := Position
  else
    Exit;
  try
    test_byte := aStream.ReadByte;
    if test_byte = $F0 then
      aStream.Position := Position + 4
    else
      aStream.Position := Position;
    for i := 0 to 32 do
    begin
      nibble_hi := aStream.ReadByte;
      nibble_lo := aStream.ReadByte;
      FPSSx80_VMEM_Params.params[i] := ((nibble_hi and 15) shl 4) + (nibble_lo and 15);
    end;
    //load checksum and $F0
    nibble_hi := aStream.ReadByte;
    nibble_lo := aStream.ReadByte;

    FPSSx80_VCED_Params := VMEMtoVCED(FPSSx80_VMEM_Params);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TPSSx80VoiceContainer.InitVoice;
begin
  GetDefinedValues(PSSx80, fInit, FPSSx80_VCED_Params.params);
  FPSSx80_VMEM_Params := VCEDtoVMEM(FPSSx80_VCED_Params);
  FPSSx80_VoiceName:='Sine Wave';
end;

function TPSSx80VoiceContainer.Get_VMEM_Params: TPSSx80_VMEM_Params;
begin
  Result := FPSSx80_VMEM_Params;
end;

function TPSSx80VoiceContainer.Set_VMEM_Params(aParams: TPSSx80_VMEM_Params): boolean;
begin
  FPSSx80_VMEM_Params := aParams;
  FPSSx80_VCED_Params := VMEMtoVCED(FPSSx80_VMEM_Params);
  Result := True;
end;

function TPSSx80VoiceContainer.Set_VCED_Params(aParams: TPSSx80_VCED_Params): boolean;
begin
  FPSSx80_VCED_Params := aParams;
  FPSSx80_VMEM_Params := VCEDtoVMEM(FPSSx80_VCED_Params);
  Result := True;
end;

function TPSSx80VoiceContainer.Get_VCED_Params: TPSSx80_VCED_Params;
begin
  Result := FPSSx80_VCED_Params;
end;

function TPSSx80VoiceContainer.Save_VMEM_ToStream(aBankNr: byte;
  var aStream: TMemoryStream): boolean;
var
  i: integer;
  nibble_lo: byte;
  nibble_hi: byte;
begin
  //dont clear the stream here or else bulk dump won't work
  if Assigned(aStream) then
  begin
    FPSSx80_VMEM_Params.BANK := aBankNr and 7;
    for i := 0 to 32 do
    begin
      nibble_hi := (FPSSx80_VMEM_Params.params[i] shr 4) and 15;
      nibble_lo := FPSSx80_VMEM_Params.params[i] and 15;
      aStream.WriteByte(nibble_hi);
      aStream.WriteByte(nibble_lo);
    end;
    Result := True;
  end
  else
    Result := False;
end;

function TPSSx80VoiceContainer.CalculateHash: string;
var
  aStream: TMemoryStream;
  i: integer;
begin
  //do not take Transpose and VoiceName into calculation
  aStream := TMemoryStream.Create;
  for i := 0 to 32 do
    aStream.WriteByte(FPSSx80_VMEM_Params.params[i]);
  aStream.Position := 0;
  Result := THashFactory.TCrypto.CreateSHA2_256().ComputeStream(aStream).ToString();
  aStream.Free;
end;

function TPSSx80VoiceContainer.GetChecksumPart: integer;
var
  checksum: integer;
  i: integer;
  tmpStream: TMemoryStream;
begin
  checksum := 0;
  tmpStream := TMemoryStream.Create;
  Save_VMEM_ToStream(FPSSx80_VMEM_Params.BANK, tmpStream);
  tmpStream.Position := 0;
  for i := 0 to tmpStream.Size - 1 do
    checksum := checksum + tmpStream.ReadByte;
  Result := checksum;
  tmpStream.Free;
end;

function TPSSx80VoiceContainer.GetChecksum: integer;
var
  checksum: integer;
begin
  checksum := 0;
  try
    checksum := GetChecksumPart;
    Result := ((not (checksum and 255)) and 127) + 1;
  except
    on e: Exception do Result := 0;
  end;
end;

procedure TPSSx80VoiceContainer.SysExVoiceToStream(var aStream: TMemoryStream);
begin
  aStream.Clear;
  aStream.Position := 0;
  aStream.WriteByte($F0);
  aStream.WriteByte($43);
  aStream.WriteByte($76);
  aStream.WriteByte($00);
  Save_VMEM_ToStream(FPSSx80_VMEM_Params.BANK, aStream);
  aStream.WriteByte(GetChecksum);
  aStream.WriteByte($F7);
end;

end.
