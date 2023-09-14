unit uConexaoMySQL;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  Data.DBXJSON, REST.JSON, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef;


type

   TConexaoMySQL = class
     private
       FConexao : TFDConnection;
       MySQLDriver : TFDPhysMYSQLDriverLink;
       Const
        FDriverNema : String = 'MySQL';
        FHostName : String = '69.49.241.29';
        FUserName : String = 'hgi18025_alphadev';
        FPassword : string = '@lph0709SD';
        FDatabase : string = 'hgi18025_alphaDB';
        FPort : string = '3306';
        FLoginPrompt : boolean = false;

     public
       constructor Create;
       destructor Destroy; override;
       function criarQuery: TFDQuery;

   end;

implementation

{ TConexaoMySQL }

function TConexaoMySQL.criarQuery: TFDQuery;
var Query : TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  Query.Connection := FConexao;
  result := Query;
end;

constructor TConexaoMySQL.Create;
begin
 // Comando Conex�o Com Banco de Dados MySQL WebService
  FConexao := TFDConnection.Create(nil);
  with FConexao do
  begin
    DriverName := 'MySQL';
    Params.Values['Server'] := FHostName;
    Params.Values['Database'] := FDatabase;
    Params.Values['User_Name'] := FUserName;
    Params.Values['Password'] := FPassword;
    Params.Values['Port'] := FPort;
    LoginPrompt := False;
    Connected := True;
  end;
end;

destructor TConexaoMySQL.Destroy;
begin
  // Comando de Desconex�o do Banco de Dados MySQL WebService
  FConexao.Free;
  inherited;
end;

end.
