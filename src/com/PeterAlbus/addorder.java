package com.PeterAlbus;

import com.mysql.cj.jdbc.Driver;

import java.io.Console;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class addorder extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String roomid=request.getParameter("roomid");
        String time_s=request.getParameter("time_s");
        String time_e=request.getParameter("time_e");
        String username=request.getParameter("username");
        time_s=time_s.replace("T"," ")+":00";
        time_e=time_e.replace("T"," ")+":00";
        Timestamp s=Timestamp.valueOf(time_s);
        Timestamp e=Timestamp.valueOf(time_e);
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if(e.getTime()-s.getTime()>21600000)
        {
            request.setAttribute("reason","时间跨度不得超过6个小时!");
            request.getRequestDispatcher("user_order_error.jsp").forward(request,response);
            return;
        }
        if(now.after(s))
        {
            request.setAttribute("reason","开始时间早于当前时间");
            request.getRequestDispatcher("user_order_error.jsp").forward(request,response);
            return;
        }
        if(s.equals(e)||s.after(e))
        {
            request.setAttribute("reason","开始时间不可晚于或等于结束时间！");
            request.getRequestDispatcher("user_order_error.jsp").forward(request,response);
            return;
        }
        Timestamp s_e,e_e;
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            Statement stat=conn.createStatement();
            ResultSet result=stat.executeQuery("select * from meetingroommanagement.orders where room_id='"+roomid+"'");
            while (result.next())
            {
                s_e=Timestamp.valueOf(result.getString("time_start"));
                e_e=Timestamp.valueOf(result.getString("time_end"));
                if((s.after(s_e)&&s.before(e_e))||(e.after(s_e)&&e.before(e_e))||(s.equals(s_e)&&e.equals(e_e)))
                {
                    conn.close();
                    stat.close();
                    result.close();
                    request.setAttribute("reason","时间冲突");
                    request.getRequestDispatcher("user_order_error.jsp").forward(request,response);
                    return;
                }
            }
            conn.close();
            stat.close();
            result.close();
        } catch (SQLException | ClassNotFoundException throwables) {
            throwables.printStackTrace();
        }
        out.println("<html><head><title>结果</title></head><body>");
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            PreparedStatement ps=conn.prepareStatement("insert into meetingroommanagement.orders(room_id, time_start, time_end, username) values (?,?,?,?)");
            ps.setString(1,roomid);
            ps.setString(2,time_s);
            ps.setString(3,time_e);
            ps.setString(4,username);
            int row=ps.executeUpdate();
            response.sendRedirect("user_order.jsp");
            ps.close();
            conn.close();
        } catch (SQLException | ClassNotFoundException throwables) {
            out.print("<br/>catch到错误 请联系管理员<br/>");
            throwables.printStackTrace();
        }
        out.println("<br/><a href=user_index.jsp>返回主页面</a></body></html>");
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        this.doGet(request, response);
    }

}