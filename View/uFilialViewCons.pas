unit uFilialViewCons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, JvExControls,
  JvSpeedButton, Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, uUtilitarios, uIFilialController, uFilialController,
  Datasnap.DBClient;

type
  TfFilialViewCons = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    spdCadastrar: TSpeedButton;
    spdAlterar: TSpeedButton;
    spdDeletar: TSpeedButton;
    Panel3: TPanel;
    edtBusca: TEdit;
    spdConsultar: TSpeedButton;
    pnStatus: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Id: TIntegerField;
    ClientDataSet1CNPJ: TStringField;
    ClientDataSet1Descricao: TStringField;
    ClientDataSet1UF: TStringField;
    ClientDataSet1Cidade: TStringField;
    ClientDataSet1Bairro: TStringField;
    ClientDataSet1Endereco: TStringField;
    ClientDataSet1ComplementoEnd: TStringField;
    ClientDataSet1FilialStatus: TStringField;
    ClientDataSet1EmpresaId: TIntegerField;
    procedure spdConsultarClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spdCadastrarClick(Sender: TObject);
    procedure spdAlterarClick(Sender: TObject);
  private
    FController: IFilialController;
    FCampo : string;
    FOrdem : string;

    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;


    { Public declarations }
  end;

var
  fFilialViewCons: TfFilialViewCons;

implementation

{$R *.dfm}

uses uFilialViewAdd;

{ TfFilialViewCons }

constructor TfFilialViewCons.Create(AOwner: TComponent);
begin
  inherited;
  FController := TFilialController.Create;
end;

procedure TfFilialViewCons.DBGrid1TitleClick(Column: TColumn);
begin
  FCampo := Column.FieldName;
  NegritarColuna(DBGrid1, FCampo);
  OrdenarClientDataSet(ClientDataSet1, FCampo);
end;

procedure TfFilialViewCons.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
   vk_escape:
    close;
  end;
end;

procedure TfFilialViewCons.FormShow(Sender: TObject);
begin
  spdConsultarClick(sender);
  NegritarColuna(DBGrid1, FCampo);
end;

procedure TfFilialViewCons.spdAlterarClick(Sender: TObject);
begin
 if not ClientDataSet1.IsEmpty then
  begin
    with FController do
     begin
       SetId(ClientDataSet1Id.Value);
       SetTelaRetornar(fFilialViewAdd.Name);
     end;
    AbrirTela(fFilialViewAdd, 'Modal');
  end
 else
  ShowMessage('Nenhum registro encontrado para ser EDITADO, operação cancelada pelo sistema!');
end;

procedure TfFilialViewCons.spdCadastrarClick(Sender: TObject);
begin
  FController.SetId(0);
  AbrirTela(fFilialViewAdd, 'Modal');
end;

procedure TfFilialViewCons.spdConsultarClick(Sender: TObject);
begin
  if FOrdem = 'Asc' then
    FOrdem := 'Desc'
  else
    FOrdem := 'Asc';

  var JSONResult := FController.ConsultarFilialLike(FCampo, edtBusca.Text, FOrdem);
  PreencherClientDataSet(fFilialViewCons,JSONResult, ClientDataSet1.Name);
  NegritarColuna(DBGrid1, FCampo);
end;

end.
