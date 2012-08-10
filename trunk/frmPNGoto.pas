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


unit frmPNGoto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Spin, StdCtrls;

type

  { TfrmGoto }

  TfrmGoto = class(TForm)
    cmdCancel: TButton;
    cmdGo: TButton;
    lblLineNumber: TLabel;
    speLineNumber: TSpinEdit;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmGoto: TfrmGoto;

implementation

{$R *.lfm}

end.

