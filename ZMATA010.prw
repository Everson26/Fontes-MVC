#include'totvs.ch'
#include'fwmvcdef.ch

/*/{Protheus.doc} User Function nomeFunction
    (Consulta de Saldos do Produto - BROWSER)
    @type  Function
    @author user Everson Queiroz
    @since 27/08/2020
    @version version 1.0
    @param param_name, param_type, param_descr
    @return Nil
    @example
    (examples)
    @see (links_or_references)
    /*/
STATIC cTitulo := "Saldos de Produto"

USER FUNCTION ZMATA010()    

Local aArea   := GetArea()
Local oBrowse
        
//Instï¿½nciando FWMBrowse - Somente com dicionï¿½rio de dados
oBrowse := FWMBrowse():New()

//Setando a tabela de cadastro de Autor/Interprete
oBrowse:SetAlias("SB1")

//Setando a descriï¿½ï¿½o da rotina
oBrowse:SetDescription(cTitulo)

//Ativa a Browse
oBrowse:Activate()

RestArea(aArea)

RETURN Nil

/*/{Protheus.doc} Menu Delf
    (Definição da Ações do Browser)
    @type  Static Function
    @author user Everson Queiroz
    @since date 27/08/2020
    @version version 1.0
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

STATIC FUNCTION MenuDef()

Local aRot := {}

//Adicionando opï¿½ï¿½es
  ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ZMATA010' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ZMATA010' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
//ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ZMATA010' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ZMATA010' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*/{Protheus.doc} Model Delf
    (Definições do Modelo de Dados)
    @type  Static Function
    @author user Everson Queiroz
    @since date 27/08/2020
    @version version 1.0
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
STATIC FUNCTION ModelDef()

Local oModel 		:= Nil
Local aZA2Rel		:= {}
Local oStPai 		:= FWFormStruct(1, 'SB1')
Local oStFilho 	    := FWFormStruct(1, 'SB2')

// Definiï¿½ï¿½es de Campos.
oModel := MPFormModel():New('ZMTA010') // ID do Modelo de Dados

//Criando o modelo e os relacionamentos
oModel:AddFields('SB1MASTER',/*cOwner*/,oStPai)
oModel:AddGrid('SB2DETAIL','SB1MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner ï¿½ para quem pertence

//Fazendo o relacionamento entre o Pai e Filho
aAdd(aZA2Rel, {'B2_FILIAL','B1_FILIAL'} )// Quando tem que gravar o campo aAdd(aZA2Rel, {'SB2_FILIAL','xFilial("ZA2")'} )
aAdd(aZA2Rel, {'B2_COD',	'B1_COD'}) 
//aAdd(aZA2Rel, {'B2_LOCAL',	'B1_LOCPAD'}) 

// Criando o Index da tela.                
oModel:SetRelation('SB2DETAIL', aZA2Rel, SB2->(IndexKey(1))) //IndexKey -> quero a ordenaï¿½ï¿½o e depois filtrado
oModel:GetModel('SB2DETAIL'):SetUniqueLine({"B2_FILIAL","B2_COD"})	//Nï¿½o repetir informaï¿½ï¿½es ou combinaï¿½ï¿½es {"CAMPO1","CAMPO2","CAMPOX"}
oModel:SetPrimaryKey({})
                        
//Setando as descriï¿½ï¿½es
oModel:SetDescription("Saldos de Produto - Detalhes")
oModel:GetModel('SB1MASTER'):SetDescription('Cadasro de Produto')
oModel:GetModel('SB2DETAIL'):SetDescription('Saldos do Produto')
                             
RETURN oModel

/*/{Protheus.doc} View Delf
    (Definições da Visualização de Dados)
    @type  Static Function
    @author user Everson Queiroz
    @since date 27/08/2020
    @version version 1.0
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

STATIC FUNCTION ViewDef()

Local oView		:= Nil
Local oModel	:= FWLoadModel('ZMATA010')
Local oStPai	:= FWFormStruct(2, 'SB1')
Local oStFilho	:= FWFormStruct(2, 'SB2')

//Criando a View
oView := FWFormView():New()
oView:SetModel(oModel)

//Adicionando os campos do cabeï¿½alho e o grid dos filhos
oView:AddField('VIEW_SB1',oStPai,'SB1MASTER')
oView:AddGrid('VIEW_SB2',oStFilho,'SB2DETAIL')
        
//Setando o dimensionamento de tamanho
oView:CreateHorizontalBox('CABEC',30)
oView:CreateHorizontalBox('GRID',70)

//Amarrando a view com as box
oView:SetOwnerView('VIEW_SB1','CABEC')
oView:SetOwnerView('VIEW_SB2','GRID')
                                
//Habilitando tï¿½tulo
oView:EnableTitleView('VIEW_SB1','Produto')
oView:EnableTitleView('VIEW_SB2','Saldo')
        
RETURN oView

