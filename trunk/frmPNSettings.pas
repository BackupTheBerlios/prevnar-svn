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
  ExtCtrls, Spin, strutils, PNCommons, Menus,charencstreams, frmIniPrev;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    chkIgnoreSections: TCheckBox;
    chkStripQuotes: TCheckBox;
    chkOkayAutotranslate: TCheckBox;
    chkConvertPercent: TCheckBox;
    cmdOkay: TButton;
    chkFillInEmpty: TCheckBox;
    cmdCancel: TButton;
    cboConfirmAutotranslate: TComboBox;
    speRecent: TSpinEdit;
    lblRecent: TLabel;
    lblConfirmAutotranslate: TLabel;
    lblSectionOpener: TLabel;
    lblSectionCloser: TLabel;
    txtIgnoreStarts: TMemo;
    txtSectionOpener: TEdit;
    lblRowSplitter: TLabel;
    txtRowSplitter: TEdit;
    lblIgnoreBeginnings: TLabel;
    txtSectionCloser: TEdit;
    procedure chkOkayAutotranslateChange(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblRowSplitterClick(Sender: TObject);
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
//uses frmIniPrev;

{$R *.lfm}

{ TfrmSettings }

function AssembleRecent (fMenuItem: array of TMenuItem): String;
var
  i:integer;
  RetVal: string= '';
begin
   for i:=0 to frmSettings.speRecent.Value-1 do
     begin //for i
       if fMenuItem[i].Visible = True
         then RetVal:=RetVal + fMenuItem[i].Caption+'*'
         else break;
     end; //next i
   Result:=RetVal;
end;

function EscToString(aString: string): String;
var
  RetVal: string='';
begin
     RetVal:=aString;
     while PosEx ('\[',RetVal) <> 0 do RetVal:=UncloseReplaceEsc(RetVal,'\[',']');
     RetVal:=UTF8StringReplace (RetVal, '\\', '\',[rfReplaceAll]);
     RetVal:=UTF8StringReplace (RetVal,  '\t', TAB,[rfReplaceAll]);
     RetVal:=UTF8StringReplace (RetVal,  '\N', CrLf,[rfReplaceAll]);
     RetVal:=UTF8StringReplace (RetVal,  '\R', Cr,[rfReplaceAll]);
     RetVal:=UTF8StringReplace (RetVal,  '\L', Lf,[rfReplaceAll]);
     Result:=RetVal;
end;

function StringToEsc(aString: string): String;
var
  RetVal: String;
begin
  RetVal:=UTF8StringReplace (aString, '\', '\\',[rfReplaceAll]);
  RetVal:=UTF8StringReplace (RetVal, TAB,  '\t',[rfReplaceAll]);
  RetVal:=UTF8StringReplace (RetVal, CrLf, '\N',[rfReplaceAll]);
  RetVal:=UTF8StringReplace (RetVal, Cr,   '\R',[rfReplaceAll]);
  RetVal:=UTF8StringReplace (RetVal, Lf,   '\L',[rfReplaceAll]);
  Result:=RetVal;
end;


procedure SaveSettings;
var
  SettingsContents: string='';
begin
 with frmSettings do
 begin //with
  SettingsContents:=BOMUTF8 //Linux throws an exception on this line, Windows does not ?!
    + 'PrevNarSettings'+ CrLf
    + 'If you edit this file in an external tool (Notepad, etc), make sure to save it as UTF8 with BOM.'+ CrLf
    + ezSettingsHeaderLocalized+ CrLf
    +'RowSplitter=' + StringToEsc(RowSplitter)+ CrLf
    +'SectionOpener=' + StringToEsc(SectionOpener)+ CrLf
    +'SectionCloser=' + StringToEsc(SectionCloser)+ CrLf
    +'FillBlanks=' + BooleanToString (FillBlanks)+ CrLf
    +'IgnoreLines=' + UTF8StringReplace (txtIgnoreStarts.Lines.Text ,crlf,'\n',[rfIgnoreCase,rfReplaceAll])+ CrLf
    +'ConfirmAutotranslate=' + its(ConfirmAutotranslate)+CrLf
    +'IgnoreSections=' + BooleanToString (IgnoreSections)+CrLf
    +'Convert%=' + BooleanToString (ConvertPercent)+CrLf
    +'DebugMode='+ BooleanToString(DebugMode)+ CrLf
    +'RecentStore=' + IntToStr (speRecent.Value)+ CrLf
    +'RecentMain='+  AssembleRecent(frmIniPrev.mnuFileRecentMain)+ CrLf
    +'RecentTrans='+  AssembleRecent(frmIniPrev.mnuFileRecentTrans)+ CrLf
    +'RecentAux='+  AssembleRecent(frmIniPrev.mnuFileRecentAux)+ CrLf
    +'RecentSet='+  AssembleRecent(frmIniPrev.mnuFileRecentSet)+ CrLf
    +'VocabularySourcePath=' + VocabularySourcePath +CrLf
    +'VocabularyPath='+ VocabularyPath+ CrLf
    +'AutotranslateOkay=' + BooleanToString(AutotranslateOkay) +CrLf
    +'StripQuotes='+ BooleanToString (StripQuotes) +CrLf
    + CrLf ; //CrLf is needed, to assure that the value will be properly read, if the settings file cannot be deleted.
 end;  //with
 try
   DeleteFile (AppendPathDelim(ProgramDirectory) + SettingsFile);
 finally
 end;
 WriteUTF8(AppendPathDelim(ProgramDirectory) + SettingsFile,SettingsContents,ufUtf8);
end;

procedure CreateRecentMenu (CreationItem: array of TMenuItem; CreationLocation: TMenuItem; Count: Integer);
var
  i:integer;
begin
 for i:=0 to Count-1 do
 begin
     CreationItem[i]:=TMenuItem.Create (CreationLocation);
     CreationItem[i].Caption:='';
     CreationItem[i].Tag:=i;
     CreationItem[i].OnClick:=@frmIniPrevMain.mnuFileRecentMainClick;
     CreationLocation.Add (CreationItem[i]);
     CreationItem[i].Visible:=False;
 end;
end;

procedure ExtractRecent (fMenuItem: array of TMenuItem; fRecentLine: String);
var
  RecentMain: array of String;
  i: integer;
  Loops: integer;
begin
  RecentMain:=Split(fRecentLine,'*');
  if (Length(RecentMain)<=14) then Loops:=(Length(RecentMain)-1) else Loops:=14;
  with frmIniPrevMain do
  begin
    for i:=0 to Loops do
      begin //for i
         fMenuItem[i].Caption:=RecentMain[i];
         fMenuItem[i].Visible:=True;
      end; //next i
   end;//with
end;

procedure LoadSettings;
var
 SettingsContents: StringArray1D;
 i: integer;
 Key:String;
 Value:String;
 FileContents:UniFile;
begin
    with frmIniPrevMain do
   begin //with
     for i:=0 to frmSettings.speRecent.Value-1 do
     begin  //for i
       mnuFileRecentMain[i]:=TMenuItem.Create (mnuFileOpenMain);
       mnuFileRecentMain[i].Caption:='';
       mnuFileRecentMain[i].Tag:=i;
       mnuFileRecentMain[i].OnClick:=@mnuFileRecentMainClick;
       mnuFileOpenMain.Add (mnuFileRecentMain[i]);
       mnuFileRecentMain[i].Visible:=False;

       mnuFileRecentTrans[i]:=TMenuItem.Create (mnuFileOpenTrans);
       mnuFileRecentTrans[i].Caption:='';
       mnuFileRecentTrans[i].Tag:=i;
       mnuFileRecentTrans[i].OnClick:=@mnuFileRecentTransClick;
       mnuFileOpenTrans.Add (mnuFileRecentTrans[i]);
       mnuFileRecentTrans[i].Visible:=False;

       mnuFileRecentAux[i]:=TMenuItem.Create (mnuFileLoadAuxLang);
       mnuFileRecentAux[i].Caption:='';
       mnuFileRecentAux[i].Tag:=i;
       mnuFileRecentAux[i].OnClick:=@mnuFileRecentAuxClick;
       mnuFileLoadAuxLang.Add (mnuFileRecentAux[i]);
       mnuFileRecentAux[i].Visible:=False;

       mnuFileRecentSet[i]:=TMenuItem.Create (mnuFileOpenSet);
       mnuFileRecentSet[i].Caption:='';
       mnuFileRecentSet[i].Tag:=i;
       mnuFileRecentSet[i].OnClick:=@mnuFileRecentSetClick;
       mnuFileOpenSet.Add (mnuFileRecentSet[i]);
       mnuFileRecentSet[i].Visible:=False;

     end; //next i
   end; //with
 if FileExistsUTF8 (AppendPathDelim(ProgramDirectory) + SettingsFile)  then
 begin
 try
   FileContents:=ReadUTF8(AppendPathDelim(ProgramDirectory) + SettingsFile);
   SettingsContents:=Split(FileContents.UniText {[0]},CrLf);
   for i:=0 to Length(SettingsContents)-1 do
   begin  //for
     Key:=LeftStr (SettingsContents[i],PosEx ('=',SettingsContents[i])-1) ;
     Value:=Mid (SettingsContents[i],Length(key+'=')+1); //TODO- this 100 shall be removed somehow
     //WARNING: If the compiler returns an error on the next line, it means that your Lazarus is too old.
     case key of
       'RowSplitter':   RowSplitter:=EscToString(Value);
       'SectionOpener': SectionOpener:=EscToString(Value);
       'SectionCloser': SectionCloser:=EscToString(Value);
       'FillBlanks': FillBlanks:=StringToBoolean  (Mid (SettingsContents[i],Length(key+'=')+1,100));
       'IgnoreLines': IgnoreLines:=Split (mid(SettingsContents[i],Length(key+'=')+1,100),'\n');
       'ConfirmAutotranslate': ConfirmAutotranslate:=StrToInt (Value);
       'IgnoreSections': IgnoreSections:=StringToBoolean(Value);
       'Convert%': ConvertPercent:=StringToBoolean(Value);
       'DebugMode': DebugMode:=StringToBoolean(Value);
       'RecentStore': RecentStore:=StrToInt(Value);
       'RecentMain':ExtractRecent (mnuFileRecentMain, Value );
       'RecentTrans':ExtractRecent (mnuFileRecentTrans,Value);
       'RecentAux':ExtractRecent (mnuFileRecentAux,Value);
       'RecentSet':
         begin
           ExtractRecent (mnuFileRecentSet,Value);
           frmIniPrevMain.mnuFileOpenSet.Enabled:=mnuFileRecentSet[0].Visible;
         end;
       'VocabularyPath':VocabularyPath:=Value;
       'VocabularySourcePath':VocabularySourcePath:=Value;
       'AutotranslateOkay': AutotranslateOkay:=StringToBoolean(Value);
       'StripQuotes':StripQuotes:=StringToBoolean(Value);
     end;  //case
   end;  //for i
   except
   end; //except
 // finally
 end
else
begin
  RowSplitter:='=';
  SectionOpener:='[';
  SectionCloser:=']';
  FillBlanks:=True ;
  SetLength(IgnoreLines,3);
  IgnoreLines[0]:='no_translate';
  IgnoreLines[1]:='\\';
  IgnoreLines[2]:=Apostrophy;
  ConfirmAutotranslate:=0;
  AutotranslateOkay:=False;
  IgnoreSections:=False;
  ConvertPercent:=False;
  StripQuotes:=True;
  DebugMode:=False;
  RecentStore:=5;
  SaveSettings;
end;
 SetSettings;
end;

procedure GetSettings;
begin
 with frmSettings do
 begin //with
   RowSplitter:=EscToString(txtRowSplitter.Text);
   SectionOpener:=EscToString(txtSectionOpener.Text);
   SectionCloser:=EscToString(txtSectionCloser.Text);
   FillBlanks:=chkFillInEmpty.Checked;
   IgnoreLines:=Split(txtIgnoreStarts.Lines.Text ,CrLf);
   ConfirmAutotranslate:=cboConfirmAutotranslate.ItemIndex;
   RecentStore:=speRecent.Value;
   AutotranslateOkay:=chkOkayAutotranslate.Checked;
   IgnoreSections:=chkIgnoreSections.Checked;
   ConvertPercent:=chkConvertPercent.Checked;
   StripQuotes:=chkStripQuotes.Checked;
 end; //with
end;

procedure SetSettings;
begin
  with frmSettings do
  begin //with
    txtRowSplitter.Text:=StringToEsc(RowSplitter);
    txtSectionOpener.Text:=StringToEsc(SectionOpener);
    txtSectionCloser.Text:=StringToEsc(SectionCloser);
    chkFillInEmpty.Checked:=FillBlanks;
    txtIgnoreStarts.Lines.Text:=Join(IgnoreLines,CrLf);
    cboConfirmAutotranslate.ItemIndex:=ConfirmAutotranslate;
    chkIgnoreSections.Checked:=IgnoreSections;
    chkConvertPercent.Checked:=ConvertPercent;
    speRecent.Value:=RecentStore;
    chkOkayAutotranslate.Checked:=AutotranslateOkay;
    chkStripQuotes.Checked:=StripQuotes;
  end; //with
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmSettings.lblRowSplitterClick(Sender: TObject);
begin

end;

procedure TfrmSettings.cmdOkayClick(Sender: TObject);
begin
  frmSettings.Hide;
end;

procedure TfrmSettings.cmdCancelClick(Sender: TObject);
begin
  frmSettings.Hide  ;
end;

procedure TfrmSettings.chkOkayAutotranslateChange(Sender: TObject);
begin

end;

end.

