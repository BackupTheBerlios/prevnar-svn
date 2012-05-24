{
    ПревНар- приложение за превеждане на INI-подобни файлове./PrevNar- an application for translating INI-like files.
    Възпроизводствено право/Copyright (C) 2012  СМ630

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
}


unit frmPNSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, strutils, PNCommons  ;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    cmdOkay: TButton;
    chkFillInEmpty: TCheckBox;
    cmdCancel: TButton;
    cboConfirmAutotranslate: TComboBox;
    lblConfirmAutotranslate: TLabel;
    lblSectionOpener: TLabel;
    lblSectionCloser: TLabel;
    txtIgnoreStarts: TMemo;
    txtSectionOpener: TEdit;
    lblRowSplitter: TLabel;
    txtRowSplitter: TEdit;
    lblIgnoreBeginnings: TLabel;
    txtSectionCloser: TEdit;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSettings: TfrmSettings;
  cboIgnoreIndex:integer;

//Public subs
procedure LoadSettings;
procedure GetSettings;
procedure SetSettings;
procedure SaveSettings;

implementation

{$R *.lfm}

{ TfrmSettings }

{
function ComboToArray(aCombo:TComboBox): StringArray1D;
var
  RetVal: StringArray1D;
  i:integer;
begin
  SetLength(RetVal,aCombo.Items.Count-1);
  for i:= 0 to aCombo.Items.Count-1 do
    RetVal[i]:=aCombo.Items[i];
  Result:=RetVal ;
end;
}

procedure SaveSettings;
var
  SettingsContents: string='';
begin
 with frmSettings do
 begin //with
  SettingsContents:= BOMUTF8 //Linux throws an exception on this line, Windows does not ?!
    + 'PrevNarSettings'+ CrLf
    + 'If you edit this file in an external tool (Notepad, etc), make sure to save it as UTF8 with BOM.'+ CrLf
    + ezSettingsHeaderLocalized+ CrLf
    +'RowSplitter=' + RowSplitter+ CrLf
    +'SectionOpener=' + SectionOpener + CrLf
    +'SectionCloser=' + SectionCloser + CrLf
    +'FillBlanks=' + BooleanToString (FillBlanks) + CrLf
    +'IgnoreLines=' + UTF8StringReplace (txtIgnoreStarts.Lines.Text ,crlf,'\n',[rfIgnoreCase,rfReplaceAll])+ CrLf
    +'ConfirmAutotranslate=' + its(ConfirmAutotranslate)
    + CrLf ; //CrLf is needed, to assure that the value will be properly read, if the settings file cannot be deleted.
 end;  //with
 try
   DeleteFile (AppendPathDelim(ProgramDirectory) + SettingsFile);
 finally
 end;
 FilePut (AppendPathDelim(ProgramDirectory) + SettingsFile,SettingsContents ) ;
end;

procedure LoadSettings;
var
 SettingsContents: StringArray1D;
 i: integer;
 Key:String;
 Value:String;
begin
 if FileExistsUTF8 (AppendPathDelim(ProgramDirectory) + SettingsFile)  then
 begin
 try
   SettingsContents:= Split(FileGet (AppendPathDelim(ProgramDirectory) + SettingsFile,0,0,ord(EncodingUTF8)),CrLf);
   for i:= 0 to Length(SettingsContents)-1 do
   begin  //for
     Key:=LeftStr (SettingsContents[i],PosEx ('=',SettingsContents[i])-1) ;
     Value:= Mid (SettingsContents[i],Length(key+'=')+1,100);;
     // ShowMessage ('>'+Mid (SettingsContents[i],Length(key+'=')+1,100)+'<');
     //WARNING: If the compiler returns an error on the next line, it means that your Lazarus is too old.
     case key of
       'RowSplitter': RowSplitter := Value; //Mid (SettingsContents[i],Length(key+'=')+1,100);
       'SectionOpener': SectionOpener := Value; //Mid (SettingsContents[i],Length(key+'=')+1,100);
       'SectionCloser': SectionCloser := Value; //Mid (SettingsContents[i],Length(key+'=')+1,100);
       'FillBlanks': FillBlanks := StringToBoolean  (Mid (SettingsContents[i],Length(key+'=')+1,100));
       'IgnoreLines': IgnoreLines:= Split (mid(SettingsContents[i],Length(key+'=')+1,100),'\n');
       'ConfirmAutotranslate': ConfirmAutotranslate:= StrToInt (Value);
     end;  //case
   end;  //for i
   except
   end; //except
// finally
 end
else
begin
RowSplitter := '=';
SectionOpener := '[';
SectionCloser := ']';
FillBlanks := True ;
SetLength(IgnoreLines,3);
IgnoreLines[0]:='no_translate';
IgnoreLines[1]:='\\';
IgnoreLines[2]:=Apostrophy;
ConfirmAutotranslate:= 0;
SaveSettings;
end;

 //end; //try
 SetSettings;
end;

procedure GetSettings;
begin
 with frmSettings do
 begin //with
   RowSplitter:= txtRowSplitter.Text;
   SectionOpener:= txtSectionOpener.text;
   SectionCloser:= txtSectionCloser.text;
   FillBlanks:= chkFillInEmpty.Checked;
   IgnoreLines:= Split(txtIgnoreStarts.Lines.Text ,CrLf);
   ConfirmAutotranslate:=cboConfirmAutotranslate.ItemIndex;
 end; //with
end;

procedure SetSettings;
begin
  with frmSettings do
  begin //with
    txtRowSplitter.Text :=RowSplitter;
    txtSectionOpener.Text:= SectionOpener;
    txtSectionCloser.Text:= SectionCloser;
    chkFillInEmpty.Checked := FillBlanks;
    txtIgnoreStarts.Lines.Text:= Join(IgnoreLines,CrLf);
    cboConfirmAutotranslate.ItemIndex:=ConfirmAutotranslate;
  end; //with
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  LoadSettings ;
end;

procedure TfrmSettings.cmdOkayClick(Sender: TObject);
begin
  frmSettings.Hide  ;
end;

procedure TfrmSettings.cmdCancelClick(Sender: TObject);
begin
  frmSettings.Hide  ;
end;


end.

