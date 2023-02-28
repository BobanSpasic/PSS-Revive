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
  TPSSx80_VCED_Dump = array [0..71] of byte;

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

        D_3_7: byte;
        D_4_7: byte;
        D_15_76: byte;
        D_15_210: byte;
        D_16_7: byte;
        D_16_32: byte;
        D_17_Hi: byte;
        D_17_Lo: byte;
        D_18_Hi: byte;
        D_18_Lo: byte;
        D_19_Hi: byte;
        D_19_Lo: byte;
        D_20_Hi: byte;
        D_21_Hi: byte;
        D_22_7: byte;
        D_23_Hi: byte;
        D_23_Lo: byte;
        D_24_54: byte;
        D_24_Lo: byte;

        D_25_Hi: byte;
        D_25_Lo: byte;
        D_26_Hi: byte;
        D_26_Lo: byte;
        D_27_Hi: byte;
        D_27_Lo: byte;
        D_28_Hi: byte;
        D_28_Lo: byte;
        D_29_Hi: byte;
        D_29_Lo: byte;
        D_30_Hi: byte;
        D_30_Lo: byte;
        D_31_Hi: byte;
        D_31_Lo: byte;
        D_32_Hi: byte;
        D_32_Lo: byte;
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

  public
    FPSSx80_VCED_Params: TPSSx80_VCED_Params;
    FPSSx80_VMEM_Params: TPSSx80_VMEM_Params;
    FPSSx80_VoiceName: string;
    function Load_VMEM_FromStream(const aStream: TMemoryStream;
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
    function Unk_Param: boolean;
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
  t.M_TL := ((aPar.D_3_7 shl 7) and 128) + aPar.M_TL and 127;
  t.M_LKS_HI_LKS_LO := ((aPar.M_LKS_HI and 15) shl 4) + (aPar.M_LKS_LO and 15);
  t.M_RKS_AR := ((aPar.M_RKS and 3) shl 6) + (aPar.M_AR and 63);
  t.M_AM_EN_DT2_D1R := ((aPar.M_AM_EN and 1) shl 7) + ((aPar.M_DT2 and 1) shl 6) +
    (aPar.M_D1R and 63);
  t.M_SIN_TBL_D2R := ((aPAr.M_SIN_TBL and 3) shl 6) + (aPar.M_D2R and 63);
  t.M_D1L_RR := ((aPar.M_D1L and 15) shl 4) + (aPar.M_RR and 15);
  t.M_SRR := ((aPar.D_20_Hi shl 4) and 240) + (aPar.M_SRR and 15);
  t.M_FB := ((aPar.D_15_76 shl 6) and 192) + ((aPar.M_FB shl 3) and 56) +
    (aPar.D_15_210 and 7);

  t.C_DT1_MUL := ((aPar.C_DT1 and 15) shl 4) + (aPar.C_MUL and 15);
  t.C_TL := ((aPar.D_4_7 shl 7) and 128) + aPar.C_TL and 127;
  t.C_LKS_HI_LKS_LO := ((aPar.C_LKS_HI and 15) shl 4) + (aPar.C_LKS_LO and 15);
  t.C_RKS_AR := ((aPar.C_RKS and 3) shl 6) + (aPar.C_AR and 63);
  t.C_AM_EN_DT2_D1R := ((aPar.C_AM_EN and 1) shl 7) + ((aPar.C_DT2 and 1) shl 6) +
    (aPar.C_D1R and 63);
  t.C_SIN_TBL_D2R := ((aPAr.C_SIN_TBL and 3) shl 6) + (aPar.C_D2R and 63);
  t.C_D1L_RR := ((aPar.C_D1L and 15) shl 4) + (aPar.C_RR and 15);
  t.C_SRR := ((aPar.D_21_Hi shl 4) and 240) + (aPar.C_SRR and 15);

  t.PMS_AMS := ((aPar.D_16_7 shl 7) and 128) + ((aPar.PMS shl 4) and 112) +
    (aPAr.AMS and 3) + ((aPar.D_16_32 shl 2) and 12);
  t.VDT := ((aPar.D_22_7 shl 7) and 128) + (aPar.VDT and 127);
  t.V_S := ((aPar.V shl 7) and 128) + ((aPar.S shl 6) and 64) +
    ((aPar.D_24_54 shl 4) and 48) + (aPar.D_24_Lo and 15);
  t.Reserved_17 := (aPar.D_17_Hi shl 4) + aPar.D_17_Lo;
  t.Reserved_18 := (aPar.D_18_Hi shl 4) + aPar.D_18_Lo;
  t.Reserved_19 := (aPar.D_19_Hi shl 4) + aPar.D_19_Lo;
  t.Reserved_23 := (aPar.D_23_Hi shl 4) + aPar.D_23_Lo;
  t.Reserved_25 := (aPar.D_25_Hi shl 4) + aPar.D_25_Lo;
  t.Reserved_26 := (aPar.D_26_Hi shl 4) + aPar.D_26_Lo;
  t.Reserved_27 := (aPar.D_27_Hi shl 4) + aPar.D_27_Lo;
  t.Reserved_28 := (aPar.D_28_Hi shl 4) + aPar.D_28_Lo;
  t.Reserved_29 := (aPar.D_29_Hi shl 4) + aPar.D_29_Lo;
  t.Reserved_30 := (aPar.D_30_Hi shl 4) + aPar.D_30_Lo;
  t.Reserved_31 := (aPar.D_31_Hi shl 4) + aPar.D_31_Lo;
  t.Reserved_32 := (aPar.D_32_Hi shl 4) + aPar.D_32_Lo;

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

  t.D_3_7 := (aPar.M_TL shr 7) and 1;
  t.D_4_7 := (aPar.C_TL shr 7) and 1;
  t.D_15_76 := (aPar.M_FB shr 6) and 3;
  t.D_15_210 := aPar.M_FB and 7;
  t.D_16_7 := (aPar.PMS_AMS shr 7) and 1;
  t.D_16_32 := (aPar.PMS_AMS shr 2) and 3;
  t.D_17_Hi := (aPar.Reserved_17 shr 4) and 15;
  t.D_17_Lo := aPar.Reserved_17 and 15;
  t.D_18_Hi := (aPar.Reserved_18 shr 4) and 15;
  t.D_18_Lo := aPar.Reserved_18 and 15;
  t.D_19_Hi := (aPar.Reserved_19 shr 4) and 15;
  t.D_19_Lo := aPar.Reserved_19 and 15;
  t.D_20_Hi := (aPar.M_SRR shr 4) and 15;
  t.D_21_Hi := (aPar.C_SRR shr 4) and 15;
  t.D_22_7 := (aPar.VDT shr 7) and 1;
  t.D_23_Hi := (aPar.Reserved_23 shr 4) and 15;
  t.D_23_Lo := aPar.Reserved_23 and 15;
  t.D_24_54 := (aPar.V_S shr 4) and 3;
  t.D_24_Lo := aPar.V_S and 15;

  t.D_25_Hi := (aPar.Reserved_25 shr 4) and 15;
  t.D_25_Lo := aPar.Reserved_25 and 15;
  t.D_26_Hi := (aPar.Reserved_26 shr 4) and 15;
  t.D_26_Lo := aPar.Reserved_26 and 15;
  t.D_27_Hi := (aPar.Reserved_27 shr 4) and 15;
  t.D_27_Lo := aPar.Reserved_27 and 15;
  t.D_28_Hi := (aPar.Reserved_28 shr 4) and 15;
  t.D_28_Lo := aPar.Reserved_28 and 15;
  t.D_29_Hi := (aPar.Reserved_29 shr 4) and 15;
  t.D_29_Lo := aPar.Reserved_29 and 15;
  t.D_30_Hi := (aPar.Reserved_30 shr 4) and 15;
  t.D_30_Lo := aPar.Reserved_30 and 15;
  t.D_31_Hi := (aPar.Reserved_31 shr 4) and 15;
  t.D_31_Lo := aPar.Reserved_31 and 15;
  t.D_32_Hi := (aPar.Reserved_32 shr 4) and 15;
  t.D_32_Lo := aPar.Reserved_32 and 15;
  Result := t;
end;

function TPSSx80VoiceContainer.GetVoiceName: string;
begin
  Result := FPSSx80_VoiceName;
end;

procedure TPSSx80VoiceContainer.SetVoiceName(aVoiceName: string);
begin
  FPSSx80_VoiceName := aVoiceName;
end;

function TPSSx80VoiceContainer.Load_VMEM_FromStream(const aStream: TMemoryStream;
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
    if test_byte = $F0 then             //reading from SysEx or from DB
      aStream.Position := Position + 4
    else
      aStream.Position := Position;
    for i := 0 to 32 do
    begin
      nibble_hi := aStream.ReadByte;
      nibble_lo := aStream.ReadByte;
      FPSSx80_VMEM_Params.params[i] := ((nibble_hi and 15) shl 4) + (nibble_lo and 15);
    end;
    if test_byte = $F0 then
    begin
      //load checksum and $F0
      //needed at loading from a bulk dump (5xVoice)
      nibble_hi := aStream.ReadByte;
      nibble_lo := aStream.ReadByte;
    end;

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
  FPSSx80_VoiceName := 'Sine Wave';
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

function TPSSx80VoiceContainer.Unk_Param: boolean;
begin
  Result := False;
  if (FPSSx80_VMEM_Params.params[3] and 128) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[4] and 128) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[15] and 199) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[16] and 140) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[17] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[18] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[19] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[20] and 240) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[21] and 240) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[22] and 128) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[23] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[24] and 63) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[25] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[26] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[27] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[28] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[29] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[30] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[31] and 255) <> 0 then Result := True;
  if (FPSSx80_VMEM_Params.params[32] and 255) <> 0 then Result := True;
end;

end.
