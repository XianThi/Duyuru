unit AnaForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, Inifiles, DSiWin32, StrUtils,
  Menus;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    L1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    Label5: TLabel;
    dlgOpen1: TOpenDialog;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
    psexec, msgvbs, pclist: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

type
  PNetResourceArray = ^TNetResourceArray;

  TNetResourceArray = array[0..100] of TNetResource;

  TStrArray = array of string;

  TStatusWindowHandle = type HWND;

implementation

{$R *.dfm}

function CreateStatusWindow(const Text: string): TStatusWindowHandle;
var
  FormWidth, FormHeight: integer;
begin
  FormWidth := 400;
  FormHeight := 164;
  result := CreateWindow('STATIC', PChar(Text), WS_OVERLAPPED or WS_POPUPWINDOW or WS_THICKFRAME or SS_CENTER or SS_CENTERIMAGE, (Screen.Width - FormWidth) div 2, (Screen.Height - FormHeight) div 2, FormWidth, FormHeight, Application.MainForm.Handle, 0, HInstance, nil);
  ShowWindow(result, SW_SHOWNORMAL);
  UpdateWindow(result);
end;

function Explode(var a: TStrArray; Border, S: string): Integer;
var
  S2: string;
begin
  Result := 0;
  S2 := S + Border;
  repeat
    SetLength(a, Length(a) + 1);
    a[Result] := Copy(S2, 0, Pos(Border, S2) - 1);
    Delete(S2, 1, Length(a[Result] + Border));
    Inc(Result);
  until S2 = '';
end;

function CreateNetResourceList(ResourceType: DWord; NetResource: PNetResource; out Entries: DWord; out List: PNetResourceArray): Boolean;
var
  EnumHandle: THandle;
  BufSize: DWord;
  Res: DWord;
begin
  Result := False;
  List := Nil;
  Entries := 0;
  if WNetOpenEnum(RESOURCE_GLOBALNET, ResourceType, 0, NetResource, EnumHandle) = NO_ERROR then
  begin
    try
      BufSize := $4000;  // 16 kByte
      GetMem(List, BufSize);
      try
        repeat
          Entries := DWord(-1);
          FillChar(List^, BufSize, 0);
          Res := WNetEnumResource(EnumHandle, Entries, List, BufSize);
          if Res = ERROR_MORE_DATA then
          begin
            ReAllocMem(List, BufSize);
          end;
        until Res <> ERROR_MORE_DATA;

        Result := Res = NO_ERROR;
        if not Result then
        begin
          FreeMem(List);
          List := Nil;
          Entries := 0;
        end;
      except
        FreeMem(List);
        raise;
      end;
    finally
      WNetCloseEnum(EnumHandle);
    end;
  end;
end;

procedure ScanNetworkResources(ResourceType, DisplayType: DWord; List: TStrings);

  procedure ScanLevel(NetResource: PNetResource);
  var
    Entries: DWord;
    NetResourceList: PNetResourceArray;
    i: Integer;
  begin
    if CreateNetResourceList(ResourceType, NetResource, Entries, NetResourceList) then
    try
      for i := 0 to Integer(Entries) - 1 do
      begin
        if (DisplayType = RESOURCEDISPLAYTYPE_GENERIC) or (NetResourceList[i].dwDisplayType = DisplayType) then
        begin
          List.AddObject(NetResourceList[i].lpRemoteName, Pointer(NetResourceList[i].dwDisplayType));
        end;
        if (NetResourceList[i].dwUsage and RESOURCEUSAGE_CONTAINER) <> 0 then
          ScanLevel(@NetResourceList[i]);
      end;
    finally
      FreeMem(NetResourceList);
    end;
  end;

begin
  ScanLevel(Nil);
end;

procedure RemoveStatusWindow(StatusWindow: TStatusWindowHandle);
begin
  DestroyWindow(StatusWindow);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  process, parameter, username: string;
  exitcode: cardinal;
  I, K, L: Integer;
  A: TStrArray;
begin
  listbox1.Clear;
  process := psexec;
  memo2.Lines.Clear;
  memo3.Lines.Clear;
  if DsiExecuteandCapture(process + ' -s -i -d \\' + memo1.Lines[0] + ' cmd /c echo f|xcopy ' + msgvbs + ' %temp%\msg.vbs /Y', memo2.Lines, '', exitcode) <> 0 then
  begin
    I := Pos('process ID', Memo2.Text);
    if I > 0 then
    begin
      Sleep(1000);
      parameter := ' -s -i -d \\' + memo1.Lines[0] + ' wscript.exe C:\windows\temp\msg.vbs /title:"' + edit1.Text + '" /message:"' + edit2.Text + '"';
      DSiExecute(process + parameter, 0);
      DsiExecuteandCapture(process + ' -s \\' + memo1.Lines[0] + ' cmd /c query user', Memo3.Lines, '', exitcode);
      K := Pos('console', memo3.Text);
      L := SendMessage(Memo3.Handle, EM_LINEFROMCHAR, K - 1, 0);
      if (K > 0) then
      begin
        Explode(A, '    ', memo3.Lines[L]);
        username := A[0];
        listbox1.Items.Add(username);
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('./ayarlar.ini');
  psexec := ini.ReadString('Ayarlar', 'psexec', '');
  if (psexec = '') then
  begin
    dlgOpen1.Filter := 'PsExec|psexec.exe';
    if dlgOpen1.Execute then
    begin
      psexec := dlgOpen1.FileName;
      ini.WriteString('Ayarlar', 'psexec', psexec);
    end
    else
    begin
      showmessage('PsExec dosyas� se�ilmedi. Program kapat�l�yor.');
      Halt;
    end;
  end;
  msgvbs := ini.ReadString('Ayarlar', 'msgvbs', '');
  if (msgvbs = '') then
  begin
    dlgOpen1.Filter := 'MsgVBS|msg.vbs';
    if dlgOpen1.Execute then
    begin
      msgvbs := dlgOpen1.FileName;
      ini.WriteString('Ayarlar', 'msgvbs', msgvbs);
    end
    else
    begin
      showmessage('VBS dosyas� se�ilmedi. Program kapat�l�yor.');
      Halt;
    end;
  end;
  pclist := ini.ReadString('Ayarlar', 'pclist', '');
  if (pclist = '') then
  begin
    dlgOpen1.Filter := 'PcList|pclist.txt';
    if dlgOpen1.Execute then
    begin
      pclist := dlgOpen1.FileName;
      ini.WriteString('Ayarlar', 'pclist', pclist);
      memo1.Lines.LoadFromFile(pclist);
    end
    else
    begin
      showmessage('Bilgisayar listesi dosyas� se�ilmedi. Program kapat�l�yor.');
      Halt;
    end;
  end
  else
  begin
    memo1.Lines.LoadFromFile(pclist);
  end;
end;

procedure TForm1.L1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    listbox1.Items.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  status: TStatusWindowHandle;
begin
  memo1.Lines.Clear;
  status := CreateStatusWindow('L�tfen bekleyin...');
  try
    ScanNetworkResources(RESOURCETYPE_DISK, RESOURCEDISPLAYTYPE_SERVER, memo1.Lines);
  finally
    RemoveStatusWindow(status);
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  label5.Caption := 'Toplam : ' + inttostr(memo1.Lines.Count);
end;

end.

