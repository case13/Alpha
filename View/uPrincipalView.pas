unit uPrincipalView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON,
  Data.DBXJSON, REST.JSON, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, uEmpresaController, uIEmpresaController, Datasnap.DBClient, uUtilitarios,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, uIFilialController, uFilialController;

type
  TfPrincipalView = class(TForm)
    Panel1: TPanel;
    pnFilial: TPanel;
    pnAluno: TPanel;
    Panel4: TPanel;
    Image3: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pnEscola: TPanel;
    pnAcao: TPanel;
    Panel9: TPanel;
    Image6: TImage;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Panel5: TPanel;
    Image4: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel3: TPanel;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    procedure pnFilialMouseEnter(Sender: TObject);
    procedure pnFilialMouseLeave(Sender: TObject);
    procedure pnAlunoMouseEnter(Sender: TObject);
    procedure pnAlunoMouseLeave(Sender: TObject);
    procedure pnEscolaMouseEnter(Sender: TObject);
    procedure pnEscolaMouseLeave(Sender: TObject);
    procedure pnAcaoMouseEnter(Sender: TObject);
    procedure pnAcaoMouseLeave(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    FEmpresaCtrl: IEmpresaController;
    FFilialCtrl: IFilialController;
    { Private declarations }
  public
     constructor Create(AOwner: TComponent); override;
    { Public declarations }

  end;

var
  fPrincipalView: TfPrincipalView;

implementation

{$R *.dfm}

uses uFilialViewCons, uFilialViewAdd;


procedure TfPrincipalView.pnFilialMouseEnter(Sender: TObject);
begin
  IluminarPainel(pnFilial, true);
end;

procedure TfPrincipalView.pnFilialMouseLeave(Sender: TObject);
begin
  IluminarPainel(pnFilial, false);
end;

constructor TfPrincipalView.Create(AOwner: TComponent);
begin
  inherited;
  FEmpresaCtrl := TEmpresaController.Create;
  FFilialCtrl := TFilialController.Create;
end;

procedure TfPrincipalView.FormShow(Sender: TObject);
begin
  FEmpresaCtrl.SetId(1);
end;

procedure TfPrincipalView.Label5Click(Sender: TObject);
begin
  FFilialCtrl.SetTelaRetornar('');
  AbrirTela(fFilialViewAdd, 'Modal');
end;

procedure TfPrincipalView.Label6Click(Sender: TObject);
begin
  AbrirTela(fFilialViewCons, 'Normal');
end;

procedure TfPrincipalView.pnAcaoMouseEnter(Sender: TObject);
begin
  IluminarPainel(pnAcao, true);
end;

procedure TfPrincipalView.pnAcaoMouseLeave(Sender: TObject);
begin
  IluminarPainel(pnAcao, false);
end;

procedure TfPrincipalView.pnAlunoMouseEnter(Sender: TObject);
begin
 IluminarPainel(pnAluno, true);
end;

procedure TfPrincipalView.pnAlunoMouseLeave(Sender: TObject);
begin
  IluminarPainel(pnAluno, false);
end;

procedure TfPrincipalView.pnEscolaMouseEnter(Sender: TObject);
begin
  IluminarPainel(pnEscola, true);
end;

procedure TfPrincipalView.pnEscolaMouseLeave(Sender: TObject);
begin
  IluminarPainel(pnEscola, false);
end;

end.
