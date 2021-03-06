unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, uJSON;

type
  TformPrincipal = class(TForm)
    pgControl: TPageControl;
    formEnviar: TTabSheet;
    formConsultar: TTabSheet;
    formDownload: TTabSheet;
    formCancelar: TTabSheet;
    formCCe: TTabSheet;
    labelTokenEnviar: TLabel;
    editTokenEnviar: TEdit;
    btnEnviar: TButton;
    memoEnviar: TMemo;
    labelRetornoEnviar: TLabel;
    memoConsultar: TMemo;
    labelTokenConsultar: TLabel;
    labelRetornoConsultar: TLabel;
    editTokenConsultar: TEdit;
    btnConsultar: TButton;
    editChaveConsultar: TEdit;
    labelChaveConsultar: TLabel;
    labelNumRec: TLabel;
    editNumRec: TEdit;
    labelTpAmbConsultar: TLabel;
    editTpAmbConsultar: TEdit;
    btnCancelamento: TButton;
    editTokenCancelamento: TEdit;
    labelRetornoCancelamento: TLabel;
    labelTokenCancelamento: TLabel;
    memoCancelamento: TMemo;
    editChaveCancelamento: TEdit;
    labelChaveCancelamento: TLabel;
    labelTpAmbCancelamento: TLabel;
    editTpAmbCancelamento: TEdit;
    btnCCe: TButton;
    editTokenCCe: TEdit;
    labelRetornoCCe: TLabel;
    labelTokenCCe: TLabel;
    memoCCe: TMemo;
    editChaveCCe: TEdit;
    labelChaveCCe: TLabel;
    labelTpAmbCCe: TLabel;
    editTpAmbCCe: TEdit;
    btnDownload: TButton;
    editTokenDownload: TEdit;
    labelRetornoDownload: TLabel;
    labelTokenDownload: TLabel;
    memoDownload: TMemo;
    editChaveDownload: TEdit;
    labelChaveDownload: TLabel;
    labelTpAmbDownload: TLabel;
    editTpAmbDownload: TEdit;
    labelTpDown: TLabel;
    editTpDownload: TEdit;
    labelOpcoesDownload: TLabel;
    checkExibir: TCheckBox;
    labelNumProt: TLabel;
    editNumProt: TEdit;
    labelJustCancelamento: TLabel;
    memoXJust: TMemo;
    labelNumSeq: TLabel;
    labelCampoAlterado: TLabel;
    labelValorAlterado: TLabel;
    labelGrupoAlterado: TLabel;
    editNumSeq: TEdit;
    editGrupoAlterado: TEdit;
    editCampoAlterado: TEdit;
    editValorAlterado: TEdit;
    labelNumItemAlterado: TLabel;
    editNumItemAlterado: TEdit;
    labelConteudo: TLabel;
    memoJson: TMemo;
    cbIsTxt: TCheckBox;
    procedure btnEnviarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnCancelamentoClick(Sender: TObject);
    procedure btnCCeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formPrincipal: TformPrincipal;

implementation
uses CTeApiFuncoes;

{$R *.dfm}



  //Procedimento de envio
  procedure TformPrincipal.btnEnviarClick(Sender: TObject);
  var
    retorno: String;
    jsonRetorno : TJSONObject;
  begin
    //Valida se for enviado o token para emitir o CT-e de exemplo
    if ((editTokenEnviar.Text <> '') and (memoJson.Text <> '')) then
    begin
      retorno := emitirCTe(editTokenEnviar.Text, memoJson.Text, cbIsTxt.Checked);
      memoEnviar.Text := retorno;

      if(memoEnviar.Text[1] = '{') then
      begin
        jsonRetorno := TJsonObject.Create(retorno);
        editChaveConsultar.Text := jsonRetorno.getString('chCTe');
        if(jsonRetorno.getString('status') = '200') then
          jsonRetorno := jsonRetorno.getJSONObject('retEnviCTe');
          editNumRec.Text := jsonRetorno.getString('nRec');
      end
      else
      begin
        if pos('DOCTYPE html', retorno) > 0 then
        begin
          memoEnviar.Lines.Add(#13#10 + #13#10 + 'Codigo do erro: 400' + #13#10 + 'Motivo: Dados enviados s�o inv�lidos');
        end
        else
        begin
          jsonRetorno := TJsonObject.Create(Copy(retorno, Pos(':', retorno) + 2, Length(retorno)-1));
          memoEnviar.Lines.Add(#13#10 + #13#10 + 'Motivo: ' + jsonRetorno.getString('motivo') + #13#10);
        end;
      end;
    end
    else
    begin
      Showmessage('Todos os campos devem estar preenchidos');
    end;

  end;


  //Procedimento de Consulta
  procedure TformPrincipal.btnConsultarClick(Sender: TObject);
  var
    retorno: String;
    jsonRetorno: TJSONObject;
  begin
    //Valida se todos os campos foram preenchidos com algum valor
    if ((editTokenConsultar.Text <> '') and (editChaveConsultar.Text <> '') and (editNumRec.Text <> '') and (editTpAmbConsultar.Text <> '')) then
    begin
      retorno := consultarStatusProcessamento(editTokenConsultar.Text, editChaveConsultar.Text, editNumRec.Text, editTpAmbConsultar.Text);
      memoConsultar.Text := retorno;

      if(memoConsultar.Text[1] = '{') then
      begin
        jsonRetorno := TJsonObject.Create(retorno);
        if(jsonRetorno.getString('status') = '200') then
          editChaveDownload.Text := jsonRetorno.getString('chCTe');
      end
      else
      begin
        jsonRetorno := TJsonObject.Create(Copy(retorno, Pos(': ', retorno) + 2, Length(retorno)));
        jsonRetorno := jsonRetorno.getJSONObject('erro');
        memoConsultar.Lines.Add(#13#10 + #13#10 + 'Codigo do erro: ' + jsonRetorno.getString('cStat') + #13#10 +
          'Motivo: ' + jsonRetorno.getString('xMotivo'));
      end;

    end
    else
    begin
      Showmessage('Todos os campos devem estar preenchidos');
    end;
  end;


  //Procedimento de Download
  procedure TformPrincipal.btnDownloadClick(Sender: TObject);
  var
    retorno: String;
  begin
    if ((editTokenDownload.Text <> '') and (editChaveDownload.Text <> '') and (editTpDownload.Text <> '') and (editTpAmbDownload.Text <> '')) then
    begin
      //Valida se todos os campos foram preenchidos com algum valor
      retorno := downloadCTe(editTokenDownload.Text, editChaveDownload.Text, editTpAmbDownload.Text, editTpDownload.Text, checkExibir.Checked);
      memoDownload.Text := retorno;
    end
    else
    begin
      Showmessage('Todos os campos devem estar preenchidos');
    end;
  end;


  //Procedimento de Cancelamento
  procedure TformPrincipal.btnCancelamentoClick(Sender: TObject);
  var
    retorno: String;
  begin
    //Valida se todos os campos foram preenchidos com algum valor e a justificativa tem pelo menos 15 caracteres

    if ((editTokenCancelamento.Text <> '') and (editChaveCancelamento.Text <> '') and (editNumProt.Text <> '') and (editTpAmbCancelamento.Text <> '') and (memoXJust.GetTextLen >= 15)) then
    begin
      retorno := cancelaCTe(editTokenCancelamento.Text, editChavecancelamento.Text, editTpAmbCancelamento.Text, editNumProt.Text, memoXJust.Text);
      memoCancelamento.Text := retorno;
    end

    else
    begin

      if (memoXJust.GetTextLen < 15) then
      begin
        Showmessage('A justificativa deve ter pelo menos 15 caracteres');
      end

      else
      begin
        Showmessage('Todos os campos devem estar preenchidos');
      end;

    end;

  end;


  //Procedimento de CCe
  procedure TformPrincipal.btnCCeClick(Sender: TObject);
  var
    retorno: String;
  begin
    //Valida se todos os campos foram preenchidos com algum valor
    if ((editTokenCCe.Text <> '') and (editChaveCCe.Text <> '') and (editNumSeq.Text <> '') and (editTpAmbCCe.Text <> '') and (editGrupoAlterado.Text <> '') and (editCampoAlterado.Text <> '') and (editValorAlterado.Text <> '') and (editNumItemAlterado.Text <> '')) then
    begin
      retorno := CCeCTe(editTokenCCe.Text, editChaveCCe.Text, editTpAmbCCe.Text, editNumSeq.Text, editGrupoAlterado.Text, editCampoAlterado.Text, editValorAlterado.Text, editNumItemAlterado.Text);
      memoCCe.Text := retorno;
    end
    else
    begin
      Showmessage('Todos os campos devem estar preenchidos');
    end;
  end;

  
end.
