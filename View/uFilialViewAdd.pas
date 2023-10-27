unit uFilialViewAdd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, uIFilialController, uFilialController,
  System.JSON, Data.DBXJSON, REST.JSON;

type
  TfFilialViewAdd = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lblTitulo: TLabel;
    lblStatus: TLabel;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblOperacao: TLabel;
    CNPJ: TEdit;
    Label2: TLabel;
    Descricao: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    UF: TComboBox;
    Cidade: TEdit;
    Label5: TLabel;
    Bairro: TEdit;
    Label6: TLabel;
    Endereco: TEdit;
    Label7: TLabel;
    ComplementoEnd: TEdit;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure CNPJKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure AcaoOperacao(Msg : string);
    procedure Salvar;
    procedure PreencherTela;

  private
    FController: IFilialController;
    FCodigoPK : integer;
    FStatus : string;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    var MsgOperacao : string;
    { Public declarations }
  end;

var
  fFilialViewAdd: TfFilialViewAdd;

implementation
 uses uUtilitarios, uFilialViewCons;
{$R *.dfm}


constructor TfFilialViewAdd.Create(AOwner: TComponent);
begin
  inherited;
  FController := TFilialController.Create;
end;

procedure TfFilialViewAdd.PreencherTela;
var
 DadoJSON : TJSONObject;
begin
  if FCodigoPK = 0 then
   begin
     CNPJ.Text := '';
     Descricao.Text := '';
     UF.ItemIndex := -1;
     Cidade.Text := '';
     Bairro.Text := '';
     Endereco.Text := '';
     ComplementoEnd.Text := '';
     CNPJ.SetFocus;
   end
  else
   begin
     DadoJSON := FController.ConsultarFilialId(FCodigoPK);
     try
      // Verificar se o JSON n�o est� vazio
      if Assigned(DadoJSON) then
       begin
        // Preencher os componentes com os valores do JSON
         CNPJ.Text := DadoJSON.GetValue('CNPJ').Value;
         Descricao.Text := DadoJSON.GetValue('Descricao').Value;
         var Indice := UF.Items.IndexOf(DadoJSON.GetValue('UF').Value);
         UF.ItemIndex := Indice;
         Cidade.Text := DadoJSON.GetValue('Cidade').Value;
         Bairro.Text := DadoJSON.GetValue('Bairro').Value;
         Endereco.Text := DadoJSON.GetValue('Endereco').Value;
         ComplementoEnd.Text := DadoJSON.GetValue('ComplementoEnd').Value;
       end;
     finally
      DadoJSON.Free;
     end;
   end;
end;

procedure TfFilialViewAdd.Salvar;
begin
  var FilialStatus := FController.GetStatus(FCodigoPK);
  var JObjetoGravar := GerarJSONCadastro(fFilialViewAdd, FCodigoPK, FilialStatus);
  if FCodigoPK = 0 then
   AcaoOperacao(FController.Incluir(JObjetoGravar))
  else
   AcaoOperacao(FController.Alterar(JObjetoGravar));

   PreencherTela;
end;

procedure TfFilialViewAdd.AcaoOperacao(Msg : string);
var
  Tela : string;
  DadosJSON : TJSONObject;
begin
  Tela := FController.GetTelaRetornar;
  if Tela <> '' then
   begin
     DadosJSON := FController.ConsultarFilialLike('Id','','Asc');
     PreencherClientDataSet(fFilialViewCons, DadosJSON, 'ClientDataSet1');
   end;

  if (AnsiUpperCase(Msg) = AnsiUpperCase('Incluido')) then
   ShowMessage('Inclus�o feita com sucesso!');

  if (AnsiUpperCase(Msg) = AnsiUpperCase('Editado'))  then
   begin
    ShowMessage('Altera��o feita com sucesso!');
    close;
   end;
   
end;


procedure TfFilialViewAdd.BitBtn1Click(Sender: TObject);
begin
   Salvar;
end;

procedure TfFilialViewAdd.CNPJKeyPress(Sender: TObject; var Key: Char);
begin
  // Verificar se o caractere pressionado n�o � um n�mero
  if not (Key in ['0'..'9', #8, #127]) then
  begin
    // Bloquear a entrada do caractere no Edit
    Key := #0;
  end;
end;

procedure TfFilialViewAdd.FormShow(Sender: TObject);
var Controller : TFilialController;
begin
  FCodigoPK := FController.GetId;
  OperacaoStatus(FCodigoPK, lblOperacao);
  PreencherTela;
end;

end.
