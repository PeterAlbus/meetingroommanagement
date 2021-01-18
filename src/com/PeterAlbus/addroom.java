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

public class addroom extends HttpServlet
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
        }
        String room_number=request.getParameter("room_number");
        String room_name=request.getParameter("room_name");
        if(room_name.length()==0||room_number.length()==0)
        {
            request.setAttribute("reason","房间号及房间类型不能为空");
            request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
            return;
        }
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            Statement st=conn.createStatement();
            ResultSet rs=st.executeQuery("select room_id from meetingroommanagement.meetingrooms where room_number='"+room_number+"'");
            if(rs.next())
            {
                request.setAttribute("reason","房间号重复");
                request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
                return;
            }
            PreparedStatement ps=conn.prepareStatement("insert into meetingroommanagement.meetingrooms(room_number, room_name) VALUES (?,?)");
            ps.setString(1,room_number);
            ps.setString(2,room_name);
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect("admin_room.jsp");
        } catch (SQLException | ClassNotFoundException throwables) {
            request.setAttribute("reason",throwables.getLocalizedMessage());
            request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
            throwables.printStackTrace();
        }
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        this.doGet(request, response);
    }

}