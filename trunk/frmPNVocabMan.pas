{
    ПревНарин- приложение за превеждане на INI-подобни файлове./PrevNarin- an application for translating INI-like files.
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

unit frmPNVocabMan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  StdCtrls{, ComCtrls}, Grids, PNCommons{, strutils};

type

  { TfrmVocabMan }

  TfrmVocabMan = class(TForm)
    cmdRemoveSources: TButton;
    cmdDone: TButton;
    cmdAddSources: TButton;
    cmdSaveVocab: TButton;
    fneVocabFilename: TFileNameEdit;
    lblVocabSources: TLabel;
    lblVocabFileName: TLabel;
    odMultipleFiles: TOpenDialog;
    sgVocabSources: TStringGrid;
    procedure cmdAddSourcesClick(Sender: TObject);
    procedure cmdDoneClick(Sender: TObject);
    procedure cmdRemoveSourcesClick(Sender: TObject);
    procedure cmdSaveVocabClick(Sender: TObject);
    procedure fneVocabFilenameChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmVocabMan: TfrmVocabMan;
  //Vocabulary:array of array of String;
  colLangMain:integer=0;
  colLangTrans:integer=1;


implementation

uses
  frmPNSettings,frmIniPrev;

{$R *.lfm}

{ TfrmVocabMan }

procedure RemoveDuplicateFiles;
var
   i:integer;
   j:integer;
begin
   with frmVocabMan do
   begin //with
     i:=sgVocabSources.RowCount-1;
     while i>=0 do
     begin //while i
       j:=i-1;
       while j>=0 do
       begin //while j
         //Case sensitive comparison must be used, otherwise it might cause problems in case sensitive file systems.
          if CompareStr (sgVocabSources.cells[colLangmain,i] ,sgVocabSources.cells [colLangmain, j])=0 then
          begin //if
            sgVocabSources.Rows[j].Delete(1);
            dec(i);
            dec(j);
          end; //if
          dec (j);
       end; //while j
       dec (i);
     end; //while i
  end; //with
end;

function LoadVocabulary(const FileName:string): StringArray2D;
var
  VocabContents: UniFile;
  VocabRows: array of String;
  Row: array of string;
  i:integer;
  j:integer=0;
  RetVal:StringArray2D;
begin
  SetLength(RetVal,0,0);
   if (FileExistsUTF8(Filename) =True) then
   begin
     VocabularyPath:= FilePath(Filename);
     VocabContents:=ReadUTF8(Filename);
     VocabRows:=Split(VocabContents.UniText,CrLf); //TODO- to get the line separator
     SetLength(RetVal,Length(VocabRows),2);
     for i:=0 to Length(VocabRows)-1 do
     begin
        Row:= Split(VocabRows[i],TAB);
        if Length(Row)= 2 then
         begin //if
           RetVal[j,0]:=row[0];
           RetVal[j,1]:=row[1];
           inc(j);
         end; //if
     end;
   end; //if FileExists
   Result:=RetVal;
end;



procedure TfrmVocabMan.cmdAddSourcesClick(Sender: TObject);
var
  MainFilename: String;
  TranslationFilename: String;
begin
   odMultipleFiles.InitialDir:=VocabularySourcePath;
   odMultipleFiles.Title:=ezSelectMainFile;
   odMultipleFiles.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|' + ezAllFiles +'(*.*)|*.*|');
   odMultipleFiles.Options:=[ofFileMustExist,ofEnableSizing,ofViewDetail,ofAutoPreview];
   if odMultipleFiles.Execute=True then
   begin
     VocabularySourcePath:=odMultipleFiles.InitialDir;
     MainFilename:=odMultipleFiles.FileName;
     if FileExistsUTF8 (MainFilename)= True then
     begin
       odMultipleFiles.Title:=ezSelectTranslationFile;
       odMultipleFiles.FileName:='';
       odMultipleFiles.Execute;
       if FileExistsUTF8 (odMultipleFiles.FileName)= True then
       begin
         sgVocabSources.InsertColRow (False,sgVocabSources.RowCount);
         sgVocabSources.Cells[colLangTrans,sgVocabSources.RowCount-1]:= odMultipleFiles.FileName;
         sgVocabSources.Cells[colLangMain,sgVocabSources.RowCount-1]:= MainFilename;
       end;
     end; //if fileexists
   end;
   //Obsolete- multipple file are proper only for PO files.
//  odMultipleFiles.Options:=[ofAllowMultiSelect,ofFileMustExist,ofEnableSizing,ofViewDetail,ofAutoPreview];
    {
    FileNames:=odMultipleFiles.Files;
    StartPos:=sgVocabSources.RowCount;
    for i:= 0 to FileNames.Count-1 do
    begin
      sgVocabSources.InsertColRow (False,i);
      sgVocabSources.Cells[colLangMain,i+StartPos]:= FileNames[i];
    end;
    RemoveDuplicateFiles;}
    if (sgVocabSources.RowCount >1) then
    begin //if
     cmdSaveVocab.Enabled:=True;
     cmdRemoveSources.Enabled:=True;
    end; //if
  end;

procedure TfrmVocabMan.cmdDoneClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfrmVocabMan.cmdRemoveSourcesClick(Sender: TObject);
begin
   sgVocabSources.DeleteRow(sgVocabSources.Selection.Top);
   if (sgVocabSources.RowCount >1) then cmdRemoveSources.Enabled:=True else cmdRemoveSources.Enabled:=False;

end;

procedure AddSourceFiles(Row:Integer );
var
  SourceLine: integer;
  i,k:integer;
  l:integer=0;
  VocabRow: integer;
  ItemIndex:Integer=0;
  MainVocab:Array of array of String;
  AppendVocab:Array of array of String;
  CurrentRow:array of string;
  AllRows:Array of String;
  Entry: String;
  VocabFile:String;
  DuplicateEntry: Boolean=False;
  FileContents:UniFile;
begin

end;

procedure TfrmVocabMan.cmdSaveVocabClick(Sender: TObject);
var
  FileIndex: integer;
  SourceLine: integer;
  i,k:integer;
  l:integer=0;
  VocabRow: integer;
  ItemIndex:Integer=0;
  MainVocab:Array of array of String;
  AppendVocab:Array of array of String;
  CurrentRow:array of string;
  AllRows:Array of String;
  Entry: String;
  VocabFile:String;
  DuplicateEntry: Boolean=False;
  FileContents:UniFile;
  VocabContents: StringArray2D;
begin
  for FileIndex:=1 to sgVocabSources.RowCount -1 do
  begin //for FileIndex Processes all files
    SetLength(MainVocab,0,0);
    SetLength(AppendVocab,0,0);
    ItemIndex:=0;
    VocabContents:=LoadVocabulary(fneVocabFilename.Text);
    FileContents:=ReadUTF8(sgVocabSources.Cells[colLangMain,FileIndex]);
    AllRows:=Split(FileContents.UniText,FileContents.NewLine);
    SetLength(MainVocab,2,ItemIndex+Length(AllRows));
    for SourceLine:=0 to ItemIndex+Length(AllRows)-1 do
    begin //for SourceLine
      DuplicateEntry:=False;
      CurrentRow:=Split(AllRows[SourceLine],RowSplitter);
      if Length(CurrentRow)=2 then
       begin //if
        Entry:= CurrentRow[1];
        for VocabRow:=0 to Length(VocabContents) -1 do  //Checks if the entry is already in the vocabulary
        begin //for VocabRow
          if CompareStr (Entry, VocabContents[VocabRow,0]) = 0 then
           begin
              DuplicateEntry:=True;
              break;
           end;
        end; // for VocabRow
        if DuplicateEntry= False then
        begin  //if not Duplicate entry
           for k:=0 to SourceLine do //check for duplicate entries in the source files
           begin //for k
             if CompareStr(Entry,MainVocab[1,k]) = 0 then
             begin
               DuplicateEntry:= True;
               break;
              end;
           end; //next k
        end; //if not Duplicate entry
         if DuplicateEntry= False then
          begin
            MainVocab[0,ItemIndex]:=CurrentRow[1];
            MainVocab[1,ItemIndex]:=CurrentRow[0];
            inc(ItemIndex);
          end; //for k
       end; //if
    end;//next SourceLine
   SetLength(MainVocab,2,ItemIndex -1 {?});

  //Handle translation file
  SetLength(AppendVocab,2,ItemIndex);
  AllRows:=Split(ReadUTF8(sgVocabSources.Cells[colLangTrans,FileIndex]).UniText,CrLf);
  l:=0;
  for SourceLine:=0 to Length(AllRows) -1 do
    begin //for SourceLine
      CurrentRow:=Split(AllRows[SourceLine],RowSplitter);
      if Length(CurrentRow) = 2 then
      begin //if
      Entry:= CurrentRow[0];
      for k:=0 to Length(MainVocab[0])-1 do
        begin //for k
          if (Entry=MainVocab[1,k]) and (CompareStr(MainVocab[0,k],CurrentRow[1])<>0) then
          begin //if
            AppendVocab[0,l]:=MainVocab[0,k];
            AppendVocab[1,l]:= CurrentRow[1];
            Inc(l);
            break;
          end;// if
        end; //for k
      end; //if
    end; //next SourceLine
    SetLength(AppendVocab,2,l);
    if FileExistsUTF8(fneVocabFilename.Text)
      then VocabFile:=ReadUTF8(fneVocabFilename.Text).UniText
      else VocabFile:='';
    for i:=0 to Length(AppendVocab[0])-1 do
    begin
       VocabFile:=VocabFile+CrLf+AppendVocab [0,i]+TAB+AppendVocab[1,i];
    end;
    WriteUTF8(fneVocabFilename.Text,VocabFile);
  end; //next FileIndex
  QuestionDlg(ezVocabularySaved,  LocalizeRowMultiple (ezVocabularySaved,fneVocabFilename.Text),
        mtCustom,  // removes the bitmap
        [mrYes,ezYes],'');
end;

procedure TfrmVocabMan.fneVocabFilenameChange(Sender: TObject);
begin
  if (Length(fneVocabFilename.Text)>0 {3}) then
    cmdAddSources.Enabled:=True;
end;

procedure TfrmVocabMan.FormActivate(Sender: TObject);
var
  i:integer;
begin
   sgVocabSources.Clear;
   for i:=0 to 4 do sgVocabSources.Columns.Add;
   sgVocabSources.Columns[0].Width:=trunc(sgVocabSources.Width/2);
   sgVocabSources.Columns[colLangMain].Title.Caption:=ezMainFile;
   sgVocabSources.Columns[1].Width:=trunc(sgVocabSources.Width/2);
   sgVocabSources.Columns[colLangTrans].Title.Caption:=ezTranslationFile;
   cmdAddSources.Enabled:=False;
   cmdSaveVocab.Enabled:=False;
   cmdRemoveSources.Enabled:=False;
   fneVocabFilename.Text:='' ;
   fneVocabFilename.InitialDir:=VocabularyPath;
end;

procedure TfrmVocabMan.FormCreate(Sender: TObject);
begin

end;

end.

