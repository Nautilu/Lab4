program Project1;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  USort in 'USort.pas';
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
