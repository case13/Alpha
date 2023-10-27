unit uIFilialController;

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
  IFilialController = interface
   function Incluir(FilialJSON: TJSONObject): string;
   function Alterar(FilialJSON: TJSONObject): string;
   function ConsultarFilialId(Id : integer) : TJSONObject;
   function ConsultarFilialLike(campo, filtro, ordem : string) : TJSONObject;




   function GetId : integer;
   procedure SetId(const values : integer);

   function GetStatus(Id : integer) : string;

   function GetTelaRetornar : string;
   procedure SetTelaRetornar(Tela : string);

  end;

implementation

end.
