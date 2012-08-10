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


unit frmPNSearch;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, PNCommons ;

type

  { TfrmSearch }

  TfrmSearch = class(TForm)
    Button1: TButton;
    cbgIgnoreChars: TCheckGroup;
    chkCaseSensitive: TCheckBox;
    cmdSearch: TButton;
    cboSearchColumn: TComboBox;
    txtIgnoreChar: TEdit;
    rgDirection: TRadioGroup;
    txtSoughtText: TLabeledEdit;
    procedure cbgIgnoreCharsItemClick(Sender: TObject; Index: integer);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSearch: TfrmSearch;

implementation

{$R *.lfm}

{ TfrmSearch }

procedure TfrmSearch.cbgIgnoreCharsItemClick(Sender: TObject; Index: integer);
begin
        if (cbgIgnoreChars.Checked [2] = true ) and  (txtIgnoreChar.Text ='') then
        begin //if
          ShowMessage (ezFillInTheTextBoxBeforeCheckingThisOption );
          cbgIgnoreChars.Checked [2]:= false ;
        end; //if
end;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin
  txtIgnoreChar.Left:= cbgIgnoreChars.left + cbgIgnoreChars.Width - txtIgnoreChar.Width -5 ;
  cbgIgnoreChars.Checked[0]:=True;
  cboSearchColumn.ItemIndex:=2;
end;

end.
