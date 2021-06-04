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

using System.Configuration;
using System.Collections.Specialized;


namespace Assignment2
{
    public partial class Form1 : Form
    {
        SqlConnection conn;
        DataSet ds;
        SqlDataAdapter daParent, daChild;
        SqlCommandBuilder cb;
        BindingSource bsParent, bsChild;

        string childTable;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string parentTable = ConfigurationManager.AppSettings.Get("ParentTable");
            childTable = ConfigurationManager.AppSettings.Get("ChildTable");
            string parentTableFKColumn = ConfigurationManager.AppSettings.Get("ParentTableFKColumn");
            string childTableFKColumn = ConfigurationManager.AppSettings.Get("ChildTableFKColumn");

            conn = new SqlConnection("Data Source = RAMONASLAPTOP; Initial Catalog = EuropeanCities; " + " Integrated Security = SSPI; ");
            ds = new DataSet();
            daParent = new SqlDataAdapter("SELECT * FROM " + parentTable, conn);
            daChild = new SqlDataAdapter("SELECT * FROM " + childTable, conn);
            cb = new SqlCommandBuilder(daChild);

            daParent.Fill(ds, parentTable);
            daChild.Fill(ds, childTable);

            DataRelation dr = new DataRelation("FK_Parent_Child", ds.Tables[parentTable].Columns[parentTableFKColumn], ds.Tables[childTable].Columns[childTableFKColumn]);
            ds.Relations.Add(dr);


            bsParent = new BindingSource();
            bsParent.DataSource = ds;
            bsParent.DataMember = parentTable;

            bsChild = new BindingSource();
            bsChild.DataSource = bsParent;
            bsChild.DataMember = "FK_Parent_Child";

            dgvParent.DataSource = bsParent;
            dgvChild.DataSource = bsChild;
        }

        private void buttonSaveData_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(ds, childTable);
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.ToString());
            }
        }
    }
}
