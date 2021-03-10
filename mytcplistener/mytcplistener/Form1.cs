using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using System.IO;

using System.Data.SqlClient;
using System.Configuration;

namespace MyTcpListener
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        String str_hour, str_minute, str_sec,str_time, str_msgindication, str_vechicleno, str_rundate, str_latitude, str_logitude, str_speed, str_vechicledesc, str_odometer, str_alertmsg, str_statusindication, str_ignition, str_digitalinput1, str_digitalinput2, str_validitystatus,str_rundate_month, str_rundate_year, str_rundate_day;
        String gprs2;  

        private void button1_Click(object sender, EventArgs e)
        {

            System.Net.IPAddress serverAddress = System.Net.IPAddress.Parse("192.168.1.87"); // <-- Change that as appropriate!

           //System.Net.IPAddress serverAddress = System.Net.IPAddress.Parse("127.0.0.1"); // <-- Change that as appropriate!

            // Start listening for connections on our IP address + Our Port number 
            TcpListener listener = new TcpListener(serverAddress, 999);

           while(true)
            {
                listener.Start();

                // Is someone trying to call us? Well answer!
                TcpClient ourTCP_Client = listener.AcceptTcpClient();

                //A network stream object. We'll use this to send and receive our data, so create a buffer for it...
                NetworkStream ourStream = ourTCP_Client.GetStream();
                byte[] dataRS = new byte[ourTCP_Client.ReceiveBufferSize];

                // read the incoming data stream - note that Read() is a blocking call...
                int bytesRead = ourStream.Read(dataRS, 0, System.Convert.ToInt32(ourTCP_Client.ReceiveBufferSize));
                //MessageBox.Show("Received : " + Encoding.ASCII.GetString(data, 0, bytesRead));

                String gprsdata4 = Encoding.ASCII.GetString(dataRS, 0, bytesRead);

                // data insertion start
                SqlConnection myConnection = new SqlConnection("user id=sa;password=editor;server=119.82.71.87,2057;database=gprs;connection timeout=30");

               // String gprsdata4 ="$1,DL7CAL4749,22,09,11,12,49,00,000000000,0000000000,00.0,0,0,0,0,0,1,V#$1,DL7CAL4749,22,09,11,12,49,05,000000000,0000000000,00.0,0,0,0,0,0,1,V#$1,DL7CAL4749,22,09,11,12,49,10,000000000,0000000000,00.0,0,0,0,0,0,1,V#$1,DL7CAL4749,22,09,11,12,49,15,000000000,0000000000,00.0,0,0,0,0,0,1,V#";

                 //MessageBox.Show(gprsdata4);
                string pattern = "#";
                string[] gprs1=Regex.Split(gprsdata4,pattern);

                for (int j = 0; j < gprs1.Length; j++)
                {
                    myConnection.Open();
                    gprs2 = gprs1[j];
                    gprs2 = gprs2.Replace("$", "");

                    // MessageBox.Show(gprs2);

                    string[] strgps = gprs2.Split(',');

                    for (int i = 0; i < strgps.Length; i++)
                    {
                        //MessageBox.Show(strgps[i]);

                        str_msgindication = strgps[0];
                        str_vechicleno = strgps[1];
                        str_rundate_day = strgps[2];
                        str_rundate_month = strgps[3];
                        str_rundate_year = strgps[4];

                        str_hour = strgps[5];
                        str_minute = strgps[6];
                        str_sec = strgps[7];

                        str_latitude = strgps[8];
                        str_logitude = strgps[9];
                        str_speed = strgps[10];

                        str_vechicledesc = strgps[11];
                        str_odometer = strgps[12];
                        str_alertmsg = strgps[13];
                        str_statusindication = strgps[14];
                        str_ignition = strgps[15];
                        str_digitalinput1 = strgps[16];
                        str_digitalinput2 = strgps[17];
                        str_validitystatus = strgps[18];
                    }

                    str_time = str_hour + ":" + str_minute + ":" + str_sec;
                    str_rundate = str_rundate_month + "/" + str_rundate_day + "/" + str_rundate_year + " " + str_time;

                    String querystring = "INSERT INTO gprs_info (msg_headerindication,vehicle_no,run_date,latitude_info,longitude_info,speed,vehicle_desc,odometer,alert_msg,status_indication,ignition,digital_input1,digital_input2,validity_status,original_str)  VALUES('" + str_msgindication + "','" + str_vechicleno + "','" + str_rundate + "','" + str_latitude + "','" + str_logitude + "','" + str_speed + "','" + str_vechicledesc + "','" + str_odometer + "','" + str_alertmsg + "','" + str_statusindication + "','" + str_ignition + "','" + str_digitalinput1 + "','" + str_digitalinput2 + "','" + str_validitystatus + "' ,'" + gprs2 + "') ";

                    // MessageBox.Show(querystring);

                    SqlCommand myCommand = new SqlCommand("Command String", myConnection);
                    myCommand.Connection = myConnection;

                    myCommand.CommandText = querystring;
                    myCommand.ExecuteNonQuery();

                    myConnection.Close();

                } //loop j end


                listener.Stop();


            } //while loop


            }

         
    }
}
