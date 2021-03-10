using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient ;

namespace Collection.classesoracle
{


    /// <summary>
    /// Summary description for PartyOS
    /// </summary>
    public class PartyOS:orclconnection  
    {
        public PartyOS()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public DataSet Adacct_rep_outstanding(string comp_code, string unit,string print_cent, string reg_code, string city_code, string agency_code, string agency_subcode, string dist_code ,string talu_code, string from_date, string ason_date, string mainag_flag, string dateformat)
        {
            OracleConnection conn;
            OracleCommand cmd;
            DataSet ds = new DataSet();
            conn = GetConnection();
            OracleDataAdapter da = new OracleDataAdapter();
            try
            {
                conn.Open();
                cmd = GetCommand("Adacct_rep_outstanding.adacct_party_out_summary", ref conn);
                cmd.CommandType = CommandType.StoredProcedure;

                OracleParameter prm1 = new OracleParameter("pcomp_code", OracleType.VarChar, 50);
                prm1.Direction = ParameterDirection.Input;
                prm1.Value = comp_code;
                cmd.Parameters.Add(prm1);


                OracleParameter prm2 = new OracleParameter("punit_code", OracleType.VarChar, 50);
                prm2.Direction = ParameterDirection.Input;
                prm2.Value = unit;
                cmd.Parameters.Add(prm2);


                OracleParameter prm3 = new OracleParameter("ppcenter_code", OracleType.VarChar, 50);
                prm3.Direction = ParameterDirection.Input;
                prm3.Value = print_cent;
                cmd.Parameters.Add(prm3);

                OracleParameter prm4 = new OracleParameter("preg_code", OracleType.VarChar, 50);
                prm4.Direction = ParameterDirection.Input;
                prm4.Value = reg_code;
                cmd.Parameters.Add(prm4);


                OracleParameter prm5 = new OracleParameter("pcity_code", OracleType.VarChar, 50);
                prm5.Direction = ParameterDirection.Input;
                prm5.Value = city_code;
                cmd.Parameters.Add(prm5);

                OracleParameter prm6 = new OracleParameter("pag_main_code", OracleType.VarChar, 50);
                prm6.Direction = ParameterDirection.Input;
                prm6.Value = agency_code;
                cmd.Parameters.Add(prm6);

                OracleParameter prm7 = new OracleParameter("pag_sub_code", OracleType.VarChar, 50);
                prm7.Direction = ParameterDirection.Input;
                prm7.Value = agency_subcode;
                cmd.Parameters.Add(prm7);


                OracleParameter prm8 = new OracleParameter("pdistcode", OracleType.VarChar, 50);
                prm8.Direction = ParameterDirection.Input;
                prm8.Value = dist_code;
                cmd.Parameters.Add(prm8);

                OracleParameter prm9 = new OracleParameter("ptalukacode", OracleType.VarChar, 50);
                prm9.Direction = ParameterDirection.Input;
                prm9.Value = talu_code;
                cmd.Parameters.Add(prm9);

                OracleParameter prm10 = new OracleParameter("pfrom_date", OracleType.VarChar, 50);
                prm10.Direction = ParameterDirection.Input;
                prm10.Value = from_date;
                cmd.Parameters.Add(prm10);

                OracleParameter prm11 = new OracleParameter("pason_date", OracleType.VarChar, 50);
                prm11.Direction = ParameterDirection.Input;
                prm11.Value = ason_date;
                cmd.Parameters.Add(prm11);

                OracleParameter prm12 = new OracleParameter("pmainag_flag", OracleType.VarChar, 50);
                prm12.Direction = ParameterDirection.Input;
                prm12.Value = mainag_flag;
                cmd.Parameters.Add(prm12);

                OracleParameter prm13 = new OracleParameter("pdateformat", OracleType.VarChar, 50);
                prm13.Direction = ParameterDirection.Input;
                prm13.Value = dateformat;
                cmd.Parameters.Add(prm13);

                cmd.Parameters.Add("p_accounts", OracleType.Cursor);
                cmd.Parameters["p_accounts"].Direction = ParameterDirection.Output;

                cmd.Parameters.Add("p_accounts1", OracleType.Cursor);
                cmd.Parameters["p_accounts1"].Direction = ParameterDirection.Output;

                da.SelectCommand = cmd ;
                da.Fill(ds);
                return ds;
            
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }


        public DataSet getPubCenter()
        {
            OracleConnection objOracleConnection;
            OracleCommand objOraclecommand;
            DataSet objDataSet = new DataSet();
            objOracleConnection = GetConnection();
            OracleDataAdapter objorclDataAdapter = new OracleDataAdapter();

            try
            {
                objOracleConnection.Open();
                objOraclecommand = GetCommand("websp_pubcenter.websp_pubcenter_p", ref objOracleConnection);
                objOraclecommand.CommandType = CommandType.StoredProcedure;

                objOraclecommand.Parameters.Add("p_accounts", OracleType.Cursor);
                objOraclecommand.Parameters["p_accounts"].Direction = ParameterDirection.Output;



                objOraclecommand.Parameters.Add("p_accounts1", OracleType.Cursor);
                objOraclecommand.Parameters["p_accounts1"].Direction = ParameterDirection.Output;


                objorclDataAdapter.SelectCommand = objOraclecommand;
                objorclDataAdapter.Fill(objDataSet);
                return objDataSet;
            }
            catch (Exception objException)
            {
                throw (objException);
            }
            finally
            {
                objOracleConnection.Close();

            }
        }


        public DataSet district(string compcode, string userid)
        {
            OracleConnection objOracleConnection;
            OracleCommand objOraclecommand;
            DataSet objDataSet = new DataSet();
            objOracleConnection = GetConnection();
            OracleDataAdapter objmysqlDataAdapter = new OracleDataAdapter();
            try
            {
                objOracleConnection.Open();
                objOraclecommand = GetCommand("CityMst_District.CityMst_District_p", ref objOracleConnection);
                objOraclecommand.CommandType = CommandType.StoredProcedure;

                OracleParameter prm1 = new OracleParameter("compcode", OracleType.VarChar, 50);
                prm1.Direction = ParameterDirection.Input;
                prm1.Value = compcode;
                objOraclecommand.Parameters.Add(prm1);


                OracleParameter prm2 = new OracleParameter("userid", OracleType.VarChar, 50);
                prm2.Direction = ParameterDirection.Input;
                prm2.Value = userid;
                objOraclecommand.Parameters.Add(prm2);
                objOraclecommand.Parameters.Add("p_Accounts", OracleType.Cursor);
                objOraclecommand.Parameters["p_Accounts"].Direction = ParameterDirection.Output;

                objmysqlDataAdapter.SelectCommand = objOraclecommand;
                objmysqlDataAdapter.Fill(objDataSet);
                return objDataSet;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                CloseConnection(ref objOracleConnection);
            }
        }


        public DataSet talukabind(string compcode, string dist_code)
        {
            string zonename = "";
            OracleConnection objOracleConnection;
            OracleCommand objOraclecommand;
            DataSet objDataSet = new DataSet();
            objOracleConnection = GetConnection();
            OracleDataAdapter objorclDataAdapter = new OracleDataAdapter();
            try
            {


                objOracleConnection.Open();
                objOraclecommand = GetCommand("BINDTALUKA.BINDTALUKA_P", ref objOracleConnection);
                objOraclecommand.CommandType = CommandType.StoredProcedure;

                OracleParameter prm1 = new OracleParameter("compcode", OracleType.VarChar);
                prm1.Direction = ParameterDirection.Input;
                prm1.Value = compcode;
                objOraclecommand.Parameters.Add(prm1);



                OracleParameter prm3 = new OracleParameter("pdist_code", OracleType.VarChar);
                prm3.Direction = ParameterDirection.Input;
                if (dist_code == "0" || dist_code == "")
                    prm3.Value = System.DBNull.Value;
                else
                    prm3.Value = dist_code;
                objOraclecommand.Parameters.Add(prm3);

                objOraclecommand.Parameters.Add("p_accounts", OracleType.Cursor);
                objOraclecommand.Parameters["p_accounts"].Direction = ParameterDirection.Output;



                objorclDataAdapter.SelectCommand = objOraclecommand;
                objorclDataAdapter.Fill(objDataSet);
                return objDataSet;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                CloseConnection(ref objOracleConnection);
            }

        }

                            
    }
}

