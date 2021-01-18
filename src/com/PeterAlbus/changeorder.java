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

public class changeorder extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
        String orderid=request.getParameter("order_id");
        String username="\0";
        int groupid = 0;
        Cookie[] cookies=request.getCookies();
        for (Cookie cookie : cookies)
        {
            if (cookie.getName().equals("username"))
            {
                username = cookie.getValue();
            }
        }
        try
        {
            Connection conn;
            PreparedStatement ps;
            ResultSet result;
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=UTC", "root", "1951123");
            ps=conn.prepareStatement("select * from meetingroommanagement.users where username=?");
            ps.setString(1,username);
            result=ps.executeQuery();
            if(result.next())
            {
                groupid=result.getInt("groupid");
            }
            result.close();
            ps.close();
            conn.close();
        } catch (SQLException | ClassNotFoundException throwables) {
            throwables.printStackTrace();
        }
        String roomid=request.getParameter("roomid");
        String time_s=request.getParameter("time_s");
        String time_e=request.getParameter("time_e");
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
                if(result.getString("order_id").equals(orderid)) continue;
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
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            Statement stat=conn.createStatement();
            ResultSet rs=stat.executeQuery(("SELECT * FROM meetingroommanagement.orders WHERE order_id='"+orderid+"'"));
            rs.next();
            if(!rs.getString("username").equals(username))
            {
                response.sendRedirect("admin_PermissionDenied.jsp");
                return;
            }
            PreparedStatement ps=conn.prepareStatement("UPDATE meetingroommanagement.orders SET time_start=?,time_end=? WHERE order_id=?");
            ps.setString(1,time_s);
            ps.setString(2,time_e);
            ps.setString(3,orderid);
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect("user_order.jsp");
        } catch (SQLException | ClassNotFoundException throwables) {
            throwables.printStackTrace();
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        this.doGet(request, response);
    }

}