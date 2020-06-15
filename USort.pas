unit USort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, TeEngine, Series, TeeProcs, Chart,
  ComCtrls;                 

const
  N = 10;   //���������� ��������� � ���������������� ������� ��� ����������
  DefaultValue = MaxInt;   //�������� �� ��������� ��� ������� �������
  ssleep = 400;   //�������� � ��

type
  TElem = record
    key: Integer;
    info: string;
  end;
  TMas = array[1..N] of TElem;   //���-������

  procedure RandomFill(var mas: TMas);  //���������� ������� ���������� �������
  function ToString(var mas: TMas): string;    //��������� ������ � ���� ������
  function Split(var mas: TMas; var tmpMas: TMas; var lbTmpMas: TListBox): Integer;    //��������� �������� ������ �� ����� ��� ����������
  procedure NaturalMergeSort(var mas: TMas; var tmpMas: TMas; var lbMas: TListBox; var lbTmpMas: TListBox); //������� ����� � �������� ������

implementation

//���������� ������� ���������� �������
procedure RandomFill(var mas: TMas);
var
  i: Integer;
begin
  Randomize;
  for i:= 1 to N do
    mas[i].key:= Random(100);
end;

//��������� ������ � ���� ������
function ToString(var mas: TMas): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to N do
    Result:= Result + IntToStr(mas[i].key) + '  ';
end;

//������ ���������� ListBox
procedure ChangeListBox(lb: TListBox; var arr: TMas);
var
  i: Integer;
begin
  lb.Items.Clear;
  for i:= 1 to N do
    if arr[i].key = DefaultValue then
      lb.Items.Add('[ ]')
    else
      lb.Items.Add(IntToStr(arr[i].key));
  Application.ProcessMessages;
  sleep(ssleep);
end;

//������� ������ (������������ � ����� ��������� ���� ��� ����� ���������� ����������� � ListBox)
procedure ClearArr(var arr: TMas);
var i: Integer;
begin
  for i:= 1 to N do
    arr[i].key:= DefaultValue;
end;

//��������� �������� ������ �� ����� ��� ����������
function Split(var Mas: TMas; var tmpMas: TMas; var lbTmpMas: TListBox): Integer;
var
  i: Integer;
  startJ, endJ: Integer;     //������� ����� � ������ ���������������� �������
  direction: Boolean;      //����������� ���������� ���������������� ������� (True - ����� �������, False - ������ ������)
begin
  i:= 1;
  startJ:= 1;
  endJ:= N;
  tmpMas[startJ]:= Mas[i];         //������ ����� ���������� � ������ ����� ���������������� �������
  ChangeListBox(lbTmpMas, tmpMas);    //���������� ��������� ���������� ������� �� ��������������� ListBox
  inc(startJ);
  Inc(i);
  direction:= True;
  Result:= 1;
  while i <= N do                       //������ �� ����� ��������� �������
  begin
    if Mas[i].key >= Mas[i-1].key then     //���� ��������� ������� ������ �����������, ����� ������������, ����������� ������� �������
      begin
        if direction = True then
        begin
          tmpMas[startJ]:= Mas[i];
          Inc(startJ);
          inc(i);
        end
        else
        begin
          tmpMas[endJ]:= Mas[i];
          Dec(endJ);
          inc(i);
        end;
      end
    else                               //���� ��������������� ����������, ����� �����������
    begin
      direction:= not direction;       //������ ����������� �� ���������������
      Inc(Result);
      if direction = True then            //� ���������� �������
        begin
          tmpMas[startJ]:= Mas[i];
          Inc(startJ);
          inc(i);
        end
      else
        begin
          tmpMas[endJ]:= Mas[i];
          Dec(endJ);
          inc(i);
        end;
    end;
    ChangeListBox(lbTmpMas, tmpMas);      //���������� ��������� ���������������� �������
  end;

end;

//������� ����� � �������� ������
procedure NaturalMergeSort (var Mas: TMas; var tmpMas: TMas; var lbMas: TListBox; var lbTmpMas: TListBox);
var
  i, startJ, endJ: Integer;
begin
  while Split(Mas, tmpMas, lbTmpMas) > 1 do       
  begin
    ClearArr(Mas);                                //������� �������� ������ ����� ���� ����� ����� ��� �� ����� ����������
    ChangeListBox(lbMas, mas);
    i:= 1; startJ:= 1; endJ:= N;
    while i <= N do
    begin
      repeat                  //������� �� ����� ����� ���� �����-������ �� ��� �� ���������� ��� �� ���������� ��������������� ������
        if tmpMas[startJ].key < tmpMas[endJ].key then          //���������� �������� �� ���� �����, � �������� ������ ���������� ����������
          begin
            Mas[i]:= tmpMas[startJ];
            Inc(i);
            Inc(startJ);
          end
        else
          begin
            Mas[i]:= tmpMas[endJ];
            Inc(i);
            Dec(endJ);
          end;
        ChangeListBox(lbMas, mas);                   //���������� ��������� �������
      until (startJ = N) or (tmpMas[startJ].key > tmpMas[startJ + 1].key) or (tmpMas[endJ].key > tmpMas[endJ - 1].key);

      if (startJ < N) and (tmpMas[startJ].key > tmpMas[startJ + 1].key) then    //���� ����������� ����� � ������, ������� ������� ����� �� ������
        begin
          repeat
            Mas[i]:= tmpMas[endJ];
            Inc(i);
            Dec(endJ);
            ChangeListBox(lbMas, mas);
          until tmpMas[endJ].key > tmpMas[endJ - 1].key;
        end;
      if tmpMas[endJ].key > tmpMas[endJ - 1].key then    //���� ����������� ����� � ������, ������� ������� ����� �� ������
        begin
          repeat
            Mas[i]:= tmpMas[startJ];
            Inc(i);
            inc(startJ);
            ChangeListBox(lbMas, mas);
          until tmpMas[startJ].key > tmpMas[startJ + 1].key;
        end;
    end;
    ClearArr(tmpMas);
    ChangeListBox(lbTmpMas, tmpMas);
  end;

end;

end.
