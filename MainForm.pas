{«адан массив записей. ѕоле key каждой записи - целое число. Ќаписать программу,
 котора€ нагл€дно демонстрирует сортировку массива по ключу key
 методом естественного сли€ни€
  оличество элементов массива таково, что что все элементы отображаютс€
 на экране. ¬ данных сортировках используетс€ дополнительный массив.}


unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs, Chart, ComCtrls,
  USort;


type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edtArray: TEdit;
    btnGenerate: TButton;
    btnEnter: TButton;
    btnSort: TButton;
    edtResult: TEdit;
    lbl4: TLabel;
    btnClear: TButton;
    lbl: TLabel;
    lstArr: TListBox;
    lstTmpArr: TListBox;
    lbl2: TLabel;
    btnExit: TButton;
    Label1: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure edtArrayKeyPress(Sender: TObject; var Key: Char);
    procedure btnEnterClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);

  private
    procedure ArrToListBox(var mas: TMas);  //отображение исходного массива в ListBox
    procedure TmpArrToListBox(var mas: TMas);   //отображение вспомогательного массива в ListBox
    function MakeArrayFromString(var Mas: TMas; var str: string): Boolean;
    function GetElem(var str: string; var el: Integer; var err: Boolean): Boolean;

  end;

var
  Form1: TForm1;
  Mas: TMas;

implementation

{$R *.dfm}

procedure TForm1.btnExitClick(Sender: TObject);
begin
  Close;
end;

//заполнение массива случайными числами
procedure TForm1.btnGenerateClick(Sender: TObject);
begin
  RandomFill(Mas);
  edtArray.Text:= ToString(Mas);
  ArrToListBox(Mas);
  btnSort.Enabled := True;
  btnEnter.Enabled:= False;
  btnGenerate.Enabled:= False;
  edtArray.ReadOnly:= True;
end;

//отображение исходного массива в ListBox
procedure TForm1.ArrToListBox(var mas: TMas);
var
  i: Integer;
begin
  for i:= 1 to N do
    lstArr.Items.Add(IntToStr(mas[i].key));
end;

//отображение вспомогательного массива в ListBox
procedure TForm1.TmpArrToListBox(var mas: TMas);
var
  i: Integer;
begin
  for i:= 1 to N do
    if mas[i].key = 0 then
      lstTmpArr.Items.Add('-')
    else
      lstTmpArr.Items.Add(IntToStr(mas[i].key));
end;

//сортировка заполненного массива
procedure TForm1.btnSortClick(Sender: TObject);
var
  tmpArr: TMas;
  i: Integer;
begin
  btnGenerate.Enabled:= False;
  btnExit.Enabled:= False;
  btnClear.Enabled:= False;
  btnSort.Enabled:= False;
  for i:= 1 to N do
  tmpArr[i].key:= DefaultValue;
  TmpArrToListBox(tmpArr);
  NaturalMergeSort(Mas, tmpArr, lstArr, lstTmpArr);
  lbl4.Visible:= True;
  edtResult.Visible:= True;
  edtResult.Text:= ToString(Mas);
  lstArr.Clear; lstTmpArr.Clear;
  btnExit.Enabled:= True;
  btnClear.Enabled:= True;
end;


//контроль вводимых символов
procedure TForm1.edtArrayKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  '0'..'9', ' ', '-', #8: ;
  #13 : btnEnterClick(Sender);  
  else Key :=Chr(0);
  end;
end;

//извлечение из строки очередного элемента
function TForm1.GetElem(var str: string; var el: Integer; var err: Boolean): Boolean;
var
  s: string;
  i: Integer;
begin
  i:= Pos(' ', str);
  if i = 0 then
    begin
      if not TryStrToInt(str, el) then
       err:= True;
      Result:= False;
    end
  else
    begin
      s:= Copy(str, 1, i-1);
      Delete(str, 1, i);
      if not TryStrToInt(s, el) then
        Result:= False
      else Result:= True;
      err:= False;
    end;
end;

//создание массива из строки
function TForm1.MakeArrayFromString(var Mas: TMas; var str: string): Boolean;
var
  el: Integer;
  i: Integer;
  ok: Boolean;
  err: Boolean;
  count: Integer;
begin
  count:= 0;
  i:= 1;
  ok:= True;
  while ok do
  begin
    ok:= GetElem(str, el, err);
    if not err then
      begin
        Mas[i].key:= el;
        inc(i);
        Inc(count);
      end
  end;
  Result:= count = N;
end;

//действи€ после ввода массива вручную
procedure TForm1.btnEnterClick(Sender: TObject);
var
  str: string;
begin
  str:= edtArray.Text;
  if MakeArrayFromString(Mas, str) then
    begin  
      btnSort.Enabled:= True;
      btnGenerate.Enabled:= False;
      btnEnter.Enabled:= False;
      edtArray.ReadOnly:= True;
      ArrToListBox(Mas);
    end
  else
    MessageDlg('Ќеверное количество элементов', mtError, mbOKCancel, 0);
end;

//очистка пол€ дл€ ввода
procedure TForm1.btnClearClick(Sender: TObject);
begin
  edtArray.Clear;
  btnSort.Enabled:= False;
  lbl4.Visible:= False;
  edtResult.Visible:= False;
  lstArr.Clear;
  lstTmpArr.Clear;
  btnEnter.Enabled:= True;
  btnGenerate.Enabled:= True;
  edtArray.ReadOnly:= False;
end;

end.
