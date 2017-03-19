program CTeAPI;

uses
  Forms,
  Unit1 in 'Unit1.pas' {formPrincipal},
  CTeApiFuncoes in 'CTeApiFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.Run;
end.
