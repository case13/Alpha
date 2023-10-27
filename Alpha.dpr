program Alpha;

uses
  Vcl.Forms,
  uPrincipalView in 'View\uPrincipalView.pas' {fPrincipalView},
  uConexaoMySQL in 'DAO\uConexaoMySQL.pas',
  uEmpresaDAO in 'DAO\uEmpresaDAO.pas',
  uEmpresaModel in 'Model\uEmpresaModel.pas',
  uIEmpresaController in 'Controller\uIEmpresaController.pas',
  uEmpresaController in 'Controller\uEmpresaController.pas',
  uFilialDAO in 'DAO\uFilialDAO.pas',
  uFilialModel in 'Model\uFilialModel.pas',
  uUtilitarios in 'Shared\uUtilitarios.pas',
  uIFilialController in 'Controller\uIFilialController.pas',
  uFilialController in 'Controller\uFilialController.pas',
  uFilialViewCons in 'View\uFilialViewCons.pas' {fFilialViewCons},
  uFilialViewAdd in 'View\uFilialViewAdd.pas' {fFilialViewAdd},
  uEscolaDAO in 'DAO\uEscolaDAO.pas',
  uEscolaModel in 'Model\uEscolaModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipalView, fPrincipalView);
  Application.CreateForm(TfFilialViewCons, fFilialViewCons);
  Application.CreateForm(TfFilialViewAdd, fFilialViewAdd);
  Application.Run;
end.
