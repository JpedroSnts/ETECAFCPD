<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resultadoRelatorio.aspx.cs" Inherits="CPD.Site.resultadoRelatorio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="Estatico/css/estiloRelatorioR.css"/>
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet"/>
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon"/>
    <link rel="shortcut icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon"/>
    <title>CPD - Resultado Relatório</title>
</head>
<body id="bodyRelatorio">
    <form id="form1" runat="server">
        <main id="folhaa4">
            <div id="cabecalhoRelatorio">
                <img src="Estatico/imagens/logoCPD.png" class="logos"/>
                <h1>
                    <asp:Literal ID="litTipoRelatorio" runat="server"></asp:Literal>
                </h1>
                <div>
                    <img src="Estatico/imagens/logoCPS.png" class="logos"/>
                    <img src="Estatico/imagens/logoSP.png" class="logos"/>
                </div>
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
    <button id="btnImprimir">Imprimir</button>
    <script>
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const relatorio = urlParams.get("tipoRelatorio");
        const inicio = urlParams.get("inicio");
        const fim = urlParams.get("fim");
        document.title = `Relatorio_${relatorio}_${inicio}_${fim}`;

        const btnImprimir = document.querySelector("#btnImprimir");
        btnImprimir.addEventListener("click", () => {
            btnImprimir.style.display = 'none';
            window.print();
            btnImprimir.style.display = 'block';
        });
    </script>
</body>
</html>
