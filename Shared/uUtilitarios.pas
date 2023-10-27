unit uUtilitarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, ExtCtrls, DBGrids, System.UITypes,
  System.JSON, Data.DBXJSON, REST.JSON, uEmpresaDAO, Datasnap.DBClient, System.Generics.Collections,
  System.Rtti, System.TypInfo, uEmpresaController;


  procedure IluminarPainel(Painel : TPanel; MudarCor : Boolean);
  procedure AbrirTela(Formulario : TForm; Tipo : string);
  procedure PreencherClientDataSet(Tela: TForm; JSONObj: TJSONObject; const DataSetNome: string);
  procedure NegritarColuna(DBGrid: TDBGrid; NomeColuna: string);
  procedure OrdenarClientDataSet(ClientDataSet: TClientDataSet; const Campo: string);
  procedure OperacaoStatus(CodigoPK : Integer; Legenda : TLabel);
  function GerarJSONCadastro(Form : TForm; CodigoPK : integer; Status : string) : TJSONObject;





implementation

{ TUtilitarios }

function GerarJSONCadastro(Form : TForm; CodigoPK : integer; Status : string) : TJSONObject;
var
  i: Integer;
  Component: TComponent;
  Control: TControl;
begin

  Result := TJSONObject.Create;

  Result.AddPair('Id', IntToStr(CodigoPk));

  if Status <> '' then
   Result.AddPair('FilialStatus', Status);

  var EmpresaCtrl := TEmpresaController.Create;
  var EmpId := EmpresaCtrl.GetId;
  Result.AddPair('EmpresaId', IntToStr(EmpId));

  try
    for i := 0 to Form.ComponentCount - 1 do
    begin
      Component := Form.Components[i];
      if Component is TEdit then
      begin
        Control := TControl(Component);
        Result.AddPair(TEdit(Control).Name, TJSONString.Create(TEdit(Control).Text));
      end
      else if Component is TComboBox then
      begin
        Control := TControl(Component);
        Result.AddPair(TComboBox(Control).Name, TJSONString.Create(TComboBox(Control).Text));
      end
      else if Component is TRadioButton then
      begin
        Control := TControl(Component);
        if TRadioButton(Control).Checked then
          Result.AddPair(TRadioButton(Control).Name, TJSONTrue.Create)
        else
          Result.AddPair(TRadioButton(Control).Name, TJSONFalse.Create);
      end
      else if Component is TCheckBox then
      begin
        Control := TControl(Component);
        if TCheckBox(Control).Checked then
          Result.AddPair(TCheckBox(Control).Name, TJSONTrue.Create)
        else
          Result.AddPair(TCheckBox(Control).Name, TJSONFalse.Create);
      end

      // Adicione mais tipos de componentes conforme necess�rio (por exemplo, TMemo, TListBox, etc.)
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure OperacaoStatus(CodigoPK : Integer; Legenda : TLabel);
begin
  try
    if CodigoPk = 0 then
     begin
      Legenda.Caption := 'Novo Registro';
      Legenda.Font.Color := clGreen;
     end
    else
     begin
      Legenda.Caption := 'Editando Registro [ C�d.: ' + IntToStr(CodigoPk) + ' ]';
      Legenda.Font.Color := clBlue;
     end;
  except

  end;

end;

procedure OrdenarClientDataSet(ClientDataSet: TClientDataSet; const Campo: string);
var
  IndexName: string;
  IndexDef: TIndexDef;
  IndexIdx: Integer;
  NewIndexDef: TIndexDef;
begin
  IndexName := Campo;
  IndexIdx := -1;

  // Verifica se o �ndice com o mesmo nome j� existe
  for IndexIdx := 0 to ClientDataSet.IndexDefs.Count - 1 do
  begin
    if ClientDataSet.IndexDefs[IndexIdx].Name = IndexName then
    begin
      // O �ndice com o mesmo nome foi encontrado
      // Alterna a ordem
      IndexDef := ClientDataSet.IndexDefs[IndexIdx];

      if ixDescending in IndexDef.Options then
        IndexDef.Options := [] // Alterna para ordem crescente
      else
        IndexDef.Options := [ixDescending]; // Alterna para ordem decrescente

      // Atualiza o �ndice
      ClientDataSet.IndexName := IndexName;
      ClientDataSet.First;
      Exit;
    end;
  end;

  // Se o �ndice n�o foi encontrado, cria um novo �ndice em ordem crescente
  NewIndexDef := ClientDataSet.IndexDefs.AddIndexDef;
  NewIndexDef.Name := IndexName;
  NewIndexDef.Fields := Campo;
  NewIndexDef.Options := [ixCaseInsensitive];
  ClientDataSet.IndexName := IndexName;
  ClientDataSet.First;
end;


procedure NegritarColuna(DBGrid: TDBGrid; NomeColuna: string);
var
  I: Integer;
  Coluna: TColumn;
begin
  if NomeColuna = '' then
    NomeColuna := DBGrid.Columns[0].FieldName;

  // Desmarcar todas as colunas como negrito
  for I := 0 to DBGrid.Columns.Count - 1 do
  begin
    Coluna := DBGrid.Columns[I];
    Coluna.Title.Font.Style := Coluna.Title.Font.Style - [fsBold];
  end;

  // Marcar a coluna especificada como negrito
  for I := 0 to DBGrid.Columns.Count - 1 do
  begin
    Coluna := DBGrid.Columns[I];
    if CompareText(Coluna.FieldName, NomeColuna) = 0 then
    begin
      Coluna.Title.Font.Style := Coluna.Title.Font.Style + [fsBold];
      Break;
    end;
  end;
end;


procedure PreencherClientDataSet(Tela: TForm; JSONObj: TJSONObject; const DataSetNome: string);
var
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  JSONPair: TJSONPair;
  I: Integer;
  Campo, Valor: string;
  ClientDataSet: TClientDataSet;
begin
  // Encontrar o ClientDataSet no formul�rio com o nome especificado
  ClientDataSet := TClientDataSet(Tela.FindComponent(DataSetNome));
  if Assigned(ClientDataSet) and (JSONObj.TryGetValue<TJSONArray>('Filiais', JSONArray)) then
  begin
    ClientDataSet.EmptyDataSet;
    for I := 0 to JSONArray.Count - 1 do
    begin
      JSONValue := JSONArray.Items[I];
      if JSONValue is TJSONObject then
      begin
        ClientDataSet.Append;
        for JSONPair in TJSONObject(JSONValue) do
        begin
          Campo := JSONPair.JsonString.Value;
          Valor := JSONPair.JsonValue.Value;
          if Assigned(ClientDataSet.FieldByName(Campo)) then
          begin
            ClientDataSet.FieldByName(Campo).AsString := Valor;
          end;
        end;
        ClientDataSet.Post;
      end;
    end;
  end;
end;

procedure AbrirTela(Formulario : TForm; Tipo : string);
begin
  with Formulario do
   begin
     Caption := 'Alpha Tecnology';
     KeyPreview := true;

     if AnsiUpperCase(Tipo) = AnsiUpperCase('Normal') then
       Formulario.Show;

     if AnsiUpperCase(Tipo) = AnsiUpperCase('Modal') then
      begin
       Formulario.ShowModal;
       Position := poScreenCenter;
      end;
   end;
end;


procedure IluminarPainel(Painel: TPanel; MudarCor : Boolean);
begin
  if MudarCor = true then
   Painel.Color := clYellow
  else
   Painel.Color := $00C08000;
end;

end.
