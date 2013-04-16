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


unit PNCommons;

{$mode objfpc}{$H+}

interface


uses
   Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Grids,
  StdCtrls, strutils, LCLProc{,ExtCtrls}{,LCLType},LResources,charencstreams,LConvEncoding;

type
  StringArray1D = array of string ;
  StringArray2D = array of array of string ;
  IntegerArray1D = array of integer;
  DisplayMode= (DisplayAll=0, DisplayUntranslatedOnly= 1, DisplayFuzzyOnly= 2, DisplayUntranslatedAndFusy= 3, DisplayTranslatedOnly=4);
  tStripQuotes= (StripAlways, StripNever, StripAuto);
  UncloseOccurence= (uncSecond, uncLast);
  UniFile= record
    UniText:string;
    Encoding: TUniStreamTypes;
    HasBom: boolean;
    ANSIEnc: string;
    NewLine: String;
  end;

  UnclosedLine=record
    Opening: String;
    Closing: String;
    Contents: String;
  end;


//Public functions
function BooleanToString (aBoolean:Boolean):String;
function StringToBoolean (aString:String):Boolean ;
function Split(AString: string; Separator: string): StringArray1D ;
function Join(const aStringArray:StringArray1D; const Separator: string=''):String;
function Occurs(str, separator: string): integer;
function Mid (AText:string; AStart :Integer; ACount:Integer=-1 ):string;
function GetBom(StartString: string):Integer;
function ReadUTF8 (FileName:String; ForcedEncoding:TUniStreamTypes=ufUndefined): UniFile;
function WriteUTF8 (FileName:String; StringToWrite: string; Encoding:TUniStreamTypes=ufUtf8; HasBOM:Boolean=True): string;

function UTF8StringReplace(const S, OldPattern, NewPattern: string;  Flags: TReplaceFlags='[]'): string;
function its (AInteger: integer): String;
function OSVersion: integer;
function FilePath(FullFileName: string):String;
function RemovePath(FullFileName: string) : string;
function LocalizeRowMultiple(aString:string; Key1:string='';Key2:string='';Key3:string='';Key4:string='';Key5:string='';Key6:string=''):string;
function LocalizeRowCountable (String0Items:string;String1Item:string; StringMultipleItems:string;KeyNumeric:QWord; Decimals:Integer=0 ):string;
function Unclose (AString:String; Opener: String; Closer: String='';Occurence:UncloseOccurence=uncSecond): UnclosedLine;
function UncloseReplaceEsc (AString:String; Opener: String; Closer: String) : String;
function InStr (SearchString: string; SoughtString:string; start:integer = 1;CaseSensitive:Boolean = False ): integer;
procedure SetOS;
procedure DebugLine(AString: string);
procedure DebugArray1D(AStringArray1D: StringArray1D);
procedure DebugArray2D(AStringArray2D: StringArray2D);


const
  CrLf = #13 + #10;
  Cr = #13;
  Lf = #10;
  TAB = #9;
  Apostrophy =#96;
  Null_Terminator = #0;
  BOMUTF8= #239+ #187 + #191;
  BOMUTF16BE= #254+#255;
  BOMUTF16LE= #255+#254;
  DebugLog= 'debuglog.txt';
  SettingsFile='prevnarin.ini';
var
   Charset: TUniStreamTypes = ufUtf8;     {0=UTF8; 1=ANSI; 2=UTF16(BE); 3:=UTF16(LE)}
   Slash:string = '\'; //  For Dos, Windows and ReactOS= \, for *nix = /
   HasBom:Boolean=False;
   Vocabulary: array of array of string;

   {Vars adjustable trough the settings windows}
   RowSplitter : string = '=';
   SectionOpener: string;
   SectionCloser: string;
   FillBlanks {when saving translation}:Boolean= True;
   IgnoreLines: StringArray1D;
   IgnoreSections: Boolean= false;
   ConvertPercent: Boolean= False;
   ConfirmAutotranslate:Integer;
   DebugMode: Boolean= False;
   RecentStore: Integer= 5;
   VocabularyPath:String;
   VocabularySourcePath:String;
   AutotranslateOkay:Boolean=False;
   StripQuotes{Set}:tStripQuotes=StripAuto;
//   StripQuotes: Boolean;
   ConvertQuotes:Boolean=True;
   QuotationMarkType:integer=0;
   QuoteChar:string='"';
   {End of adjustable vars}

  {Localization strings start here}
  ezFullStop: string;
  ezComma: string;
  ezBracketOpen: string;
  ezBracketClose: string;
  ezSemicolon: string;
  ezSpace: string;
  ezYes:String;
  ezNo:String;
  ezOkay:String;
  ezCancel:String;
  ezError:String;
  ezInvertedCommaOpen: string;
  ezInvertedCommaClose: string;
  ezIsLoaded: string;
  ezIsSavedAs: string;
  ezMRPFiles: string;
  ezFilesSaved: string;
  ezFileName: string;
  ezMenuFileName: string;
  ezNote: string;
  ezRow: string;
  ezSection: string;
  ezKey: string;
  ezDefault: string;
  ezTranslation: string;
  ezMainFile: String;
  ezTranslationFile: String;
  ezLanguageFiles: string;
  ezTextFiles: string;
  ezAllFiles: string;
  ezTotalStrings:string;
  ezTotalStringsEtc:String;
  ezTranslatedStrings:string;
  ezUntranslatedStrings:String;
  ezUntranslatableStrings:String;
  ezPerCent:String;
  ezBOM:string;
  ezNoBOM:string;
  ezCharsetName: array [0..5] of string;
  ezSelectMainfile: string;
  ezSelectTranslationFile: string;
  ezSelectAuxFile: String;
  ezSelectVocabularyFile: String;
  ezSaveTranslatedFileAs: String;
  ezSelectFileToWrite: String;
  ezAnErrorOccuredWhenTryingToLoadAuxiliaryFile:String;
  ezSettings: String;
  ezRowSplitter: String;
  ezFillInEmptyLines: String;
  ezSectionOpener: String;
  ezSectionCloser: String;
  ezIniPrev:String;
  ezTo:String;
  ezFileToFile:String;
  ezFileNotSaved:String;
  ezDoYouWantToSaveTheFileBeforeExit:String;
  ezFillInTheTextBoxBeforeCheckingThisOption:String;
  ezNewLines:String;
  ezAutoFilledLines:String;
  ezSearchComplete:String;
  ezSettingsHeaderLocalized:String;
  ezNoStringsFoundMakeSureThatYouHaveSetTheProperRowSplitterInTheSettinsAndThatYouHaveOpenedAProperFile:String;
  ezWarning:String;
  ezDoYouWantToOpenTheTranslationFileWithANewEncoding:String;
  ezTheChangesInYourTranslationAreNotSavedIfYouPressYesTheyWillBeLost:String;
  ezAutotranslate:String;
  ezDoYouWantToAutotranslate1to2:String;
  ezSelectANewLineCharacterBeforeSavingTheTranslation:String;
  ezUnloadVocabulary:String;
  ezVocabularySaved:String;
  ezMissingOpeningQuotationMarkOnLine1: String;
  ezMissingClosingQuotationMarkOnLine1: String;
  ezTooManyQuotationMarksOnLine1:String;
  ezDoubleQuotationMarksOnLine1: String;
  ezErrorWhileReadinSettingsFile: String;
  ezNoQuoteErrorsFound: String;
{Localization strings end here}

implementation

function its (AInteger: integer): String;
begin
  result := IntToStr (AInteger) ;
end;


//Next function is a modification of a one from http://forum.lazarus.freepascal.org/, authored by jwdietrich
function OSVersion: integer;
 var
  RetVal:integer;
  osErr: integer;
  response: longint;
begin
  {$IFDEF LCLcarbon}
  RetVal := 2; //Mac OS X
  {$ELSE}
  {$IFDEF Linux}
  RetVal := 1; //Linux Kernel
  {$ELSE}
  {$IFDEF UNIX}
  RetVal := 1; //'Unix ';
  {$ELSE}
  {$IFDEF WINDOWS}
  RetVal:=0;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  Result:= RetVal;
end;

procedure SetOS;  //Sets the variables, according to the OS
begin
  if OSVersion= 0 then Slash:= '\' else Slash:= '/';
end;

function BooleanToString (aBoolean:Boolean ):string; //BoolToStr returns odd data, so I make this one
var
  RetVal: string;
begin
  if aBoolean = true then RetVal:='True' else RetVal:='False';
  Result:=RetVal ;
end;

function StringToBoolean (aString:String):Boolean ;
var
  RetVal:boolean;
begin
  if CompareStr (aString,'True')= 0 then
  RetVal:=True
  else
    RetVal:=False   ;
  Result :=RetVal;
end;

//TODO: To replace it with the Lazarus inbuilt function
function FilePath(FullFileName: string):String;
var
  RetVal:String;
  SlashPosition: Integer;
begin
  RetVal:=ReverseString(FullFileName);
  SlashPosition:=PosEx(Slash,RetVal);
  RetVal:=ReverseString(Mid(RetVal,SlashPosition));
  Result:=RetVal;
end;

//TODO: To replace this with the Lazarus inbuild function
function RemovePath(FullFileName: string) : string;
var
   RetVal: string;
   SlashPosition: Integer;
begin
   //Lazarus does not have an inbuilt function for searching backward, or at least I did not find one
   RetVal:=ReverseString(FullFileName);
   SlashPosition:= PosEx (Slash,RetVal) ;
   RetVal:=ReverseString(LeftStr(RetVal, SlashPosition-1));
   Result:=RetVal;
end;


//Next 4 functions are from http://forum.lazarus.freepascal.org/, authored by KpjComp
type TUTF8Indexed = record
  charWidths:array of byte;
  rawData:array of DWord;
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


function UTF8ToUTF8Indexed(const Src:string):TUTF8Indexed;
var
  charLen:PtrInt;
  p,pe:pchar;
  cw,i:integer;
begin
  charLen := UTF8Length(Src);
  setlength(result.charWidths,charLen);
  setlength(result.rawData,charlen);
  //fill our raw data with 0's, so that compares will work when
  //out UF8, have different sizes.
  FillByte(result.rawData[0],sizeof(DWord),0);
  p := @Src[1];
  pe := @Src[length(src)];
  i:=0;
  while p <= pe do
  begin
    cw := UTF8CharacterLength(p);
    result.charwidths[i] := cw;
    move(p^,result.rawData[i],cw);
    inc(p,cw);
    inc(i);
  end;
end;

function UTF8IndexedToUTF8(const Src:TUTF8Indexed):string;
var
  uPos,iPos,len,cc:PtrInt;
begin
  //first set our result to maximum size possible,
  cc := length(Src.rawData);
  setlength(result,4*cc);
  uPos := 0;
  for iPos := 0 to cc-1 do
  begin
    move(src.rawData[iPos],result[upos+1],src.charWidths[iPos]);
    inc(upos,src.charWidths[ipos]);
  end;
  setlength(result,uPos);
end;

function UTF8StringReplace(const S, OldPattern, NewPattern: string;  Flags: TReplaceFlags='[]'): string;
var
  osrc,src,search:TUTF8Indexed;
  outpos,lpTextLen,lpSearchLen,lpTextEnd,lpTextPos:PtrInt;
const
  //constanst for string expansion, basically lets start at 128 bytes, then
  //increase double each time and max out at 32K.
  SizeResultStart=128;
  SizeResultMaxInc=32*1024;
  //
  procedure NeedSize(s:PtrInt);
  var
    cl,ns:PtrInt;
  begin
    //use our constants to control string expansion
    cl := length(result);
    if cl>=s then exit;
    ns := cl;
    if ns > SizeResultMaxInc then ns := SizeResultMaxInc;
    setlength(result,cl+ns);
  end;
  //
  procedure CopyNextChar;
   begin
     NeedSize(outpos+src.charWidths[lpTextPos]);
     move(osrc.rawData[lpTextPos],result[outpos+1],osrc.charWidths[lpTextPos]);
     inc(outpos,osrc.charWidths[lpTextPos]);
     inc(lpTextPos);
   end;
  //
  function AllEqual:boolean;
  var
    lp:PtrInt;
  begin
    result := false;
    for lp := 1 to length(search.rawData)-1 do
    begin
      if search.RawData[lp] <> src.rawData[lpTextPos+lp] then exit;
    end;
    result := true;
  end;
  //
begin
  if Length(S)= 0 then Result:=''
  else
  begin
  if rfIgnoreCase in Flags then
  begin
    //this is our ignore case, so lets lowercase search & text
    osrc := UTF8ToUTF8Indexed(S);
    src := UTF8ToUTF8Indexed(UTF8LowerCase(S));
    //osrc and src should be same size, lets double check
    if length(osrc.rawData)<>length(src.rawData) then
      raise Exception.Create('Lengths not equal');
    search := UTF8ToUTF8Indexed(UTF8LowerCase(OldPattern));
    //if there is nothing in our search, then there is nothing to replace
    if length(search.rawData) < 1 then begin
      result := S;
      exit;
    end;
    //ok mow have src & search in lowercase so our finds will work
    setlength(result,SizeResultStart);
    outpos := 0;
    lpTextLen := length(src.charWidths);
    lpSearchLen := length(search.charWidths);
    lpTextEnd := lpTextLen-lpSearchLen+1;
    lpTextPos := 0;
    //let's find our first char match
    while lpTextPos < lpTextEnd do
    begin
      if src.rawData[lpTextPos]=search.rawData[0] then
      begin
        //we have a match, are the rest equal.
        if AllEqual then
        begin
          if length(newPattern)>0 then
          begin
            NeedSize(outpos+length(newPattern));
            move(newPattern[1],result[outpos+1],length(newPattern));
            inc(outpos,length(newPattern));
          end;
          inc(lpTextPos,length(search.rawData));
          if rfReplaceAll in Flags then continue
          else break;
        end;
      end;
      //if we get here, there was no match, just copy char to output
      CopyNextChar;
    end;
    //grab any remaining..
    while lpTextPos < lpTextLen do CopyNextChar;
    //resize result, to correct size.
    setlength(result,outpos);
  end
  else
  begin
    //if were not bothered about case, the standard StringReplace should work.
    result := StringReplace(S,OldPattern,NewPattern,Flags);
  end;
  end;
end;


//I fixed a buggy function which I found somewhere in the internet, instead of writing a new one, I am not quite sure that it works properly always, especially with UTF8
function Occurs(str, separator: string): integer; //Counts the occurences of a separator in a string
var
  i, nSep: integer;
  SeparatorLength: Integer;
begin
  SeparatorLength := Length(separator);
  nSep := 0;
  for i := 1 to Length(str) do
  if MidStr (str,i,SeparatorLength) = separator then
      Inc(nSep);
  Result := nSep;
end;


//Returns an array with the parts of "str" separated by "separator"
//TODO: When occurs returns zero, the Split func will crash
//TODO: Most probably this function will not work properly with UNICODE strings.
 function Split(AString: string; Separator: string): StringArray1D ;
var
  i, n: integer;
  SeparatorLength: Integer;
  strline: string;
  strfield: string; //Content of a line
begin
  SeparatorLength:= Length(separator);
  n := Occurs(AString, separator);
  SetLength(Result, n + 1);
  i := 0;
  //The last char of the last line of the array is cropped.
  //To evade this, a separator string is appended to the string.
  strline := AString + separator;
  repeat
    if Pos(separator, strline) > 0 then
    begin
      strfield := Copy(strline, {1} SeparatorLength-1 , Pos(separator, strline) - 1); //TODO
      strline := Copy(strline, Pos(separator, strline) + {1}  SeparatorLength , Length(strline) -
        pos(separator, strline)); //TODO= I am not sure if these are okay
    end
    else
    begin
      strfield := strline;
      strline := '';
    end;
    Result[i] := strfield;
    Inc(i);
  until strline = '';
  if Result[High(Result)] = '' then
    SetLength(Result, Length(Result) - 1);
end;

 function Join(const aStringArray:StringArray1D; const Separator: string=''):String;
 var
   RetVal: String='';
   i:integer;
   ArrayLength:integer;
 begin
   ArrayLength:= Length(aStringArray);
   if ArrayLength > 0 then
   begin //if
     for i:= 0 to ArrayLength -2 do
         RetVal:=RetVal+ aStringArray[i]+ Separator;
      RetVal:=RetVal+ aStringArray[ArrayLength-1];
   end; //if
   Result:= RetVal ;
 end;

 //Returns 0 for UTF8, 2 for UTF16(BE) and 3 for UTF16(LE)
 function GetBom(StartString: string):Integer; //StartString= The first 3 chars of a file
var
  RetVal: Integer;
begin
     if LeftStr (StartString,3)= BOMUTF8 then
     Retval:= 0
     else
         if LeftStr (StartString,2)= BOMUTF16BE
         then retval:=2
         else
             if LeftStr (StartString,2)= BOMUTF16LE
             then retval:=3;
   Result:= RetVal;
end;

 //In Lazarus ACount is not optional, so here is a workaround.
function Mid (AText:string; AStart :Integer; ACount:Integer=-1 ):string;
var
  StringLength: Integer;
begin
  if ACount= -1 then StringLength:= Length(AText)  else StringLength:= ACount;
  result := MidStr(AText,AStart, StringLength)  ;
end;


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

 function ReadUTF8 (FileName:String; ForcedEncoding:TUniStreamTypes=ufUndefined): UniFile ;
 var
  fCES: TCharEncStream;
  RetVal: UniFile;
begin
  fCES:=TCharEncStream.Create;
  if ForcedEncoding<>ufUndefined then
  begin //if
    fCES.ForceType:= True;
    fCES.UniStreamType:=ForcedEncoding;
  end //if
  else
    fCES.Reset;
  fCES.LoadFromFile(UTF8ToSys(FileName));
  if (fCES.UniStreamType=ufANSI) then
  begin
    fCES.ANSIEnc:=LConvEncoding.GetDefaultTextEncoding ;
  end;
 RetVal.UniText:=fCES.UTF8Text ;
  //This is workaround of a bug in charencstreams
  if (fCES.UniStreamType=ufANSI) and (fces.ANSIEnc='utf8')
    then RetVal.Encoding:=ufUtf8
    else RetVal.Encoding:=fCES.UniStreamType;
  RetVal.HasBom:=fCES.HasBOM;
  RetVal.ANSIEnc:=fCES.ANSIEnc;
  RetVal.NewLine:=NewLineString (RetVal.UniText);
  Result:=RetVal;
end;

function WriteUTF8 (FileName:String; StringToWrite: string; Encoding:TUniStreamTypes=ufUtf8; HasBOM:Boolean=True): string;
var
   fCES: TCharEncStream;
begin
   fCES:=TCharEncStream.Create;
   fCES.HaveType:=True;
   fCES.UniStreamType:= Encoding;
   fCES.HasBOM:=HasBOM;
   fCES.UTF8Text:=StringToWrite;
   fCES.SaveToFile(UTF8ToSys(FileName));
end;


function RealToString (aReal:real; Width:Integer=0; Decimals:Integer=3):string;
var
  RetVal:string;
begin
     Str (aReal:Width:Decimals,RetVal);
     Result:=RetVal;
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
  Result:=RetVal ;
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


//Returns the text between Opener and Closer. Example- unclose ([section], '[',']') returns „section“.
function Unclose (AString:String; Opener: String; Closer: String='';Occurence:UncloseOccurence=uncSecond): UnclosedLine;
var
  TokenStart: integer=0;
  TokenLength: integer=0;
  RetVal: UnclosedLine;
  a,b: Integer;
begin
  a:=PosEx(Opener,AString);
  b:= Length(AString);
  if PosEx(Opener,AString)< Length(AString)then
     TokenStart:=PosEx(Opener,AString)+ Length(Opener)
  else
     TokenStart:=1; //Opener is missing
  if Length(Closer)<>0 then
  begin
  if PosEx(Closer,AString, TokenStart+1)> 0 then
  begin
   if (Occurence= uncSecond)
             then TokenLength:=PosEx(Closer,AString, TokenStart+1)-TokenStart
             else TokenLength:=rPos(Closer,AString)-TokenStart;
    end
  else TokenLength:=Length(AString); //Closer is missing
    RetVal.Contents:=Mid(AString,TokenStart,TokenLength);
    RetVal.Opening:=LeftStr(AString,TokenStart-1); //todo
    if TokenLength>-1
      then RetVal.Closing:=Mid(AString,TokenLength+TokenStart)
      else RetVal.Closing:='';
  end
  else
  begin
     RetVal.Contents:=Mid(AString,TokenStart);
     RetVal.Opening:=LeftStr(AString,TokenStart-1);
     RetVal.Closing:='' ;
  end;
  Result:=RetVal;
end;

function UncloseReplaceEsc (AString:String; Opener: String; Closer: String) : String;
var
  EscChar: String='';
  TokenStart: integer;
  TokenLength: integer;
begin
TokenStart:= PosEx(Opener,AString);
if TokenStart<>0 then
begin
  TokenStart:= TokenStart+ Length(Opener);
  TokenLength:= PosEx(Closer,AString, TokenStart+1)- TokenStart;
   try
    EscChar:= chr(StrToInt(mid(AString,TokenStart,TokenLength))) ;
   Except
     EscChar:='';
   end;
end;
Result:= LeftStr(AString,TokenStart- Length(Opener)-1)+ EscChar+ Mid (AString,TokenStart+TokenLength+Length(Closer));
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
       //TODO: This works only for a [x,2] array
       DebugLine ('Line:' + IntToStr ( i) + tab + AStringArray2D[i,0] + TAB +AStringArray2D[i,1]);
     end;
   end;
 end;


end.

