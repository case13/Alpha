unit uEscolaDAO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, uConexaoMySQL, System.JSON,
  Data.DBXJSON, REST.JSON, uEscolaModel;

  type
    TEscolaDAO = class
      private
        FConexao : TConexaoMySQL;
      public
        constructor Create;
        function ConsultarEscolaLike(Model : TEscolaModel) : TJSONObject;
        function ConsultarEscolaId(Id : Integer) : TJSONObject;
        function Incluir(Model : TEscolaModel) : string;
        function Alterar(Model : TEscolaModel) : string;
        procedure PreencherParametros(Model : TEscolaModel; Query : TFDQuery);

    end;

implementation

{ TFilialDAO }

procedure TEscolaDAO.PreencherParametros(Model : TEscolaModel; Query : TFDQuery);
begin
  with Query do
   begin
     if Model.Id <> 0 then
      ParamByName('Id').AsInteger := Model.Id;

      ParamByName('Descricao').AsString := Model.Descricao;
      ParamByName('UF').AsString := Model.UF;
      ParamByName('Cidade').AsString := Model.Cidade;
      ParamByName('Bairro').AsString := Model.Bairro;
      ParamByName('Endereco').AsString := Model.Endereco;
      ParamByName('ComplementoEnd').AsString := Model.ComplementoEnd;
      ParamByName('FilialId').AsInteger := Model.FilialId;
   end;
end;


function TEscolaDAO.Incluir(Model: TEscolaModel): string;
var
  Query : TFDQuery;
begin
  try
    Query := FConexao.criarQuery;
     try
       With Query do
        begin
         SQL.Add('insert into Filial');
         SQL.Add('(Descricao, UF, Cidade, Bairro, Endereco, ComplementoEnd, FilialId)');
         SQL.Add('values');
         SQL.Add('(:Descricao, :UF, :Cidade, :Bairro, :Endereco, :ComplementoEnd, :FilialId)');
         PreencherParametros(Model,Query);
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


function TEscolaDAO.Alterar(Model: TEscolaModel): string;
var
 Query : TFDQuery;
 begin
 try
   Query := FConexao.criarQuery;
    try
      with Query do
       begin
         SQL.Add('update Escola');
         sql.Add('set Descricao = :Descricao, UF = :UF, Cidade = :Cidade, Bairro = :Bairro, Endereco = :Endereco,');
         Sql.Add('ComplementoEnd = :ComplementoEnd, FilialId = :FilialId');
         sql.Add('where Id = :Id');
          PreencherParametros(Model,Query);
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

function TEscolaDAO.ConsultarEscolaId(Id: Integer): TJSONObject;
var
 Query : TFDQuery;
 ObjJSON : TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query := FConexao.criarQuery;
    Query.SQL.Text := 'SELECT * FROM Escola WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := Id;
    Query.Open;

     if not Query.IsEmpty then
      begin
        try
          ObjJSON := TJSONObject.Create;
          With ObjJSON do
           begin
            AddPair('Id', Query.FieldByName('Id').AsString);
            AddPair('Descricao', Query.FieldByName('Descricao').AsString);
            AddPair('UF', Query.FieldByName('UF').AsString);
            AddPair('Cidade', Query.FieldByName('Cidade').AsString);
            AddPair('Bairro', Query.FieldByName('Bairro').AsString);
            AddPair('Endereco', Query.FieldByName('Endereco').AsString);
            AddPair('ComplementoEnd', Query.FieldByName('ComplementoEnd').AsString);
            AddPair('FilialId', Query.FieldByName('FilialId').AsString);
           end;
        finally
          Result := ObjJSON;
        end;
      end
     else
      Result := TJSONObject.Create;

  finally
    ObjJSON.Free;
    Query.Free;
  end;
end;

function TEscolaDAO.ConsultarEscolaLike(Model : TEscolaModel): TJSONObject;
var
 Query : TFDQuery;
 JSONArr: TJSONArray;
 JSONObj: TJSONObject;
begin
  try
    JSONArr := TJSONArray.Create;
    Result := TJSONObject.Create;
    Query := FConexao.criarQuery;

    var vCampo := Model.Campo;
    var vFiltro := Model.Filtro;
    var vOrdem := Model.Ordem;

    if vCampo = '' then
      vCampo := 'Id';

    if vOrdem = '' then
      vOrdem := 'Asc';


    With Query do
     begin
       SQL.Add('select * from Escola');
       SQL.Add('where ' + vCampo + ' like ''%' + vFiltro + '%''');
       SQL.Add('Order by ' + vCampo + ' ' + vOrdem);
       Open;
       JSONArr := TJSONArray.Create;
        while not EOF do
         begin
            JSONObj := TJSONObject.Create;
            JSONObj.AddPair('Id', FieldByName('Id').AsString);
            JSONObj.AddPair('Descricao', FieldByName('Descricao').AsString);
            JSONObj.AddPair('UF', FieldByName('UF').AsString);
            JSONObj.AddPair('Cidade', FieldByName('Cidade').AsString);
            JSONObj.AddPair('Bairro', FieldByName('Bairro').AsString);
            JSONObj.AddPair('Endereco', FieldByName('Endereco').AsString);
            JSONObj.AddPair('ComplementoEnd', FieldByName('ComplementoEnd').AsString);
            JSONObj.AddPair('FilialId', FieldByName('FilialId').AsString);
            JSONArr.AddElement(JSONObj);
           Next;
         end;

      if JSONArr.Count > 0 then
        Result.AddPair('Escolas', JSONArr)
      else
        Result.AddPair('Escolas', TJSONArray.Create); // Retorna um JSON vazio

     end;
  finally
    Query.Free;
  end;
end;

constructor TEscolaDAO.Create;
begin
   FConexao := TConexaoMySQL.Create;
end;



end.