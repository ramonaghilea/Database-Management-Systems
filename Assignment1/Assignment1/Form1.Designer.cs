
namespace Assignment1
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dgvCountries = new System.Windows.Forms.DataGridView();
            this.dgvCities = new System.Windows.Forms.DataGridView();
            this.buttonSaveData = new System.Windows.Forms.Button();
            this.refreshButton = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCountries)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCities)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvCountries
            // 
            this.dgvCountries.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCountries.Location = new System.Drawing.Point(73, 44);
            this.dgvCountries.Name = "dgvCountries";
            this.dgvCountries.RowHeadersWidth = 62;
            this.dgvCountries.RowTemplate.Height = 28;
            this.dgvCountries.Size = new System.Drawing.Size(889, 169);
            this.dgvCountries.TabIndex = 0;
            // 
            // dgvCities
            // 
            this.dgvCities.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvCities.Location = new System.Drawing.Point(73, 270);
            this.dgvCities.Name = "dgvCities";
            this.dgvCities.RowHeadersWidth = 62;
            this.dgvCities.RowTemplate.Height = 28;
            this.dgvCities.Size = new System.Drawing.Size(889, 161);
            this.dgvCities.TabIndex = 1;
            // 
            // buttonSaveData
            // 
            this.buttonSaveData.Location = new System.Drawing.Point(73, 479);
            this.buttonSaveData.Name = "buttonSaveData";
            this.buttonSaveData.Size = new System.Drawing.Size(174, 53);
            this.buttonSaveData.TabIndex = 2;
            this.buttonSaveData.Text = "Save Data";
            this.buttonSaveData.UseVisualStyleBackColor = true;
            this.buttonSaveData.Click += new System.EventHandler(this.buttonSaveData_Click);
            // 
            // refreshButton
            // 
            this.refreshButton.Location = new System.Drawing.Point(292, 479);
            this.refreshButton.Name = "refreshButton";
            this.refreshButton.Size = new System.Drawing.Size(174, 53);
            this.refreshButton.TabIndex = 3;
            this.refreshButton.Text = "Refresh";
            this.refreshButton.UseVisualStyleBackColor = true;
            this.refreshButton.Click += new System.EventHandler(this.refreshButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1115, 579);
            this.Controls.Add(this.refreshButton);
            this.Controls.Add(this.buttonSaveData);
            this.Controls.Add(this.dgvCities);
            this.Controls.Add(this.dgvCountries);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvCountries)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgvCities)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvCountries;
        private System.Windows.Forms.DataGridView dgvCities;
        private System.Windows.Forms.Button buttonSaveData;
        private System.Windows.Forms.Button refreshButton;
    }
}

