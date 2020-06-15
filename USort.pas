unit USort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, TeEngine, Series, TeeProcs, Chart,
  ComCtrls;                 

const
  N = 10;   //количество элементов в демонстрационном массиве для сортировки
  DefaultValue = MaxInt;   //значение по умолчанию для очистки массива
  ssleep = 400;   //задержка в мс

type
  TElem = record
    key: Integer;
    info: string;
  end;
  TMas = array[1..N] of TElem;   //тип-массив

  procedure RandomFill(var mas: TMas);  //заполнение массива случайными числами
  function ToString(var mas: TMas): string;    //возвращат массив в виде строки
  function Split(var mas: TMas; var tmpMas: TMas; var lbTmpMas: TListBox): Integer;    //разбивает исходный массив на серии для сортировки
  procedure NaturalMergeSort(var mas: TMas; var tmpMas: TMas; var lbMas: TListBox; var lbTmpMas: TListBox); //сливает серии в исходный массив

implementation

//заполнение массива случайными числами
procedure RandomFill(var mas: TMas);
var
  i: Integer;
begin
  Randomize;
  for i:= 1 to N do
    mas[i].key:= Random(100);
end;

//возвращат массив в виде строки
function ToString(var mas: TMas): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to N do
    Result:= Result + IntToStr(mas[i].key) + '  ';
end;

//меняет содержимое ListBox
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

//очищает массив (используется в конце очередной фазы для более наглядного отображения в ListBox)
procedure ClearArr(var arr: TMas);
var i: Integer;
begin
  for i:= 1 to N do
    arr[i].key:= DefaultValue;
end;

//разбивает исходный массив на серии для сортировки
function Split(var Mas: TMas; var tmpMas: TMas; var lbTmpMas: TListBox): Integer;
var
  i: Integer;
  startJ, endJ: Integer;     //индексы конца и начала вспомогательного массива
  direction: Boolean;      //направление заполнения вспомогательного массива (True - слева направо, False - справа налево)
begin
  i:= 1;
  startJ:= 1;
  endJ:= N;
  tmpMas[startJ]:= Mas[i];         //первая серия начинается с левого конца вспомогательного массива
  ChangeListBox(lbTmpMas, tmpMas);    //отображаем изменения временного массива на соответствующем ListBox
  inc(startJ);
  Inc(i);
  direction:= True;
  Result:= 1;
  while i <= N do                       //проход по всему исходному массиву
  begin
    if Mas[i].key >= Mas[i-1].key then     //если очередной элемент больше предыдущего, серия продолжается, направление остаётся прежним
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
    else                               //если упорядоченность нарушается, серия прерывается
    begin
      direction:= not direction;       //меняем направление на противоположное
      Inc(Result);
      if direction = True then            //и записываем элемент
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
    ChangeListBox(lbTmpMas, tmpMas);      //отображаем изменения вспомогательного массива
  end;

end;

//сливает серии в исходный массив
procedure NaturalMergeSort (var Mas: TMas; var tmpMas: TMas; var lbMas: TListBox; var lbTmpMas: TListBox);
var
  i, startJ, endJ: Integer;
begin
  while Split(Mas, tmpMas, lbTmpMas) > 1 do       
  begin
    ClearArr(Mas);                                //очищаем исходный массив чтобы было лучше видно как он будет изменяться
    ChangeListBox(lbMas, mas);
    i:= 1; startJ:= 1; endJ:= N;
    while i <= N do
    begin
      repeat                  //сливаем из обеих серий пока какая-нибудь из них не закончится или не закончится вспомогательный массив
        if tmpMas[startJ].key < tmpMas[endJ].key then          //сравниваем элементы из двух серий, в исходный массив записываем наименьший
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
        ChangeListBox(lbMas, mas);                   //отображаем изменения массива
      until (startJ = N) or (tmpMas[startJ].key > tmpMas[startJ + 1].key) or (tmpMas[endJ].key > tmpMas[endJ - 1].key);

      if (startJ < N) and (tmpMas[startJ].key > tmpMas[startJ + 1].key) then    //если закончилась серия в начале, сливаем остаток серии из хвоста
        begin
          repeat
            Mas[i]:= tmpMas[endJ];
            Inc(i);
            Dec(endJ);
            ChangeListBox(lbMas, mas);
          until tmpMas[endJ].key > tmpMas[endJ - 1].key;
        end;
      if tmpMas[endJ].key > tmpMas[endJ - 1].key then    //если закончилась серия в хвосте, сливаем остаток серии из начала
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
