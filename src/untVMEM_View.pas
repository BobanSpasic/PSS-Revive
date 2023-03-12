{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 VMEM View - table view of a PSS-x80 voice data
}

unit untVMEM_View;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  kgrids, untPSSx80Voice, untUtils, kfunctions;

type

  { TfrmVMEM_View }

  TfrmVMEM_View = class(TForm)
    btBank1: TButton;
    btBank2: TButton;
    btBank3: TButton;
    btBank4: TButton;
    btBank5: TButton;
    btLabel: TButton;
    sgParams: TKGrid;
    sgVMEM: TStringGrid;
    procedure btBankClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgVMEMPrepareCanvas(Sender: TObject; aCol, aRow: integer;
      aState: TGridDrawState);
    procedure FillSG(aParams: TPSSx80_VMEM_Params);
    procedure sgVMEMSelection(Sender: TObject; aCol, aRow: integer);
  private

  public

  end;

var
  frmVMEM_View: TfrmVMEM_View;
  TmpVoice:     TPSSx80VoiceContainer;
  SaveToBank:   integer;
  VoiceName:    string;
  Editing:      boolean;

implementation

{$R *.lfm}

{ TfrmVMEM_View }

procedure TfrmVMEM_View.FormShow(Sender: TObject);
var
  i: integer;
begin
  if Editing then
  begin
    btBank1.Visible := True;
    btBank2.Visible := True;
    btBank3.Visible := True;
    btBank4.Visible := True;
    btBank5.Visible := True;
    btLabel.Visible := True;
  end
  else
  begin
    btBank1.Visible := False;
    btBank2.Visible := False;
    btBank3.Visible := False;
    btBank4.Visible := False;
    btBank5.Visible := False;
    btLabel.Visible := False;
  end;
  SaveToBank := 0;
  sgVMEM.Width := sgVMEM.DefaultColWidth * 9 + 4;
  sgParams.Width := sgParams.DefaultColWidth * 9 + 4;
  for i := 1 to 33 do
  begin
    sgVMEM.Cells[0, i] := IntToStr(i - 1);
    sgParams.Cells[0, i] := IntToStr(i - 1);
  end;
  sgParams.Cells[1, 0] := '7';
  sgParams.Cells[2, 0] := '6';
  sgParams.Cells[3, 0] := '5';
  sgParams.Cells[4, 0] := '4';
  sgParams.Cells[5, 0] := '3';
  sgParams.Cells[6, 0] := '2';
  sgParams.Cells[7, 0] := '1';
  sgParams.Cells[8, 0] := '0';
  sgParams.CellSpan[1, 1] := MakeCellSpan(8, 1);
  sgParams.Cells[1, 1] := 'BANK';
  sgParams.CellSpan[1, 2] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 2] := 'M_DT1';
  sgParams.CellSpan[5, 2] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 2] := 'M_MUL';
  sgParams.CellSpan[1, 3] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 3] := 'C_DT1';
  sgParams.CellSpan[5, 3] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 3] := 'C_MUL';
  sgParams.CellSpan[2, 4] := MakeCellSpan(7, 1);
  sgParams.Cells[2, 4] := 'M_TL';
  sgParams.CellSpan[2, 5] := MakeCellSpan(7, 1);
  sgParams.Cells[2, 5] := 'C_TL';
  sgParams.CellSpan[1, 6] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 6] := 'M_LKS(Hi)';
  sgParams.CellSpan[5, 6] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 6] := 'M_LKS(Lo)';
  sgParams.CellSpan[1, 7] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 7] := 'C_LKS(Hi)';
  sgParams.CellSpan[5, 7] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 7] := 'C_LKS(Lo)';
  sgParams.CellSpan[1, 8] := MakeCellSpan(2, 1);
  sgParams.Cells[1, 8] := 'M_RKS';
  sgParams.CellSpan[3, 8] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 8] := 'M_AR';
  sgParams.CellSpan[1, 9] := MakeCellSpan(2, 1);
  sgParams.Cells[1, 9] := 'C_RKS';
  sgParams.CellSpan[3, 9] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 9] := 'C_AR';
  sgParams.Cells[1, 10] := 'M_AM_EN';
  sgParams.Cells[2, 10] := 'M_DT2';
  sgParams.CellSpan[3, 10] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 10] := 'M_D1R';
  sgParams.Cells[1, 11] := 'C_AM_EN';
  sgParams.Cells[2, 11] := 'C_DT2';
  sgParams.CellSpan[3, 11] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 11] := 'C_D1R';
  sgParams.CellSpan[1, 12] := MakeCellSpan(2, 1);
  sgParams.Cells[1, 12] := 'M_SIN_TBL';
  sgParams.CellSpan[3, 12] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 12] := 'M_D2R';
  sgParams.CellSpan[1, 13] := MakeCellSpan(2, 1);
  sgParams.Cells[1, 13] := 'C_SIN_TBL';
  sgParams.CellSpan[3, 13] := MakeCellSpan(6, 1);
  sgParams.Cells[3, 13] := 'C_D2R';
  sgParams.CellSpan[1, 14] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 14] := 'M_D1L';
  sgParams.CellSpan[5, 14] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 14] := 'M_RR';
  sgParams.CellSpan[1, 15] := MakeCellSpan(4, 1);
  sgParams.Cells[1, 15] := 'C_D1L';
  sgParams.CellSpan[5, 15] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 15] := 'C_RR';
  sgParams.CellSpan[3, 16] := MakeCellSpan(3, 1);
  sgParams.Cells[3, 16] := 'FB';
  sgParams.CellSpan[2, 17] := MakeCellSpan(3, 1);
  sgParams.Cells[2, 17] := 'PMS';
  sgParams.CellSpan[7, 17] := MakeCellSpan(2, 1);
  sgParams.Cells[7, 17] := 'AMS';
  sgParams.CellSpan[5, 21] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 21] := 'M_SRR';
  sgParams.CellSpan[5, 22] := MakeCellSpan(4, 1);
  sgParams.Cells[5, 22] := 'C_SRR';
  sgParams.CellSpan[2, 23] := MakeCellSpan(7, 1);
  sgParams.Cells[2, 23] := 'VDT';
  sgParams.Cells[1, 25] := 'V';
  sgParams.Cells[2, 25] := 'S';
end;

procedure TfrmVMEM_View.btBankClick(Sender: TObject);
const
  cv: array[0..8] of integer = (0, 128, 64, 32, 16, 8, 4, 2, 1);
var
  CellVal: byte;
  RowVal: byte;
  c, r: integer;
  dump: TPSSx80_VMEM_Params;
begin
  SaveToBank := (Sender as TButton).Tag;
  for r := 1 to 33 do
  begin
    RowVal := 0;
    for c := 1 to 8 do
    begin
      CellVal := StrToInt(sgVMEM.Cells[c, r]);
      RowVal := RowVal + (CellVal * cv[c]);
      dump.params[r - 1] := RowVal;
    end;
  end;
  dump.params[0] := SaveToBank;
  TmpVoice.Set_VMEM_Params(dump);
  Close;
end;

procedure TfrmVMEM_View.FormCreate(Sender: TObject);
begin
  TmpVoice := TPSSx80VoiceContainer.Create;
end;

procedure TfrmVMEM_View.FormDestroy(Sender: TObject);
begin
  TmpVoice.Free;
end;

procedure TfrmVMEM_View.sgVMEMPrepareCanvas(Sender: TObject;
  aCol, aRow: integer; aState: TGridDrawState);
const
  unk: array[0..33] of integer =
    (0, 0, 0, 0, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199, 140, 255, 255, 255, 240,
    240, 128, 255, 63, 255, 255, 255, 255, 255, 255, 255, 255);
  cv: array[0..8] of integer = (0, 128, 64, 32, 16, 8, 4, 2, 1);
var
  c, r: integer;
begin
  Unused(aState);
  c := cv[aCol];
  r := unk[aRow];
  if ((r and c) <> 0) and ((Sender as TStringGrid).Cells[aCol, aRow] = '1') then
  begin
    (Sender as TStringGrid).Canvas.Brush.Color := clSkyBlue;
  end
  else
  if (r and c) <> 0 then
  begin
    (Sender as TStringGrid).Canvas.Brush.Color := clGray;
  end
  else
    (Sender as TStringGrid).Canvas.Brush.Color := clDefault;
end;

procedure TfrmVMEM_View.FillSG(aParams: TPSSx80_VMEM_Params);
const
  cv: array[1..8] of byte = (128, 64, 32, 16, 8, 4, 2, 1);
var
  line: byte;
  b: byte;
  i, j: integer;
begin
  if not Assigned(frmVMEM_View) then exit;
  frmVMEM_View.Caption := 'VMEM View - ' + VoiceName;
  for i := 0 to 32 do
  begin
    line := aParams.params[i];
    for j := 1 to 8 do
    begin
      b := cv[j];
      sgVMEM.Cells[j, i + 1] := BoolToStr(((line and b) = b), '1', '0');
    end;
  end;
end;

procedure TfrmVMEM_View.sgVMEMSelection(Sender: TObject; aCol, aRow: integer);
begin
  if Editing then
    if sgVMEM.Cells[aCol, aRow] = '1' then sgVMEM.Cells[aCol, aRow] := '0'
    else
      sgVMEM.Cells[aCol, aRow] := '1';
end;

end.
