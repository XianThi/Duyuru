program Duyuru;

uses
  Forms,
  AnaForm in 'AnaForm.pas' {Form1},
  DSiWin32 in 'DSiWin32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
