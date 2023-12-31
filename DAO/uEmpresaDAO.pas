unit uEmpresaDAO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, uConexaoMySQL, System.JSON,
  Data.DBXJSON, REST.JSON;


  type

   TEmpresaDAO = class
     private
       FConexaoMySQL : TConexaoMySQL;

     public
       constructor Create(Conexao: TConexaoMySQL);
       function ConsultarEmpresasEmJSON: string;
       function ConsultarEmpresaLikeJSON(filtro : string) : TJSONObject;
       function ConsultarEmpresaIdJSON(Id: Integer): TJSONObject;
       function IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
       function AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;


     end;

implementation

function TEmpresaDAO.AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query := FConexaoMySQL.criarQuery;

    try
      with Query do
       begin
         SQL.Add('UPDATE EMPRESA');
         SQL.Add('SET CNPJ = :CNPJ, RAZAOSOCIAL = :RAZAOSOCIAL,');
         SQL.Add('NOMEFANTASIA = :NOMEFANTASIA, CABECALHO = :CABECALHO,');
         SQL.Add('RODAPE = :RODAPE, EMPRESASTATUS = :EMPRESASTATUS');
         SQL.Add('WHERE ID = :ID');

          var Id := StrToInt(EmpresaJSON.GetValue<string>('Id', ''));
          ParamByName('Id').AsInteger := Id;
          ParamByName('CNPJ').AsString := EmpresaJSON.GetValue<string>('CNPJ', '');
          ParamByName('RazaoSocial').AsString := EmpresaJSON.GetValue<string>('RazaoSocial', '');
          ParamByName('NomeFantasia').AsString := EmpresaJSON.GetValue<string>('NomeFantasia', '');
          ParamByName('Cabecalho').AsString := EmpresaJSON.GetValue<string>('Cabecalho', '');
          ParamByName('Rodape').AsString := EmpresaJSON.GetValue<string>('Rodape', '');
          ParamByName('EmpresaStatus').AsString := EmpresaJSON.GetValue<string>('EmpresaStatus', '');

         ExecSQL;
       end;
       result := 'ALTERA��O feita com sucesso!';
    except
      result := 'FALHA na tantativa de ALTERAR o registro!';
    end;
    finally
    Query.Free;
  end;
end;


function TEmpresaDAO.IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query := FConexaoMySQL.criarQuery;

    try
      with Query do
       begin
         SQL.Add('INSERT INTO EMPRESA');
         SQL.Add('(CNPJ, RAZAOSOCIAL, NOMEFANTASIA, CABECALHO, RODAPE, EMPRESASTATUS)');
         SQL.Add('VALUES');
         SQL.Add('(:CNPJ, :RAZAOSOCIAL, :NOMEFANTASIA, :CABECALHO, :RODAPE, :EMPRESASTATUS)');

          ParamByName('CNPJ').AsString := EmpresaJSON.GetValue<string>('CNPJ', '');
          ParamByName('RazaoSocial').AsString := EmpresaJSON.GetValue<string>('RazaoSocial', '');
          ParamByName('NomeFantasia').AsString := EmpresaJSON.GetValue<string>('NomeFantasia', '');
          ParamByName('Cabecalho').AsString := EmpresaJSON.GetValue<string>('Cabecalho', '');
          ParamByName('Rodape').AsString := EmpresaJSON.GetValue<string>('Rodape', '');
          ParamByName('EmpresaStatus').AsString := EmpresaJSON.GetValue<string>('EmpresaStatus', '');

         ExecSQL;
       end;
       result := 'INCLUS�O feita com sucesso!';
    except
      result := 'FALHA na tentativa de INCLUIR o novo registro!';
    end;
  finally
    Query.Free;
  end;
end;


function TEmpresaDAO.ConsultarEmpresaIdJSON(Id: Integer): TJSONObject;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query := FConexaoMySQL.criarQuery;
    Query.SQL.Text := 'SELECT * FROM EMPRESA WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := Id;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := TJSONObject.Create;
      Result.AddPair('Id', Query.FieldByName('Id').AsString);
      Result.AddPair('CNPJ', Query.FieldByName('CNPJ').AsString);
      Result.AddPair('RazaoSocial', Query.FieldByName('RazaoSocial').AsString);
      Result.AddPair('NomeFantasia', Query.FieldByName('NomeFantasia').AsString);
      Result.AddPair('Cabecalho', Query.FieldByName('Cabecalho').AsString);
      Result.AddPair('Rodape', Query.FieldByName('Rodape').AsString);
      Result.AddPair('EmpresaStatus', Query.FieldByName('EmpresaStatus').AsString);
    end
    else
    begin
      Result := TJSONObject.Create; // Retorna um objeto JSON vazio se a empresa n�o for encontrada
    end;
  finally
    Query.Free;
  end;
end;


function TEmpresaDAO.ConsultarEmpresaLikeJSON(filtro: string): TJSONObject;
var
  Query: TFDQuery;
  JSONArr: TJSONArray;
  JSONObj: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  JSONArr := TJSONArray.Create;
  Result := TJSONObject.Create;

  try
    Query := FConexaoMySQL.criarQuery;
    with Query do
    begin
      SQL.Add('SELECT * FROM Empresa');
      SQL.Add('WHERE CNPJ LIKE ''%'+Filtro+'%'' OR');
      SQL.Add('RazaoSocial LIKE ''%'+Filtro+'%'' OR');
      SQL.Add('NomeFantasia LIKE ''%'+Filtro+'%'' OR');
      SQL.Add('EmpresaStatus LIKE ''%'+Filtro+'%''');
      Open;
       var Contagem := Query.RecordCount;


      JSONArr := TJSONArray.Create;
      while not EOF do
      begin
        JSONObj := TJSONObject.Create;
        JSONObj.AddPair('Id', FieldByName('Id').AsString);
        JSONObj.AddPair('CNPJ', FieldByName('CNPJ').AsString);
        JSONObj.AddPair('RazaoSocial', FieldByName('RazaoSocial').AsString);
        JSONObj.AddPair('NomeFantasia', FieldByName('NomeFantasia').AsString);
        JSONObj.AddPair('Cabecalho', FieldByName('Cabecalho').AsString);
        JSONObj.AddPair('Rodape', FieldByName('Rodape').AsString);
        JSONObj.AddPair('EmpresaStatus', FieldByName('EmpresaStatus').AsString);
        JSONArr.AddElement(JSONObj);
        Next;
      end;

      if JSONArr.Count > 0 then
        Result.AddPair('Empresas', JSONArr)
      else
        Result.AddPair('Empresas', TJSONArray.Create); // Retorna um JSON vazio

    end;
  finally
    Query.Free;
  end;
end;


function TEmpresaDAO.ConsultarEmpresasEmJSON: string;
var
  Query: TFDQuery;
  JSONArr: TJSONArray;
  JSONObj: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  JSONArr := TJSONArray.Create;
  try
    Query := FConexaoMySQL.criarQuery;
    Query.SQL.Text := 'SELECT * FROM EMPRESA';
    Query.Open;

    while not Query.Eof do
    begin
      JSONObj := TJSONObject.Create;
      JSONObj.AddPair('Id', Query.FieldByName('Id').AsString);
      JSONObj.AddPair('CNPJ', Query.FieldByName('CNPJ').AsString);
      JSONObj.AddPair('RazaoSocial', Query.FieldByName('RazaoSocial').AsString);
      JSONObj.AddPair('NomeFantasia', Query.FieldByName('NomeFantasia').AsString);
      JSONObj.AddPair('Cabecalho', Query.FieldByName('Cabecalho').AsString);
      JSONObj.AddPair('Rodape', Query.FieldByName('Rodape').AsString);
      JSONObj.AddPair('EmpresaStatus', Query.FieldByName('EmpresaStatus').AsString);
      JSONArr.AddElement(JSONObj);
      Query.Next;
    end;

    if JSONArr.Count > 0 then
     begin
       Result := JSONArr.ToJSON;
     end
    else
     begin
       Result := '[]';
     end;
  finally
    Query.Free;
    JSONArr.Free;
  end;
end;


constructor TEmpresaDAO.Create(Conexao: TConexaoMySQL);
begin
  FConexaoMySQL := TConexaoMySQL.Create;
end;


end.
