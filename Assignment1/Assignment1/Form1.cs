using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Assignment1
{
    public partial class Form1 : Form
    {
        SqlConnection conn;
        DataSet ds;
        SqlDataAdapter daCountries, daCities;
        SqlCommandBuilder cb;
        BindingSource bsCountries, bsCities;

        private void buttonSaveData_Click(object sender, EventArgs e)
        {
            try
            {
                daCities.Update(ds, "City");
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.ToString());
            }
        }

        private void refreshButton_Click(object sender, EventArgs e)
        {
            ds = new DataSet();
            //daCountries = new SqlDataAdapter("SELECT * FROM Country", conn);
            //daCities = new SqlDataAdapter("SELECT * FROM City", conn);
            //cb = new SqlCommandBuilder(daCities);

            daCountries.Fill(ds, "Country");
            daCities.Fill(ds, "City");
        }

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            conn = new SqlConnection("Data Source = RAMONASLAPTOP; Initial Catalog = EuropeanCities; " + " Integrated Security = SSPI; ");
            ds = new DataSet();
            daCountries = new SqlDataAdapter("SELECT * FROM Country", conn);
            daCities = new SqlDataAdapter("SELECT * FROM City", conn);
            cb = new SqlCommandBuilder(daCities);

            daCountries.Fill(ds, "Country");
            daCities.Fill(ds, "City");

            DataRelation dr = new DataRelation("FK_Country_City", ds.Tables["Country"].Columns["CountryName"], ds.Tables["City"].Columns["CountryName"]);
            ds.Relations.Add(dr);

            //Console.WriteLine(ds.Tables["Country"].Constraints.Count);
            //Console.WriteLine(ds.Tables["City"].Constraints.Count);

            bsCountries = new BindingSource();
            bsCountries.DataSource = ds;
            bsCountries.DataMember = "Country"; //local data table Country

            bsCities = new BindingSource();
            bsCities.DataSource = bsCountries;
            bsCities.DataMember = "FK_Country_City";

            dgvCountries.DataSource = bsCountries;
            dgvCities.DataSource = bsCities;
        }
    }
}
