unit uEmpresaController;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  System.JSON, Data.DBXJSON, REST.JSON, uEmpresaModel, uIEmpresaController;

  type
     TEmpresaController = class(TInterfacedObject, IEmpresaController)
     public
       function IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
       function AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;
       function ConsultarIdJSON(Id : integer) : TJSONObject;
       function ConsultarEmpresaLikeJSON(filtro: string): TJSONObject;

  end;

implementation

{ TEmpresaController }


function TEmpresaController.ConsultarEmpresaLikeJSON(filtro: string): TJSONObject;
begin
  var Model := TEmpresaModel.Create;
  result := Model.ConsultarEmpresaLikeJSON(filtro);
end;

function TEmpresaController.ConsultarIdJSON(Id : integer): TJSONObject;
begin
  var Model := TEmpresaModel.Create;
  result := Model.ConsultarEmpresaIdJSON(Id);
end;

function TEmpresaController.IncluirEmpresaJSON(EmpresaJSON: TJSONObject): string;
begin
 var Model := TEmpresaModel.Create;
 result := model.IncluirEmpresaJSON(EmpresaJSON);
end;

function TEmpresaController.AlterarEmpresaJSON(EmpresaJSON: TJSONObject): string;
begin
 var Model := TEmpresaModel.Create;
 result := Model.AlterarEmpresaJSON(EmpresaJSON);
end;


end.
