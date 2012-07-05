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

unit frmIniPrev;

{$mode objfpc}{$H+}

interface

uses
  {Classes,} SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Grids,
  StdCtrls, strutils, LCLProc, ExtCtrls, LCLType, Classes, charencstreams
  , frmPNSettings, frmPNSearch, frmPNGoto, pnCommons, frmPNAbout;


type

  { TfrmIniPrevMain }

  TfrmIniPrevMain = class(TForm)
    cmdOkay: TButton;
    cmdCancel: TButton;
    lblAnsiCPMain: TLabel;
    lblAnsiCPTranslation: TLabel;
    lblBOMTranslationWrite: TLabel;
    lblCharsetTranslationWrite: TLabel;
    lblArrow: TLabel;
    lblStatusSecondary: TLabel;
    lblBOMDefault: TLabel;
    lblBOMTranslation: TLabel;
    lblCharsetTranslation: TLabel;
    lblNewLineStringDefault: TLabel;
    lblCharsetDefault: TLabel;
    lblStatus: TLabel;
    lblNewLineStringTranslation: TLabel;
    mnuFileLoadAuxUnload: TMenuItem;
    mnuFileLoadAuxLangRecent: TMenuItem;
    mnuFileLoadAuxLangSeparator: TMenuItem;
    mnuFileOpenTrans: TMenuItem;
    mnuFileOpenTransSeparator: TMenuItem;
    mnuFileOpenTransBrowse: TMenuItem;
    mnuFileOpenMainBrowse: TMenuItem;
    mnuFileMainSeparator: TMenuItem;
    mnuMiscAbout: TMenuItem;
    mnuFileLoadAuxLang: TMenuItem;
    mnuViewShowTranslated: TMenuItem;
    mnuView: TMenuItem;
    mnuEditSeparator01: TMenuItem;
    mnuEditCopyToTrans: TMenuItem;
    mnuMiscAddNewStrings: TMenuItem;
    mnuEditFindPrev: TMenuItem;
    mnuEditFindNext: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuFileSeparator01: TMenuItem;
    mnuMiscSettings: TMenuItem;
    mnuMisc: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    mnuFileSaveTranslation: TMenuItem;
    mnuEditGoToLine: TMenuItem;
    mnuEditFind: TMenuItem;
    odMultipleFiles: TOpenDialog;
    sdSingleFile: TSaveDialog;
    tmrStatus: TTimer;
    txtMDefault: TMemo;
    mnuEditPreviousUntranslated: TMenuItem;
    mnuEditNextUntranslated: TMenuItem;
    mmMain: TMainMenu;
    mnuEdit: TMenuItem;
    mnuFileOpenMain: TMenuItem;
    mnuFile: TMenuItem;
    odSingleFile: TOpenDialog;
    sgStringList: TStringGrid;
    txtMAux: TMemo;
    txtMTranslation: TMemo;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lblAnsiCPTranslationClick(Sender: TObject);
    procedure lblBOMTranslationClick(Sender: TObject);
    procedure lblBOMTranslationWriteClick(Sender: TObject);
    procedure lblCharsetDefaultClick(Sender: TObject);
    procedure lblCharsetTranslationClick(Sender: TObject);
    procedure lblCharsetTranslationWriteClick(Sender: TObject);
    procedure mnuFileLoadAuxLangRecentClick(Sender: TObject);
    procedure mnuFileLoadAuxUnloadClick(Sender: TObject);
    procedure mnuFileOpenMainBrowseClick(Sender: TObject);
    procedure mnuEditCopyToTransClick(Sender: TObject);
    procedure mnuFileOpenTransBrowseClick(Sender: TObject);
    procedure mnuFileOpenTransClick(Sender: TObject);
    procedure mnuFileUnloadAuxLangClick(Sender: TObject);
    procedure mnuMiscAddNewStringsClick(Sender: TObject);
    procedure mnuEditFindNextClick(Sender: TObject);
    procedure mnuEditFindPrevClick(Sender: TObject);
    procedure mnuEditGoToLineClick(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuEditFindClick(Sender: TObject);
    procedure mnuEditNextUntranslatedClick(Sender: TObject);
    procedure mnuEditPreviousUntranslatedClick(Sender: TObject);
    procedure mnuFileOpenMainClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuFileSaveTranslationClick(Sender: TObject);
    procedure mnuFileTransFileClick(Sender: TObject);
    procedure mnuMiscAboutClick(Sender: TObject);
    procedure mnuMiscSettingsClick(Sender: TObject);
    procedure mnuViewShowTranslatedClick(Sender: TObject);
    procedure sgStringListDblClick(Sender: TObject);
    procedure sgStringListKeyPress(Sender: TObject; var Key: char);
    procedure sgStringListPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure tmrStatusTimer(Sender: TObject);
    procedure txtMTranslationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuFileRecentMainClick (Sender: TObject);
    procedure mnuFileRecentTransClick (Sender: TObject);
    procedure mnuFileRecentAuxClick (Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
var
  mnuFileRecentMain:array [0..14] of TMenuItem;
  mnuFileRecentTrans:array [0..14] of TMenuItem;
  mnuFileRecentAux:array [0..14] of TMenuItem;

const
  DummyConst=True ; //Lazarus does not want to compile, if no constant is declared.

var
  SgSlFG: array of TColor;
  SgSlBG: array of TColor;


  frmIniPrevMain: TfrmIniPrevMain;
  //The latter variables will be adjustable through the settings, when implemented
  colRow:integer = 0;
  colSection:Integer= 1;
  colKey:integer=2;
  colMain:integer=3;
  colTranslation:integer=4;
  //End of adjustable vars

  Unsaved:Boolean = False;
  AuxLoaded: Boolean = False;
  SearchString:String;
  SearchCaseSensitive: Boolean = False;
  CharsetMain: TUniStreamTypes;
  CharsetTranslation: TUniStreamTypes;
  //CharsetTranslationWrite: Integer;
  CharsetTranslationWrite: TUniStreamTypes;
  FilenameMain: string;
  FilenameTranslation: string;
  TranslationStrings: array of array of String;
  AuxStrings: array of array of String;
  NewLineTranslation: String ;
  BOMTranslation: Boolean ;
  TranslationNewRows: array of string;
  SearchIgnoreChars: array [0..2] of String;
  SaveInProgress: boolean=False;

  {Column indices start here}
  stlRow: int64;
  stlSection: int64;
  stlKey: int64;
  stlDefault: int64;
  stlTranslation: int64;
  {Column indices end here}

implementation

{$R *.lfm}

{ TfrmIniPrevMain }


//Detects the new line string (CrLf, Cr or Lf)
function NewLineString(Str:string): string;
var
  RetVal: string;
begin
     if PosEx (CrLf, Str) <>0 then
     begin
       RetVal:=crlf;
     end
     else if PosEx (Cr , Str) <>0 then
     begin
       RetVal:=Cr;
       end
       else if PosEx (Lf , Str) <> 0 then
       begin
         RetVal:=Lf;
         end;
  Result:=RetVal ;
end;

procedure DebugLine(AString: string);  //Appends a line to the debug log
var
 FileVar: TextFile;
 DebugFileName: String;
begin
 if debugmode = true then
 begin //if
   DebugFileName:=UTF8ToSys(AppendPathDelim(ProgramDirectory) + debuglog);
  AssignFile(FileVar, DebugFileName);
  {$I+} //use exceptions
  try
    if FileExists (DebugFileName) then
       Append (FileVar)
    else
    Rewrite(FileVar);
    Writeln(FileVar,AString);
    CloseFile(FileVar);
  except
    on E: EInOutError do
    begin
    // Writeln('File handling error occurred. Details: '+E.ClassName+'/'+E.Message);
    end;
  end; //try
 end; //if debugmode
end;

procedure DebugArray1D(AStringArray1D: StringArray1D);
var
 i: integer;
begin
  if debugmode = true then
  begin
  DebugLine (crlf+'Dumping array with size ' + its(Length(AStringArray1D)));
  for i:=0 to Length(AStringArray1D) -1 do
  begin
      DebugLine ('Line:' + IntToStr ( i) + tab + AStringArray1D[i] + TAB +AStringArray1D[i]);
    end;
  end;
end;

procedure DebugArray2D(AStringArray2D: StringArray2D);
var
 i: integer;
begin
  if debugmode = true then
  begin
  DebugLine (crlf+'Dumping array with size ' + its(Length(AStringArray2D)));
  for i:=0 to Length(AStringArray2D) -1 do
  begin
      DebugLine ('Line:' + IntToStr ( i) + tab + AStringArray2D[i,0] + TAB +AStringArray2D[i,1]);
    end;
  end;
end;


//I could not find a case insensitive search function in a reasonable time, so I made this one
function InStr (SearchString: string; SoughtString:string; start:integer = 1;CaseSensitive:Boolean = False ): integer;
var
  RetVal:integer= 0;
begin
     if CaseSensitive= True then
          RetVal:= PosEx (SoughtString, SearchString , start)
     else
         RetVal:= PosEx (UTF8LowerCase  (SoughtString),UTF8LowerCase  (SearchString), start );
     Result:= RetVal ;
end;


//Returns the text between Opener and Closer. Example- unclose ([section], '[',']') returns „section“.
function Unclose (AString:String; Opener: String; Closer: String) : String;
var
    RetVal: String;
begin
    RetVal:= Mid (AString,PosEx (Opener,AString)+1, PosEx(Closer,AString,PosEx (Opener,AString)+Length(opener))-PosEx (Opener,AString)-1);
    Result:=RetVal;
end;

//Calculates the % value of the portion, relative to the whole part
function PerCent (WholePart: Double; Portion:Double): Double;
begin
     Result:= (Portion/WholePart)*100;
end;


//Converts the character sequence for a new string to a human readable string
function NewLineToText(str: string):string;
var
  RetVal: string;
begin
  if str= CrLf then
       RetVal:='CrLf'
     else if str= Cr then
     begin
       RetVal:='Cr'
       end
       else if str=Lf then
       begin
         RetVal:='Lf';
         end;
  Result:=RetVal ;
end;


//Localizes a sting in the format "Localizable %1 strings %2 must %3 use %4 numbers %5 after the percent sign, instead of same letters, so the translator could change the word order"
function LocalizeRowMultiple(aString:string; Key1:string='';Key2:string='';Key3:string='';Key4:string='';Key5:string='';Key6:string=''):string;
var
  RetVal:string;
begin
  RetVal:=aString;
  if Key1<>'' then RetVal:=UTF8StringReplace (RetVal,'%1',Key1,[]);
  if Key2<>'' then RetVal:=UTF8StringReplace (RetVal,'%2',Key2,[]);
  if Key3<>'' then RetVal:=UTF8StringReplace (RetVal,'%3',Key3,[]);
  if Key4<>'' then RetVal:=UTF8StringReplace (RetVal,'%4',Key4,[]);
  if Key5<>'' then RetVal:=UTF8StringReplace (RetVal,'%5',Key5,[]);
  if Key6<>'' then RetVal:=UTF8StringReplace (RetVal,'%6',Key6,[]);
  result:=RetVal ;
end;


function RealToString (aReal:real; Width:Integer=0; Decimals:Integer=3):string;
var
  RetVal:string;
begin
     Str (aReal:Width:Decimals,RetVal);
     Result:=RetVal;
end;


//This could be quite tricky- in some languages different suffixes are used, depending the last digit of the number.
function LocalizeRowCountable (String0Items:string;String1Item:string; StringMultipleItems:string;KeyNumeric:QWord; Decimals:Integer=0 ):string;
var
  RetVal:string;
begin
if StringMultipleItems='' then StringMultipleItems:=String1Item;
if String0Items='' then String0Items:=StringMultipleItems; //In most European languages 0 goes with plural
case KeyNumeric of
  0: RetVal:=UTF8StringReplace (String0Items,'%1',RealToString(KeyNumeric,0,Decimals ),[]);
  1: RetVal:=UTF8StringReplace (String1Item,'%1',RealToString(KeyNumeric,0,Decimals ),[]);
  else RetVal:=UTF8StringReplace (StringMultipleItems,'%1',RealToString(KeyNumeric,0,Decimals),[]) //>1 or floating point
  end; //case
  Result:=RetVal;
end;

procedure LocalizeSettings;
begin
  with frmSettings do
  begin //with
    Caption:= ezSettings;
    lblRowSplitter.Caption:= ezRowSplitter;
    lblSectionOpener.Caption:= ezSectionOpener ;
    lblSectionCloser.Caption:= ezSectionCloser ;
    chkFillInEmpty.Caption:= ezFillInEmptyLines;
    cmdOkay.Caption:= ezOkay ;
    cmdCancel.Caption:=ezCancel ;
  end;//with
end;


procedure Localize;
begin
  {English is default}
  ezComma:=',';
  ezBracketOpen:='(' ;
  ezBracketClose:=')' ;
  ezSemicolon:=';';
  ezSpace:=' ';
  ezOkay:='Okay';
  ezCancel:='Cancel';
  ezError:='Error';
  ezRow:= 'Row';
  ezSection:= 'Section';
  ezKey:= 'Key';
  ezDefault:= 'Default';
  ezTranslation:= 'Translation';
  ezLanguageFiles:= 'Language files';
  ezTextFiles:= 'Text Files';
  ezAllFiles:= 'All files';
  ezTotalStrings:='Total strings: ';
  ezTotalStringsEtc:= 'Total strings: %1(%2);Translated: %3(%4%); Untranslated: %5(%6%)';
  ezTranslatedStrings:='Translated: ';
  ezUntranslatedStrings:='Untranslated: ';
  ezUntranslatableStrings:='Untranslatable: ';
  ezPerCent:='%';
  ezBOM:='BOM';
  ezNoBOM:='No BOM';
  ezCharsetName[0]:='UTF8';
  ezCharsetName[1]:='ANSI';
  ezCharsetName[2]:='UTF16(BE)';
  ezCharsetName[3]:='UTF16(LE)';
  ezCharsetName[4]:='UTF32(BE)';
  ezCharsetName[5]:='UTF32(LE)';
  ezSelectMainfile:='Select main file';
  ezSelectTranslationFile:= 'Select translation file';
  ezSelectAuxFile:= 'Select auxiliary file';
  ezAnErrorOccuredWhenTryingToLoadAuxiliaryFile:='An error occured when trying to load auxiliary file “%1”';
  ezSettings:= 'Settings';
  ezRowSplitter:= 'Row splitter';
  ezFillInEmptyLines:= 'Fill in empty lines';
  ezSectionOpener:= 'Section opener' ;
  ezSectionCloser:= 'Section closer' ;
  ezTo:= 'to';
  ezFileToFile:= '- %1 to %2';
  ezFileNotSaved:='File not saved';
  ezDoYouWantToSaveTheFileBeforeExit:='Do you want to save the file before exit?';
  ezIniPrev:='IniPrev';
  ezFillInTheTextBoxBeforeCheckingThisOption:='Fill in the text box before checking this option';
  ezNewLines:='New lines';
  ezAutoFilledLines:='Autofilled new lines';
  ezSearchComplete:='Search complete';
  ezSettingsHeaderLocalized:=''; //Should be empty for English.
  ezNoStringsFoundMakeSureThatYouHaveSetTheProperRowSplitterInTheSettinsAndThatYouHaveOpenedAProperFile:= 'No strings found. Make sure that you have set the proper' +CrLf+ 'rowsplitter in the settins and that you have opened a proper file';
  ezWarning:='Warning!';
  ezDoYouWantToOpenTheTranslationFileWithANewEncoding:='Do you want to open the translation file with a new encoding?';
  ezTheChangesInYourTranslationAreNotSavedIfYouPressYesTheyWillBeLost:= 'The changes in your translation are not saved.'+CrLf+ 'If you press “Yes” they will be lost.';
  ezAutotranslate:='Autotranslate';
  ezDoYouWantToAutotranslate1to2:='Do you want to autotranslate %1 to %2 (empty line on key %3)?';
  frmIniPrevMain.Caption:=ezIniPrev;
end;

procedure Reposition; //Position the elements in the main form, after being resized by the user
var
   TopDefault: integer;
   TopTranslation: integer;
begin
with frmIniPrevMain do
begin //with
  sgStringList.Left:= 10;
  sgStringList.Top:= 10;
  sgStringList.Height:= frmIniPrevMain.Height - 80;
  sgStringList.Width:= frmIniPrevMain.Width - 20;
  sgStringList.Columns[colRow].Width:= 30;
  sgStringList.Columns[colSection].Width:= 50;
  sgStringList.Columns[colKey].Width:= 30;
  sgStringList.Columns[colMain].Width:=  trunc((frmIniPrevMain.sgStringList.Width - 90) / 2) - 20;
  sgStringList.Columns[colTranslation].Width:=  frmIniPrevMain.sgStringList.Columns[colMain].Width;
  TopDefault:= frmIniPrevMain.Height - lblNewLineStringDefault.Height -40;
  TopTranslation:= TopDefault+20;

  lblNewLineStringDefault.Top:= TopDefault;
  lblNewLineStringTranslation.Top:= TopTranslation;
  lblStatus.top:= TopDefault;
  lblStatusSecondary.top:=TopTranslation;
  lblCharsetDefault.Top:=TopDefault;
  lblAnsiCPMain.Top:=TopDefault;
  lblCharsetTranslation.Top:=TopTranslation;
  lblCharsetTranslationWrite.Top:=TopTranslation;
  lblAnsiCPTranslation.Top:=TopTranslation;
  lblBOMDefault.top:=TopDefault ;
  lblBOMTranslation.top:=TopTranslation ;
  lblBOMTranslationWrite.top:=TopTranslation ;
  lblArrow.Top:=TopTranslation ;
  txtMDefault.Top:= 85;
  txtMDefault.left:= txtMTranslation.Left;
  txtMDefault.Width:= frmIniPrevMain.Width - 100;
  if AuxLoaded =true then
  begin
    txtMDefault.Height:= trunc(frmIniPrevMain.Height/2.3- 125 );
    txtMAux.Height:= txtMDefault.Height;
    txtMAux.Top:=txtMDefault.Top + txtMDefault.Height  + 10;
    txtMTranslation.Top:= txtMAux.Top + txtMAux.Height  + 10;
  end
  else
  begin
     txtMDefault.Height:= trunc(frmIniPrevMain.Height/2- 125 );
     txtMTranslation.Top:= txtMDefault.Top + txtMDefault.Height  + 10;
  end;

  txtMAux.Left:= 50;
  txtMAux.Width:= txtMDefault.Width;
  txtMTranslation.Height:= txtMDefault.Height;
  txtMTranslation.Left:= 50;
  txtMTranslation.Width:= txtMDefault.Width;
  cmdOkay.top:= txtMTranslation.top+ txtMTranslation.Height + 10    ;
  cmdOkay.left:= trunc(frmIniPrevMain.Width/2 - frmIniPrevMain.cmdOkay.Width);
  cmdCancel.top:= cmdOkay.top ;
  cmdCancel.left:= frmIniPrevMain.cmdOkay.left+frmIniPrevMain.cmdOkay.Width +1;
end; //with
end;

procedure DeleteStringGridRows (aStringGrid: TStringGrid);
var
   i:integer;
begin
//.clean causes problems
  for i:= 1 to aStringGrid.RowCount-1 do
  begin //for i
    aStringGrid.DeleteRow (1);
  end; //for i
  {//I could not find what the hex is TGridZoneSet
  sgStringList.Clean (0,1,sgStringList.RowCount-1, sgStringList.ColCount -1, gzNormal  ) ;
  //Error: Incompatible type for arg no. 5: Got "TGridZone", expected "TGridZoneSet"
  }
end;

function ShiftCharset(InputCharset: TUniStreamTypes): TUniStreamTypes;
var
  RetVal: TUniStreamTypes;
begin
  RetVal:= InputCharset;
     if ord(InputCharset) < Length(ezCharsetName)-1 then ord(RetVal):= (ord(InputCharset)) + 1 else ord(RetVal):=0;
  Result:= RetVal ;
end;

procedure UpdateRecent(MenuItem: array of TMenuItem; FileName: string);
var
  i:integer;
  UpCount:integer;
begin
if Length(FileName)>0 then
begin
  UpCount:=14;
  for i:=0 to 14 do //Check if the item is already in the list and finds its location
  begin //for i
     if (MenuItem[i].Visible=True) then
       begin //if visible
         if CompareStr(MenuItem[i].Caption,FileName)=0 then
         begin
           UpCount:= i;
           break;
         end;
        end //if visible
       else
       begin //if not visible
         UpCount:=i;
         break;
       end; //end if not visible
  end; //for i

  if UpCount=0 then
  begin //if
  MenuItem[0].Caption:=FileName;
  MenuItem[0].Visible:=True;
  end //if
  else
  begin //else
    for i:=UpCount downto 1 do
    begin //for
      if MenuItem[i-1].Visible= True then
        begin //if
          MenuItem[i].Visible:=True;
          MenuItem[i].Caption:= MenuItem[i-1].Caption;
       end; //if
    end;  //next i
       MenuItem[0].Caption:=FileName;
  end;//else
end;
end;


{procedure UpdateRecent(MenuItem: array of TMenuItem; NewFile: string);
var
  i:integer;
  UpCount:integer;
begin
if Length(NewFile)>0 then
begin
  UpCount:=14;
  for i:=0 to 14 do //Check if the item is already in the list and finds its location
  begin //for i
     if (mnuFileRecentMain[i].Visible=True) then
       begin //if visible
         if CompareStr(mnuFileRecentMain[i].Caption,NewFile)=0 then
         begin
           UpCount:= i;
           break;
         end;
        end //if visible
       else
       begin //if not visible
         UpCount:=i;
         break;
       end; //end if not visible
  end; //for i

  for i:=UpCount downto 1 do
    begin //for
      if mnuFileRecentMain[i-1].Visible= True then
      begin //if
        mnuFileRecentMain[i].Visible:=True;
        mnuFileRecentMain[i].Caption:= mnuFileRecentMain[i-1].Caption;
      end; //if
    end;  //next i
  mnuFileRecentMain[0].Caption:= NewFile;
  end;//if
end;  }

procedure OpenMainFile (FileName: string=''; ForcedCharset:TUniStreamTypes=ufUndefined; CleanTable:Boolean=True);
const
  TF= true;
var
  FileContents: UniFile;
  MainFileContents: string;
  MainStrings: StringArray1D;
  MainLine: string;
  NewLine: string;
  i: integer;
  RowNumber: integer;
  SplitterLocation:integer;
  SectionName: string= '';
begin
  with frmIniPrevMain do
  begin //with
  if FileName ='' then
    begin
    odSingleFile.Title:=ezSelectMainFile;
    odSingleFile.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|'  + ezAllFiles +'(*.*)|*.*|');
      if odSingleFile.Execute = false then exit;
      FileName:= odSingleFile.FileName;
    end;
    FilenameMain:=FileName;
    FileContents:= ReadUTF8(FileName,ForcedCharset);
    MainFileContents:=FileContents[0];
    ord(CharsetMain):=StrToInt(FileContents[1]);

    if StringToBoolean (FileContents[2]) = True then lblBOMDefault.Caption:= ezBOM else lblBOMDefault.Caption:= ezNoBOM;

    //TODO- The ANSI codepage shall be selectable via a popup menu.
    if CharsetMain=ufANSI then
      begin
        lblAnsiCPMain.Visible:=True;
        lblAnsiCPMain.Caption:=FileContents[3]; //ANSI codepage- CP1251, CP1253, etc.
      end
      else
        lblAnsiCPMain.Visible:=False;

    lblCharsetDefault.Caption:= ezCharsetName[ord(CharsetMain)];
    NewLine:= NewLineString(MainFileContents);
    lblNewLineStringDefault.Caption:= NewLineToText(NewLine ) ;
    MainStrings:= Split (MainFileContents, NewLine );

    lblCharsetDefault.Visible:=TF;
    lblCharsetDefault.Enabled:=TF;

    if CleanTable = True then DeleteStringGridRows(sgStringList);
    RowNumber:=1;
    for i:= 0 to (Length (MainStrings )-1) do
      begin //for i
      MainLine:= MainStrings[i];
      if CompareText(LeftStr (MainLine,Length(SectionCloser)), SectionOpener)= 0 then
       begin
         SectionName:= Unclose(MainLine, SectionOpener, SectionCloser);
       end;
      SplitterLocation:= PosEx(RowSplitter,MainLine) ;
      if (SplitterLocation) <> 0 then
      begin //if
        {if CleanTable = true then } sgStringList.InsertColRow (false, RowNumber);
        sgStringList.Cells [colSection, RowNumber]:= SectionName;
        sgStringList.Cells [colRow ,RowNumber]:= IntToStr (RowNumber);
        sgStringList.Cells [colKey,RowNumber]:= LeftStr  (MainLine,SplitterLocation-1);
        sgStringList.Cells [colMain,RowNumber ]:= Mid (MainLine,SplitterLocation+1, Length(MainLine)-SplitterLocation );
        RowNumber:=RowNumber+1;
       end; //if
    end; //for i
    {if {sgStringList.RowCount}RowNumber<= 1 then
     begin
          ShowMessage (ezNoStringsFoundMakeSureThatYouHaveSetTheProperRowSplitterInTheSettinsAndThatYouHaveOpenedAProperFile);
          exit;
     end;}
  SetLength(SgSlBG,sgStringList.RowCount);
  for i:=0 to sgStringList.RowCount-1 do SgSlBG[i]:= clWhite;

  lblStatus.Caption:= ezTotalStrings + IntToStr ( sgStringList.RowCount -1);
  mnuFileLoadAuxLang.Enabled:=TF;
  mnuFileOpenTrans.Enabled:=TF;
  lblNewLineStringDefault.Visible:=TF;
  lblBOMDefault.Visible:=TF;
  lblStatus.Visible:=TF;
  mnuEditFind.Enabled:=TF ;
  UpdateRecent (mnuFileRecentMain, FileName);
  end; //with
end;

procedure TfrmIniPrevMain.mnuFileOpenMainClick(Sender: TObject);
begin
     if TMenuItem(Sender).tag <> 0 then  ShowMessage (its(TMenuItem (Sender).Tag)) ;
end;

procedure TfrmIniPrevMain.mnuFileRecentMainClick  (Sender: TObject);
begin
   OpenMainFile(mnuFileRecentMain[TMenuItem (Sender).Tag].Caption);
end;


procedure TfrmIniPrevMain.mnuFileOpenMainBrowseClick(Sender: TObject);
begin
   OpenMainFile('',ufUndefined,True);
end;

procedure TfrmIniPrevMain.lblCharsetDefaultClick(Sender: TObject);
var
  i:integer;
begin
  CharsetMain:= ShiftCharset(CharsetMain);
  lblCharsetDefault.Caption:= ezCharsetName[ord(CharsetMain)];
  lblCharsetDefault.Enabled:=False;
  for i:= 1 to frmIniPrevMain.sgStringList.RowCount -1 do
  begin //for i
    frmIniPrevMain.sgStringList.Cells [colMain,i]:='';
    frmIniPrevMain.sgStringList.Cells [colKey,i]:='';
    frmIniPrevMain.sgStringList.Cells [colSection,i]:='';
  end; //next i
  if CharsetMain=ufANSI
     then lblAnsiCPMain.Visible:=True
     else lblAnsiCPMain.Visible:= False;
  try
   OpenMainFile(FilenameMain,CharsetMain, false );
   except
   end;
end;


//AuxStrings is two dimentional, so in the future it might support more than one aux file
procedure OpenAuxFile (FileName: string=''; ForcedCharset:TUniStreamTypes= ufUndefined);
const
  TF= true;
var
  AuxFileContents: UniFile;
  FileContents: string;
  ContentStrings: StringArray1D;
  MainLine: string;
  NewLine: string;
  i,j: integer;
  Key: String;
  SplitterLocation:integer;
  SectionName: string= '';
begin
  with frmIniPrevMain do
  begin //with
  try
    if FileName='' then
    begin
    odSingleFile.Title:=ezSelectAuxFile;
    odSingleFile.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|'  + ezAllFiles +'(*.*)|*.*|');
      if odSingleFile.Execute = false then exit;
      FileName:= odSingleFile.FileName;
    end;
    AuxFileContents:= ReadUTF8(FileName) ;// FileGet(FileName, 0,0);
    FileContents:=AuxFileContents[0];
    NewLine:= NewLineString(FileContents);
    ContentStrings:=Split (FileContents, NewLine );
    SetLength(AuxStrings,sgStringList.RowCount+1,1);
  for i:=0 to Length(ContentStrings)-1 do
  begin //for i
    if CompareText(LeftStr (MainLine,Length(SectionCloser)), SectionOpener)= 0 then
    begin
       SectionName:= Unclose(MainLine, SectionOpener, SectionCloser);
    end;
    if PosEx (RowSplitter,ContentStrings[i])<> 0 then
      begin //if
        Key:=LeftStr (ContentStrings[i],PosEx (RowSplitter,contentStrings[i])-1) ;
           for j:=0 to sgStringList.RowCount -1 do
           begin //for j
              if  (CompareText (Key,sgStringList.Cells[colKey,j])=0)
              and ((CompareText (SectionName,sgStringList.Cells[colSection,j])=0) or (Length(SectionName)= 0) or (IgnoreSections=True))
              then
              begin //if
                SplitterLocation:= PosEx(RowSplitter,ContentStrings[i]);
                AuxStrings [j,0]:=  Mid (ContentStrings[i],SplitterLocation+1, Length(ContentStrings[i])-SplitterLocation ) ; //The KEY value is not usable, since there might be equal keys in different sections
                DebugLine (its(i)+'='+ AuxStrings [j,0]);
                Break;
              end  //if
           end //for j    }
      end //if
  end; //for i
  AuxStrings[sgStringList.RowCount,0]:=RemovePath(FileName);
  AuxLoaded:=True;
  mnuFileLoadAuxUnload.Enabled:=True;
  UpdateRecent(mnuFileRecentAux,FileName);
  except
    QuestionDlg(ezError,LocalizeRowMultiple(ezAnErrorOccuredWhenTryingToLoadAuxiliaryFile,FileName),
      mtCustom, [mrOK,ezOkay],'');
  end; //try
end; //with
end;

procedure TfrmIniPrevMain.mnuFileRecentAuxClick  (Sender: TObject);
begin
   OpenAuxFile (mnuFileRecentAux[TMenuItem(Sender).Tag].Caption);
end;

procedure InsertX (var AArray: StringArray2D; const Index: Cardinal; const Value: StringArray1D);
var
  ALength: integer;
  TailElements: integer;
begin
  ALength:=Length(AArray);
  Assert (Index<= ALength);
  SetLength(AArray,ALength +1);
  Finalize (AArray[ALength]);
  TailElements:= ALength -Index ;
  If TailElements >= 0 then
  begin //if
    Move (AArray[index], AArray[index+1], SizeOf (StringArray1D)*TailElements);
    Initialize (AArray[Index ]);
    AArray[Index]:= Value;
    end
    else //If the elemet is appended to the end of the array
     if (TailElements = -1) then
        begin
          AArray [Index-1]:= Value ;
        end;
end;

//Returns the index of the TranslationStrings, corresponding to the given row (RowNumber)
function GetRowIndex (RowNumber:integer): Integer;
var
  i:integer;
  RetVal: Integer =0;
begin
  for i:= 0 to Length(TranslationStrings)-1 do
  begin//for i
    if  CompareText (TranslationStrings[i,1], IntToStr (RowNumber))=0  then
    begin //if
      Retval:= i;
      break;
    end;//if
  end; //for i
 if RetVal= 0 then RetVal:= Length(TranslationStrings) ;
 Result:= RetVal;
 DebugLine ('GetRowIndex:'+ 'i=' + IntToStr (i) + tab + 'RowNumber=' + IntToStr (RowNumber) );
end;

procedure SaveTranslation (FileName: String ='');
var
  i:integer;
  FullStrings: UTF8String='';
begin
if SaveInProgress = false then
begin //if
with frmIniPrevMain do
begin //with
  SaveInProgress:=True;
  for i:= 0 to Length(TranslationStrings) -1 do
  begin //for
      if CompareText(RightStr(TranslationStrings [i,0],1), RowSplitter) = 0 then //Checks if the row is empty
      begin //if
        if frmSettings.chkFillInEmpty.Checked  = True
        then FullStrings:= FullStrings+ sgStringList.cells[colKey,StrToInt (TranslationStrings[i,1])]+ RowSplitter+  sgStringList.cells[colMain,strtoint(TranslationStrings[i,1])] +NewLineTranslation;
      end
    else
       FullStrings:= FullStrings + TranslationStrings [i,0] + NewLineTranslation
  end; //for
  if FileName= '' then
  begin
    sdSingleFile.Title:= ezSaveTranslatedFileAs;
    sdSingleFile.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|'  + ezAllFiles +'(*.*)|*.*|');
    if sdSingleFile.Execute = true then FilenameTranslation:= sdSingleFile.FileName ;
  end;
  WriteUTF8(FilenameTranslation,FullStrings,CharsetTranslationWrite,BOMTranslation);
  frmIniPrevMain.Caption:= LeftStr (frmIniPrevMain.Caption, Length(frmIniPrevMain.Caption) -1) ;
  mnuFileSaveTranslation.Enabled:= false;
  Unsaved:= false;
  SaveInProgress:=False;
end; //with
end; //if
end;

procedure TfrmIniPrevMain.mnuFileSaveTranslationClick(Sender: TObject);
begin
  SaveTranslation(FilenameTranslation);
end;


procedure TfrmIniPrevMain.mnuFileSaveAsClick(Sender: TObject);
begin
  SaveTranslation();
end;

procedure SetCellBackground({StringGrid: TStringGrid ; Column: Integer;} Row: integer; BackgroundColour: TColor  );
begin
    SgSlBG[Row]:= BackgroundColour;
end;

//Checks if a line is translatable, i.e. not starting with a string linsted in frmSettings.cboIgnoreBeginnings
function LineTranslatable(LineNumber:integer): Boolean ;
var
  RetVal: Boolean= True;
  i: integer;
begin
     for i:= 0 to Length(IgnoreLines)-1  do
     begin //for i
           if CompareText(LeftStr (frmIniPrevMain.sgStringList.Cells [colMain,LineNumber],Length(IgnoreLines [i])),IgnoreLines [i]) = 0
           then RetVal:=False  ;
     end; //for i
     Result:=RetVal;
end;

procedure PrintStatus(); //Prints the status (Total, translated, untranslated...)
var
  TranslatedCount: integer=0;
  UntranslatedCount: integer=0;
  UntranslatableCount:integer=0;
  i: integer;
begin
with frmIniPrevMain do
begin //with
     for i:= 1 to sgStringList.RowCount -1 do
     begin //for i
       if LineTranslatable(i)= false then inc(UntranslatableCount) else
         if (CompareText (sgStringList.Cells[colMain,i], sgStringList.Cells[colTranslation,i])= 0 )
         or (Length(sgStringList.Cells[colTranslation,i])=0)
         then inc(UntranslatedCount);
     end; //next i
     TranslatedCount:= sgStringList.RowCount -1 - UntranslatableCount - UntranslatedCount;
     lblStatus.Caption:= LocalizeRowMultiple (ezTotalStringsEtc,its(sgStringList.RowCount -1 - UntranslatableCount),its(sgStringList.RowCount -1),its(TranslatedCount),its (trunc(PerCent(sgStringList.RowCount-1-UntranslatableCount,TranslatedCount))),its((sgStringList.RowCount-1-UntranslatableCount) - TranslatedCount),its (100- trunc(PerCent(sgStringList.RowCount-1-UntranslatableCount,TranslatedCount))));
end; //with
end;


function RemoveIgnoreChars(aStr: string; IgnoreChars:array of String): String;
var
  i: Integer;
  RetVal: string;
begin
     RetVal:=aStr;
     for i:=0 to Length (IgnoreChars) do
     begin //for
      RetVal:=UTF8StringReplace (RetVal,IgnoreChars[i],'',[]);
     end; //for
     Result:= RetVal;
end;

//Searches if the same string is already translated on another entry.
function SearchTranslatedString(SoughtString: string): string;
var
  AutotranslateIgnoreChars:array [0..4] of String;
  i: integer;
  RetVal:string='';
begin
//Splitting a string would be a better solution- ignore chars shall be customizable.
AutotranslateIgnoreChars[0]:='&';
AutotranslateIgnoreChars[1]:='_';
AutotranslateIgnoreChars[2]:='.';
AutotranslateIgnoreChars[3]:='?';
AutotranslateIgnoreChars[4]:='!';
  with frmIniPrevMain do
  begin //with
    for i:= 1 to sgStringList.RowCount -1 do
    begin//for
     if (CompareText(sgStringList.Cells[colMain,i],SoughtString)=0)
          and (Length (sgStringList.Cells[colTranslation,i])>0)then
       begin //if
         RetVal:=sgStringList.Cells[colTranslation,i];
         Break;
       end; //if
    end; //for
  end; //with
  Result:= RetVal;
end;

procedure ShowHideItems(ListMode: DisplayMode=DisplayAll);
var
  i:integer;
begin
  with frmIniPrevMain do
  begin //with
    for i:= 1 to sgStringList.RowCount -1 do
    begin //for i
       if (ListMode=DisplayAll) then sgStringList.RowHeights [i]:=sgStringList.DefaultRowHeight ;
       if (ListMode=DisplayUntranslatedOnly) then
         begin
           if ((CompareText (sgStringList.Cells [colMain,i], sgStringList.Cells [colTranslation,i]) <> 0)
             and (Length(sgStringList.Cells [colTranslation,i]) >0))
             or (LineTranslatable(i) = False)
             then sgStringList.RowHeights [i]:=0
             else sgStringList.RowHeights [i]:=sgStringList.DefaultRowHeight;
         end; //if
    end; //for i
end; //with
end;

procedure OpenTranslationFile (FileName: string=''; ForcedCharset:TUniStreamTypes= ufUndefined);
const
  TF= true;
var
  FileContents:UniFile;
  TranslationFileContents: string;
  i,j: integer;
  CurrentNewLine:integer=0;
  NextNewLine:integer=0;
  TranslatedCount: Integer=0;
  NewLine:string='';
  Key:String='';
  InsertLine: StringArray1D;
  NewLineContents: String = '';
  NewLinesFound:integer=0;
  AutoFilledLines:integer=0;
begin
with frmIniPrevMain do
begin //with
  if FileName='' then
  begin //if
    odSingleFile.Title:=ezSelectTranslationFile;
    odSingleFile.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|'  + ezAllFiles +'(*.*)|*.*|');
    if odSingleFile.Execute = False then exit;
    FilenameTranslation:= odSingleFile.FileName;
    FileName:= FilenameTranslation;
  end;//if
  FileContents:= ReadUTF8 (FileName,ForcedCharset);
  TranslationFileContents:=FileContents[0];
  ord(CharsetTranslation):=ord(StrToInt(FileContents[1]));

  //TODO- The ANSI codepage shall be selectable via a popup menu.
  if CharsetTranslation=ufANSI then
  begin
    lblAnsiCPTranslation.Visible:=True;
    lblAnsiCPTranslation.Caption:=FileContents[3];
  end
  else
    lblAnsiCPTranslation.Visible:=False;

  lblCharsetTranslation.Caption:= ezCharsetName[ord(CharsetTranslation)];
  CharsetTranslationWrite:=CharsetTranslation;
  lblCharsetTranslationWrite.Caption:= ezCharsetName[ord(CharsetTranslationWrite)];
  NewLine:= NewLineString(TranslationFileContents);
  NewLineTranslation:=  NewLine;
  BOMTranslation:= StringToBoolean (FileContents[2]);
  if BOMTranslation=True then lblBOMTranslation.Caption:= ezBOM else lblBOMTranslation.Caption:= ezNoBOM;
  lblBOMTranslationWrite.Caption:= lblBOMTranslation.Caption;
  lblNewLineStringTranslation.Visible:=True;
  lblNewLineStringTranslation.Caption:= NewLineToText(NewLine) ;
  SetLength(TranslationStrings,Occurs(TranslationFileContents,NewLine),2);
  CurrentNewLine:=1;
  for i:=1 to sgStringList.RowCount - 1 do sgStringList.Cells[colTranslation,i]:=''; //Cleans translations column
  DebugLine ('Translation File Contents' +crlf+ TranslationFileContents);
  for i:=0 to Occurs(TranslationFileContents,NewLine)-1 do
  begin //for i
    NextNewLine:= PosEx (NewLine, TranslationFileContents,CurrentNewLine)+length(NewLine);
    TranslationStrings[i,0]:= MidStr (TranslationFileContents,CurrentNewLine,NextNewLine- CurrentNewLine-length(NewLine));
    CurrentNewLine:= NextNewLine;
      if PosEx (RowSplitter,TranslationStrings[i,0])<> 0 then
      begin //if
        Key:=LeftStr (TranslationStrings[i,0],PosEx (RowSplitter,TranslationStrings[i,0])-1) ;
           for j:=0 to sgStringList.RowCount -1 do
           begin //for j
              if  CompareText (key,sgStringList.Cells[colKey,j])=0 then
              begin //if
                sgStringList.Cells[colTranslation,j]:= Mid (TranslationStrings[i,0],Length(key+RowSplitter)+1,100);
                TranslationStrings [i,1]:= sgStringList.Cells[colRow,j]; //The KEY value is not usable, since there might be equal keys in different sections
                break;
              end  //if
           end //for j    }
      end //if
  end; //for i
    TranslatedCount:=0;
    //Here is the concept- there are two ways to add strings, that are missing in the translation file
    //1. Append them to the end of the file
    //2. Insert them in the same positions, as in the original file.
    //Option 1 is easier, but it is noo good, so option 2 is done.
  //for i:= sgStringList.RowCount-1 downto 1 do //row 0 are the captions
  for i:= 1 to sgStringList.RowCount-1 do //row 0 contains the captions
  begin //for i
      {case sgStringList.Cells [colTranslation,i] of
         '': SetCellBackground (sgStringList,colTranslation,i,clYellow);
         sgStringList.Cells [colMain,i]: SetCellBackground (sgStringList,colTranslation,i,clCream)
         else inc (TranslatedCount);
    end;}
        //I tried to use CASE with no succes, it occured that the version of Lazarus that I had some bugs.
        if sgStringList.Cells [colTranslation,i]= '' then
          begin //if Line is missing in the translation file
            SetCellBackground(i,clYellow);
            SetLength(InsertLine,2);
            NewLineContents:= SearchTranslatedString (sgStringList.Cells [colMain,i]);
            if (Length(NewLineContents)>0) and (ConfirmAutotranslate= 2) then
                  if(QuestionDlg(ezAutotranslate,  LocalizeRowMultiple(ezDoYouWantToAutotranslate1to2,sgStringList.Cells [colMain,i],NewLineContents,sgStringList.Cells[colKey,i]),
                  mtCustom, [mrYes,ezYes,mrNo,ezNo],'')) = mrNo then NewLineContents:='';
            InsertLine [0]:=sgStringList.Cells [colKey,i]+ RowSplitter+  NewLineContents ;
            sgStringList.Cells [colTranslation,i]:=  NewLineContents;
            InsertLine [1]:=IntToStr (i);
            InsertX (TranslationStrings,GetRowIndex (i-1)+1, InsertLine) ;
            inc(NewLinesFound);
            if length(NewLineContents)>0 then inc(AutoFilledLines);
          end;//if
        if ((CompareText (sgStringList.Cells [colTranslation,i], sgStringList.Cells [colMain,i]) =0) and (LineTranslatable(i)= True)) then SetCellBackground (i,clGreen);
        if (CompareText (sgStringList.Cells [colTranslation,i], sgStringList.Cells [colMain,i]) <>0)
        and (CompareText (sgStringList.Cells [colTranslation,i], '')<>0) then inc (TranslatedCount);
  end; //for i
  DebugArray2D (TranslationStrings);
  PrintStatus();
//  mnuFileOpenTrans.Enabled:=TF ;
  lblNewLineStringTranslation.Visible:=TF;
  lblBOMTranslation.Visible:=TF;
  lblBOMTranslationWrite.Visible:=TF;
  lblCharsetTranslation.Visible:=TF;
  lblCharsetTranslationWrite.Visible:=TF;
  lblArrow.Visible:=TF;
  mnuEditNextUntranslated.Enabled:=tf ;
  mnuEditPreviousUntranslated.Enabled:=tf ;
  mnuEditGoToLine.Enabled:=TF  ;
  mnuFileSaveAs.Enabled:=TF;
  sgStringList.Enabled:=TF;
  //TODO- does not update when loading a recent file.
  frmIniPrevMain.Caption:= ezIniPrev + LocalizeRowMultiple (ezFileToFile,RemovePath(FilenameMain),RemovePath(FileName));
  lblStatusSecondary.Caption:= ezNewLines + ezSpace+ its(NewLinesFound) + '; ' + ezAutoFilledLines + ezSpace + its(AutoFilledLines);
  tmrStatus.Enabled:=True ;
  UpdateRecent(mnuFileRecentTrans,FileName);
  end; //with
end;

procedure TfrmIniPrevMain.mnuFileTransFileClick(Sender: TObject);
begin
   OpenTranslationFile();
end;

procedure TfrmIniPrevMain.mnuFileRecentTransClick  (Sender: TObject);
begin
   FilenameTranslation:=mnuFileRecentTrans [TMenuItem (Sender).Tag].Caption;
   OpenTranslationFile (FilenameTranslation);
end;

procedure TfrmIniPrevMain.lblCharsetTranslationClick(Sender: TObject);
  var
    i:integer;
begin
  lblCharsetDefault.Enabled:=False;
  if Unsaved=True then
     if QuestionDlg   (ezWarning, ezDoYouWantToOpenTheTranslationFileWithANewEncoding + crlf +ezTheChangesInYourTranslationAreNotSavedIfYouPressYesTheyWillBeLost,
        mtCustom, [mrYes,ezYes,mrNo,ezNo],'') = mrNo then exit;
  if CharsetTranslation=ufANSI
     then lblAnsiCPTranslation.Visible:=True
     else lblAnsiCPTranslation.Visible:=False;
  for i:= 1 to frmIniPrevMain.sgStringList.RowCount -1 do frmIniPrevMain.sgStringList.Cells [colTranslation,i]:='';
  CharsetTranslation:= ShiftCharset(CharsetTranslation);
  lblCharsetTranslation.Caption:= ezCharsetName[ord(CharsetTranslation)];
  OpenTranslationFile(FilenameTranslation,CharsetTranslation);
  lblCharsetDefault.Enabled:=True;
end;

procedure TfrmIniPrevMain.mnuMiscAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TfrmIniPrevMain.mnuMiscSettingsClick(Sender: TObject);
var
  Result: Integer;
begin
  LocalizeSettings ;
  Result:=   frmSettings.ShowModal;
  if Result = mrOK then
  GetSettings;
  SaveSettings;
end;


procedure TfrmIniPrevMain.mnuViewShowTranslatedClick(Sender: TObject);
begin
frmIniPrevMain.mnuViewShowTranslated.Checked:= not (frmIniPrevMain.mnuViewShowTranslated.Checked);
  if frmIniPrevMain.mnuViewShowTranslated.Checked= False
     then ShowHideItems (DisplayUntranslatedOnly)
     else ShowHideItems(DisplayAll);
end;

procedure SetEditWidgets (ModeOn:Boolean);
begin
  with frmIniPrevMain do
  begin //with
   mnuFile.Enabled:= not ModeOn ;
   mnuEditCopyToTrans.Enabled:=ModeOn;
   mnuEditNextUntranslated.Enabled:= not ModeOn;
   mnuEditPreviousUntranslated.Enabled:=not ModeOn;
   mnuEditFind.Enabled:=not ModeOn;
   mnuEditFindNext.Enabled:=not ModeOn;
   mnuEditFindPrev.Enabled:=not ModeOn;
   mnuEditGoToLine.Enabled:=not ModeOn;
   mnuView.Enabled:=not ModeOn;
   mnuMiscAddNewStrings.Enabled:=not ModeOn;
   sgStringList.Enabled:= not ModeOn;
   txtMDefault.visible:=ModeOn;
   txtMTranslation.Visible:=ModeOn;
   txtMAux.Visible:=ModeOn ;
   cmdOkay.visible:=ModeOn;
   cmdCancel.visible:=ModeOn;

   if ModeOn = true then
     sgStringList.Font.Color:= cl3DDkShadow
   else
     sgStringList.Font.Color:= clDefault;
   end; //with
end;

procedure EditItem;
begin
  with frmIniPrevMain do
  begin
    SetEditWidgets(True );
    txtMDefault.Text:= sgStringList.Cells [colMain,sgStringList.Selection.Top];
    txtMTranslation.Text:= sgStringList.Cells [colTranslation,sgStringList.Selection.Top];
    txtMAux.Visible:=AuxLoaded;
    if AuxLoaded=True then txtMAux.Text:= AuxStrings[Length(AuxStrings)-1,0]+ CrLf +  AuxStrings [sgStringList.Selection.Top,0];
    Reposition;
    txtMTranslation.SetFocus ;
  end;
end;

procedure TfrmIniPrevMain.sgStringListDblClick(Sender: TObject);
begin
  EditItem;
end;

procedure TfrmIniPrevMain.sgStringListKeyPress(Sender: TObject; var Key: char);
begin
if (Ord(key)) = 13 {Enter} then EditItem;
end;

procedure TfrmIniPrevMain.sgStringListPrepareCanvas(sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
   If ((aCol = colTranslation) and (aRow>0)) then
   sgStringList.Canvas.Brush.Color:= SgSlBG[aRow];
   if ((aRow >0) and (aRow= sgStringList.Selection.Top)) then
   sgStringList.Canvas.Brush.Color:= clTeal  ;
   sgStringList.Canvas.Font.Color:= clBlack;
end;

procedure TfrmIniPrevMain.tmrStatusTimer(Sender: TObject);
begin
  lblStatusSecondary.Caption:='' ;
  tmrStatus.Enabled:=False;
end;


function UTF8StringReplace(const S, OldPattern, NewPattern: string{;  Flags: TReplaceFlags}): string;
var
  StringFull: UTF16String;
  StartPosition: integer;
  i: integer=1;
begin
       StringFull:= UTF8ToUTF16 (s) ;
       repeat
       StartPosition:=PosEx (UTF8LowerCase(OldPattern),UTF8LowerCase(UTF16ToUTF8(StringFull)),i);  //There is no utf16 to lowercase
       if StartPosition= 0 then
         if i=1 then StringFull:= s else break
       else
       begin
         StringFull:= UTF16ToUTF8(LeftStr(StringFull,StartPosition-1)+ UTF8ToUTF16(NewPattern)+ RightStr(StringFull, UTF8Length (StringFull)-StartPosition-UTF8Length(OldPattern)+1));
         i:=StartPosition+1;
       end; //else
     until StartPosition=0;
     Result:=StringFull;
end;

procedure TfrmIniPrevMain.FormCreate(Sender: TObject);
const
  TF= false;  //Since the same items are enabled/disabled in different subs, TF is easier for copy/paste
begin
   SetOS;
   SetLength(SgSlBG,1 );
   frmIniPrevMain.mnuViewShowTranslated.Checked:=True;
   //If you get an error on goDontScrollPartCell, then your version of Lazarus is too old. You need at 0.9.31 or later.
   sgStringList.Options:=  [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect,goDblClickAutoSize,goDontScrollPartCell] ;
   if DebugMode= true then
   begin
     try  DeleteFile (UTF8ToSys(AppendPathDelim(ProgramDirectory) + debuglog));
       except
     end; //try
   end; //if
  Localize();
  mnuFileOpenTrans.Enabled:=TF;
  txtMDefault.Visible:=TF;
  txtMAux.Visible:= AuxLoaded;
  txtMTranslation.Visible:=TF;
  cmdOkay.visible:=TF;
  cmdCancel.visible:=TF;
  lblNewLineStringDefault.Visible:=TF;
  lblNewLineStringTranslation.Visible:=TF;
  lblBOMDefault.Visible:=TF;
  lblBOMTranslation.Visible:=TF;
  lblBOMTranslationWrite.Visible:=TF;
  lblCharsetDefault.Visible:=TF;
  lblCharsetTranslation.Visible:=TF;
  lblCharsetTranslationWrite.Visible:=TF;
  lblAnsiCPMain.Visible:=TF;
  lblAnsiCPTranslation.Visible:=TF;
  lblArrow.Visible:=TF;
  lblStatus.Visible:=TF;
  sgStringList.Enabled:=TF;
  mnuFileOpenTrans.Enabled:=TF;
  mnuFileLoadAuxLang.Enabled:=TF;
  mnuFileSaveTranslation.Enabled:=TF;
  mnuFileSaveAs.Enabled:=TF;
  mnuFileLoadAuxUnload.Enabled:=TF;
  mnuEditNextUntranslated.Enabled:=tf;
  mnuEditPreviousUntranslated.Enabled:=tf;
  mnuEditFind.Enabled:=tf;
  mnuEditFindNext.Enabled:=TF;
  mnuEditFindPrev.Enabled:=TF;
  mnuEditGoToLine.Enabled:=TF;
  mnuEditCopyToTrans.Enabled:=TF;

  sgStringList.Columns.add;
  sgStringList.Columns.add;
  sgStringList.Columns.add;
  sgStringList.Columns.add;
  sgStringList.Columns.add;
 // Reposition;
  sgStringList.Columns[0].Title.Caption:= ezRow;
  sgStringList.Columns[1].Title.Caption:= ezSection;
  sgStringList.Columns[2].Title.Caption:= ezKey;
  sgStringList.Columns[3].Title.Caption:= ezDefault;
  sgStringList.Columns[4].Title.Caption:= ezTranslation;
  lblStatus.Caption :='' ;
  lblStatusSecondary.Caption :='' ;

 end;

procedure OkayClicked();
  var
  i:integer;
 begin
 with frmIniPrevMain do
 begin //with
  SetEditWidgets(False);
  sgStringList.Cells [colMain,sgStringList.Selection.Top]:= txtMDefault.Text;
  sgStringList.Cells [colTranslation,sgStringList.Selection.Top]:=  txtMTranslation.Text;
  SetCellBackground(sgStringList.Selection.Top,clWhite);
  for i:= 0 to Length(TranslationStrings) do
  begin //for i
    if TranslationStrings[i,1]= sgStringList.Cells[colRow,sgStringList.Selection.Top] then
      begin //if
        TranslationStrings[i,0]:= sgStringList.Cells[colKey,StrToInt(TranslationStrings[i,1])]  + RowSplitter + sgStringList.Cells[colTranslation,sgStringList.Selection.Top];
        break;
      end; //if
  end; //for i
  if Unsaved = False then frmIniPrevMain.Caption:= frmIniPrevMain.Caption + '*';
  Unsaved:=True;
  mnuFileSaveTranslation.Enabled:= true ;
  PrintStatus();
 end;  //with
end;

procedure TfrmIniPrevMain.txtMTranslationKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (key=LCLtype.VK_RETURN) and (ssCtrl in Shift) then OkayClicked();
   if (key=LCLType.VK_ESCAPE) then  SetEditWidgets(False);
end;


procedure TfrmIniPrevMain.cmdOkayClick(Sender: TObject);
 begin
 OkayClicked();
end;

procedure TfrmIniPrevMain.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveSettings;
end;

function SaveBefore ():Integer;
var
   RetVal:integer;
begin
     RetVal:= QuestionDlg(ezFileNotSaved, ezFileNotSaved + CrLf + ezDoYouWantToSaveTheFileBeforeExit,
        mtCustom,  // removes the bitmap
        [mrYes,ezYes,mrNo,ezNo,mrCancel,ezCancel],'');
     if RetVal= mrYes then SaveTranslation(FilenameTranslation);
     Result:=RetVal;
end;

procedure TfrmIniPrevMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    if Unsaved= true then
    begin  //if
      if SaveBefore()= mrCancel then CanClose:=false;
    end; //if
end;

procedure TfrmIniPrevMain.cmdCancelClick(Sender: TObject);
begin
  SetEditWidgets(False);
end;

procedure TfrmIniPrevMain.FormResize(Sender: TObject);
begin
  Reposition;
end;

procedure TfrmIniPrevMain.lblAnsiCPTranslationClick(Sender: TObject);
begin

end;

procedure TfrmIniPrevMain.lblBOMTranslationClick(Sender: TObject);
begin

end;

procedure TfrmIniPrevMain.lblBOMTranslationWriteClick(Sender: TObject);
begin
   BOMTranslation:=not BOMTranslation;
   if BOMTranslation= true then lblBOMTranslationWrite.Caption:= ezBOM else lblBOMTranslationWrite.Caption:= ezNoBOM;
end;

procedure TfrmIniPrevMain.lblCharsetTranslationWriteClick(Sender: TObject);
begin
    CharsetTranslationWrite:= ShiftCharset(CharsetTranslationWrite);
    lblCharsetTranslationWrite.Caption:= ezCharsetName[ord(CharsetTranslationWrite)];
    if  CharsetTranslationWrite=ufANSI then
    begin
      lblBOMTranslationWrite.Caption:=ezNoBOM;
      lblBOMTranslationWrite.Enabled:=false
    end
    else
    begin
      if BOMTranslation=True then lblBOMTranslationWrite.Caption:= ezBOM else lblBOMTranslationWrite.Caption:= ezNoBOM;
      lblBOMTranslationWrite.Enabled:=True;
    end;
end;

procedure TfrmIniPrevMain.mnuFileLoadAuxLangRecentClick(Sender: TObject);
begin
   OpenAuxFile();
end;

procedure TfrmIniPrevMain.mnuFileLoadAuxUnloadClick(Sender: TObject);
begin
   SetLength(AuxStrings,0,0);
   AuxLoaded:=False;
   mnuFileLoadAuxUnload.Enabled:=False;
end;

//Copies the contents of the main line into the translation line (works only in edit mode)
procedure MainIntoTranslation;
begin
     with frmIniPrevMain do
       txtMTranslation.Text:= txtMDefault.Text;
end;

procedure TfrmIniPrevMain.mnuEditCopyToTransClick(Sender: TObject);
begin
     MainIntoTranslation;
end;

procedure TfrmIniPrevMain.mnuFileOpenTransBrowseClick(Sender: TObject);
begin
  OpenTranslationFile;
end;

procedure TfrmIniPrevMain.mnuFileOpenTransClick(Sender: TObject);
begin

end;

procedure TfrmIniPrevMain.mnuFileUnloadAuxLangClick(Sender: TObject);
begin
 SetLength(AuxStrings,0,0);
 AuxLoaded:=False;
 mnuFileLoadAuxUnload.Enabled:=False;
end;

procedure TfrmIniPrevMain.mnuMiscAddNewStringsClick(Sender: TObject);
var
  i:integer;
begin
    odMultipleFiles.Title:=ezSelectTranslationFile;
    odMultipleFiles.Filter:= (ezLanguageFiles +  '(*.lng)|*.lng|' + ezTextFiles +'(*.txt)|*.txt|'  + ezAllFiles +'(*.*)|*.*|');
    if odMultipleFiles.Execute = False then exit;
    for i:=0 to odMultipleFiles.Files.Count -1 do
    begin //for
      FilenameTranslation:= odMultipleFiles.Files[i];
      //FileName:= FilenameTranslation;
      OpenTranslationFile(FilenameTranslation);
      Unsaved:=True;
      SaveTranslation(FilenameTranslation);
    end; //for i
    for i:=1 to sgStringList.RowCount - 1 do sgStringList.Cells[colTranslation,i]:=''; //Cleans translations column
    frmIniPrevMain.Caption:= ezIniPrev;
    FilenameTranslation:= '';
end;

procedure TfrmIniPrevMain.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;


//Returns True if the sought string is in the line
//SearchCol= 0 for searching in main strings; 1 for translation strings only; 2 for searching in both columns
function SearchLine(LineNumber:integer; SearchColumns: Integer=2):boolean;
var
  RetVal: Boolean = false;
  LineString: array [0..1] of string;
begin
with frmIniPrevMain do
begin //with
      case SearchColumns of
       0: begin //0 //Search main strings only
         LineString [0]:= RemoveIgnoreChars(sgStringList.Cells [colMain,LineNumber], SearchIgnoreChars);
          if (InStr (LineString[0], SearchString,1,SearchCaseSensitive ) > 0) then RetVal:=True;
        end; //0

     1: begin //1  //Search translation strings only
        LineString [1]:= RemoveIgnoreChars(sgStringList.Cells [colTranslation,LineNumber],SearchIgnoreChars);
       if (InStr (LineString[1], SearchString,1,SearchCaseSensitive ) > 0) then RetVal:=True;
       end; //1
     2: begin //2  //Search everywhere
         LineString [0]:= RemoveIgnoreChars(sgStringList.Cells [colMain,LineNumber],SearchIgnoreChars);
         LineString [1]:= RemoveIgnoreChars(sgStringList.Cells [colTranslation,LineNumber],SearchIgnoreChars);
         if (InStr (LineString[0], SearchString,1,SearchCaseSensitive ) > 0)
         or (InStr (LineString[1], SearchString,1,SearchCaseSensitive ) > 0)
         then RetVal:=True;
        end //2
     end; //case
end; //with
Result:=RetVal;
end;

function FindNext (StartLine: Integer;SearchColumns: Integer=2): Integer;  //Searches a next occurence of a string
var
  i:Integer;
  RetVal: integer=-1;
begin
with frmIniPrevMain do
  begin //with
   for i:=StartLine to frmIniPrevMain.sgStringList.RowCount-1 do
    begin //for
     if SearchLine(i,frmSearch.cboSearchColumn.ItemIndex)= True then
      begin //if
        RetVal:=i;
        break;
      end; //if
     end; //for
  end; //with
Result:= RetVal;
end;

function FindPrev (StartLine:Integer;SearchColumns: Integer=2):Integer;   //Searches a previous occurence of a string
var
  i:Integer;
  RetVal: integer=-1;
begin
with frmIniPrevMain do
begin //with
for i:=StartLine downto 1 do
   begin //for
         if SearchLine(i,frmSearch.cboSearchColumn.ItemIndex)= True then
         begin //if
           RetVal:=i;
           break;
         end; //if
   end; //for
end; //with
Result:= RetVal;
end;


procedure TfrmIniPrevMain.mnuEditFindClick(Sender: TObject);
var
  Result: Integer;
  i: integer;
  SearchResult:Integer;
begin
repeat
  Result:= frmSearch.ShowModal;
  if Result = mrOK then
  begin //if
    frmIniPrevMain.mnuEditFindNext.Enabled:=True;
    frmIniPrevMain.mnuEditFindPrev.Enabled:=True;
    for i:= 0 to Length(SearchIgnoreChars)-1 do
      begin //for
       SearchIgnoreChars[i]:='';
      end; //for
      with frmSearch do
        begin //with
          SearchString:= txtSoughtText.Text;
          if (cbgIgnoreChars.Checked[0] = true) then SearchIgnoreChars[0]:='&';
          if (cbgIgnoreChars.Checked[1] = true) then SearchIgnoreChars[1]:='_';
          if (cbgIgnoreChars.Checked[2] = true) then SearchIgnoreChars[2]:=txtIgnoreChar.text ;
          SearchCaseSensitive:= chkCaseSensitive.Checked;
          case rgDirection.ItemIndex of
             0: SearchResult:= FindNext(sgStringList.Selection.Top+1);
             1: SearchResult:= FindPrev(sgStringList.Selection.Top-1);
             2: begin
                   SearchResult:= FindNext(1);
                   rgDirection.ItemIndex:=0;
                end  //2
           end; //case
         end;//with
        if  (SearchResult > 0)
        then  frmIniPrevMain.sgStringList.Row:= SearchResult
        else QuestionDlg   (ezSearchComplete, ezSearchComplete,
             mtCustom,  // Should remove the bitmap, but does not
             [mrOK,ezOkay],'');
  end; //if
until Result= mrCancel;    //This is quite an ugly solution, it shall be rewritten some day.
end;

procedure TfrmIniPrevMain.mnuEditFindNextClick(Sender: TObject);
var
  SearchResult: integer =0;
begin
     SearchResult:= FindNext(sgStringList.Selection.Top+1);
     if (SearchResult>0) then
       frmIniPrevMain.sgStringList.Row:= SearchResult;
end;

procedure TfrmIniPrevMain.mnuEditFindPrevClick(Sender: TObject);
var
  SearchResult: integer =0;
begin
     SearchResult:= FindPrev(sgStringList.Selection.Top-1);
     if (SearchResult>0) then
       frmIniPrevMain.sgStringList.Row:= SearchResult;
end;

procedure TfrmIniPrevMain.mnuEditGoToLineClick(Sender: TObject);
var
   LineNumber: integer;
begin
     frmGoto.speLineNumber.MaxValue:= frmIniPrevMain.sgStringList.RowCount -1;
    if frmGoto.ShowModal = mrOK then
       begin
         LineNumber:= frmGoto.speLineNumber.Value;
         frmIniPrevMain.sgStringList.row:= LineNumber ;
       end;
end;

procedure TfrmIniPrevMain.mnuEditNextUntranslatedClick(Sender: TObject);
var
  i:integer;
begin
with sgStringList do
begin //with
     for i:= Row+1  to RowCount-1 do
     begin //for i
           if LineTranslatable(i)= True then
           if (Cells [colMain,i]=Cells [colTranslation,i]) or (Cells [colTranslation,i]='') then
           begin
             Row:= i;
             break;
           end;
     end; //for i
end; //with
end;

procedure TfrmIniPrevMain.mnuEditPreviousUntranslatedClick(Sender: TObject);
var
  i:integer;
begin
with sgStringList do
begin //with
     for i:= Row-1  downto 1 do //Row 0 are the captions
     begin //for i
           if LineTranslatable(i)= True then
           if (Cells [colMain,i]=Cells [colTranslation,i]) or (Cells [colTranslation,i]='') then
           begin
             Row:= i;
             break;
           end;
     end; //for i
end; //with
end;


end.
