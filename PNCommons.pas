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


unit PNCommons;

{$mode objfpc}{$H+}

interface


uses
   Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Grids,
  StdCtrls, strutils, LCLProc{,ExtCtrls}{,LCLType};

type
  StringArray1D = array of string ;
  StringArray2D = array of array of string ;
  IntegerArray1D = array of integer;
  Encoding = (EncodingUndefined=-1,EncodingUTF8=0,EncodingANSI=1,EncodingUTF16_BE=2,EncodingUTF16_LE=3);
  //TODO: I tried to use unumeration, but it occured that in Pascal Eum<> Integer, so the final result is odd.

//Public functions
function BooleanToString (aBoolean:Boolean):String;
function StringToBoolean (aString:String):Boolean ;
function Split(const AString: string; const Separator: string): StringArray1D ;
function Join(const aStringArray:StringArray1D; const Separator: string=''):String;
function Occurs(const str, separator: string): integer;
function Mid (AText:string; AStart :Integer; ACount:Integer=-1 ):string;
function GetBom(StartString: string):Integer;
function FileGet(FileName: string; StartPosition: integer = 0; StringLenth: integer = 0; ForcedEncoding: integer= ord(EncodingUndefined)): string;
procedure FilePut(FileName: string; StringToWrite: string; StartPosition: integer=0);
procedure SetOS;
function UTF8StringReplace(const S, OldPattern, NewPattern: string;  Flags: TReplaceFlags): string;
function its (AInteger: integer): String;
function OSVersion: integer;
function RemovePath(FullFileName: string) : string;

const
  DebugMode= False;
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
  SettingsFile='prevnar.ini';

var
   Charset: integer = 0;     {0=UTF8; 1=ANSI; 2=UTF16(BE); 3:=UTF16(LE)}
   Slash:string = '\'; //  For Dos, Windows and ReactOS= \, for *nix = /
   RowSplitter : string = '=';
   SectionOpener: string;
   SectionCloser: string;
   FillBlanks {when saving translation}:Boolean= True;
   IgnoreLines: StringArray1D;
   ConfirmAutotranslate:Integer;

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
  ezCharsetName: array [0..1{3}] of string; //TODO: To set it to 1..3 when UTF16 support is implemented.
  ezSelectMainfile: string;
  ezSelectTranslationFile: string;
  ezSaveTranslatedFileAs: String;
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


//TODO: To replace this with the Lazarus inbuild function
function RemovePath(FullFileName: string) : string;
  var RetVal: string;
      SlashPosition: Integer;
begin
     //Lazarus does not have an inbuilt function for searching backward, or at least I did not find one
     RetVal:=ReverseString(FullFileName);
     SlashPosition:= PosEx (Slash,RetVal) ;
     RetVal:= ReverseString(LeftStr(RetVal, SlashPosition-1));
     Result:= RetVal ;
end;


//Next 3 functions are from http://forum.lazarus.freepascal.org/, authored by KpjComp
type TUTF8Indexed = record
  charWidths:array of byte;
  rawData:array of DWord;
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

function UTF8StringReplace(const S, OldPattern, NewPattern: string;  Flags: TReplaceFlags): string;
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
    inc(outpos);
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
function Occurs(const str, separator: string): integer; //Counts the occurences of a separator in a string
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
 function Split(const AString: string; const Separator: string): StringArray1D ;
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

 function FileGet(FileName: string; StartPosition: integer = 0; StringLenth: integer = 0; ForcedEncoding: integer= ord(EncodingUndefined)): string;
 var
   ReturnString: String  ;
   stream: TFileStream;
   BOM: Integer=0;
 begin
   if StringLenth = 0 then
   begin
     StringLenth := FileSize(FileName);
   end;
 //  stream := TFileStream.Create(UTF8ToSys(FileName), fmOpenRead or fmShareDenyNone);
   stream := TFileStream.Create(UTF8ToSys(FileName), fmShareDenyNone );
   try
     stream.Seek(StartPosition, soFromBeginning);
     SetLength(ReturnString, StringLenth);
     stream.Read(ReturnString[1], StringLenth);
   finally
     stream.Free();
   end;
   BOM := GetBom(LeftStr(ReturnString,3));
   if BOM = 1 then //removes the BOM string
      ReturnString := Mid(ReturnString,4)
   else if (BOM =2) or (BOM =3) then ReturnString := Mid(ReturnString,3);

   if ForcedEncoding = ord(EncodingUndefined) then
      Charset := BOM // GetBom(LeftStr(ReturnString,3))
   else
     Charset:= ord(ForcedEncoding);
 case Charset of
      ord(EncodingANSI) :  Result := AnsiToUtf8(ReturnString);
      ord(EncodingUTF8) :  Result := ReturnString;
      //Still I cannot make UTF16 convertion work
      ord(EncodingUTF16_BE) :
                            begin
                            Result := UTF16ToUTF8(ReturnString) ; //UnicodeToUtf8 (ReturnString);
                            end;
      ord(EncodingUTF16_LE) :
                            begin
                            Result := UTF16ToUTF8 (ReturnString) ; //UnicodeToUtf8 (ReturnString);
                            end;

 end; //case

   {if Charset = 0 then //UTF16BE and LE are still not implemented
       Result := AnsiToUtf8(ReturnString)   //ANSI
   else if
       Result := ReturnString; //UTF8}
 end;

 procedure FilePut(FileName: string; StringToWrite: string; StartPosition: integer);
 var
   stream: TFileStream;
 begin
   if FileExists (UTF8ToSys(FileName)) = true then
   begin
     stream := TFileStream.  Create(UTF8ToSys(FileName), fmOpenWrite);
   end
   else
        stream := TFileStream.Create(UTF8ToSys(FileName), fmCreate);
   try
     stream.Seek(StartPosition, soFromBeginning);
     stream.WriteBuffer(Pointer(StringToWrite)^, Length(StringToWrite));
   finally
     stream.Free();
   end;
 end;


end.

