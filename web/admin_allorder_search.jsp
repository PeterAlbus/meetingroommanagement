<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/1/3
  Time: 1:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>搜索结果</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/float.css" rel="stylesheet">
    <link href="css/bkg.css" rel="stylesheet">
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String sa=request.getParameter("search_according");
    String search=request.getParameter("search");
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
    if(groupid==1)
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
                <li><a href="admin_users.jsp">管理用户</a></li>
                <%
                    }
                %>
                <li class="active"><a href="#">搜索结果</a></li>
            </ul>
        </div>
        <p class="navbar-text navbar-right">欢迎!<%=nickname%>,<a href="process_logout.jsp">登出</a></p>
    </div>
</nav>
<div class="container">
    <div class="row text-right">
        <img src="image/book3.png" style="margin:auto">
        <img src="image/book2.png" style="margin:auto">
        <img src="image/book1.png" style="margin:auto">
    </div>
    <div class="text-right" style="margin-top: 50px">
        <form action="admin_allorder_search.jsp" class="form-inline" role="form" method="post">
            <select class="form-control" name="search_according">
                <option value="room_number">会议室房间号</option>
                <option value="room_name">会议室类型</option>
            </select>
            <input type="text" class="form-control" name="search"/>
            <input type="submit" class="btn btn-default" value="搜索">
        </form>
    </div>
    <table class="table table-hover">
        <caption>
            <div class="page-header">
                <h1>所有预订</h1>
            </div>
        </caption>
        <thead>
        <tr>
            <th>#</th>
            <th>会议室类型</th>
            <th>房间号</th>
            <th>预订时间</th>
            <th>申请人</th>
            <th>删除时间</th>
        </tr>
        </thead>
        <tbody>
        <%
            try
            {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
                ps=conn.prepareStatement("select * from meetingroommanagement.orders");
                result=ps.executeQuery();
                while(result.next())
                {
                    PreparedStatement ps1=conn.prepareStatement("select * from meetingroommanagement.meetingrooms where room_id=?");
                    ps1.setString(1,result.getString("room_id"));
                    ResultSet rs=ps1.executeQuery();
                    if(!rs.next())
                    {
                        if(!rs.getString(sa).equals(search)) continue;
        %>
        <tr>
            <td><%=index%></td>
            <td>房间已不存在</td>
            <td>房间已不存在</td>
            <td><%=result.getString("time_start")%>-<%=result.getString("time_end")%>    </td>
            <td><%=result.getString("username")%></td>
            <td>
                <form action="deleteorder" method="post" onsubmit="return confirm('确定要删除吗？');">
                    <input type="text" style="display:none"  value=<%=result.getString("order_id")%> name="order_id"/>
                    <input type="submit" value="删除本预订" class="btn btn-danger">
                </form>
            </td>
        </tr>
        <%
                continue;
            }
            if(!rs.getString(sa).equals(search)) continue;
        %>
        <tr>
            <td><%=index%></td>
            <td><%=rs.getString("room_name")%></td>
            <td><%=rs.getString("room_number")%></td>
            <td>
                <%=result.getString("time_start")%>-<%=result.getString("time_end")%>
                <%
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    Timestamp e=Timestamp.valueOf(result.getString("time_end"));
                    Timestamp s=Timestamp.valueOf(result.getString("time_start"));
                    if(now.after(e))
                    {
                %>
                <span class="label label-success">已使用</span>
                <%
                }
                else if(now.before(s))
                {
                %>
                <span class="label label-default">未使用</span>
                <%
                }
                else if(now.after(s)&&now.before(e))
                {
                %>
                <span class="label label-danger">使用中</span>
                <%
                    }
                %>
            </td>
            <td><%=result.getString("username")%></td>
            <td>
                <form action="deleteorder" method="post" onsubmit="return confirm('确定要删除吗？');">
                    <input type="text" style="display:none"  value=<%=result.getString("order_id")%> name="order_id"/>
                    <input type="submit" value="删除本预订" class="btn btn-danger">
                </form>
            </td>
        </tr>
        <%
                    index++;
                    rs.close();
                    ps1.close();
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
    <p class="text-right"><input type="button" onclick="javascript:history.go(-1)" class="btn btn-default" value="返回"/></p>
</div>
</body>
</html>
