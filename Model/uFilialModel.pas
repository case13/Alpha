﻿unit uFilialModel;

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
    TFilialModel = class

    private
      FCNPJ : string;
      FDescricao : string;
      FUF : string;
      FCidade : string;
      FBairro : string;
      FEndereco : string;
      FComplementoEnd : string;
      FFilialStatus : string;
      FEmpresaId : integer;

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
      property CNPJ: string read FCNPJ write FCNPJ;
      property Descricao: string read FDescricao write FDescricao;
      property UF: string read FUF write FUF;
      property Cidade: string read FCidade write FCidade;
      property Bairro: string read FBairro write FBairro;
      property Endereco: string read FEndereco write FEndereco;
      property ComplementoEnd: string read FComplementoEnd write FComplementoEnd;
      property FilialStatus: string read FFilialStatus write FFilialStatus;
      property EmpresaId: integer read FEmpresaId write FEmpresaId;
                      

      // Propriedade estática preenchida por get e set.
      class property Id: integer read GetId write SetId;
      class property Campo: string read GetCampoPesquisa write SetCampoPesquisa;
      class property Filtro: string read GetFiltro write SetFiltro;
      class property Ordem: string read GetOrdem write SetOrdem;
      class property TelaRetornar: string read GetTelaRetornar write SetTelaRetornar;


      function ValidarCampos(FilialJSON: TJSONObject): string;
      function Incluir(FilialJSON: TJSONObject): string;
      function Alterar(FilialJSON: TJSONObject): string;
      function ConsultarFilialId(Id: Integer): TJSONObject;
      function ConsultarFilialLike(FilialModel : TFilialModel) : TJSONObject;
      function GetStatus : string;

  end;

implementation
   uses uFilialDAO;

{ TFilialModel }

class function TFilialModel.GetOrdem: string;
begin
  result := FOrdem;
end;

function TFilialModel.GetStatus : string;
var
  DAO : TFilialDAO;
begin
  DAO := TFilialDAO.Create;
  result := DAO.GetStatus(Self);
end;

class function TFilialModel.GetTelaRetornar: string;
begin
  result := FTelaRetornar;
end;

class procedure TFilialModel.SetTelaRetornar(const Value: string);
begin
  FTelaRetornar := Value;
end;

class procedure TFilialModel.SetOrdem(value: string);
begin
  FOrdem := value;
end;

class function TFilialModel.GetFiltro: string;
begin
  result := FFiltro;
end;

class procedure TFilialModel.SetFiltro(value: string);
begin
  FFiltro := value;
end;

class function TFilialModel.GetId: integer;
begin
  result := FId;
end;

class procedure TFilialModel.SetId(const value: integer);
begin
  FId := value;
end;


class function TFilialModel.GetCampoPesquisa: string;
begin
  result := FCampo;
end;


class procedure TFilialModel.SetCampoPesquisa(const Value: string);
begin
  FCampo := Value;
end;


function TFilialModel.ConsultarFilialId(Id: Integer): TJSONObject;
var
  DAO : TFilialDAO;
begin
  DAO := TFilialDAO.Create;
  result := DAO.ConsultarFilialId(Id);
end;

function TFilialModel.ConsultarFilialLike(FilialModel : TFilialModel): TJSONObject;
var
  DAO : TFilialDAO;
begin
  DAO := TFilialDAO.Create;
  result := DAO.ConsultarFilialLike(self);
end;



function TFilialModel.Alterar(FilialJSON: TJSONObject): string;
var
  checagem : string;
begin
 checagem := ValidarCampos(FilialJSON);
 if checagem = '' then
  begin
    var DAO := TFilialDAO.Create;
    result := DAO.Alterar(FilialJSON);
  end
 else
  result := checagem;
end;

function TFilialModel.Incluir(FilialJSON: TJSONObject): string;
var
  checagem : string;
begin
 checagem := ValidarCampos(FilialJSON);
 if checagem = '' then
  begin
    var DAO := TFilialDAO.Create;
    result := DAO.Incluir(FilialJSON);
  end
 else
  result := checagem;
end;




function TFilialModel.ValidarCampos(FilialJSON: TJSONObject): string;
begin

  CNPJ := FilialJSON.GetValue('CNPJ').Value;
  Descricao := FilialJSON.GetValue('Descricao').Value;
  UF := FilialJSON.GetValue('UF').Value;
  Cidade := FilialJSON.GetValue('Cidade').Value;
  Bairro := FilialJSON.GetValue('Bairro').Value;
  Endereco := FilialJSON.GetValue('Endereco').Value;
  
  // Verificar se os campos obrigat�rios est�o preenchidos
  if CNPJ = '' then
    result := 'Informe o CNPJ da filial!';
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