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
            <h1>
                <asp:Literal ID="litTipoRelatorio" runat="server"></asp:Literal>
            </h1>
            <table>
                <thead>
                    <asp:Literal ID="litTituloTabela" runat="server"></asp:Literal>
                   <%-- <th>DATA</th>
                    <th>RM</th>
                    <th>PROFESSOR</th>
                    <th>E-MAIL</th>
                    <th>ITEM</th>
                    <th>TIPO OCORRÊNCIA</th>--%>
                </thead>
                <tbody>
                    <asp:Literal ID="litConteudoTabela" runat="server"></asp:Literal>
                    <%--<td>11/09/2023</td>
                    <td>36419</td>
                    <td>Frederico Arco e Flexa Machado Justo</td>
                    <td>frederico.machado@etec.sp.gov.br</td>
                    <td>INFO LAB 05</td>--%>
                </tbody>
            </table>
        </main>
    </form>
</body>
</html>
