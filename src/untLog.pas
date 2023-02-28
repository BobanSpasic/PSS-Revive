unit untLog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmMIDILog }

  TfrmMIDILog = class(TForm)
    mmMIDIIn: TMemo;
    mmMIDIOut: TMemo;
    procedure InLog(aText: string);
    procedure OutLog(aText: string);
  private

  public

  end;

var
  frmMIDILog: TfrmMIDILog;

implementation

{$R *.lfm}

procedure TfrmMIDILog.InLog(aText: string);
begin
  mmMIDIIn.Lines.Add(aText);
end;

procedure TfrmMIDILog.OutLog(aText: string);
begin
  mmMIDIOut.Lines.Add(aText);
end;

end.

