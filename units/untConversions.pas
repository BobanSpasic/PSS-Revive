{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 Convert files from other programs to syx files
}

unit untConversions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, untPSSx80Voice, untUtils;

function Ved2Syx(aFileName: string): string;
function BW2Syx(aFileName: string): string;

implementation

function Ved2Syx(aFileName: string): string;
var
  vedStream: TStringList;
  syxStream: TMemoryStream;
  syxName: string;
  voice: TPSSx80VoiceContainer;
begin
  Result := '';
  vedStream := TStringList.Create;
  syxStream := TMemoryStream.Create;
  voice := TPSSx80VoiceContainer.Create;
  syxName := StringReplace(aFilename, '.ved', '.syx', [rfIgnoreCase, rfReplaceAll]);
  vedStream.LoadFromFile(aFileName);
  if vedStream.Count = 36 then
  begin
    voice.InitVoice;
    with voice.FPSSx80_VCED_Params do
    begin
      M_DT1 := StrToInt(vedStream.Strings[0]);
      M_MUL := StrToInt(vedStream.Strings[2]);
      M_TL := StrToInt(vedStream.Strings[4]);
      M_LKS_HI := StrToInt(vedStream.Strings[6]);
      M_LKS_LO := StrToInt(vedStream.Strings[8]);
      M_RKS := StrToInt(vedStream.Strings[10]);
      M_AR := StrToInt(vedStream.Strings[12]);
      M_AM_EN := StrToInt(vedStream.Strings[26]);
      M_DT2 := StrToInt(vedStream.Strings[28]);
      M_D1R := StrToInt(vedStream.Strings[14]);
      M_SIN_TBL := StrToInt(vedStream.Strings[24]);
      M_D2R := StrToInt(vedStream.Strings[16]);
      M_D1L := StrToInt(vedStream.Strings[18]);
      M_RR := StrToInt(vedStream.Strings[20]);
      M_SRR := StrToInt(vedStream.Strings[22]);
      M_FB := StrToInt(vedStream.Strings[30]);

      C_DT1 := StrToInt(vedStream.Strings[1]);
      C_MUL := StrToInt(vedStream.Strings[3]);
      C_TL := StrToInt(vedStream.Strings[5]);
      C_LKS_HI := StrToInt(vedStream.Strings[7]);
      C_LKS_LO := StrToInt(vedStream.Strings[9]);
      C_RKS := StrToInt(vedStream.Strings[11]);
      C_AR := StrToInt(vedStream.Strings[13]);
      C_AM_EN := StrToInt(vedStream.Strings[27]);
      C_DT2 := StrToInt(vedStream.Strings[29]);
      C_D1R := StrToInt(vedStream.Strings[15]);
      C_SIN_TBL := StrToInt(vedStream.Strings[25]);
      C_D2R := StrToInt(vedStream.Strings[17]);
      C_D1L := StrToInt(vedStream.Strings[19]);
      C_RR := StrToInt(vedStream.Strings[21]);
      C_SRR := StrToInt(vedStream.Strings[23]);

      PMS := StrToInt(vedStream.Strings[31]);
      AMS := StrToInt(vedStream.Strings[32]);
      VDT := StrToInt(vedStream.Strings[33]);
      V := StrToInt(vedStream.Strings[34]);
      S := StrToInt(vedStream.Strings[35]);
    end;
    voice.FPSSx80_VMEM_Params := VCEDtoVMEM(voice.FPSSx80_VCED_Params);
    voice.SysExVoiceToStream(0, syxStream);
    syxStream.SaveToFile(syxName);
    Result := ExtractFileName(syxName);
  end;
  vedStream.Free;
  syxStream.Free;
  voice.Free;
end;

function BW2Syx(aFileName: string): string;
var
  inputStream: TMemoryStream;
  bankName: array [1..8] of char;
  voiceName: array [1..16] of char;
  voiceList: TStringList;
  vmemData: array [0..32] of byte;
  voiceDump: TMemoryStream;
  i, j: integer;
  checksum: integer;
  syxname: string;
  padding: string;
begin
  Result := '';
  inputStream := TMemoryStream.Create;
  inputStream.LoadFromFile(aFileName);
  if inputStream.Size = 4908 then
  begin
    voiceList := TStringList.Create;
    for i := 1 to 8 do
      bankName[i] := char(inputStream.ReadByte);
    for i := 0 to 99 do
    begin
      for j := 1 to 16 do
        voiceName[j] := char(inputStream.ReadByte);
      voiceList.Add(GetValidFileName(voiceName));
    end;
    for i := 0 to 99 do
    begin
      for j := 0 to 32 do
        vmemData[j] := inputStream.ReadByte;
      //checksumm
      checksum := 0;
      for j := 0 to 32 do
        checksum := checksum + vmemData[j];
      checksum := ((not (checksum and 255)) and 127) + 1;
      voiceDump := TMemoryStream.Create;
      voiceDump.WriteByte($F0);
      voiceDump.WriteByte($43);
      voiceDump.WriteByte($76);
      voiceDump.WriteByte($00);
      for j := 0 to 32 do
      begin
        voiceDump.WriteByte((vmemData[j] shr 4) and 15);     // hi nibble
        voiceDump.WriteByte(vmemData[j] and 15);             // lo nibble
      end;
      voiceDump.WriteByte(byte(checksum));  //checksumm goes here
      voiceDump.WriteByte($F7);
      if i < 10 then padding := '0' else padding := '';
      syxname := IncludeTrailingPathDelimiter(ExtractFileDir(aFileName)) + padding + IntToStr(i) + ' ' + trim(voiceList[i]) + '.syx';
      voiceDump.SaveToFile(syxname);
      voiceDump.Free;
      Result := ExtractFileName(syxname);
    end;
    //voiceList.SaveToFile(aFileName + '.ins');   // debug
    voiceList.Free;
  end;
  inputStream.Free;
end;

end.
