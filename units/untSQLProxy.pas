{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 Author: Boban Spasic

 Unit description:
 In the beginning, all the SQL-related functions were par of the untMain,
 that made the unit less readable.
 Now, all the SQL-related functions and procedures are in this unit/class.
}

unit untSQLProxy;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, SQLite3DS, DB,
  Dialogs, Controls, Grids;

type
  TSQLProxy = class(TPersistent)
  private
    SQLite3Con: TSQLite3Connection;
    SQLTrans: TSQLTransaction;
    SQLQuery: TSQLQuery;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateTables;
    procedure Connect;
    procedure AddVoice(aID, aName: string; var aData: TMemoryStream);
    procedure GetVoice(aID: string; var msData: TMemoryStream);
    procedure DeleteVoice(aID: string);
    procedure Vacuum;
    procedure CleanTable(ATable: string);
    procedure Commit(aID, aName: string);
    procedure GUIGridRefresh(sgDB: TStringGrid);
    procedure GUIGridRefreshFiltered(sgDB: TStringGrid; Filter: string);
    function GetDbFileName: string;
    procedure SetDbFileName(DbFileName: string);
    property DbFileName: string read GetDbFileName write SetDbFileName;
    function GetVoiceCount: integer;
    procedure GetVoiceList(var sl: TStringList);
  end;

implementation

constructor TSQLProxy.Create;
begin
  inherited;
  SQLite3Con := TSQLite3Connection.Create(nil);
  SQLTrans := TSQLTransaction.Create(nil);
  SQLQuery := TSQLQuery.Create(nil);
  SQLite3Con.Transaction := SQLTrans;
  SQLite3Con.AlwaysUseBigint := False;
  SQLite3Con.Connected := False;
  SQLite3Con.KeepConnection := False;
  SQLite3Con.LoginPrompt := False;
  SQLTrans.Active := False;
  SQLTrans.DataBase := SQLite3Con;
  SQLQuery.DataBase := SQLite3Con;
  SQLQuery.Transaction := SQLTrans;
end;

destructor TSQLProxy.Destroy;
begin
  SQLite3Con.Connected := False;
  SQLite3Con.Free;
  SQLTrans.Free;
  SQLQuery.Free;
  inherited;
end;

function TSQLProxy.GetDbFileName: string;
begin
  Result := SQLite3Con.DatabaseName;
end;

procedure TSQLProxy.SetDbFileName(DbFileName: string);
begin
  SQLite3Con.DatabaseName := DbFileName;
end;

procedure TSQLProxy.CreateTables;
begin
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    SQLQuery.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS VOICES (ID VARCHAR(64) UNIQUE NOT NULL, NAME VARCHAR(32) NOT NULL, DATA BLOB);';
    SQLQuery.ExecSQL;
    SQLTrans.Commit;
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.Connect;
begin
  SQLite3Con.Connected := True;
end;

procedure TSQLProxy.AddVoice(aID, aName: string; var aData: TMemoryStream);
var
  aExists: boolean;
  aExName: string;
begin
  aExists := False;
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    aExName := '';
    SQLQuery.SQL.Text :=
      'SELECT * FROM VOICES WHERE ID = :AID';
    SQLQuery.Params.ParamByName('AID').AsString := aID;
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      if SQLQuery.FieldCount > 0 then
      begin
        aExName := SQLQuery.Fields[1].AsString;
        //do not bother the user with confirmation dialog if the names are the same
        //category and origin will be updated with the new ones
        if trim(aName) <> trim(aExName) then
          aExists := True;
        Break;
      end;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;

    if aExists and (MessageDlg('Duplicate', aName + ' is a duplicate of ' +
      aExName + #13#10 + 'Overwrite?', mtConfirmation, mbYesNo, 0) = mrNo) then
      Exit
    else
    begin
      SQLQuery.SQL.Text :=
        'INSERT OR REPLACE INTO VOICES (ID, NAME, DATA) VALUES (:AID, :AName, :AData);';
      SQLQuery.Params.ParamByName('AID').AsString := aID;
      SQLQuery.Params.ParamByName('AName').AsString := aName;
      SQLQuery.Params.ParamByName('AData').LoadFromStream(aData, ftBlob);
      SQLQuery.ExecSQL;
      SQLTrans.Commit;
    end;
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.GetVoice(aID: string; var msData: TMemoryStream);
begin
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    SQLQuery.SQL.Text :=
      'SELECT * FROM VOICES WHERE ID = :AID';
    SQLQuery.Params.ParamByName('AID').AsString := aID;
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      if SQLQuery.FieldCount > 0 then
      begin
        TBlobField(SQLQuery.FieldByName('DATA')).SaveToStream(msData);
        Break;
      end;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;
  end;
end;

procedure TSQLProxy.DeleteVoice(aID: string);
begin
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    SQLQuery.SQL.Text := 'DELETE FROM VOICES WHERE ID = ''' + aID + ''';';
    SQLQuery.ExecSQL;
    SQLTrans.Commit;
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.GUIGridRefresh(sgDB: TStringGrid);
var
  sl: TStringList;
  i: integer;
  sName, sID: string;
begin
  sgDB.RowCount := 1;
  if SQLite3Con.Connected then
  begin
    sgDB.BeginUpdate;
    sl := TStringList.Create;
    sl.Delimiter := ';';
    SQLQuery.SQL.Text := 'SELECT * FROM VOICES';
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      //(ID, NAME, CATEGORY, DATA, SUPPL_VER, SUPPL, ORIGIN)
      sName := SQLQuery.FieldByName('NAME').AsString;
      sID := SQLQuery.FieldByName('ID').AsString;
      sl.Add('"' + sName + '";"' + sID + '"');
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;
    sgDB.RowCount := sl.Count + 1;
    for i := 0 to sl.Count - 1 do
    begin
      sgDB.Rows[i + 1].Delimiter := ';';
      sgDB.Rows[i + 1].QuoteChar := '"';
      sgDB.Rows[i + 1].StrictDelimiter := True;
      sgDB.Rows[i + 1].DelimitedText := sl[i];
    end;
    sl.Free;
    sgDB.EndUpdate(True);
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.GUIGridRefreshFiltered(sgDB: TStringGrid; Filter: string);
var
  sl: TStringList;
  i: integer;
  sName, sID: string;
begin
  sgDB.RowCount := 1;
  if SQLite3Con.Connected then
  begin
    sgDB.BeginUpdate;
    sl := TStringList.Create;
    sl.Delimiter := ';';
    SQLQuery.SQL.Text := 'SELECT * FROM VOICES WHERE NAME LIKE ''%' +
      Filter + '%''';
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      //(ID, NAME, CATEGORY, DATA, SUPPL_VER, SUPPL, ORIGIN)
      sName := SQLQuery.FieldByName('NAME').AsString;
      sID := SQLQuery.FieldByName('ID').AsString;
      sl.Add('"' + sName + '";"' + sID + '"');
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;
    sgDB.RowCount := sl.Count + 1;
    for i := 0 to sl.Count - 1 do
    begin
      sgDB.Rows[i + 1].Delimiter := ';';
      sgDB.Rows[i + 1].QuoteChar := '"';
      sgDB.Rows[i + 1].StrictDelimiter := True;
      sgDB.Rows[i + 1].DelimitedText := sl[i];
    end;
    sl.Free;
    sgDB.EndUpdate(True);
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.Commit(aID, aName: string);
var
  aExists: boolean;
  msData: TMemoryStream;
begin
  if SQLite3Con.Connected then
  begin
    msData := TMemoryStream.Create;
    aExists := False;
    SQLQuery.Close;
    SQLQuery.SQL.Text :=
      'SELECT * FROM VOICES WHERE ID = :AID';
    SQLQuery.Params.ParamByName('AID').AsString := aID;
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      if SQLQuery.FieldCount > 0 then
      begin
        TBlobField(SQLQuery.FieldByName('DATA')).SaveToStream(msData);
        aExists := True;
        Break;
      end;
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;
    if aExists then
    begin
      SQLQuery.SQL.Text :=
        'INSERT OR REPLACE INTO VOICES (ID, NAME, DATA) VALUES (:AID, :AName, :AData);';
      SQLQuery.Params.ParamByName('AID').AsString := aID;
      SQLQuery.Params.ParamByName('AName').AsString := aName;
      SQLQuery.Params.ParamByName('AData').LoadFromStream(msData, ftBlob);
      SQLQuery.ExecSQL;
      SQLTrans.Commit;
    end;
    msData.Free;
  end
  else
    ShowMessage('No database file assigned');
end;

procedure TSQLProxy.Vacuum;
var
  tmpDataset: TSqlite3Dataset;
  wasConnected: boolean;
begin
  wasConnected := SQLite3Con.Connected;

  SQLite3Con.Close;
  repeat
  until not SQLite3Con.Connected;

  tmpDataset := TSqlite3Dataset.Create(nil);
  tmpDataset.FileName := SQLite3Con.DatabaseName;
  tmpDataset.ExecSQL('VACUUM;');
  tmpDataset.Free;

  SQLite3Con.Connected := wasConnected;
end;

procedure TSQLProxy.CleanTable(ATable: string);
begin
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    SQLQuery.SQL.Text := 'DELETE FROM ' + ATable;
    SQLQuery.ExecSQL;
    SQLTrans.Commit;
  end
  else
    ShowMessage('No database file assigned');
end;

function TSQLProxy.GetVoiceCount: integer;
begin
  Result := 0;
  if SQLite3Con.Connected then
  begin
    SQLQuery.Close;
    SQLQuery.SQL.Text := 'SELECT COUNT(*) AS cnt FROM BIN_VOICES;';
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    Result := SQLQuery.Fields[0].AsInteger;
    SQLQuery.Close;
    SQLTrans.Commit;
  end;
end;

procedure TSQLProxy.GetVoiceList(var sl: TStringList);
var
  sName, sID: string;
begin
  if SQLite3Con.Connected then
  begin
    SQLQuery.SQL.Text := 'SELECT * FROM VOICES';
    SQLTrans.StartTransaction;
    SQLQuery.Open;
    while not SQLQuery.EOF do
    begin
      sName := SQLQuery.FieldByName('NAME').AsString;
      sID := SQLQuery.FieldByName('ID').AsString;
      sl.AddPair(sID, sName);
      SQLQuery.Next;
    end;
    SQLQuery.Close;
    SQLTrans.Commit;
  end
  else
    ShowMessage('No database file assigned');
end;

end.
