<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/1/3
  Time: 10:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户管理</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/float.css" rel="stylesheet">
    <link href="css/bkg.css" rel="stylesheet">
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String username="000";
    String nickname = null;
    int groupid = 0,index=1;
    boolean flag=false;
    Cookie[] cookies=request.getCookies();
    for(int i=0;i<cookies.length;i++)
    {
        if(cookies[i].getName().equals("username"))
        {
            flag=true;
            username=cookies[i].getValue();
        }
    }
    if(!flag)
    {
        response.sendRedirect("login_index.jsp");
        return;
    }
    Connection conn;
    PreparedStatement ps;
    ResultSet result;
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=UTC", "root", "1951123");
        ps=conn.prepareStatement("select * from meetingroommanagement.users where username=?");
        ps.setString(1,username);
        result=ps.executeQuery();
        if(result.next())
        {
            nickname=result.getString("nickname");
            groupid=result.getInt("groupid");
        }
    } catch (SQLException | ClassNotFoundException throwables) {
        throwables.printStackTrace();
    }
    if(groupid==1||groupid==2)
    {
        response.sendRedirect("admin_PermissionDenied.jsp");
    }
%>
<nav class="nav navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">会议室预订系统-管理系统</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li><a href="admin_index.jsp">主页</a></li>
                <li><a href="admin_allorder.jsp">查看所有订单</a></li>
                <li><a href="admin_room.jsp">管理会议室</a></li>
                <%
                    if(groupid==3)
                    {
                %>
                <li class="active"><a href="admin_users.jsp">管理用户</a></li>
                <%
                    }
                %>
            </ul>
        </div>
        <p class="navbar-text navbar-right">欢迎!<%=nickname%>,<a href="process_logout.jsp">登出</a></p>
    </div>
</nav>
<div class="container">
    <div class="row text-right">
        <img src="image/people220.png" style="margin:auto">
        <img src="image/people220_1.png" style="margin:auto">
    </div>
    <div class="text-right" style="margin-top: 50px">
        <form action="admin_users_search.jsp" class="form-inline" role="form" method="post">
            <select class="form-control" name="search_according">
                <option value="username">用户名</option>
                <option value="nickname">用户昵称</option>
            </select>
            <input type="text" class="form-control" name="search"/>
            <input type="submit" class="btn btn-default" value="搜索">
        </form>
    </div>
    <table class="table table-hover">
        <caption>
            <div class="page-header">
                <h1>用户列表</h1>
            </div>
        </caption>
        <thead>
        <tr>
            <th>#</th>
            <th>用户名</th>
            <th>昵称</th>
            <th>密码长度</th>
            <th>用户组</th>
            <th>管理操作</th>
        </tr>
        </thead>
        <tbody>
<%
    try
    {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
        ps=conn.prepareStatement("select * from meetingroommanagement.users");
        result=ps.executeQuery();
        while(result.next())
        {
%>
        <tr>
            <td><%=index%></td>
            <td><%=result.getString("username")%></td>
            <td><%=result.getString("nickname")%></td>
            <td><%=result.getString("password").length()%></td>
        <%
            if (result.getInt("groupid")==1)
            {
        %>
            <td><span class="label label-default">普通用户</span></td>
            <td>
                <form action="giveadmin" method="post">
                    <input type="text" style="display:none"  value=<%=result.getString("username")%> name="username"/>
                    <input type="submit" value="给与管理员权限" class="btn btn-success">
                </form>
            </td>
        </tr>
        <%
            }
            else if(result.getInt("groupid")==2)
            {
        %>
            <td><span class="label label-primary">管理员</span></td>
            <td>
                <form action="canceladmin" method="post">
                    <input type="text" style="display:none"  value=<%=result.getString("username")%> name="username"/>
                    <input type="submit" value="撤销管理员权限" class="btn btn-danger">
                </form>
            </td>
        </tr>
        <%
            }
            else if(result.getInt("groupid")==3)
            {
        %>
            <td><span class="label label-warning">超级账户</span></td>
            <td>
                <form>
                    <input type="button" value="没有权限来操作" class="btn btn-default">
                </form>
            </td>
        </tr>
        <%
            }
            index++;
        }
        result.close();
        ps.close();
        conn.close();
    } catch (SQLException throwables) {
        throwables.printStackTrace();
    }
%>
        </tbody>
    </table>
    <div style="z-index:999;display: block; position: fixed; right: 200px; bottom: 200px;">
        <div id="switchbutton">
            <a href="user_index.jsp"><img src="image/touser.png" class="float"></a>
        </div>
    </div>
</div>
</body>
</html>
