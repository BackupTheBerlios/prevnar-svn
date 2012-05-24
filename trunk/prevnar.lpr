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


program IniPrev;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  //Interfaces, // this includes the LCL widgetset
  Forms, Interfaces, frmIniPrev, frmPNSettings, frmPNSearch, frmPNGoto,
  PNCommons;

{$R *.res}

begin
  Application.Title:='ПревНар [PrevNar]';
  Application.Initialize;
  Application.CreateForm(TfrmIniPrevMain, frmIniPrevMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmGoto, frmGoto);
  Application.Run;
end.

