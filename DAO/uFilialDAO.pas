unit uFilialDAO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, uConexaoMySQL, System.JSON,
  Data.DBXJSON, REST.JSON, uFilialModel;

  type
    TFilialDAO = class
      private
        FConexao : TConexaoMySQL;
      public
        constructor Create;
        function ConsultarFilialLike(FilialModel : TFilialModel) : TJSONObject;
        function ConsultarFilialId(Id : Integer) : TJSONObject;
        function Incluir(FilialJSON : TJSONObject) : string;
        function Alterar(FilialJSON : TJSONObject) : string;
        function GetStatus(Model : TFilialModel) : String;


    end;

implementation

{ TFilialDAO }

function TFilialDAO.GetStatus(Model : TFilialModel) : String;
var Query : TFDQuery;
begin
 try
  try
     Query := FConexao.criarQuery;
     with Query do
      begin
        Sql.Add('select FilialStatus from Filial');
        Sql.Add('where Id = :Id');
         Params[0].AsInteger := Model.Id;
        Open;
         result := FieldByName('FilialStatus').AsString;
      end;
  finally
    Query.Free;
  end;
 except
    Query.Free;
 end;
end;

function TFilialDAO.Incluir(FilialJSON: TJSONObject): string;
var
  Query : TFDQuery;
begin
  try
    Query := FConexao.criarQuery;
     try
       With Query do
        begin
         SQL.Add('insert into Filial');
         SQL.Add('(CNPJ, Descricao, UF, Cidade, Bairro, Endereco, ComplementoEnd, FilialStatus, EmpresaId)');
         SQL.Add('values');
         SQL.Add('(:CNPJ, :Descricao, :UF, :Cidade, :Bairro, :Endereco, :ComplementoEnd, :FilialStatus, :EmpresaId)');
          ParamByName('CNPJ').AsString := FilialJSON.GetValue<string>('CNPJ', '');
          ParamByName('Descricao').AsString := FilialJSON.GetValue<string>('Descricao', '');
          ParamByName('UF').AsString := FilialJSON.GetValue<string>('UF', '');
          ParamByName('Cidade').AsString := FilialJSON.GetValue<string>('Cidade', '');
          ParamByName('Bairro').AsString := FilialJSON.GetValue<string>('Bairro', '');
          ParamByName('Endereco').AsString := FilialJSON.GetValue<string>('Endereco', '');
          ParamByName('ComplementoEnd').AsString := FilialJSON.GetValue<string>('ComplementoEnd', '');
          ParamByName('FilialStatus').AsString := 'ATIVO';
          ParamByName('EmpresaId').AsInteger := FilialJSON.GetValue<integer>('EmpresaId', 0);
         ExecSQL;
        end;
        result := 'Incluido';
     except
       result := 'Falha ao tentar INCLUIR novo registro!';
       Query.Free;
     end;
  finally
    Query.Free;
  end;
end;


function TFilialDAO.Alterar(FilialJSON: TJSONObject): string;
var
 Query : TFDQuery;
 begin
 try
   Query := FConexao.criarQuery;
    try
      with Query do
       begin
         SQL.Add('update Filial');
         sql.Add('set CNPJ = :CNPJ, Descricao = :Descricao, UF = :UF, Cidade = :Cidade, Bairro = :Bairro, Endereco = :Endereco,');
         Sql.Add('ComplementoEnd = :ComplementoEnd, FilialStatus = :FilialStatus, EmpresaId = :EmpresaId');
         sql.Add('where Id = :Id');
          ParamByName('CNPJ').AsString := FilialJSON.GetValue<string>('CNPJ', '');
          ParamByName('Descricao').AsString := FilialJSON.GetValue<string>('Descricao', '');
          ParamByName('UF').AsString := FilialJSON.GetValue<string>('UF', '');
          ParamByName('Cidade').AsString := FilialJSON.GetValue<string>('Cidade', '');
          ParamByName('Bairro').AsString := FilialJSON.GetValue<string>('Bairro', '');
          ParamByName('Endereco').AsString := FilialJSON.GetValue<string>('Endereco', '');
          ParamByName('ComplementoEnd').AsString := FilialJSON.GetValue<string>('ComplementoEnd', '');
          ParamByName('FilialStatus').AsString := FilialJSON.GetValue<string>('FilialStatus', '');
          ParamByName('EmpresaId').AsInteger := FilialJSON.GetValue<integer>('EmpresaId', 0);
          ParamByName('Id').AsInteger := FilialJSON.GetValue<integer>('Id', 0);
         ExecSQL;
       end;
       result := 'Editado';
    except
      result := 'Falha ao tentar ALTERAR o registro!';
      Query.Free;
    end;
 finally
   Query.Free;
 end;
end;

function TFilialDAO.ConsultarFilialId(Id: Integer): TJSONObject;
var Query : TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query := FConexao.criarQuery;
    Query.SQL.Text := 'SELECT * FROM Filial WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := Id;
    Query.Open;

     if not Query.IsEmpty then
      begin
        Result := TJSONObject.Create;
        Result.AddPair('Id', Query.FieldByName('Id').AsString);
        Result.AddPair('CNPJ', Query.FieldByName('CNPJ').AsString);
        Result.AddPair('Descricao', Query.FieldByName('Descricao').AsString);
        Result.AddPair('UF', Query.FieldByName('UF').AsString);
        Result.AddPair('Cidade', Query.FieldByName('Cidade').AsString);
        Result.AddPair('Bairro', Query.FieldByName('Bairro').AsString);
        Result.AddPair('Endereco', Query.FieldByName('Endereco').AsString);
        Result.AddPair('ComplementoEnd', Query.FieldByName('ComplementoEnd').AsString);
        Result.AddPair('FilialStatus', Query.FieldByName('FilialStatus').AsString);
        Result.AddPair('EmpresaId', Query.FieldByName('EmpresaId').AsString);
      end
    else
     begin
        Result := TJSONObject.Create;
     end;
  finally
    Query.Free;
  end;
end;

function TFilialDAO.ConsultarFilialLike(FilialModel : TFilialModel): TJSONObject;
var
 Query : TFDQuery;
 JSONArr: TJSONArray;
 JSONObj: TJSONObject;
begin
  try
    JSONArr := TJSONArray.Create;
    Result := TJSONObject.Create;
    Query := FConexao.criarQuery;

    var vCampo := FilialModel.Campo;
    var vFiltro := FilialModel.Filtro;
    var vOrdem := FilialModel.Ordem;

    if vCampo = '' then
      vCampo := 'Id';

    if vOrdem = '' then
      vOrdem := 'Asc';


    With Query do
     begin
       SQL.Add('select * from Filial');
       SQL.Add('where ' + vCampo + ' like ''%' + vFiltro + '%''');
       SQL.Add('Order by ' + vCampo + ' ' + vOrdem);
       Open;
       JSONArr := TJSONArray.Create;
        while not EOF do
         begin
            JSONObj := TJSONObject.Create;
            JSONObj.AddPair('Id', FieldByName('Id').AsString);
            JSONObj.AddPair('CNPJ', FieldByName('CNPJ').AsString);
            JSONObj.AddPair('Descricao', FieldByName('Descricao').AsString);
            JSONObj.AddPair('UF', FieldByName('UF').AsString);
            JSONObj.AddPair('Cidade', FieldByName('Cidade').AsString);
            JSONObj.AddPair('Bairro', FieldByName('Bairro').AsString);
            JSONObj.AddPair('Endereco', FieldByName('Endereco').AsString);
            JSONObj.AddPair('ComplementoEnd', FieldByName('ComplementoEnd').AsString);
            JSONObj.AddPair('FilialStatus', FieldByName('FilialStatus').AsString);
            JSONObj.AddPair('EmpresaId', FieldByName('EmpresaId').AsString);
            JSONArr.AddElement(JSONObj);
           Next;
         end;

      if JSONArr.Count > 0 then
        Result.AddPair('Filiais', JSONArr)
      else
        Result.AddPair('Filiais', TJSONArray.Create); // Retorna um JSON vazio

     end;
  finally
    Query.Free;
  end;
end;

constructor TFilialDAO.Create;
begin
   FConexao := TConexaoMySQL.Create;
end;



end.
