unit uPrincipalView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON,
  Data.DBXJSON, REST.JSON, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, uEmpresaController, uIEmpresaController, Datasnap.DBClient,
  Vcl.ExtCtrls;

type
  TfPrincipalView = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Id: TIntegerField;
    ClientDataSet1CNPJ: TStringField;
    ClientDataSet1RazaoSocial: TStringField;
    ClientDataSet1NomeFantasia: TStringField;
    ClientDataSet1Cabecalho: TStringField;
    ClientDataSet1Rodape: TStringField;
    ClientDataSet1EmpresaStatus: TStringField;
    Panel1: TPanel;
    Edit1: TEdit;
    Consultar: TBitBtn;
    procedure ConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FEmpresaController: IEmpresaController;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; EmpresaController: IEmpresaController); reintroduce;
    { Public declarations }
  end;

var
  fPrincipalView: TfPrincipalView;

implementation

{$R *.dfm}


constructor TfPrincipalView.Create(AOwner: TComponent; EmpresaController: IEmpresaController);
begin
  inherited Create(AOwner);
  FEmpresaController := EmpresaController;
end;


procedure TfPrincipalView.FormCreate(Sender: TObject);
begin
  FEmpresaController := TEmpresaController.Create;
end;

procedure TfPrincipalView.ConsultarClick(Sender: TObject);
var
  filtro: string;
  EmpresasJSON: TJSONObject;
  EmpresasArray: TJSONArray;
  EmpresasItem: TJSONValue;
begin
  filtro := Edit1.Text;

  // Chame a fun��o ConsultarEmpresaLikeJSON do controlador
  EmpresasJSON := FEmpresaController.ConsultarEmpresaLikeJSON(filtro);

  // Se o JSON retornar um objeto com a chave "Empresas", voc� pode carregar os dados no DBGrid
  if Assigned(EmpresasJSON) and EmpresasJSON.TryGetValue<TJSONArray>('Empresas', EmpresasArray) then
    begin
      ClientDataSet1.EmptyDataSet;
      ClientDataSet1.Close;
      ClientDataSet1.Open;

      // Itere pelos elementos do JSONArray e insira-os no ClientDataSet
      for EmpresasItem in EmpresasArray do
       begin
        if EmpresasItem <> nil then // Verifique se o item n�o � nulo
         begin
           ClientDataSet1.Insert;
           ClientDataSet1.FieldByName('Id').AsString := EmpresasItem.GetValue<string>('Id', '');
           ClientDataSet1.FieldByName('CNPJ').AsString := EmpresasItem.GetValue<string>('CNPJ', '');
           ClientDataSet1.FieldByName('RazaoSocial').AsString := EmpresasItem.GetValue<string>('RazaoSocial', '');
           ClientDataSet1.FieldByName('NomeFantasia').AsString := EmpresasItem.GetValue<string>('NomeFantasia', '');
           ClientDataSet1.FieldByName('Cabecalho').AsString := EmpresasItem.GetValue<string>('Cabecalho', '');
           ClientDataSet1.FieldByName('Rodape').AsString := EmpresasItem.GetValue<string>('Rodape', '');
           ClientDataSet1.FieldByName('EmpresaStatus').AsString := EmpresasItem.GetValue<string>('EmpresaStatus', '');
           ClientDataSet1.Post;
         end;
       end;
    end;
end;



end.
