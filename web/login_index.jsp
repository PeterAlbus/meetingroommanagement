<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/24
  Time: 10:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>会议室管理系统-登录</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/login.css" rel="stylesheet">
  </head>
  <body style="background-image: url('image/login2.jpg');background-size: cover">
  <%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    Cookie[] cookies=request.getCookies();
    for(int i=0;i<cookies.length;i++)
    {
      if(cookies[i].getName().equals("username"))
      {
        response.sendRedirect("user_index.jsp");
      }
    }
  %>
  <div class="container">
    <div class="row" style="margin-top: 200px">
      <div class="col-md-6 col-md-offset-3">
      <form action="process_checklogin.jsp" method="post" class="form-horizontal">
        <span class="heading">会议室管理系统-登录</span>
        <div class="form-group">
          <p>
          <input type="text" name="username" id="username" class="form-control" placeholder="用户名"/>
          <span class="glyphicon glyphicon-user"></span>
          </p>
        </div>
        <div class="form-group">
          <p>
          <input type="password" name="password" id="password" class="form-control" placeholder="密码"/>
          <span class="glyphicon glyphicon-lock"></span>
          </p>
        </div>
        <p class="text-center">
        <input type="submit" class="btn btn-default" value="登录">
        <a href="login_register.jsp">注册新用户</a>
        </p>
      </form>
      </div>
    </div>
  </div>
  </body>
</html>
