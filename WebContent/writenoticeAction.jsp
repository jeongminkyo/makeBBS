<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.NoticeDAO" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class ="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>YB술칭게이들</title>
</head>
<body>
	<%
		String userID = null;
		String saveFolder = "Fileupload";
		String encType = "euc-kr";
		int sizeLimit = 5*1024*1024;
		String savePath = "";
		savePath = request.getRealPath("Fileupload");
		if(session.getAttribute("userID") != null)
    	{
    		userID = (String) session.getAttribute("userID");
    	}
    	
    	if(userID == null)
    	{
    		PrintWriter script = response.getWriter();
    		script.println("<script>");
    		script.println("alert('로그인을 하세요.')");
    		script.println("location.href = 'login.jsp'");
    		script.println("</script>");
    	}
    	else
    	{
    		try
    		{
    			MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit, encType ,new DefaultFileRenamePolicy());
    	        String fileName = multi.getFilesystemName("upfile");    
    	        /* 파일이 업로드 되었는지 체크 */
    	        if(fileName==null)
		        {
		    		if(bbs.getBbsTitle()==null || bbs.getBbsContent() == null)
	    			{
	    				PrintWriter script= response.getWriter();
	    				script.println("<script>");
	    				script.println("alert('입력이 안 된 사람이 있습니다.')");
	    				script.println("history.back()");
	    				script.println("</script>");
	    			}
	    			else
	    			{
	    				NoticeDAO noticeDAO = new NoticeDAO();
	    				int result = noticeDAO.write(bbs.getBbsTitle(),userID, bbs.getBbsContent(),savePath);
	    				if(result == -1)
	    				{
	    					PrintWriter script = response.getWriter();
	    					script.println("<script>");
	    					script.println("alert('글쓰기에 실패했습니다.')");
	    					script.println("history.back()");
	    					script.println("</script>");
	    				}
	    				else 
	    				{
	    					PrintWriter script = response.getWriter();
	    					script.println("<script>");
	    					script.println("location.href ='notice.jsp'");
	    					script.println("</script>");
	    				}
	    			}	
    			}
    	        else
    	        {
    	        	NoticeDAO noticeDAO = new NoticeDAO();
    				int result = noticeDAO.write(bbs.getBbsTitle(),userID, bbs.getBbsContent(),savePath);
    				if(result == -1)
    				{
    					PrintWriter script = response.getWriter();
    					script.println("<script>");
    					script.println("alert('글쓰기에 실패했습니다.')");
    					script.println("history.back()");
    					script.println("</script>");
    				}
    				else 
    				{
    					PrintWriter script = response.getWriter();
    					script.println("<script>");
    					script.println("location.href ='notice.jsp'");
    					script.println("</script>");
    				}	
    	        }
    		}
    		catch(IOException e)
    		{
    	        out.print("<h2>IOException이 발생했습니다 </h2> <br> <pre>" + e.getMessage() + "</pre>");
    	    }
    	}
    
    %>	    

</body>
</html>