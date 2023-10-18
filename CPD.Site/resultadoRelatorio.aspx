<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resultadoRelatorio.aspx.cs" Inherits="CPD.Site.resultadoRelatorio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="Estatico/css/estiloOcorrencias.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet"/>
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon"/>
    <link rel="shortcut icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon"/>
    <title>CPD - Resultado Relatório</title>
</head>
<body>
    <form id="form1" runat="server">
        <main>
            <div id="cabecalhoRelatorio">
                <img src="Estatico/imagens/logoCPD.png"/>
                <h1>
                    <asp:Literal ID="litTipoRelatorio" runat="server"></asp:Literal>
                </h1>
                <img src="Estatico/imagens/logoETECAF.png"/>
            </div>

            <table>
                <thead>
                    <asp:Literal ID="litTituloTabela" runat="server"></asp:Literal>
                </thead>
                <tbody>
                    <asp:Literal ID="litConteudoTabela" runat="server"></asp:Literal>
                </tbody>
            </table>
        </main>
    </form>
</body>
</html>
