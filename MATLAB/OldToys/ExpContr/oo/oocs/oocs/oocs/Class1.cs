using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace WindowsFormsApplication1
{
    class mPainter
    {
        public static void draw2d(float[] xx, float[] yy, System.Windows.Forms.Panel mPanel)
        {

            Bitmap mbmp = new Bitmap(mPanel.Width, mPanel.Height);

            draw2d(xx, yy, mbmp);

            mPanel.CreateGraphics().DrawImage(mbmp,0,0);





        }

        public static void draw2d(float[] xx, float[] yy, System.Drawing.Bitmap mbmp)
        {

            int l_marg, r_marg=5;
            int t_marg = 5, b_marg;
            double mmax_y, mmin_y;

            double xScale, yScale;
            
            mmax_y=-1000000;
            mmin_y=1000000;

            for(int i=0;i<yy.Length;i++){
                if(mmax_y<yy[i])
                    mmax_y=yy[i];
                if(mmin_y>yy[i])
                    mmin_y=yy[i];
            }


            Graphics mgr = Graphics.FromImage(mbmp);
            Font mfnt = new Font(FontFamily.GenericSansSerif, 8);
            Pen mpen = new Pen(Color.Black, 1);
            l_marg = Convert.ToInt32(mgr.MeasureString(mmax_y.ToString(), mfnt).Width > mgr.MeasureString(mmin_y.ToString(), mfnt).Width ? mgr.MeasureString(mmax_y.ToString(), mfnt).Width : mgr.MeasureString(mmin_y.ToString(), mfnt).Width) + 5;

            b_marg = Convert.ToInt32(mgr.MeasureString("000", mfnt).Height) + 5;

            xScale = (mbmp.Width-l_marg-r_marg)/(xx[xx.Length - 1] - xx[0]);
            yScale = (mbmp.Height-t_marg-b_marg)/(mmax_y - mmin_y);



            mgr.FillRectangle(new SolidBrush(Color.White), new Rectangle(0, 0, mbmp.Width, mbmp.Height));


            //Draw Axis rectangle:
            mgr.DrawLine(mpen, l_marg, t_marg, mbmp.Width - r_marg, t_marg);
            mgr.DrawLine(mpen, mbmp.Width-r_marg, t_marg, mbmp.Width - r_marg, mbmp.Height-b_marg);
            mgr.DrawLine(mpen, mbmp.Width - r_marg, mbmp.Height - b_marg, l_marg, mbmp.Height - b_marg);
            mgr.DrawLine(mpen, l_marg, mbmp.Height - b_marg, l_marg, t_marg);

            for(int i=0;i<xx.Length-1;i++)
                mgr.DrawLine(mpen,Convert.ToInt32((xx[i]-xx[0])*xScale+l_marg),Convert.ToInt32(mbmp.Height-b_marg-yy[i]*yScale),Convert.ToInt32((xx[i+1]-xx[0])*xScale+l_marg),Convert.ToInt32(mbmp.Height-b_marg-yy[i+1]*yScale));

            double ntics_y=4;
            double ntics_x = 4;
            double val;
            for (int i = 0; i < ntics_y+1; i++)
            {
                val=(mmin_y + (mmax_y - mmin_y) / (double)ntics_y * (double)i);
                if(i==0)
                    mgr.DrawString(val.ToString("####0"), mfnt, new SolidBrush(Color.Black), new PointF(2, (float)(mbmp.Height - b_marg - i * (mbmp.Height - b_marg - t_marg) / ntics_y)- mgr.MeasureString(val.ToString("###0"),mfnt).Height));
                else
                    mgr.DrawString(val.ToString("####0"), mfnt, new SolidBrush(Color.Black), new PointF(2, (float)(mbmp.Height - b_marg - i * (mbmp.Height - b_marg - t_marg) / ntics_y)));
            }

            for (int i = 0; i < ntics_x + 1; i++)
            {
                val=(xx[0] + (xx[xx.Length-1] - xx[0]) / (double)ntics_y * (double)i);
                if(i==ntics_x)
                    mgr.DrawString(val.ToString("###0"), mfnt, new SolidBrush(Color.Black), new PointF((float)(l_marg+i*(mbmp.Width-l_marg-r_marg)/ntics_x- mgr.MeasureString(val.ToString("###0"),mfnt).Width), mbmp.Height-b_marg));
                else
                    mgr.DrawString(val.ToString("###0"), mfnt, new SolidBrush(Color.Black), new PointF((float)(l_marg+i*(mbmp.Width-l_marg-r_marg)/ntics_x), mbmp.Height-b_marg));
            }

            mgr.Dispose();

        }
    }
}
