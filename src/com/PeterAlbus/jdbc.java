package com.PeterAlbus;

import com.mysql.cj.jdbc.Driver;

import java.io.Console;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/jdbc")
public class jdbc extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html><head><title>读取数据库信息</title></head><body>");
        try {
            //DriverManager.registerDriver(new Driver());
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=UTC", "root", "1951123");
            Statement stat=conn.createStatement();

            PreparedStatement pstmt;
            String sql="insert into users(username,password,nickname) values(?,?,?)";
            //使用PreparedStatement对象里来构建并执行SQL语句，3个问号代表3个字段预先要保留的值
            pstmt=conn.prepareStatement(sql);
            // Sql中的位置和值
            pstmt.setString(1, "4");
            pstmt.setString(2,"5");
            pstmt.setString(3, "6");
            pstmt.execute();
            ResultSet result=stat.executeQuery("select * from users");
            while (result.next())
            {
                String name,owner,sex;
                name=result.getString("username");
                owner=result.getString("nickname");
                sex=result.getString("password");
                out.println(name+" "+owner+" "+sex+"<br>");
            }
            conn.close();
            stat.close();
            result.close();
        } catch (SQLException | ClassNotFoundException throwables) {
            throwables.printStackTrace();
        }
        out.println("<br/>输出完毕</body></html>");
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        this.doGet(request, response);
    }

}