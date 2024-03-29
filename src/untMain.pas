{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

}

unit untMain;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  {$IFDEF WINDOWS}
  Messages,
  {$ENDIF}
  SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  Grids, Spin, atshapeline, ECEditBtns, ECLink, ECSlider, ECSpinCtrls, Types,
  LCLIntf, LazFileUtils, LCLType, MaskEdit, Buttons, AdvLed, LazUTF8,
  TAGraph, TASeries, TAGUIConnectorBGRA, Math, SyncObjs, VersionSupport
  {$IFDEF WINDOWS}
  ,MIDI, untUnPortMIDI
  {$ENDIF}
  {$IFDEF UNIX}
  ,untLinuxMIDI, PortMidi
  {$ENDIF}
  , untPSSx80Voice, untPSSx80Bank, untSQLProxy, untUtils, untPSSx80Utils,
  untMiniINI, untPopUp, untVMEM_View, untLog, untConversions;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    alBank1: TAdvLed;
    alBank2: TAdvLed;
    alBank3: TAdvLed;
    alBank4: TAdvLed;
    alBank5: TAdvLed;
    btDeleteVoiceDB: TButton;
    btStore: TButton;
    btRandomize: TButton;
    CarrierRR: TLineSeries;
    CarrierSRR: TLineSeries;
    cbAutoPreview: TCheckBox;
    cbMidiIn: TComboBox;
    cbMidiOut: TComboBox;
    ChartGUIConnectorBGRA1: TChartGUIConnectorBGRA;
    cbLivePreview: TCheckBox;
    cbShowLog: TCheckBox;
    gbLKS: TGroupBox;
    gbENV: TGroupBox;
    Graph: TChart;
    Divider: TLineSeries;
    ilLKS_HI: TImageList;
    ilLKS_LO: TImageList;
    ilSIN_TBL: TImageList;
    imM_SIN_TBL: TImage;
    imC_SIN_TBL: TImage;
    imLogo: TImage;
    imLKS_HI: TImage;
    imLKS_LO: TImage;
    lbAutoPreviewBank: TLabel;
    lbInfo: TLabel;
    lbMod: TLabel;
    lbCredits1: TLabel;
    lbFontSize: TLabel;
    lbMidiIn: TLabel;
    lbMidiOut: TLabel;
    lbCar: TLabel;
    lbPopUpDur: TLabel;
    lnkCredits2: TECLink;
    lnkCredits3: TECLink;
    lnkVisit: TECLink;
    MaskEdit1: TMaskEdit;
    MaskEdit10: TMaskEdit;
    MaskEdit11: TMaskEdit;
    MaskEdit12: TMaskEdit;
    MaskEdit13: TMaskEdit;
    MaskEdit14: TMaskEdit;
    MaskEdit15: TMaskEdit;
    MaskEdit16: TMaskEdit;
    MaskEdit17: TMaskEdit;
    MaskEdit18: TMaskEdit;
    MaskEdit19: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    MaskEdit23: TMaskEdit;
    MaskEdit24: TMaskEdit;
    MaskEdit25: TMaskEdit;
    MaskEdit26: TMaskEdit;
    MaskEdit27: TMaskEdit;
    MaskEdit28: TMaskEdit;
    MaskEdit29: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit30: TMaskEdit;
    MaskEdit31: TMaskEdit;
    MaskEdit32: TMaskEdit;
    MaskEdit33: TMaskEdit;
    MaskEdit34: TMaskEdit;
    MaskEdit35: TMaskEdit;
    MaskEdit36: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit9: TMaskEdit;
    mmInfo: TMemo;
    ModulatorRR: TLineSeries;
    ModulatorSRR: TLineSeries;
    pnLivePreview: TPanel;
    pnCredits: TPanel;
    pnInfo: TPanel;
    S: TECSlider;
    AMS: TECSlider;
    seFontSize: TSpinEdit;
    sePopUpDur: TSpinEdit;
    slGen: TShapeLine;
    slMod: TShapeLine;
    slCar: TShapeLine;
    seAutoPreviewBank: TSpinEdit;
    tsSettings: TTabSheet;
    VDT: TECSlider;
    PMS: TECSlider;
    V: TECSlider;
    edbtSelSysExDir: TECEditBtn;
    edSlot01: TLabeledEdit;
    edSlot02: TLabeledEdit;
    edSlot03: TLabeledEdit;
    edSlot04: TLabeledEdit;
    edSlot05: TLabeledEdit;
    C_AM_EN: TECSlider;
    C_AR: TECSlider;
    C_D1L: TECSlider;
    C_D1R: TECSlider;
    C_D2R: TECSlider;
    C_DT1: TECSlider;
    C_DT2: TECSlider;
    C_LKS_HI: TECSlider;
    C_LKS_LO: TECSlider;
    M_MUL: TECSlider;
    M_DT1: TECSlider;
    C_MUL: TECSlider;
    C_RKS: TECSlider;
    C_RR: TECSlider;
    C_SIN_TBL: TECSlider;
    M_SRR: TECSlider;
    M_RKS: TECSlider;
    M_LKS_LO: TECSlider;
    M_LKS_HI: TECSlider;
    M_FB: TECSlider;
    C_SRR: TECSlider;
    M_TL: TECSlider;
    M_DT2: TECSlider;
    M_SIN_TBL: TECSlider;
    M_AM_EN: TECSlider;
    M_AR: TECSlider;
    M_D1R: TECSlider;
    M_D1L: TECSlider;
    M_D2R: TECSlider;
    M_RR: TECSlider;
    C_TL: TECSlider;
    pnSlot01: TPanel;
    pnSlot02: TPanel;
    pnSlot03: TPanel;
    pnSlot04: TPanel;
    pnSlot05: TPanel;
    tbBank: TToolBar;
    tbbtSaveBank: TToolButton;
    tbbtSendVoiceDump: TToolButton;
    tbSearch: TEdit;
    lbFiles: TListBox;
    lbVoices: TListBox;
    tbpnSearch: TPanel;
    pcFilesDatabase: TPageControl;
    pnBankSlots: TPanel;
    pnFileManager: TPanel;
    pnVoiceManager: TPanel;
    ilToolbarBankPerformance: TImageList;
    SaveBankDialog1: TSaveDialog;
    SelectSysExDirectoryDialog1: TSelectDirectoryDialog;
    sl3: TShapeLine;
    sl4: TShapeLine;
    Splitter1: TSplitter;
    sgDB: TStringGrid;
    tbDatabase: TToolBar;
    tbbtRefresh: TToolButton;
    tbbtCommit: TToolButton;
    tbSeparator1: TToolButton;
    tbSeparator2: TToolButton;
    tbSeparator5: TToolButton;
    tbbtDelVoice: TToolButton;
    tbSeparator6: TToolButton;
    tbSeparator7: TToolButton;
    tbStoreToDB: TToolButton;
    tsFiles: TTabSheet;
    tsDatabase: TTabSheet;
    procedure alBankClick(Sender: TObject);
    procedure btDeleteVoiceDBClick(Sender: TObject);
    procedure btRandomizeClick(Sender: TObject);
    procedure btSelectDirClick(Sender: TObject);
    procedure btStoreClick(Sender: TObject);
    procedure cbMidiInChange(Sender: TObject);
    procedure cbMidiOutChange(Sender: TObject);
    procedure cbShowLogChange(Sender: TObject);
    procedure C_LKSChange(Sender: TObject);
    procedure edSlotChange(Sender: TObject);
    procedure edSlotEditingDone(Sender: TObject);
    procedure edSlotDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure edSlotDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure imLKS_LOClick(Sender: TObject);
    procedure imLogoClick(Sender: TObject);
    procedure lbFilesClick(Sender: TObject);
    procedure lbFilesDblClick(Sender: TObject);
    procedure lbFilesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lbVoicesClick(Sender: TObject);
    procedure lbVoicesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lnkCreditsClick(Sender: TObject);
    procedure MaskEditLinkedEdit(Sender: TObject);
    procedure M_LKSChange(Sender: TObject);
    procedure SliderLinkedEdit(Sender: TObject);
    procedure SliderChange(Sender: TObject);
    procedure pnSlotClick(Sender: TObject);
    procedure seFontSizeChange(Sender: TObject);
    procedure sePopUpDurChange(Sender: TObject);
    procedure sgDBBeforeSelection(Sender: TObject; aCol, aRow: integer);
    procedure sgDBClick(Sender: TObject);
    procedure sgDBDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: boolean);
    procedure sgDBEditingDone(Sender: TObject);
    procedure sgDBStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure tbbtCommitClick(Sender: TObject);
    procedure tbbtDelVoiceClick(Sender: TObject);
    procedure tbbtRefreshClick(Sender: TObject);
    procedure tbbtSaveBankClick(Sender: TObject);
    procedure tbbtSendVoiceDumpClick(Sender: TObject);
    procedure LoadLastStateBank;
    procedure FillFilesList(aFolder: string);
    procedure OpenSysEx(aName: string);
    procedure tbSearchKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure tbStoreToDBClick(Sender: TObject);
    procedure SendSimpleMelody(aCh: integer);
    procedure VoiceToGUI(aVoiceNr: integer);
    procedure GUIToVoice(aVoiceNr: integer);
    procedure RefreshGraph;
    function LoadVoiceNames(aSysExName: string): boolean;
    function SaveVoiceNames(aSysExName: string): boolean;
    procedure RefreshGui;
    procedure LEDs(aVoiceNr: integer);
    procedure LEDGreen(aVoiceNr: integer);
    procedure LEDYellow(aVoiceNr: integer);

  private
    FCriticalSection: TCriticalSection;
    {$IFDEF WINDOWS}
    procedure MIDIdataIn(var msg: TMessage); message WM_MIDIDATA_ARRIVED;
    {$ENDIF}
  public
    procedure OnMidiInData(const aDeviceIndex: integer;
      const aStatus, aData1, aData2: byte);
    procedure OnSysExData(const aDeviceIndex: integer; const aStream: TMemoryStream);
  end;

var
  dragItem: integer;
  sgSyxDragItem: integer;
  FMidiIn: string;
  FMidiInInt: integer;
  FMidiOut: string;
  FMidiOutInt: integer;
  FMidiIsActive: boolean;
  frmMain: TfrmMain;
  LastSysExOpenDir: string;
  LastSysExSaveDir: string;
  LastSysEx: string;
  FUpdatingForm: boolean;
  DBName: string;
  HomeDir: string;
  //AppDir: string;
  compArray: array [0..1] of string;
  compList: TStringList;
  LastSelectedRow: integer;
  SQLProxy: TSQLProxy;
  LastClickedFile: integer;
  PopUpDuration: integer;
  FTmpVoice: TPSSx80VoiceContainer;
  FEditVoice: TPSSx80VoiceContainer;
  FTmpBank: TPSSx80BankContainer;
  FBank: TPSSx80BankContainer;
  CurrentBank: integer;
  LoadingBank: boolean;

implementation

{$R *.lfm}

{$IFDEF WINDOWS}
//uses JWAwindows;
{$ENDIF}

{ TfrmMain }

procedure TfrmMain.tbSearchKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  Unused(Shift);
  if Key = VK_RETURN then tbbtRefresh.Click;
end;

procedure TfrmMain.tbStoreToDBClick(Sender: TObject);
var
  voiceStream: TMemoryStream;
  i: integer;
begin
  for i := 1 to 5 do
  begin
    try
      voiceStream := TMemoryStream.Create;
      FBank.GetVoice(i, FTmpVoice);
      FTmpVoice.Save_VMEM_ToStream(i, voiceStream);
      SQLProxy.AddVoice(FTmpVoice.CalculateHash, FBank.GetVoiceName(i),
        voiceStream);

    finally
      voiceStream.Free;
    end;
  end;
  PopUp('Done!', PopUpDuration);
end;

procedure TfrmMain.OnMidiInData(const aDeviceIndex: integer;
  const aStatus, aData1, aData2: byte);
begin
  //do not call GUI elements from a callback function, use Messages

  // skip active sensing signals from keyboard
  if aStatus = $FE then Exit;  //skip active sensing
  if aStatus = $F8 then Exit;  //skip real-time clock
  {$IFDEF WINDOWS}
  PostMessage(Application.MainForm.Handle,
    WM_MIDIDATA_ARRIVED,
    aDeviceIndex,
    aStatus + (aData1 and $ff) shl 8 + (aData2 and $FF) shl 16);
  {$ENDIF}
end;

{$IFDEF WINDOWS}
procedure TfrmMain.MIDIdataIn(var msg: TMessage);
begin
  // simply display the values:
  if (Msg.lParamlo <> $F8)     // IGNORE real-time message clock $F8 = 248
    and (Msg.lParamlo <> $FE)  // IGNORE "Active Sensing" $FE = 254
  then
  begin
      {
      mmTestSamples.Append( IntToStr( Msg.wParamhi) +' '
                       +IntToStr( Msg.wParamlo) +'  '
                       // MIDI Note on / off
                       +IntToHex( Msg.lParamlo and $FF, 2) +' '
                       // MIDI Note value
                       +IntToHex( (Msg.lParamlo shr 8) and $FF, 2) +' '
                       // MIDI Key On Velocity
                       +IntToHex( Msg.lParamhi and $FF, 2)
                       );

                       // this value always contains NULL and can be ignored :
                       //+IntToHex( (Msg.lParamhi shr 8) and $FF, 2)
                       }
  end;
end;
{$ENDIF}

procedure TfrmMain.OnSysExData(const aDeviceIndex: integer;
  const aStream: TMemoryStream);
var
  VoiceNr: integer;
  Received: boolean;
begin
  Unused(aDeviceIndex);
  Received := False;
  try
    try
      FCriticalSection.Acquire;
      VoiceNr := 1;
      if aStream.Size = 72 then
      begin
        frmMIDILog.InLog(StreamToVCEDHex(aStream));
        if ContainsPSSx80Voice(aStream, VoiceNr) then
        begin
          FEditVoice.Load_VMEM_FromStream(aStream, 0);
          FBank.SetVoice(VoiceNr, FEditVoice);
          FBank.SetVoiceName(VoiceNr, 'Received ' + IntToStr(VoiceNr));
          Received := True;
        end;
      end;
      FCriticalSection.Leave;
    finally
      if Received then
      begin
        if VoiceNr = 5 then VoiceToGUI(VoiceNr);
        CurrentBank := VoiceNr;
        LEDYellow(VoiceNr);
        edSlot01.Text := FBank.GetVoiceName(1);
        edSlot02.Text := FBank.GetVoiceName(2);
        edSlot03.Text := FBank.GetVoiceName(3);
        edSlot04.Text := FBank.GetVoiceName(4);
        edSlot05.Text := FBank.GetVoiceName(5);
      end;
    end;
  except
    on e: Exception do ShowMessage('Exception:' + #13#10 + e.Message);
  end;
end;

procedure TfrmMain.btSelectDirClick(Sender: TObject);
begin
  if SelectSysExDirectoryDialog1.Execute then
  begin
    lbVoices.Clear;
    LastSysExOpenDir := IncludeTrailingPathDelimiter(
      SelectSysExDirectoryDialog1.FileName);
    edbtSelSysExDir.Text := ShortenFileName(LastSysExOpenDir);
    FillFilesList(SelectSysExDirectoryDialog1.FileName);
  end;
end;

procedure TfrmMain.btStoreClick(Sender: TObject);
begin
  LoadingBank := True;
  GUIToVoice(CurrentBank);
  LEDGreen(CurrentBank);
  LoadingBank := False;
end;

procedure TfrmMain.RefreshGraph;
var
  newX: double;
  d1, d2: integer;
  M_off, C_off: integer;
begin
  d1 := 15;
  d2 := 12;
  M_off := 20;
  C_off := 0;
  with Graph do
  begin
    ModulatorRR.Clear;
    ModulatorSRR.Clear;
    CarrierRR.Clear;
    CarrierSRR.Clear;
    Divider.Clear;
    Divider.AddXY(0, M_off - 2);
    Divider.AddXY(320, M_off - 2);

    ModulatorRR.AddXY(0, M_off);
    newX := 64 - M_AR.Position;
    ModulatorRR.AddXY(newX, M_off + 15);
    newX := newX + 64 - M_D1R.Position;
    ModulatorRR.AddXY(newX, M_off + max(0, d1 - M_D1L.Position));
    newX := newX + 64 - M_D2R.Position;
    ModulatorRR.AddXY(newX, M_off + max(0, d2 - M_D1L.Position));
    newX := newX + 64 - M_RR.Position;
    ModulatorRR.AddXY(newX, M_off);

    ModulatorSRR.AddXY(0, M_off);
    newX := 64 - M_AR.Position;
    ModulatorSRR.AddXY(newX, M_off + 15);
    newX := newX + 64 - M_D1R.Position;
    ModulatorSRR.AddXY(newX, M_off + max(0, 15 - M_D1L.Position));
    newX := newX + 64 - M_D2R.Position;
    ModulatorSRR.AddXY(newX, M_off + max(0, 12 - M_D1L.Position));
    newX := newX + 128 - M_SRR.Position;
    ModulatorSRR.AddXY(newX, M_off);

    CarrierRR.AddXY(0, C_off);
    newX := 64 - C_AR.Position;
    CarrierRR.AddXY(newX, C_off + 15);
    newX := newX + 64 - C_D1R.Position;
    CarrierRR.AddXY(newX, C_off + max(0, d1 - C_D1L.Position));
    newX := newX + 64 - C_D2R.Position;
    CarrierRR.AddXY(newX, C_off + max(0, d2 - C_D1L.Position));
    newX := newX + 64 - C_RR.Position;
    CarrierRR.AddXY(newX, C_off);

    CarrierSRR.AddXY(0, C_off);
    newX := 64 - C_AR.Position;
    CarrierSRR.AddXY(newX, C_off + 15);
    newX := newX + 64 - C_D1R.Position;
    CarrierSRR.AddXY(newX, C_off + max(0, 15 - C_D1L.Position));
    newX := newX + 64 - C_D2R.Position;
    CarrierSRR.AddXY(newX, C_off + max(0, 12 - C_D1L.Position));
    newX := newX + 128 - C_SRR.Position;
    CarrierSRR.AddXY(newX, C_off);
  end;
end;

procedure TfrmMain.btDeleteVoiceDBClick(Sender: TObject);
begin
  if MessageDlg('Confirm deletion of Voices database',
    'This operation is not reversible.' + #13#10 + 'Are you sure?',
    mtWarning, mbYesNo, 0) = mrYes then
  begin
    SQLProxy.CleanTable('VOICES');
    SQLProxy.Vacuum;
  end;
end;

procedure TfrmMain.btRandomizeClick(Sender: TObject);
var
  dtSgn, dtVal: byte;
begin
  Randomize;
  LoadingBank := True; //stop Live Preview
  M_MUL.Position := trunc((M_MUL.Max + 1) * Random);
  dtSgn := trunc(Random);
  dtVal := trunc((M_DT1.Max + 1) * Random);
  if dtSgn > 0 then dtVal := -dtVal;
  M_DT1.Position := dtVal;
  M_DT2.Position := trunc((M_DT2.Max + 1) * Random);
  M_SIN_TBL.Position := trunc((M_SIN_TBL.Max + 1) * Random);
  M_AM_EN.Position := trunc((M_AM_EN.Max + 1) * Random);

  M_AR.Position := max(30, trunc((M_AR.Max + 1) * Random));
  M_D1R.Position := trunc((M_D1R.Max + 1) * Random);
  M_D1L.Position := trunc((M_D1L.Max + 1) * Random);
  M_D2R.Position := trunc((M_D2R.Max + 1) * Random);
  M_RR.Position := trunc((M_RR.Max + 1) * Random);
  M_SRR.Position := trunc((M_SRR.Max + 1) * Random);
  M_RKS.Position := trunc((M_RKS.Max + 1) * Random);
  M_LKS_LO.Position := trunc((M_LKS_LO.Max + 1) * Random);
  M_LKS_HI.Position := trunc((M_LKS_HI.Max + 1) * Random);
  M_FB.Position := trunc((M_FB.Max + 1) * Random);
  M_TL.Position := trunc((M_TL.Max + 1) * Random);

  C_MUL.Position := trunc((C_MUL.Max + 1) * Random);
  dtSgn := trunc(Random);
  dtVal := trunc((C_DT1.Max + 1) * Random);
  if dtSgn > 0 then dtVal := -dtVal;
  C_DT1.Position := dtVal;
  C_DT2.Position := trunc((C_DT2.Max + 1) * Random);
  C_SIN_TBL.Position := trunc((C_SIN_TBL.Max + 1) * Random);
  C_AM_EN.Position := trunc((C_AM_EN.Max + 1) * Random);

  C_AR.Position := max(30, trunc((C_AR.Max + 1) * Random));
  C_D1R.Position := trunc((C_D1R.Max + 1) * Random);
  C_D1L.Position := trunc((C_D1L.Max + 1) * Random);
  C_D2R.Position := trunc((C_D2R.Max + 1) * Random);
  C_RR.Position := trunc((C_RR.Max + 1) * Random);
  C_SRR.Position := trunc((C_SRR.Max + 1) * Random);
  C_RKS.Position := trunc((C_RKS.Max + 1) * Random);
  C_LKS_LO.Position := trunc((C_LKS_LO.Max + 1) * Random);
  C_LKS_HI.Position := trunc((C_LKS_HI.Max + 1) * Random);
  C_TL.Position := 90;

  PMS.Position := trunc((PMS.Max + 1) * Random);
  AMS.Position := trunc((AMS.Max + 1) * Random);
  VDT.Position := trunc((VDT.Max + 1) * Random);
  V.Position := trunc((V.Max + 1) * Random);
  LoadingBank := False; //leave one slider to triger the LivePreview if set
  S.Position := trunc((S.Max + 1) * Random);

end;

procedure TfrmMain.alBankClick(Sender: TObject);
begin
  LoadingBank := True;
  //Save editor state to the current bank before changing bank
  GUIToVoice(CurrentBank);
  CurrentBank := (Sender as TAdvLed).Tag;
  //Change bank
  VoiceToGUI(CurrentBank);
  LoadingBank := False;
  frmVMEM_View.ShowModal;
  //after close
  if untVMEM_View.SaveToBank <> 0 then
    //zero means the form is closed without click on Save to Bank X
  begin
    if Assigned(untVMEM_View.TmpVoice) then
    begin
      CurrentBank := untVMEM_View.SaveToBank;
      FBank.SetVoice(CurrentBank, untVMEM_View.TmpVoice);
      FBank.SetVoiceName(CurrentBank, copy(untVMEM_View.VoiceName,
        10, Length(untVMEM_View.VoiceName) - 10));
      VoiceToGUI(CurrentBank);
      LEDYellow(CurrentBank);
    end;
  end;
end;

procedure TfrmMain.cbMidiInChange(Sender: TObject);
var
  i: integer;
  err: PmError;
begin
  for i := 0 to MidiInput.Devices.Count - 1 do
    MidiInput.Close(i);
  if cbMidiIn.ItemIndex <> -1 then
  begin
    FMidiIn := cbMidiIn.Text;
    FMidiInInt := cbMidiIn.ItemIndex;
    err := MidiInput.Open(FMidiInInt);
    if (err = 0) or (err = 1) then
    begin
      frmMIDILog.InLog('Opening port ' + IntToStr(FMidiInInt) + ' successfull');
      FMidiIsActive := True;
    end
    else
    begin
      frmMIDILog.InLog('Opening port ' + IntToStr(FMidiInInt) +
        ' failed: ' + Pm_GetErrorText(err));
      cbMidiIn.ItemIndex := -1;
    end;
  end;
end;

procedure TfrmMain.cbMidiOutChange(Sender: TObject);
var
  i: integer;
  err: PmError;
begin
  for i := 0 to MidiOutput.Devices.Count - 1 do
    MidiOutput.Close(i);
  if cbMidiOut.ItemIndex <> -1 then
  begin
    FMidiOut := cbMidiOut.Text;
    FMidiOutInt := cbMidiOut.ItemIndex;
    err := MidiOutput.Open(FMidiOutInt);
    if (err = 0) or (err = 1) then
    begin
      frmMIDILog.OutLog('Opening port ' + IntToStr(FMidiOutInt) + ' successful');
      FMidiIsActive := True;
    end
    else
    begin
      frmMIDILog.OutLog('Opening port ' + IntToStr(FMidiOutInt) +
        ' failed: ' + Pm_GetErrorText(err));
      cbMidiOut.ItemIndex := -1;
    end;
  end;
end;

procedure TfrmMain.cbShowLogChange(Sender: TObject);
begin
  if cbShowLog.Checked then
    frmMIDILog.Show
  else
    frmMIDILog.Close;
end;

procedure TfrmMain.C_LKSChange(Sender: TObject);
begin
  gbLKS.Caption := 'LKS Carrier';
  ilLKS_HI.GetBitmap(trunc(C_LKS_HI.Position), imLKS_HI.Picture.Bitmap);
  ilLKS_LO.GetBitmap(trunc(C_LKS_LO.Position), imLKS_LO.Picture.Bitmap);
  SliderLinkedEdit(Sender);
end;

procedure TfrmMain.edSlotChange(Sender: TObject);
begin
  (Sender as TLabeledEdit).Hint := (Sender as TLabeledEdit).Text;
end;

procedure TfrmMain.edSlotEditingDone(Sender: TObject);
begin
  FBank.SetVoiceName((Sender as TLabeledEdit).Tag, (Sender as TLabeledEdit).Text);
end;

procedure TfrmMain.edSlotDragDrop(Sender, Source: TObject; X, Y: integer);
var
  dmp: TMemoryStream;
  i: integer;
begin
  Unused(X, Y);
  if Source = lbFiles then
  begin
    if lbFiles.ItemIndex = -1 then exit;
    dmp := TMemoryStream.Create;
    dmp.Clear;
    FTmpBank.AppendSysExBankToStream(dmp);
    for i := 1 to 5 do
    begin
      LEDGreen(i);
      FBank.SetVoiceName(i, FTmpBank.GetVoiceName(i));
    end;
    FBank.LoadBankFromStream(dmp, 0);
    edSlot01.Text := FBank.GetVoiceName(1);
    edSlot02.Text := FBank.GetVoiceName(2);
    edSlot03.Text := FBank.GetVoiceName(3);
    edSlot04.Text := FBank.GetVoiceName(4);
    edSlot05.Text := FBank.GetVoiceName(5);
    dmp.Free;
    VoiceToGUI(1);
    LEDGreen(1);
  end;

  if Source = lbVoices then
  begin
    if (lbVoices.ItemIndex = -1) or (lbFiles.ItemIndex = -1) then Exit;
    //FTmpVoice.InitVoice;
    FTmpBank.GetVoice(lbVoices.ItemIndex + 1, FTmpVoice);
    FBank.SetVoice((Sender as TLabeledEdit).Tag, FTmpVoice);
    FBank.SetVoiceName((Sender as TLabeledEdit).Tag,
      FTmpBank.GetVoiceName(lbVoices.ItemIndex + 1));
    (Sender as TLabeledEdit).Text :=
      FBank.GetVoiceName((Sender as TLabeledEdit).Tag);
    LEDGreen((Sender as TLabeledEdit).Tag);
    VoiceToGUI((Sender as TLabeledEdit).Tag);
    LEDGreen((Sender as TLabeledEdit).Tag);
  end;

  if Source = sgDB then
  begin
    dmp := TMemoryStream.Create;
    SQLProxy.GetVoice(sgDB.Cells[1, dragItem], dmp);
    FTmpVoice.Load_VMEM_FromStream(dmp, 0);
    if FBank.SetVoice((Sender as TLabeledEdit).Tag, FTmpVoice) then
    begin
      FBank.SetVoiceName((Sender as TLabeledEdit).Tag, sgDB.Cells[0, dragItem]);
      (Sender as TLabeledEdit).Text :=
        FBank.GetVoiceName((Sender as TLabeledEdit).Tag);
      LEDGreen((Sender as TLabeledEdit).Tag);
      VoiceToGUI((Sender as TLabeledEdit).Tag);
      LEDGreen((Sender as TLabeledEdit).Tag);
    end;
    dmp.Free;
  end;
end;

procedure TfrmMain.edSlotDragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: boolean);
begin
  Unused(Source, State);
  Unused(X, Y);
  if (Sender = lbFiles) and (dragItem <> -1) then Accept := True;
  if (Sender = lbVoices) and (dragItem <> -1) then Accept := True;
  if (Sender = sgDB) and (dragItem <> -1) then Accept := True;
end;

procedure TfrmMain.FillFilesList(aFolder: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  FindSYX(IncludeTrailingPathDelimiter(aFolder), sl);
  FindImportable(IncludeTrailingPathDelimiter(aFolder), sl);
  lbFiles.Items.Clear;
  lbFiles.Items.AddStrings(sl);
  sl.Free;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Unused(CloseAction);
  FreeAndNil(FCriticalSection);
  FTmpVoice.Free;
  FEditVoice.Free;
  FTmpBank.Free;
  FBank.Free;
  SQLProxy.Free;
  compList.Free;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  ini: TMiniINIFile;
begin
  CanClose := False;
  try
    ini := TMiniINIFile.Create;
    ini.LoadFromFile(HomeDir + 'settings.ini');
    if cbMIDIIn.ItemIndex <> -1 then
      ini.WriteString('MIDIInput', cbMidiIn.Text);
    if cbMidiOut.ItemIndex <> -1 then
      ini.WriteString('MIDIOutput', cbMidiOut.Text);
    ini.WriteString('LastSysExOpenDir', LastSysExOpenDir);
    ini.WriteString('LastSysExSaveDir', LastSysExSaveDir);
    ini.WriteString('LastSysEx', LastSysEx);
    ini.WriteInteger('FontSize', frmMain.Font.Height);
    ini.WriteInteger('PopUpDuration', PopUpDuration);
    ini.WriteInteger('PanelPosition1', pcFilesDatabase.Width);
    ini.WriteInteger('PanelPosition2', pnFileManager.Width);
    ini.WriteInteger('PanelPosition3', frmMain.Width);
    ini.SaveToFile(HomeDir + 'settings.ini');
    FBank.SaveBankToSysExFile(HomeDir + 'lastState.syx');
    SaveVoiceNames(HomeDir + 'lastState.syx');
  finally
    ini.Free;
  end;
  if FMidiIsActive then
  begin
    MidiInput.CloseAll;
    MidiOutput.CloseAll;

    CanClose := True;
  end
  else
    CanClose := True;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: integer;
  ini: TMiniINIFile;
begin
  FCriticalSection := TCriticalSection.Create;
  CurrentBank := 1;
  LoadingBank := False;
  frmMain.FormStyle := fsNormal;
  //something in Lazarus changes the lfm file and puts fsStayOnTop
  HomeDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(GetUserDir) +
    'PSS Revive');
  if not DirectoryExists(HomeDir) then CreateDir(HomeDir);
  FTmpVoice := TPSSx80VoiceContainer.Create;
  FEditVoice := TPSSx80VoiceContainer.Create;
  FTmpBank := TPSSx80BankContainer.Create;
  FBank := TPSSx80BankContainer.Create;
  FTmpVoice.InitVoice;
  FTmpBank.InitBank;
  FBank.InitBank;

  for i := 1 to 5 do
  begin
    TLabeledEdit(FindComponent(Format('edSlot%.2d', [i]))).Text :=
      FBank.GetVoiceName(i);
    LEDGreen(i);
  end;

  for i := 1 to 36 do
  begin
    if (i <> 4) and (i <> 20) then
    begin
      TMaskEdit(FindComponent('MaskEdit' + IntToStr(i))).EditMask := '##;1; ';
      TMaskEdit(FindComponent('MaskEdit' + IntToStr(i))).AutoSelect := False;
    end;
  end;

  pcFilesDatabase.ActivePage := tsFiles;

  FMidiIsActive := False;
  FMidiInInt := -1;
  FMidiOutInt := -1;
  FMidiIn := '';
  FMidiOut := '';
  {$IFDEF WINDOWS}
  MidiInput.OnMidiData := @Self.OnMidiInData;
  MidiInput.OnSysExData := @Self.OnSysExData;
  {$ENDIF}

  //fill MIDI ports to ComboBoxes
  cbMidiIn.Items.Clear;
  cbMidiOut.Items.Clear;
  cbMidiIn.Items.Assign(MidiInput.Devices);
  cbMidiOut.Items.Assign(MidiOutput.Devices);

  //DB Stuff
  DBName := HomeDir + 'PSSSysExDB.sqlite';
  SQLProxy := TSQLProxy.Create;
  SQLProxy.DbFileName := DBName;
  SQLProxy.Connect;

  SQLProxy.CreateTables;

  sgDB.RowCount := 1;

  //stringgrid sgDB list of changed rows
  compList := TStringList.Create;
  compList.Sorted := True;
  compList.Duplicates := dupIgnore;
  lastSelectedRow := -1;
  sgDB.FastEditing := False;

  LastSysExOpenDir := '';
  LastSysExSaveDir := '';
  LastSysEx := '';

  lastClickedFile := -1;

  ilLKS_HI.GetBitmap(16, imLKS_HI.Picture.Bitmap);
  ilLKS_LO.GetBitmap(16, imLKS_LO.Picture.Bitmap);

  try
    ini := TMiniINIFile.Create;
    ini.LoadFromFile(HomeDir + 'settings.ini');
    cbMIDIIn.ItemIndex := cbMidiIn.Items.IndexOf(ini.ReadString('MIDIInput', ''));
    if cbMidiIn.ItemIndex <> -1 then
    begin
      FMidiIn := cbMidiIn.Text;
      FMidiInInt := cbMidiIn.ItemIndex;
      try
        MidiInput.Open(FMidiInInt);
      except
        on e: Exception do PopUp('Could not open' + #13#10 + 'MIDI Input', 2);
      end;
      FMidiIsActive := True;
    end;
    cbMidiOut.ItemIndex := cbMidiOut.Items.IndexOf(ini.ReadString('MIDIOutput', ''));
    if cbMidiOut.ItemIndex <> -1 then
    begin
      FMidiOut := cbMidiOut.Text;
      FMidiOutInt := cbMidiOut.ItemIndex;
      try
        MidiOutput.Open(FMidiOutInt);
      except
        on e: Exception do PopUp('Could not open' + #13#10 + 'MIDI Output', 2);
      end;
      FMidiIsActive := True;
    end;
    LastSysExOpenDir := ini.ReadString('LastSysExOpenDir', '');
    LastSysExSaveDir := ini.ReadString('LastSysExSaveDir', '');
    LastSysEx := ini.ReadString('LastSysEx', '');
    frmMain.Font.Height := ini.ReadInteger('FontSize', 11);
    PopUpDuration := ini.ReadInteger('PopUpDuration', 2);
    sePopUpDur.Value := PopUpDuration;
    seFontSize.Value := frmMain.Font.Height;
    pcFilesDatabase.Width := ini.ReadInteger('PanelPosition1', 680);
    pnFileManager.Width := ini.ReadInteger('PanelPosition2', 360);
    frmMain.Width := ini.ReadInteger('PanelPosition3', 1490);
    if DirectoryExists(LastSysExOpenDir) then
    begin
      SelectSysExDirectoryDialog1.InitialDir := LastSysExOpenDir;
      edbtSelSysExDir.Text := ShortenFileName(LastSysExOpenDir);
      FillFilesList(LastSysExOpenDir);
    end;
    if DirectoryExists(LastSysExSaveDir) then
      SaveBankDialog1.InitialDir := LastSysExSaveDir;
    if lbFiles.Items.IndexOf(LastSysEx) <> -1 then
    begin
      lbFiles.ItemIndex := lbFiles.Items.IndexOf(LastSysEx);
      if FileExists(LastSysExOpenDir + LastSysEx) then
        OpenSysEx(LastSysExOpenDir + LastSysEx);
    end;

    LoadLastStateBank;
    LoadingBank := True;
    VoiceToGUI(CurrentBank);
    LoadingBank := False;
    lbFilesClick(Self);
  finally
    ini.Free;
  end;
  mmInfo.Lines.Add('PSS Revive version ' + GetFileVersion);
  mmInfo.Lines.Add('');
  mmInfo.Lines.Add('Built for ' + GetTargetInfo);
  mmInfo.Lines.Add('Compiler ' + GetCompilerInfo + ' on ' + GetCompiledDate);
  mmInfo.Lines.Add('Widgetset ' + GetLCLVersion + ' and ' + GetWidgetset);
end;

procedure TfrmMain.imLKS_LOClick(Sender: TObject);
begin
  if gbLKS.Caption = 'LKS Modulator' then
  begin
    gbLKS.Caption := 'LKS Carrier';
    ilLKS_HI.GetBitmap(trunc(C_LKS_HI.Position), imLKS_HI.Picture.Bitmap);
    ilLKS_LO.GetBitmap(trunc(C_LKS_LO.Position), imLKS_LO.Picture.Bitmap);
  end
  else
  begin
    gbLKS.Caption := 'LKS Modulator';
    ilLKS_HI.GetBitmap(trunc(M_LKS_HI.Position), imLKS_HI.Picture.Bitmap);
    ilLKS_LO.GetBitmap(trunc(M_LKS_LO.Position), imLKS_LO.Picture.Bitmap);
  end;
end;

procedure TfrmMain.imLogoClick(Sender: TObject);
begin
  untVMEM_View.Editing := False;
  frmVMEM_View.Show;
end;

procedure TfrmMain.LoadLastStateBank;
var
  dmp: TMemoryStream;
  i: integer;
  Itm: string;
  isBank: boolean;
begin
  isBank := False;
  Itm := HomeDir + 'lastState.syx';
  if FileExists(itm) then
  begin
    dmp := TMemoryStream.Create;
    dmp.LoadFromFile(itm);
    i := 0;
    if ContainsPSSx80Data(dmp, i, isBank) then
    begin
      if isBank and (i <> -1) then
      begin
        FBank.LoadBankFromStream(dmp, i);
        if LoadVoiceNames(itm) then
          for i := 1 to 5 do
            FBank.SetVoiceName(i, FTmpBank.GetVoiceName(i));
        for i := 1 to 5 do
        begin
          TLabeledEdit(FindComponent(Format('edSlot%.2d', [i]))).Text :=
            FBank.GetVoiceName(i);
        end;
      end;
    end;
    dmp.Free;
  end;
end;

procedure TfrmMain.lbFilesClick(Sender: TObject);
var
  dbg: string;
  Itm: string;
  sLastClickedFile: string;
begin
  if lbFiles.ItemIndex <> -1 then
  begin
    lastClickedFile := lbFiles.ItemIndex;
    sLastClickedFile := lbFiles.Items[LastClickedFile];
    Itm := lbFiles.Items[lbFiles.ItemIndex];
    if (LowerCase(ExtractFileExt(itm)) = '.ved') or
      (LowerCase(ExtractFileExt(itm)) = '.lib') then
    begin
      if (LowerCase(ExtractFileExt(itm)) = '.ved') then
        itm := Ved2Syx(IncludeTrailingPathDelimiter(LastSysExOpenDir) + Itm);
      if (LowerCase(ExtractFileExt(itm)) = '.lib') then
        itm := BW2Syx(IncludeTrailingPathDelimiter(LastSysExOpenDir) + Itm);
      PopUp('Converting', PopUpDuration);
      FillFilesList(LastSysExOpenDir);
    end;
    if itm <> '' then
    begin
      LastSysEx := itm;
      dbg := IncludeTrailingPathDelimiter(LastSysExOpenDir) + Itm;
      lbVoices.Clear;
      OpenSysEx(dbg);
      if LowerCase(ExtractFileExt(dbg)) = '.mbk' then
      begin
        PopUp('Converting', PopUpDuration);
        FTmpBank.SaveBankToSysExFile(ChangeFileExt(dbg, '.syx'));
        FillFilesList(LastSysExOpenDir);
      end;
      if lbFiles.Items.IndexOf(sLastClickedFile) <> -1 then
        lbFiles.ItemIndex := lbFiles.Items.IndexOf(sLastClickedFile);
      LastClickedFile := lbFiles.ItemIndex;
    end;
  end;
end;

procedure TfrmMain.lbFilesDblClick(Sender: TObject);
var
  dbg: string;
  Itm: string;
  dmp: TMemoryStream;
  i: integer;
begin
  if lbFiles.ItemIndex <> -1 then
  begin
    lastClickedFile := lbFiles.ItemIndex;
    Itm := lbFiles.Items[lbFiles.ItemIndex];
    LastSysEx := itm;
    dbg := IncludeTrailingPathDelimiter(LastSysExOpenDir) + Itm;
    lbVoices.Clear;
    OpenSysEx(dbg);
    if (lastClickedFile <> -1) and ((lastClickedFile) < lbFiles.Items.Count) then
      lbFiles.ItemIndex := lastClickedFile;

    dmp := TMemoryStream.Create;
    dmp.Clear;
    FTmpBank.AppendSysExBankToStream(dmp);
    FBank.LoadBankFromStream(dmp, 0);
    for i := 1 to 5 do
    begin
      LEDGreen(i);
      FBank.SetVoiceName(i, FTmpBank.GetVoiceName(i));
      TLabeledEdit(FindComponent(Format('edSlot%.2d', [i]))).Text :=
        FBank.GetVoiceName(i);
    end;
    VoiceToGUI(1);
    LEDGreen(1);
    dmp.Free;
  end;
end;

procedure TfrmMain.lbFilesStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Unused(DragObject);
  if lbFiles.ItemIndex <> -1 then
    dragItem := lbFiles.ItemIndex;
end;

procedure TfrmMain.lbVoicesClick(Sender: TObject);
begin
  if (lbVoices.ItemIndex = -1) or (lbFiles.ItemIndex = -1) then Exit;
  FTmpBank.GetVoice(lbVoices.ItemIndex + 1, FTmpVoice);
  untVMEM_View.VoiceName := lbVoices.Items[lbVoices.ItemIndex];
  frmVMEM_View.FillSG(FTmpVoice.Get_VMEM_Params);
end;

procedure TfrmMain.lbVoicesStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Unused(DragObject);
  if lbVoices.ItemIndex <> -1 then
    dragItem := lbVoices.ItemIndex;
end;

procedure TfrmMain.lnkCreditsClick(Sender: TObject);
begin
  OpenURL((Sender as TECLink).Hint);
end;

procedure TfrmMain.MaskEditLinkedEdit(Sender: TObject);
var
  i: integer;
  currVal: integer;
  minVal, maxVal: integer;
  voiceStream: TMemoryStream;
begin
  for i := 0 to pnBankSlots.ControlCount - 1 do
    if (pnBankSlots.Controls[i].Tag = (Sender as TMaskEdit).Tag) and
      (pnBankSlots.Controls[i] is TECSlider) then
    begin
      currVal := StrToIntDef(UTF8StringReplace(trim((Sender as TMaskEdit).Text),
        '_', '', [rfReplaceAll]), 0);
      minVal := trunc((pnBankSlots.Controls[i] as TECSlider).Min);
      maxVal := trunc((pnBankSlots.Controls[i] as TECSlider).Max);
      if currVal > maxVal then currVal := maxVal;
      if currVal < minVal then currVal := minVal;
      (pnBankSlots.Controls[i] as TECSlider).Position := currVal;
    end;

  if cbLivePreview.Checked and not LoadingBank then
  begin
    GUIToVoice(CurrentBank);
    if FMidiOutInt <> -1 then
    begin
      try
        voiceStream := TMemoryStream.Create;
        FEditVoice.SysExVoiceToStream(CurrentBank, voiceStream);
        frmMIDILog.OutLog('Live preview: ' + StreamToVCEDHex(voiceStream));
        MidiOutput.SendSysEx(FMidiOutInt, voiceStream);
        MidiOutput.Send(FMidiOutInt, $C0, 99 + CurrentBank, 0);
      finally
        voiceStream.Free;
      end;
    end
    else
    begin
      ShowMessage('Please set-up the MIDI Output first');
      pcFilesDatabase.ActivePage := tsSettings;
    end;
  end;
end;

procedure TfrmMain.M_LKSChange(Sender: TObject);
begin
  gbLKS.Caption := 'LKS Modulator';
  ilLKS_HI.GetBitmap(trunc(M_LKS_HI.Position), imLKS_HI.Picture.Bitmap);
  ilLKS_LO.GetBitmap(trunc(M_LKS_LO.Position), imLKS_LO.Picture.Bitmap);
  SliderLinkedEdit(Sender);
end;

procedure TfrmMain.SliderLinkedEdit(Sender: TObject);
var
  i: integer;
  voiceStream: TMemoryStream;
begin
  if not LoadingBank then LEDYellow(CurrentBank);
  for i := 0 to pnBankSlots.ControlCount - 1 do
    if (pnBankSlots.Controls[i].Tag = (Sender as TECSlider).Tag) and
      (pnBankSlots.Controls[i] is TMaskEdit) then
      (pnBankSlots.Controls[i] as TMaskEdit).Text :=
        IntToStr(Trunc(TECSlider(Sender).Position));
  if Sender = M_SIN_TBL then
    ilSIN_TBL.GetBitmap(trunc(M_SIN_TBL.Position), imM_SIN_TBL.Picture.Bitmap);
  if Sender = C_SIN_TBL then
    ilSIN_TBL.GetBitmap(trunc(C_SIN_TBL.Position), imC_SIN_TBL.Picture.Bitmap);

  if cbLivePreview.Checked and not LoadingBank then
  begin
    GUIToVoice(CurrentBank);
    if FMidiOutInt <> -1 then
    begin
      try
        voiceStream := TMemoryStream.Create;
        FEditVoice.SysExVoiceToStream(CurrentBank, voiceStream);
        frmMIDILog.OutLog('Live preview: ' + StreamToVCEDHex(voiceStream));
        MidiOutput.SendSysEx(FMidiOutInt, voiceStream);
        MidiOutput.Send(FMidiOutInt, $C0, 99 + CurrentBank, 0);
      finally
        voiceStream.Free;
      end;
    end
    else
    begin
      ShowMessage('Please set-up the MIDI Output first');
      pcFilesDatabase.ActivePage := tsSettings;
    end;
  end;
end;

procedure TfrmMain.SliderChange(Sender: TObject);
begin
  RefreshGraph;
  SliderLinkedEdit(Sender);
end;

procedure TfrmMain.pnSlotClick(Sender: TObject);
begin
  LoadingBank := True;
  //Save editor state to the current bank before changing bank
  GUIToVoice(CurrentBank);
  CurrentBank := (Sender as TPanel).Tag;
  //Change bank
  VoiceToGUI(CurrentBank);
  LoadingBank := False;
end;

procedure TfrmMain.OpenSysEx(aName: string);
var
  dmp: TMemoryStream;
  i, j: integer;
  nr: integer;
  isBank: boolean;
  fName: string;
begin
  if aName = '' then exit;
  if FileExists(aName) then
  begin
    isBank := False;
    dmp := TMemoryStream.Create;
    dmp.LoadFromFile(aName);
    fName := ExtractFileNameWithoutExt(ExtractFileNameOnly(aName));
    i := 0;
    if ContainsPSSx80Data(dmp, i, isBank) then
    begin
      if (isBank = False) and (i <> -1) then
      begin
        for j := 1 to 5 do
        begin
          FBank.GetVoice(j, FTmpVoice);
          FTmpBank.SetVoice(j, FTmpVoice);
          FTmpBank.SetVoiceName(j, FBank.GetVoiceName(j));
        end;
        lbVoices.Items.Clear;
        lbVoices.Items.Add(fName);
        FTmpVoice.Load_VMEM_FromStream(dmp, i);
        untVMEM_View.VoiceName := fName;
        frmVMEM_View.FillSG(FTmpVoice.Get_VMEM_Params);
        FTmpVoice.SetVoiceName(fName);
        FTmpBank.SetVoice(1, FTmpVoice);
        FTmpBank.SetVoiceName(1, FTmpVoice.GetVoiceName);
      end;
      if isBank and (i <> -1) then
      begin
        lbVoices.Items.Clear;
        FTmpBank.LoadBankFromStream(dmp, i);
        for nr := 1 to 5 do
        begin
          if not LoadVoiceNames(aName) then    //from .ins files if any
            FTmpBank.SetVoiceName(nr, fName + ' ' + IntToStr(nr));
          lbVoices.Items.Add(FTmpBank.GetVoiceName(nr));
        end;
      end;
    end;
    dmp.Free;
  end;
end;

procedure TfrmMain.tbbtSendVoiceDumpClick(Sender: TObject);
var
  bankStream: TMemoryStream;
  err: PmError;
begin
  if FMidiOutInt <> -1 then
  begin
    try
      bankStream := TMemoryStream.Create;
      FBank.SysExBankToStream(bankStream);
      frmMIDILog.OutLog('Send dump: ' + StreamToVCEDHex(bankStream));
      err := MidiOutput.SendSysEx(FMidiOutInt, bankStream);
      if (err = 0)
        {$IFNDEF WINDOWS}
        or (err = 1)
        {$ENDIF}
      then
      begin
        PopUp('Bank sent', PopUpDuration);
      end
      else
        PopUp('Bank sending failed!' + #13 + 'Error message:' +
          #13 + Pm_GetErrorText(err), PopUpDuration);
    finally
      bankStream.Free;
    end;
  end
  else
  begin
    ShowMessage('Please set-up the MIDI Output first');
    pcFilesDatabase.ActivePage := tsSettings;
  end;
end;

procedure TfrmMain.SendSimpleMelody(aCh: integer);
const
  notes: array [0..8] of integer = (24, 36, 48, 60, 72, 84, 96, 108, 120);
var
  i: integer;
begin
  if FMidiOutInt <> -1 then
  begin
    if aCh < 1 then aCh := 1;
    if aCh > 16 then aCh := 16;
    aCh := aCh - 1;
    for i := 0 to 8 do
    begin
      MidiOutput.Send(FMidiOutInt, 144 + aCh, notes[i], 100);
      sleep(200);
      MidiOutput.Send(FMidiOutInt, 128 + aCh, notes[i], 0);
      sleep(50);
    end;
  end
  else
  begin
    ShowMessage('Please set-up the MIDI Output first');
    pcFilesDatabase.ActivePage := tsSettings;
  end;
end;

procedure TfrmMain.seFontSizeChange(Sender: TObject);
begin
  frmMain.Font.Height := seFontSize.Value;
  frmMain.Invalidate;
end;

procedure TfrmMain.sePopUpDurChange(Sender: TObject);
begin
  PopUpDuration := sePopUpDur.Value;
end;

procedure TfrmMain.sgDBBeforeSelection(Sender: TObject; aCol, aRow: integer);
var
  c: integer;
begin
  Unused(aCol);
  for c := 0 to 1 do
  begin
    if aRow < sgDB.RowCount then
    begin
      //sometimes aRow is greater than the row count
      compArray[c] := sgDB.Cells[c, aRow];
      lastSelectedRow := aRow;
    end;
  end;
end;

procedure TfrmMain.sgDBClick(Sender: TObject);
var
  ID: string;
  Row: integer;
  dmp: TMemoryStream;
  voiceStream: TMemoryStream;
begin
  Row := sgDB.Row;
  if (cbAutoPreview.Checked) and (Row > 0) then
  begin
    try
      ID := sgDB.Cells[1, Row];
      dmp := TMemoryStream.Create;
      voiceStream := TMemoryStream.Create;
      SQLProxy.GetVoice(ID, dmp);
      FTmpVoice.Load_VMEM_FromStream(dmp, 0);
      FTmpVoice.SysExVoiceToStream(seAutoPreviewBank.Value, voiceStream);
      MidiOutput.SendSysEx(FMidiOutInt, voiceStream);
      MidiOutput.Send(FMidiOutInt, $C0, 99 + seAutoPreviewBank.Value, 0);
      frmMIDILog.OutLog('DB Auto-preview: ' + StreamToVCEDHex(voiceStream));
    finally
      dmp.Free;
      voiceStream.Free;
    end;
  end;
end;

procedure TfrmMain.sgDBDragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: boolean);
begin
  Unused(State, X, Y);
  if Source = sgDB then Accept := False;
end;

procedure TfrmMain.sgDBEditingDone(Sender: TObject);
var
  chg: boolean;
  c: integer;
begin
  chg := False;
  if lastSelectedRow <> -1 then
  begin
    for c := 0 to 1 do
      if compArray[c] <> sgDB.Cells[c, lastSelectedRow] then chg := True;
    if chg then compList.Add(IntToStr(lastSelectedRow));
  end;
end;

procedure TfrmMain.sgDBStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  P: TPoint;
  PCol, PRow: longint;
begin
  Unused(DragObject);
  P := Default(TPoint);
  GetCursorPos(P);
  with sgDB do
  begin
    P := ScreenToClient(P);
    MouseToCell(P.x, P.y, PCol, PRow);
  end;
  if PRow <> -1 then
    dragItem := PRow;
end;

procedure TfrmMain.tbbtCommitClick(Sender: TObject);
var
  i: integer;
  nr: integer;
  FName, FId: string;
begin
  for i := 0 to compList.Count - 1 do
  begin
    nr := StrToInt(compList[i]);
    FName := sgDB.Cells[0, nr];
    FId := sgDB.Cells[1, nr];
    SQLProxy.Commit(FId, FName);
  end;
  compList.Clear;
end;

procedure TfrmMain.tbbtDelVoiceClick(Sender: TObject);
var
  FID, FName: string;
begin
  if sgDB.Row > 0 then
  begin
    FID := sgDB.Cells[1, sgDB.Row];
    FName := sgDB.Cells[0, sgDB.Row];
    if MessageDlg('Delete confirmation', 'Are you sure you want to delete' +
      #13#10 + FName + ' from database?', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      SQLProxy.DeleteVoice(FID);
      SQLProxy.GUIGridRefresh(sgDB);
      compList.Clear;
    end;
  end;
end;

procedure TfrmMain.tbbtRefreshClick(Sender: TObject);
var
  vc: integer;
begin
  if trim(tbSearch.Text) = '' then
    SQLProxy.GUIGridRefresh(sgDB)
  else
  begin
    SQLProxy.GUIGridRefreshFiltered(sgDB, tbSearch.Text);
  end;
  vc := SQLProxy.GetVoiceCount;
  compList.Clear;
  PopUp('Total voices:' + #13#10 + IntToStr(vc), PopUpDuration);
end;

procedure TfrmMain.tbbtSaveBankClick(Sender: TObject);
begin
  if SaveBankDialog1.Execute then
  begin
    FBank.SaveBankToSysExFile(SaveBankDialog1.FileName);
    SaveVoiceNames(SaveBankDialog1.FileName);
    LastSysExSaveDir := IncludeTrailingPathDelimiter(
      ExtractFileDir(SaveBankDialog1.FileName));
  end;
end;

procedure TfrmMain.VoiceToGUI(aVoiceNr: integer);
var
  dtSgn: integer;
  dtVal: integer;
  i: integer;
begin
  //FBank.GetVoice(aVoiceNr, FEditVoice);    //just VMEM
  FEditVoice.Set_VCED_Params(FBank.GetVCED(aVoiceNr)); //VMEM and VCED
  untVMEM_View.VoiceName := 'Bank ' + IntToStr(CurrentBank) + ' - ' +
    FBank.GetVoiceName(aVoiceNr);
  untVMEM_View.Editing := True;
  frmVMEM_View.FillSG(FEditVoice.Get_VMEM_Params);

  LEDs(aVoiceNr);
  CurrentBank := aVoiceNr;

  M_MUL.Position := FEditVoice.Get_VCED_Params.M_MUL;
  dtSgn := FEditVoice.Get_VCED_Params.M_DT1 and 8;
  dtVal := FEditVoice.Get_VCED_Params.M_DT1 and 7;
  if dtSgn > 0 then dtVal := -dtVal;
  M_DT1.Position := dtVal;
  M_DT2.Position := FEditVoice.Get_VCED_Params.M_DT2;
  M_SIN_TBL.Position := FEditVoice.Get_VCED_Params.M_SIN_TBL;
  M_AM_EN.Position := FEditVoice.Get_VCED_Params.M_AM_EN;

  M_AR.Position := FEditVoice.Get_VCED_Params.M_AR;
  M_D1R.Position := FEditVoice.Get_VCED_Params.M_D1R;
  M_D1L.Position := FEditVoice.Get_VCED_Params.M_D1L;
  M_D2R.Position := FEditVoice.Get_VCED_Params.M_D2R;
  M_RR.Position := FEditVoice.Get_VCED_Params.M_RR;
  M_SRR.Position := FEditVoice.Get_VCED_Params.M_SRR;
  M_RKS.Position := FEditVoice.Get_VCED_Params.M_RKS;
  M_LKS_LO.Position := FEditVoice.Get_VCED_Params.M_LKS_LO;
  M_LKS_HI.Position := FEditVoice.Get_VCED_Params.M_LKS_HI;
  M_FB.Position := FEditVoice.Get_VCED_Params.M_FB;
  M_TL.Position := 99 - min(99, FEditVoice.Get_VCED_Params.M_TL);

  C_MUL.Position := FEditVoice.Get_VCED_Params.C_MUL;
  dtSgn := FEditVoice.Get_VCED_Params.C_DT1 and 8;
  dtVal := FEditVoice.Get_VCED_Params.C_DT1 and 7;
  if dtSgn > 0 then dtVal := -dtVal;
  C_DT1.Position := dtVal;
  C_DT2.Position := FEditVoice.Get_VCED_Params.C_DT2;
  C_SIN_TBL.Position := FEditVoice.Get_VCED_Params.C_SIN_TBL;
  C_AM_EN.Position := FEditVoice.Get_VCED_Params.C_AM_EN;

  C_AR.Position := FEditVoice.Get_VCED_Params.C_AR;
  C_D1R.Position := FEditVoice.Get_VCED_Params.C_D1R;
  C_D1L.Position := FEditVoice.Get_VCED_Params.C_D1L;
  C_D2R.Position := FEditVoice.Get_VCED_Params.C_D2R;
  C_RR.Position := FEditVoice.Get_VCED_Params.C_RR;
  C_SRR.Position := FEditVoice.Get_VCED_Params.C_SRR;
  C_RKS.Position := FEditVoice.Get_VCED_Params.C_RKS;
  C_LKS_LO.Position := FEditVoice.Get_VCED_Params.C_LKS_LO;
  C_LKS_HI.Position := FEditVoice.Get_VCED_Params.C_LKS_HI;
  C_TL.Position := 99 - min(99, FEditVoice.Get_VCED_Params.C_TL);

  PMS.Position := FEditVoice.Get_VCED_Params.PMS;
  AMS.Position := FEditVoice.Get_VCED_Params.AMS;
  VDT.Position := FEditVoice.Get_VCED_Params.VDT;
  V.Position := FEditVoice.Get_VCED_Params.V;
  S.Position := FEditVoice.Get_VCED_Params.S;

  for i := 0 to pnBankSlots.ControlCount - 1 do
    if (pnBankSlots.Controls[i] is TECSlider) then
    begin
      SliderLinkedEdit(pnBankSlots.Controls[i] as TECSlider);
    end;
end;

procedure TfrmMain.GUIToVoice(aVoiceNr: integer);
var
  dtSgn: integer;
  dtVal: integer;
begin
  FEditVoice.FPSSx80_VCED_Params.M_MUL := trunc(M_MUL.Position);
  if M_DT1.Position < 0 then dtSgn := 8
  else
    dtSgn := 0;
  dtVal := abs(trunc(M_DT1.Position)) + dtSgn;
  FEditVoice.FPSSx80_VCED_Params.M_DT1 := dtVal;
  FEditVoice.FPSSx80_VCED_Params.M_DT2 := trunc(M_DT2.Position);
  FEditVoice.FPSSx80_VCED_Params.M_SIN_TBL := trunc(M_SIN_TBL.Position);
  FEditVoice.FPSSx80_VCED_Params.M_AM_EN := trunc(M_AM_EN.Position);
  FEditVoice.FPSSx80_VCED_Params.M_AR := trunc(M_AR.Position);
  FEditVoice.FPSSx80_VCED_Params.M_D1R := trunc(M_D1R.Position);
  FEditVoice.FPSSx80_VCED_Params.M_D1L := trunc(M_D1L.Position);
  FEditVoice.FPSSx80_VCED_Params.M_D2R := trunc(M_D2R.Position);
  FEditVoice.FPSSx80_VCED_Params.M_RR := trunc(M_RR.Position);
  FEditVoice.FPSSx80_VCED_Params.M_SRR := trunc(M_SRR.Position);
  FEditVoice.FPSSx80_VCED_Params.M_RKS := trunc(M_RKS.Position);
  FEditVoice.FPSSx80_VCED_Params.M_LKS_LO := trunc(M_LKS_LO.Position);
  FEditVoice.FPSSx80_VCED_Params.M_LKS_HI := trunc(M_LKS_HI.Position);
  FEditVoice.FPSSx80_VCED_Params.M_FB := trunc(M_FB.Position);
  FEditVoice.FPSSx80_VCED_Params.M_TL := 99 - trunc(M_TL.Position);

  FEditVoice.FPSSx80_VCED_Params.C_MUL := trunc(C_MUL.Position);
  if C_DT1.Position < 0 then dtSgn := 8
  else
    dtSgn := 0;
  dtVal := abs(trunc(C_DT1.Position)) + dtSgn;
  FEditVoice.FPSSx80_VCED_Params.C_DT1 := dtVal;
  FEditVoice.FPSSx80_VCED_Params.C_DT2 := trunc(C_DT2.Position);
  FEditVoice.FPSSx80_VCED_Params.C_SIN_TBL := trunc(C_SIN_TBL.Position);
  FEditVoice.FPSSx80_VCED_Params.C_AM_EN := trunc(C_AM_EN.Position);
  FEditVoice.FPSSx80_VCED_Params.C_AR := trunc(C_AR.Position);
  FEditVoice.FPSSx80_VCED_Params.C_D1R := trunc(C_D1R.Position);
  FEditVoice.FPSSx80_VCED_Params.C_D1L := trunc(C_D1L.Position);
  FEditVoice.FPSSx80_VCED_Params.C_D2R := trunc(C_D2R.Position);
  FEditVoice.FPSSx80_VCED_Params.C_RR := trunc(C_RR.Position);
  FEditVoice.FPSSx80_VCED_Params.C_SRR := trunc(C_SRR.Position);
  FEditVoice.FPSSx80_VCED_Params.C_RKS := trunc(C_RKS.Position);
  FEditVoice.FPSSx80_VCED_Params.C_LKS_LO := trunc(C_LKS_LO.Position);
  FEditVoice.FPSSx80_VCED_Params.C_LKS_HI := trunc(C_LKS_HI.Position);
  FEditVoice.FPSSx80_VCED_Params.C_TL := 99 - trunc(C_TL.Position);

  FEditVoice.FPSSx80_VCED_Params.PMS := trunc(PMS.Position);
  FEditVoice.FPSSx80_VCED_Params.AMS := trunc(AMS.Position);
  FEditVoice.FPSSx80_VCED_Params.VDT := trunc(VDT.Position);
  FEditVoice.FPSSx80_VCED_Params.V := trunc(V.Position);
  FEditVoice.FPSSx80_VCED_Params.S := trunc(S.Position);

  FEditVoice.Set_VMEM_Params(VCEDtoVMEM(FEditVoice.Get_VCED_Params));

  FBank.SetVoice(aVoiceNr, FEditVoice);
  LEDGreen(aVoiceNr);
end;

function TfrmMain.LoadVoiceNames(aSysExName: string): boolean;
var
  insName: string;
  insDir: string;
  sl: TStringList;
  i: integer;
begin
  Result := False;
  insName := ExtractFileNameWithoutExt(ExtractFileName(aSysExName)) + '.ins';
  insDir := IncludeTrailingPathDelimiter(ExtractFileDir(aSysExName));
  if FileExistsUTF8(insDir + insName) then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(insDir + insName);
    if sl.Count = 5 then
    begin
      for i := 1 to 5 do
        FTmpBank.SetVoiceName(i, sl[i - 1]);
      Result := True;
    end;
    sl.Free;
  end;
end;

function TfrmMain.SaveVoiceNames(aSysExName: string): boolean;
var
  insName: string;
  insDir: string;
  sl: TStringList;
  i: integer;
begin
  Result := False;
  insName := ExtractFileNameWithoutExt(ExtractFileName(aSysExName)) + '.ins';
  insDir := IncludeTrailingPathDelimiter(ExtractFileDir(aSysExName));
  sl := TStringList.Create;
  for i := 1 to 5 do
    sl.Add(FBank.GetVoiceName(i));
  try
    sl.SaveToFile(insDir + insName);
    Result := True;
  except
    on e: Exception do
      Result := False;
  end;
  sl.Free;
end;

procedure TfrmMain.RefreshGui;
begin
  SliderChange(M_AR);
  M_LKSChange(M_LKS_HI);
  C_LKSChange(C_LKS_HI);
end;

procedure TfrmMain.LEDs(aVoiceNr: integer);
begin
  case aVoiceNr of
    1: begin
      alBank1.Enabled := True;
      alBank1.State := lsOn;
      alBank2.Enabled := False;
      alBank2.State := lsOff;
      alBank3.Enabled := False;
      alBank3.State := lsOff;
      alBank4.Enabled := False;
      alBank4.State := lsOff;
      alBank5.Enabled := False;
      alBank5.State := lsOff;
    end;
    2: begin
      alBank1.Enabled := False;
      alBank1.State := lsOff;
      alBank2.Enabled := True;
      alBank2.State := lsOn;
      alBank3.Enabled := False;
      alBank3.State := lsOff;
      alBank4.Enabled := False;
      alBank4.State := lsOff;
      alBank5.Enabled := False;
      alBank5.State := lsOff;
    end;
    3: begin
      alBank1.Enabled := False;
      alBank1.State := lsOff;
      alBank2.Enabled := False;
      alBank2.State := lsOff;
      alBank3.Enabled := True;
      alBank3.State := lsOn;
      alBank4.Enabled := False;
      alBank4.State := lsOff;
      alBank5.Enabled := False;
      alBank5.State := lsOff;
    end;
    4: begin
      alBank1.Enabled := False;
      alBank1.State := lsOff;
      alBank2.Enabled := False;
      alBank2.State := lsOff;
      alBank3.Enabled := False;
      alBank3.State := lsOff;
      alBank4.Enabled := True;
      alBank4.State := lsOn;
      alBank5.Enabled := False;
      alBank5.State := lsOff;
    end;
    5: begin
      alBank1.Enabled := False;
      alBank1.State := lsOff;
      alBank2.Enabled := False;
      alBank2.State := lsOff;
      alBank3.Enabled := False;
      alBank3.State := lsOff;
      alBank4.Enabled := False;
      alBank4.State := lsOff;
      alBank5.Enabled := True;
      alBank5.State := lsOn;
    end;
    else
    begin
      alBank1.Enabled := False;
      alBank1.State := lsOff;
      alBank2.Enabled := False;
      alBank2.State := lsOff;
      alBank3.Enabled := False;
      alBank3.State := lsOff;
      alBank4.Enabled := False;
      alBank4.State := lsOff;
      alBank5.Enabled := False;
      alBank5.State := lsOff;
    end;
  end;
end;

procedure TfrmMain.LEDGreen(aVoiceNr: integer);
begin
  case aVoiceNr of
    1: alBank1.Kind := lkGreenLight;
    2: alBank2.Kind := lkGreenLight;
    3: alBank3.Kind := lkGreenLight;
    4: alBank4.Kind := lkGreenLight;
    5: alBank5.Kind := lkGreenLight;
  end;
end;

procedure TfrmMain.LEDYellow(aVoiceNr: integer);
begin
  case aVoiceNr of
    1: alBank1.Kind := lkYellowLight;
    2: alBank2.Kind := lkYellowLight;
    3: alBank3.Kind := lkYellowLight;
    4: alBank4.Kind := lkYellowLight;
    5: alBank5.Kind := lkYellowLight;
  end;
end;

end.
