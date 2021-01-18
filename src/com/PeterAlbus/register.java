package com.PeterAlbus;

import java.io.Console;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class register extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String username=request.getParameter("username");
        String nickname=request.getParameter("nickname");
        String password=request.getParameter("password");
        if(username.length()==0)
        {
            request.setAttribute("reason","用户名不能为空");
            request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
            return;
        }
        if(nickname.length()==0)
        {
            request.setAttribute("reason","昵称不能为空");
            request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
            return;
        }
        if(password.length()==0)
        {
            request.setAttribute("reason","密码不能为空");
            request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
            return;
        }
        out.println("<html><head><title>注册结果</title></head><body>");
        try
        {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
            Statement st=conn.createStatement();
            ResultSet rs=st.executeQuery("select username from meetingroommanagement.users where username='"+username+"'");
            if(rs.next())
            {
                request.setAttribute("reason","用户名重复");
                request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
                return;
            }
            PreparedStatement ps=conn.prepareStatement("insert into meetingroommanagement.users(username, nickname, password) values (?,?,?)");
            ps.setString(1,username);
            ps.setString(2,nickname);
            ps.setString(3,password);
            ps.executeUpdate();
            conn.close();
            request.setAttribute("reason","成功注册您的账户，请到登录页面登录");
            request.getRequestDispatcher("login_register_success.jsp").forward(request,response);
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