program Alpha;

uses
  Vcl.Forms,
  uPrincipalView in 'View\uPrincipalView.pas' {fPrincipalView},
  uConexaoMySQL in 'DAO\uConexaoMySQL.pas',
  uEmpresaDAO in 'DAO\uEmpresaDAO.pas',
  uEmpresaModel in 'Model\uEmpresaModel.pas',
  uIEmpresaController in 'Controller\uIEmpresaController.pas',
  uEmpresaController in 'Controller\uEmpresaController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipalView, fPrincipalView);
  Application.Run;
end.
