unit Unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, PythonEngine, PythonGUIInputOutput, SdpoSerial, Registry;

type

  { Tform2 }

  Tform2 = class(TForm)
    btn_test: TButton;
    btn_test1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    IdleTimer1: TIdleTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cb_com: TComboBox;
    cb_in1: TComboBox;
    cb_in2: TComboBox;
    cb_out: TComboBox;
    test: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    serial: TSdpoSerial;
    procedure btn_test1Click(Sender: TObject);
    procedure btn_testClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure serialRxData(Sender: TObject);
  private
    { private declarations }
    a0,a1,a2,a3:string;
  public
    { public declarations }
    ready: boolean;
    procedure analyse;
    procedure lire_com;

  end;

var
  form2: Tform2;

implementation
Uses unit1;
{$R *.lfm}

{ Tform2 }

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

{ TForm1 }
procedure Tform2.analyse;
var
i:integer;

OutPutList: TStringList;
str:string;
begin
  str := StringReplace(memo2.text, sLineBreak, '', [rfReplaceAll]);
  test.caption :=str;
  OutPutList := TStringList.Create;
   try
     Split(';', str, OutPutList) ;
     //self.caption:=inttostr(OutPutList.count);
   finally
     if  OutPutList.count = 4 then begin
       a0:=OutPutList.Strings[0];
       a1:=OutPutList.Strings[1];
       a2:=OutPutList.Strings[2];
       a3:=OutPutList.Strings[3];

       //in1
       if (self.CheckBox1.checked) and (self.cb_in1.Text='A0') then begin
         if a0 <> '' then if strtofloat(a0)>1000 then form1.in1.SwitchOn:= True else form1.in1.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in1.Text='A1') then begin
         if a1 <> '' then if strtofloat(a1)>1000 then form1.in1.SwitchOn:= True else form1.in1.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in1.Text='A2') then begin
         if a2 <> '' then if strtofloat(a2)>1000 then form1.in1.SwitchOn:= True else form1.in1.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in1.Text='A3') then begin
         if a3 <> '' then if strtofloat(a3)>1000 then form1.in1.SwitchOn:= True else form1.in1.SwitchOn:= False;
       end;

       //in2
       if (self.CheckBox1.checked) and (self.cb_in2.Text='A0') then begin
         if a0 <> '' then if strtofloat(a0)>1000 then form1.in2.SwitchOn:= True else form1.in2.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in2.Text='A1') then begin
         if a1 <> '' then if strtofloat(a1)>1000 then form1.in2.SwitchOn:= True else form1.in2.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in2.Text='A2') then begin
         if a2 <> '' then if strtofloat(a2)>1000 then form1.in2.SwitchOn:= True else form1.in2.SwitchOn:= False;
       end;
       if (self.CheckBox1.checked) and (self.cb_in2.Text='A3') then begin
         if a3 <> '' then if strtofloat(a3)>1000 then form1.in2.SwitchOn:= True else form1.in2.SwitchOn:= False;
       end;

       form1.in1Change(self);
   end;
     OutPutList.Free;
   end;
end;

procedure Tform2.FormCreate(Sender: TObject);
begin




  memo1.Lines.LoadFromFile('config0.cfg');
  CheckBox1.checked :=( form2.memo1.lines[0] = '1' );
  //cb_com.Text:=form2.memo1.lines[1];
  cb_in1.Text:=form2.memo1.lines[2];
  cb_in2.Text:=form2.memo1.lines[3];
  cb_out.Text:=form2.memo1.lines[4];
  btn_test.Click;
  IdleTimer1.Enabled:=self.CheckBox1.Checked;
  ready:=true;

end;
procedure Tform2.lire_com;
var
  reg: TRegistry;
  st: Tstrings;
  i: Integer;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('hardware\devicemap\serialcomm');
    st := TstringList.Create;
    cb_com.clear;
    try
      reg.GetValueNames(st);
      for i := 0 to st.Count - 1 do
        cb_com.Items.Add(reg.Readstring(st.strings[i]));
    finally
      st.Free;
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;


procedure Tform2.FormShow(Sender: TObject);
begin
  self.lire_com;
end;

procedure Tform2.IdleTimer1Timer(Sender: TObject);
begin
  memo2.Clear;
  self.serial.WriteData('#'+chr(13)+chr(10));

end;

procedure Tform2.Label2Click(Sender: TObject);
begin

end;

procedure Tform2.Memo2Change(Sender: TObject);
begin
  //self.analyse;
end;

procedure Tform2.serialRxData(Sender: TObject);
var rec:string;
begin
  rec:=serial.ReadData;
  Memo2.Append(rec);
  self.analyse;
end;

procedure Tform2.btn_testClick(Sender: TObject);
begin

  if  cb_com.Text='' then begin
    exit;
  end;

  try
    serial.Device:=self.cb_com.text;
    serial.Active:=true;

    serial.WriteData(self.cb_out.Text[2]+'-255.');
    serial.WriteData(self.cb_out.Text[2]+'-0.');
   except
     on E : Exception do
     begin
       ShowMessage('Exception message = '+E.Message);
     end;
   end;

end;

procedure Tform2.btn_test1Click(Sender: TObject);
begin
  lire_com;
end;

procedure Tform2.Button2Click(Sender: TObject);
begin
  memo1.clear;
  memo1.lines.Add('0');
  memo1.lines.add( self.cb_com.Text);
  memo1.Lines.add( self.cb_in1.Text);
  memo1.Lines.add( self.cb_in2.Text);
  memo1.Lines.add( self.cb_out.Text);
  memo1.lines.SaveToFile('config0.cfg');
end;

procedure Tform2.CheckBox1Click(Sender: TObject);
begin
  form1.in1.Enabled:=not self.CheckBox1.Checked;
  form1.in2.Enabled:=not self.CheckBox1.Checked;
  self.IdleTimer1.Enabled:=self.CheckBox1.Checked;
end;




end.

