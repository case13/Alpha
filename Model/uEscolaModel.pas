﻿unit uEscolaModel;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  System.JSON, Data.DBXJSON, REST.JSON;

  type
    TEscolaModel = class

    private
      FDescricao : string;
      FUF : string;
      FCidade : string;
      FBairro : string;
      FEndereco : string;
      FComplementoEnd : string;
      FFilialId : integer;

      class var
        FId : integer;
      class function GetId: integer; static;
      class procedure SetId(const value : integer); static;

      class var
        FCampo : string;
        FOrdem : string;
        FFiltro : string;
        FTelaRetornar : string;


      class function GetTelaRetornar: string; static;
      class procedure SetTelaRetornar(const Value: string); static;

      class function GetCampoPesquisa: string; static;
      class procedure SetCampoPesquisa(const Value: string); static;

      class function GetFiltro : string; static;
      class procedure SetFiltro(value : string); static;

      class function GetOrdem : string; static;
      class procedure SetOrdem(value : string); static;


    public
      property Descricao: string read FDescricao write FDescricao;
      property UF: string read FUF write FUF;
      property Cidade: string read FCidade write FCidade;
      property Bairro: string read FBairro write FBairro;
      property Endereco: string read FEndereco write FEndereco;
      property ComplementoEnd: string read FComplementoEnd write FComplementoEnd;
      property FilialId: integer read FFilialId write FFilialId;


      // Propriedade estática preenchida por get e set.
      class property Id: integer read GetId write SetId;
      class property Campo: string read GetCampoPesquisa write SetCampoPesquisa;
      class property Filtro: string read GetFiltro write SetFiltro;
      class property Ordem: string read GetOrdem write SetOrdem;
      class property TelaRetornar: string read GetTelaRetornar write SetTelaRetornar;


      function ValidarCampos : string;
      function Incluir : string;
      function Alterar : string;
      function ConsultarEscolaId(Id: Integer): TJSONObject;
      function ConsultarEscolaLike : TJSONObject;

      procedure PreencherPropriedades(EscolaJSON : TJSONObject);
      //function PrepararEscolaJSON : TJSONObject;

  end;

implementation
   uses uEscolaDAO;

{ TFilialModel }

class function TEscolaModel.GetOrdem: string;
begin
  result := FOrdem;
end;

class function TEscolaModel.GetTelaRetornar: string;
begin
  result := FTelaRetornar;
end;

class procedure TEscolaModel.SetTelaRetornar(const Value: string);
begin
  FTelaRetornar := Value;
end;

class procedure TEscolaModel.SetOrdem(value: string);
begin
  FOrdem := value;
end;

class function TEscolaModel.GetFiltro: string;
begin
  result := FFiltro;
end;

class procedure TEscolaModel.SetFiltro(value: string);
begin
  FFiltro := value;
end;

class function TEscolaModel.GetId: integer;
begin
  result := FId;
end;

class procedure TEscolaModel.SetId(const value: integer);
begin
  FId := value;
end;


class function TEscolaModel.GetCampoPesquisa: string;
begin
  result := FCampo;
end;


class procedure TEscolaModel.SetCampoPesquisa(const Value: string);
begin
  FCampo := Value;
end;


function TEscolaModel.ConsultarEscolaId(Id: Integer): TJSONObject;
var
  DAO : TEscolaDAO;
begin
  DAO := TEscolaDAO.Create;
  result := DAO.ConsultarEscolaId(Id);
end;

function TEscolaModel.ConsultarEscolaLike : TJSONObject;
var
  DAO : TEscolaDAO;
begin
  DAO := TEscolaDAO.Create;
  result := DAO.ConsultarEscolaLike(self);
end;



function TEscolaModel.Alterar : string;
var
  checagem : string;
begin
 checagem := ValidarCampos;
 if checagem = '' then
  begin
    var DAO := TEscolaDAO.Create;
    result := DAO.Alterar(Self);
  end
 else
  result := checagem;
end;

function TEscolaModel.Incluir : string;
var
  checagem : string;
begin
 checagem := ValidarCampos;
 if checagem = '' then
  begin
    var DAO := TEscolaDAO.Create;
    result := DAO.Incluir(Self);
  end
 else
  result := checagem;
end;


procedure TEscolaModel.PreencherPropriedades(EscolaJSON: TJSONObject);
begin
  Descricao := EscolaJSON.GetValue('Descricao').Value;
  UF := EscolaJSON.GetValue('UF').Value;
  Cidade := EscolaJSON.GetValue('Cidade').Value;
  Bairro := EscolaJSON.GetValue('Bairro').Value;
  Endereco := EscolaJSON.GetValue('Endereco').Value;
  ComplementoEnd := EscolaJSON.GetValue('ComplementoEnd').Value;
  FilialId := StrToInt(EscolaJSON.GetValue('FilialId').Value);
end;
{
function TEscolaModel.PrepararEscolaJSON: TJSONObject;
var
 JSONArr: TJSONArray;
 JSONObj: TJSONObject;
begin
  JSONArr := TJSONArray.Create;
  try
    JSONObj := TJSONObject.Create;
    JSONObj.AddPair(Id);
    JSONObj.AddPair('Descricao', FieldByName('Descricao').AsString);
            JSONObj.AddPair('UF', FieldByName('UF').AsString);
            JSONObj.AddPair('Cidade', FieldByName('Cidade').AsString);
            JSONObj.AddPair('Bairro', FieldByName('Bairro').AsString);
            JSONObj.AddPair('Endereco', FieldByName('Endereco').AsString);
            JSONObj.AddPair('ComplementoEnd', FieldByName('ComplementoEnd').AsString);
            JSONObj.AddPair('FilialId', FieldByName('FilialId').AsString);
            JSONArr.AddElement(JSONObj);
  finally

  end;
end;
 }
function TEscolaModel.ValidarCampos : string;
begin
  // Verificar se os campos obrigat�rios est�o preenchidos
  if Descricao = '' then
    result := 'Informe a DESCRIÇÃO da filial!';
  if UF = '' then
    result := 'Informe a UF da filial!';
  if Cidade = '' then
    result := 'Informe a CIDADE da filial!';
  if Bairro = '' then
    result := 'Informe o BAIRRO da filial!';
  if Endereco = '' then
    result := 'Informe o ENDEREÇO da filial!';

  result := '';

end;

end.
