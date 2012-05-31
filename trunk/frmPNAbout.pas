unit frmPNAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    lblVersion: TLabel;
    lblGPL: TLabel;
    txtGPL: TMemo;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

end.

