<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/30
  Time: 10:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录中</title>
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String username=request.getParameter("username");
    String password=request.getParameter("password");
    if(username.length()==0)
    {
        request.setAttribute("reason","用户名不能为空");
        request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
        return;
    }
    if(password.length()==0)
    {
        request.setAttribute("reason","密码不能为空");
        request.getRequestDispatcher("login_register_fail.jsp").forward(request,response);
        return;
    }
    Connection conn = null;
    PreparedStatement ps;
    ResultSet result;
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
        ps=conn.prepareStatement("select * from meetingroommanagement.users where username=?");
        ps.setString(1,username);
        result=ps.executeQuery();
        if(result.next())
        {
            if(password.equals(result.getString("password")))
            {
                Cookie uname=new Cookie("username",username);
                //uname.setMaxAge(100000);
                response.addCookie(uname);
                request.getRequestDispatcher("login_suc_temp.jsp").forward(request,response);
            }
            else
            {
                request.setAttribute("reason","密码错误");
                request.getRequestDispatcher("login_fail.jsp").forward(request,response);
            }
        }
        else
        {
            request.setAttribute("reason","没有该用户名");
            request.getRequestDispatcher("login_fail.jsp").forward(request,response);
        }
        result.close();
        ps.close();
        conn.close();
    } catch (SQLException | ClassNotFoundException throwables)
    {
        request.setAttribute("reason","catch到错误,可能是未成功连接到数据库,请联系管理员");
        request.getRequestDispatcher("login_fail.jsp").forward(request,response);
        throwables.printStackTrace();
    }
%>
</body>
</html>
