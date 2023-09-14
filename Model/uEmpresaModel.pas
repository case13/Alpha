unit uEmpresaModel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  System.JSON, Data.DBXJSON, REST.JSON, uEmpresaDAO;
type

   TEmpresaModel = class
     private
       FId : integer;
       FCNPJ : string;
       FRazaoSocial : string;
       FNomeFantasia : string;
       FCabecalho : string;
       FRodape : string;
       FEmpresaStatus : string;

     public
       property Id: integer read FId write FId;
       property CNPJ: string read FCNPJ write FCNPJ;
       property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
       property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
       property Cabecalho: string read FCabecalho write FCabecalho;
       property Rodape: string read FRodape write FRodape;
       property EmpresaStatus: string read FEmpresaStatus write FEmpresaStatus;




       function IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
       function AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;
       function ConsultarEmpresaIdJSON(Id: Integer): TJSONObject;
       function ConsultarEmpresaLikeJSON(filtro: string): TJSONObject;
       function ValidarCampos(EmpresaJSON: TJSONObject): string;


     end;


implementation

{ TEmpresaModel }


function TEmpresaModel.ValidarCampos(EmpresaJSON: TJSONObject): string;
begin
  CNPJ := EmpresaJSON.GetValue('CNPJ').Value;
  RazaoSocial := EmpresaJSON.GetValue('RazaoSocial').Value;
  NomeFantasia := EmpresaJSON.GetValue('NomeFantasia').Value;
  Cabecalho := EmpresaJSON.GetValue('Cabecalho').Value;
  Rodape := EmpresaJSON.GetValue('Rodape').Value;
  EmpresaStatus := EmpresaJSON.GetValue('EmpresaStatus').Value;

  // Verificar se os campos obrigatórios estão preenchidos
  if CNPJ = '' then
    result := 'Informe um CNPJ válido!';
  if RazaoSocial = '' then
    result := 'Informe a RAZÃO SOCIAL da empresa!';
  if NomeFantasia = '' then
    result := 'Informe o NOME FANTASIA da empresa!';

  result := '';
end;



function TEmpresaModel.AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;
var
  checagem : string;
begin
  checagem := ValidarCampos(EmpresaJSON);
  if checagem = '' then
  begin
    var DAO := TEmpresaDAO.Create(nil);
    result := DAO.AlterarEmpresaJSON(EmpresaJSON);
  end;
  result := checagem;
end;

function TEmpresaModel.IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
var
  checagem : string;
begin
  checagem := ValidarCampos(EmpresaJSON);
  if checagem = '' then
  begin
    var DAO := TEmpresaDAO.Create(nil);
    result := DAO.IncluirEmpresaJSON(EmpresaJSON);
  end;
  result := checagem;
end;

function TEmpresaModel.ConsultarEmpresaLikeJSON(filtro: string): TJSONObject;
begin
  var DAO := TEmpresaDAO.Create(nil);
  result := DAO.ConsultarEmpresaLikeJSON(filtro);
end;

function TEmpresaModel.ConsultarEmpresaIdJSON(Id: Integer): TJSONObject;
begin
 var DAO := TEmpresaDAO.Create(nil);
 result := DAO.ConsultarEmpresaIdJSON(Id);
end;




end.
