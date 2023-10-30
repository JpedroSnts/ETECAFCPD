using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using CPD.Site.Util;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Api
{
    public partial class gerarOcorrencia : System.Web.UI.Page
    {
        #region JSON
        private class item
        {
            public string textarea { get; set; }
            public string ddl { get; set; }
            public int tipo { get; set; }
        }

        private class OcorrenciaJson
        {
            public int rm { get; set; }
            public string data { get; set; }
            public List<item> itens { get; set; }
            public List<string> cd_itens { get; set; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Admin(Session))
            {
                Response.StatusCode = 401;
                Response.End();
            }
            if (Request.HttpMethod == "POST")
            {
                using (var sr = new StreamReader(Request.InputStream))
                {
                    string body = sr.ReadToEnd();
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    OcorrenciaJson json = serializer.Deserialize<OcorrenciaJson>(body);

                    OcorrenciaAmbienteController aController = new OcorrenciaAmbienteController();
                    OcorrenciaEquipamentoController eController = new OcorrenciaEquipamentoController();

                    DateTime data = DateTime.Parse(json.data);
                    for (int i = 0; i < json.itens.Count; i++)
                    {
                        Usuario usuario = new Usuario() { RM = json.rm };
                        if (json.itens[i].tipo == 1)
                        {
                            Ambiente ambiente = new Ambiente() { Sigla = json.cd_itens[i] };
                            OcorrenciaAmbiente oa = new OcorrenciaAmbiente()
                            {
                                Ambiente = ambiente,
                                Usuario = usuario,
                                ReservaAmbiente = new ReservaAmbiente() { Usuario = usuario, Ambiente = ambiente, DataSaidaPrevista = data },
                                TipoOcorrencia = new TipoOcorrenciaAmbiente { Codigo = int.Parse(json.itens[i].ddl) },
                                Descricao = json.itens[i].textarea
                            };
                            aController.Registrar(oa);
                        }
                        else
                        {
                            Equipamento equipamento = new Equipamento() { Sigla = json.cd_itens[i] };
                            OcorrenciaEquipamento oe = new OcorrenciaEquipamento()
                            {
                                Equipamento = equipamento,
                                Usuario = usuario,
                                ReservaEquipamento = new ReservaEquipamento() { Usuario = usuario, Equipamento = equipamento, DataSaidaPrevista = data },
                                TipoOcorrencia = new TipoOcorrenciaEquipamento { Codigo = int.Parse(json.itens[i].ddl) },
                                Descricao = json.itens[i].textarea
                            };
                            eController.Registrar(oe);
                        }
                    }
                }
            }
        }
    }
}