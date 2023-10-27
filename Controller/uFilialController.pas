unit uFilialController;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  System.JSON, Data.DBXJSON, REST.JSON, uFilialModel, uIFilialController;

  type
     TFilialController = class(TInterfacedObject, IFilialController)
     public
       function Incluir(FilialJSON: TJSONObject): string;
       function Alterar(FilialJSON: TJSONObject): string;
       function ConsultarFilialId(Id : integer) : TJSONObject;
       function ConsultarFilialLike(campo, filtro, ordem : string) : TJSONObject;

       function GetId : integer;
       procedure SetId(const value : integer);

       function GetStatus(Id : integer) : string;

       function GetTelaRetornar : string;
       procedure SetTelaRetornar(Tela : string);



     end;

implementation

{ TEmpresaController }

procedure TFilialController.SetId(const value: integer);
begin
  var Model := TFilialModel.Create;
  Model.Id := value;
end;

function TFilialController.GetId: integer;
begin
  var Model := TFilialModel.Create;
  result := Model.Id;
end;

procedure TFilialController.SetTelaRetornar(Tela: string);
begin
  var Model := TFilialModel.Create;
  Model.TelaRetornar := Tela;
end;

function TFilialController.GetTelaRetornar: string;
begin
  var Model := TFilialModel.Create;
  result := Model.TelaRetornar;
end;
   
function TFilialController.GetStatus(Id: integer): string;
begin
  var Model := TFilialModel.Create;
  Model.Id := Id;
  result := Model.GetStatus;
end;


function TFilialController.Alterar(FilialJSON: TJSONObject): string;
begin
 var Model := TFilialModel.Create;
 result := Model.Alterar(FilialJSON);
end;

function TFilialController.ConsultarFilialId(Id: integer): TJSONObject;
begin
 var Model := TFilialModel.Create;
 result := Model.ConsultarFilialId(Id);
end;

function TFilialController.ConsultarFilialLike(campo, filtro,
  ordem: string): TJSONObject;
begin
  var Model := TFilialModel.Create;
  Model.Campo := Campo;
  Model.Filtro := filtro;
  Model.Ordem := ordem;
  result := Model.ConsultarFilialLike(Model);
end;



function TFilialController.Incluir(FilialJSON: TJSONObject): string;
begin
  var Model := TFilialModel.Create;
  Result := Model.Incluir(FilialJSON);
end;



end.
