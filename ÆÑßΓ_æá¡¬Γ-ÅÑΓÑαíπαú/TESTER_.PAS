{ ������������� ��������� ������������.
  (�) ������� �.�., 2003 }
unit tester_;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  jpeg;

type
  TForm1 = class(TForm)
    // ������
    Label5: TLabel;

    // �������������� ������
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;

    // ����������� ������ ������
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;

    Image1: TImage;
    Panel1: TPanel;
    RadioButton5: TRadioButton;
    Button1: TButton;

    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);

    // ��� ���������� ��������� ���� �������
    procedure Info;
    procedure VoprosToScr;
    procedure ShowPicture; // ������� �����������
    procedure ResetForm;   // "�������" ����� ����� ������� ���������� �������
    procedure Itog;
    procedure FormCreate(Sender: TObject); // ��������� ������������


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;     // �����

implementation
{$R *.DFM}
const
   N_LEV=4; // ������ ������ ������
   N_ANS=4; // ������ �������� �������

var
  f:TextFile;
  fn:string; // ��� ����� ��������

  level:array[1..N_LEV] of integer; // �����, ��������������� ������
  mes:array[1..N_LEV] of string;    // ���������, ��������������� ������

  score:array[1..N_ANS] of integer; // ������ �� ����� ������
  summa:integer;  // ������� �����
  vopros:integer; // ����� �������� �������
  otv:integer;    // ����� ���������� ������

// ����� ���������� � �����
procedure Tform1.Info;
var
   s,buf:string;
begin
   readln(f,s);
   Form1.Caption := s;
   buf:='';
   repeat
         readln(f,s);
         if s[1] <> '.'
            then buf := buf +s + #13;
   until s[1] ='.';
   Label5.caption:=buf;
end;

// ��������� ���������� �� ������� �� ����
Procedure GetLevel;
var
   i:integer;
   buf:string;
begin
     i:=1;
     repeat
         readln(f,buf);
         if buf[1] <> '.' then begin
            mes[i]:=buf;        // ���������
            readln(f,level[i]); // ������
            i:=i+1;
         end;
     until buf[1]='.';
end;

// ��������������� �����������
Procedure TForm1.ShowPicture;
var
  w,h: integer; // ����������� ��������� ������� ��������
begin
  // ��������� ���������� ������� ��������
  w:=ClientWidth-10;
  h:=ClientHeight
         - Panel1.Height -10
         - Label5.Top
         - Label5.Height - 10;

  // �������
  if Label1.Caption <> ''
     then h:=h-Label1.Height-10;
  if Label2.Caption <> ''
     then h:=h-Label2.Height-10;
  if Label3.Caption <> ''
     then h:=h-Label3.Height-10;
  if Label4.Caption <> ''
     then h:=h-Label4.Height-10;

  // ���� ������ �������� ������ w �� h,
  // �� ��� �� ��������������
  Image1.Top:=Form1.Label5.Top+Label5.Height+10;
  if Image1.Picture.Bitmap.Height > h
        then Image1.Height:=h
        else Image1.Height:= Image1.Picture.Height;
  if Image1.Picture.Bitmap.Width > w
        then Image1.Width:=w
        else Image1.Width:=Image1.Picture.Width;

  Image1.Visible := True;
end;

// ������� ������
Procedure TForm1.VoprosToScr;
  var
   i:integer;
   s,buf:string;
   ifn:string; // ���� �����������
  begin
     vopros:=vopros+1;
     caption:='������ ' + IntToStr(vopros);
     // ��������� ������
     buf:='';
     repeat
           readln(f,s);
           if (s[1] <> '.') and (s[1] <> '\')
              then buf:=buf+s+' ';
     until (s[1] ='.') or (s[1] ='\');
     Label5.caption:=buf;  // ������� ������

     { ����������� ���������, �� ������� ������ �����
       ����, ��� ��������� �������������� ������
       � ��������� ����������� ��������� ������
       ������� �����, ������� ����� ������������
       ��� �� ������.}
     if s[1] <> '\'
       then Image1.Tag:=0 // � ������� ��� �����������
       else // � ������� ���� �����������
        begin
          Image1.Tag:=1;
          ifn:=copy(s,2,length(s));
          try
            Image1.Picture.LoadFromFile(ifn);
            except
              on E:EFOpenError do
                 Image1.Tag:=0;
          end;
        end;

     // ������ �������� �������
     i:=1;
     repeat
        buf:='';
        repeat // ������ ����� �������� ������
          readln(f,s);
          if (s[1]<>'.') and (s[1] <> ',')
                then buf:=buf+s+' ';
        until (s[1]=',')or(s[1]='.');
        // �������� �������������� �����
        score[i]:= StrToInt(s[2]);
        case i of
            1: Label1.caption:=buf;
            2: Label2.caption:=buf;
            3: Label3.caption:=buf;
            4: Label4.caption:=buf;
        end;
        i:=i+1;
     until s[1]='.';
     // ����� ��������� ����������� � �������������� ������

     // ����� ������� ��� �������
     if Image1.Tag =1  // ���� ����������� � �������
        then ShowPicture;

     // ����� �������������� �������
     if Form1.Label1.Caption <> ''
     then begin
        if Form1.Image1.Tag =1
            then Label1.top:=Image1.Top+Image1.Height+10
            else Label1.top:=Label5.Top+Label5.Height+10;
        RadioButton1.top:=Label1.top;
        Label1.visible:=TRUE;
        RadioButton1.visible:=TRUE;
     end;

     if Form1.Label2.Caption <> ''
     then begin
        Label2.top:=Label1.top+ Label1.height+10;
        RadioButton2.top:=Label2.top;
        Label2.visible:=TRUE;
        RadioButton2.visible:=TRUE;
     end;

     if Form1.Label3.Caption <> ''
     then begin
        Label3.top:=Label2.top+ Label2.height+10;
        RadioButton3.top:=Label3.top;
        Label3.visible:=TRUE;
        RadioButton3.visible:=TRUE;
     end;

     if Form1.Label4.Caption <> ''
     then begin
        Label4.top:=Label3.top+ Label3.height+10;
        RadioButton4.top:=Label4.top;
        Label4.visible:=TRUE;
        RadioButton4.visible:=TRUE;
     end;
  end;

Procedure TForm1.ResetForm;
begin // ������� ���������� ��� ����� � �����������

     Label1.Visible:=FALSE;
     Label1.caption:='';
     Label1.width:=ClientWidth-Label1.left-5;
     RadioButton1.Visible:=FALSE;

     Label2.Visible:=FALSE;
     Label2.caption:='';
     Label2.width:=ClientWidth-Label2.left-5;
     RadioButton2.Visible:=FALSE;

     Label3.Visible:=FALSE;
     Label3.caption:='';
     Label3.width:=ClientWidth-Label3.left-5;
     RadioButton3.Visible:=FALSE;

     Label4.Visible:=FALSE;
     Label4.caption:='';
     Label4.width:=ClientWidth-Label4.left-5;
     RadioButton4.Visible:=FALSE;

     Label5.width:=ClientWidth-Label5.left-5;

     Image1.Visible:=FALSE;
end;

// ����������� ������������ ������
procedure TForm1.Itog;
  var
   i:integer;
   buf:string;
  begin
   buf:='';
   buf:='���������� ������������'+ #13
		+'����� ������: '+ IntToStr(summa);
   i:=1;
   while (summa < level[i]) and (i<N_LEV) do
         i:=i+1;
   buf:=buf+ #13+mes[i];
   Label5.Top:=20;
   Label5.caption:=buf;
  end;

procedure TForm1.FormActivate(Sender: TObject);
  begin
     ResetForm;
     if ParamCount = 0
     then begin
             Label5.caption:= '�� ����� ���� �������� �����.';
             Button1.caption:='Ok';
             Button1.tag:=2;
             Button1.Enabled:=TRUE
          end
     else begin
          fn := ParamStr(1);
          assignfile(f,fn);
          try
            reset(f);
          except
            on EFOpenError do
               begin
                    ShowMessage('���� ����� '+fn+' �� ������.');
                    Button1.caption:='Ok';
                    Button1.tag:=2;
                    Button1.Enabled:=TRUE;
                    exit;
               end;
          end;
          Info; // ��������� � ������� ���������� � �����
          GetLevel;    // ��������� ���������� �� ������� ������
     end;
end;

// ������ �� ������ Button1
procedure TForm1.Button1Click(Sender: TObject);
  begin
     case Button1.tag of
       0: begin
               Button1.caption:='������';
               Button1.tag:=1;
               RadioButton5.Checked:=TRUE;
               // ����� ������� �������
               Button1.Enabled:=False;
               ResetForm;
               VoprosToScr;
          end;
       1: begin // ����� ��������� ��������
               summa:=summa+score[otv];
               RadioButton5.Checked:=TRUE;
               Button1.Enabled:=False;
               ResetForm;
               if not eof(f)
                  then VoprosToScr
                  else
                     begin
                        summa:=summa+score[otv];
                        closefile(f);
                        Button1.caption:='Ok';
                        Form1.caption:='���������';
                        Button1.tag:=2;
                        Button1.Enabled:=TRUE;
                        Itog; // ������� ���������
                     end;
          end;
       2: begin // ���������� ������
            Form1.Close;
          end;
     end;
end;

// ��������� ��������� ������� OnClick
// ��� ����������� RadioButton1-RadioButton4
procedure TForm1.RadioButtonClick(Sender: TObject);
begin
  if sender = RadioButton1
  then otv:=1
  else if sender = RadioButton1
          then otv:=2
          else if sender = RadioButton3
                  then otv:=3
                  else otv:=4;
  Button1.enabled:=TRUE;
end;

// ������������ ��������� �����������
procedure TForm1.FormCreate(Sender: TObject);
begin
    Image1.AutoSize := False;
    Image1.Proportional := True;
    RadioButton1.Visible := False;
end;

end.
