<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	String idValue = request.getParameter("id");
	
	Class.forName("oracle.jdbc.driver.OracleDriver");

	Connection conn = null;
	PreparedStatement pstmtItem = null;
	PreparedStatement pstmtDetail = null;

	String jdbcDriver = "jdbc:oracle:thin:@localhost:1521:orcl";
	String dbUser = "c##jspexam";
	String dbPass = "jsppw";

	Throwable occuredException = null;

	try {
		int id = Integer.parseInt(idValue);
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		conn.setAutoCommit(false);
		
		pstmtItem = conn.prepareStatement("insert into ITEM values (?, ?)");
		pstmtItem.setInt(1, id);
		pstmtItem.setString(2, "상품 이름" + id);
		pstmtItem.executeUpdate();
		
		if (request.getParameter("error") != null) {
			throw new Exception("의도적 익셉션 발생");
		}
		
		pstmtDetail = conn.prepareStatement("insert into ITEM_DETAIL values (?, ?)");
		pstmtDetail.setInt(1, id);
		pstmtDetail.setString(2, "상세 설명" + id);
		pstmtDetail.executeUpdate();
		
		conn.commit();
	} catch(Throwable e) {
		if (conn != null) {
			try {
				conn.rollback();
			} catch(SQLException ex) {}
		}
		occuredException = e;
	} finally {
		if (pstmtItem != null)
			try {pstmtItem.close(); } catch(SQLException ex) {}
		if (pstmtDetail != null)
			try {pstmtDetail.close(); } catch(SQLException ex) {}
		if (conn != null) try { conn.close(); } catch(SQLException ex) {}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>값 입력</title>
</head>
<body>

<% if (occuredException != null) { %>
에러가 발생하였습니다: <%= occuredException.getMessage() %>
<% } else { %>
데이터가 성공적으로 들어감
<% } %>

</body>
</html>