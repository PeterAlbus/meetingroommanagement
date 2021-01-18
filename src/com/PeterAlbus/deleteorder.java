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

public class deleteorder extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
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
        if(groupid==1)
        {
            response.sendRedirect("admin_PermissionDenied.jsp");
            return;
        }
        String orderid=request.getParameter("order_id");
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            PreparedStatement ps=conn.prepareStatement("DELETE FROM meetingroommanagement.orders where order_id=?");
            ps.setString(1,orderid);
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect("admin_allorder.jsp");
        } catch (SQLException | ClassNotFoundException throwables) {
            throwables.printStackTrace();
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        this.doGet(request, response);
    }

}