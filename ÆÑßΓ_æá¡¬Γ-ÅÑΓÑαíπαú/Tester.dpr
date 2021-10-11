program Tester;

uses
  Forms,
  tester_ in 'tester_.pas' {Form1};

{$R *.RES}

begin
  Application.Title := 'Тестирование';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
