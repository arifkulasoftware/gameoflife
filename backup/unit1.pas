unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    sg1: TStringGrid;
    sg2: TStringGrid;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure sg1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    function countcell(ACol,ARow:Integer;AFillCount:Boolean=True):Integer;
    procedure startaction  ;
    procedure doaction ;
    procedure docell(ACol,ARow:Integer);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.countcell(ACol, ARow: Integer; AFillCount: Boolean): Integer;
var
  StartRow , EndRow , StartCol , EndCol , i,J : Integer ;
begin
 result:=0;
 If ARow=0 Then StartRow:=0 Else StartRow:=ARow-1;
 If ACol=0 Then StartCol:=0 Else StartCol:=ACol-1;
 if ARow=sg1.rowcount-1 Then EndRow:=sg1.rowcount-1 Else EndRow:=ARow+1 ;
 if ACol=sg1.colcount-1 Then EndCol:=sg1.colcount-1 Else EndCol:=ACol+1 ;

 for i:=startrow to endrow do
  for j:=startcol to endcol do
   begin

     if not ((i=arow) and (j=acol)) Then
      if ( AFillCount and (sg1.cells[j,i]='*') ) or
         ( not AFillCount and (sg1.cells[j,i]=' ') )
           then inc(result);

     Application.ProcessMessages;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If Button1.Tag=0 then
    begin
      button1.tag:=1;
      startaction ;
      timer1.Enabled:=True;
    end else begin
      timer1.Enabled:=False;
      button1.tag:=0;
    end;
end;

procedure TForm1.sg1Click(Sender: TObject);
begin
  docell(sg1.col,sg1.Row);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 doaction ;
end;

procedure TForm1.startaction;
var i,j,c : integer ;
begin
  c:=0;
  for i:=0 to sg1.RowCount-1 do
   for j:=0 to sg1.ColCount-1 do
     begin
       c:=c mod 100+1;
       if random(100)<38 then sg1.Cells[j,i]:='*';
     end;
  sg2.Assign(sg1);
  timer1.Enabled:=True;
end;

procedure TForm1.doaction;
var i,j : integer ;
begin
  for i:=0 to sg1.RowCount-1 do
   for j:=0 to sg1.ColCount-1 do
    docell(j,i);
  sg1.Assign(sg2);
  panel1.tag:=panel1.tag+1;
  panel1.caption:=IntToStr(Panel1.tag);
end;

procedure TForm1.docell(ACol, ARow: Integer);
begin
  case countcell(ACol,ARow) of
   0..1 : sg2.Cells[ACol,ARow]:=' ' ;
      2 : sg2.Cells[ACol,ARow]:=sg1.Cells[ACol,ARow] ;
      3 : begin sg2.Cells[ACol,ARow]:='*' ; if sg1.Cells[ACol,ARow]=' ' then button1.tag:=button1.tag+1 ; button1.caption:=IntTostr(Button1.tag-3); end;
   else sg2.Cells[ACol,ARow]:=' ' ;
  end;
end;

initialization
 randomize ;
end.

